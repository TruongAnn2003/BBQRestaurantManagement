Create Database BBQRestaurantManagement
go
USE BBQRestaurantManagement
-----------------------------------------------------------------------------------

CREATE TABLE Customers
(
	CustomerID nvarchar(10) CONSTRAINT IDkey PRIMARY KEY,
	NameCustomer nvarchar(100),
	NumberPhone nvarchar(20) NOT NULL,
	CONSTRAINT RightID CHECK(CustomerID LIKE 'CUS%')
);

CREATE TABLE Services
(
	IDServices nvarchar(10) CONSTRAINT IDServiceskey PRIMARY KEY,
	NameServices nvarchar(100) NOT NULL,
	CONSTRAINT RightIDServices CHECK(IDServices LIKE 'SER%'),
);

CREATE TABLE TypeServices
(
	IDType nvarchar(10) CONSTRAINT IDTypekey PRIMARY KEY,
	NameType nvarchar(100) NOT NULL,
	IDServices nvarchar(10),
	Price BIGINT NOT NULL,
	CONSTRAINT RightIDType CHECK(IDType LIKE 'TYP1%' or IDType LIKE 'TYP2%' or IDType LIKE 'TYP3%'), 
	--1. Dịch vụ phòng; 2. Dịch vụ đính kèm; 3. Dịch vụ khuyến mãi
	CONSTRAINT FK_Type_Services FOREIGN KEY (IDServices) REFERENCES Services(IDServices),
	CONSTRAINT RightPrice CHECK(Price >= 0)
);

CREATE TABLE Customer_TypeServices
(
	CustomerID nvarchar(10) ,
	IDTypeServices nvarchar(10) ,
	CONSTRAINT IDCus_SerKey PRIMARY KEY(CustomerID,IDTypeServices),
	CONSTRAINT FK_TypeServices FOREIGN KEY (IDTypeServices) REFERENCES TypeServices(IDType),
	CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	Quantity int NOT NULL,
	TotalMoney BIGINT NOT NULL
);

CREATE TABLE TablesCustomer
(
	TablesID nvarchar(10) CONSTRAINT TablesCustomerkey PRIMARY KEY,
	MaxSeats int  NOT NULL,
	RoomType nvarchar(10),
	CONSTRAINT RightTablesID CHECK(TablesID LIKE 'TAB%'), 
	CONSTRAINT FK_Tables_Type FOREIGN KEY (RoomType) REFERENCES TypeServices(IDType),
	CONSTRAINT RightRoomType CHECK(RoomType LIKE 'TYP1%')
);

ALTER TABLE TablesCustomer 
ADD Status bit NOT NULL 

CREATE TABLE StatusInvoice
(
	StatusInvoiceID nvarchar(10) CONSTRAINT StatusInvoicekey PRIMARY KEY,
	NameStatusInvoice nvarchar(100) NOT NULL,
)

CREATE TABLE StatusInvoice_Details
(
	InvoiceDetailsID nvarchar(10) CONSTRAINT IDInvoiceDetailskey PRIMARY KEY,
	CheckIn_Time time ,
	CheckOut_Time time ,
	StatusInvoice nvarchar(10),
	CONSTRAINT FK_StatusInvoice FOREIGN KEY (StatusInvoice) REFERENCES StatusInvoice(StatusInvoiceID),
	CONSTRAINT RightCheck_Time CHECK(CheckIn_Time<CheckOut_Time)
)

CREATE TABLE Invoice
(
	InvoiceID nvarchar(10) CONSTRAINT InvoiceIDKey PRIMARY KEY,
	CreationTime datetime NOT NULL,
	Price BIGINT NOT NULL,
	Discount int,
	InvoiceDetails nvarchar(10),
	--CONSTRAINT FK_InvoiceDetails FOREIGN KEY (InvoiceDetails) REFERENCES StatusInvoice_Details(InvoiceDetailsID),
	CONSTRAINT RightPriceInvoice CHECK(Price >= 0)
)

CREATE TABLE Booking
(
	BookingID nvarchar(10) CONSTRAINT IDBookingkey PRIMARY KEY,
	BookingDate date NOT NULL,
	BookingStatus nvarchar(50) NOT NULL,
	Duration int,
	Note nvarchar(100),
	NumberCustomer int,
	CustomerBooking nvarchar(10),
	ServiceBooking nvarchar(10),
	TableBooking nvarchar(10), 
	BookingInvoice nvarchar(10),
	CONSTRAINT FK_CustomerBooking FOREIGN KEY (CustomerBooking) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_ServiceBooking FOREIGN KEY (ServiceBooking) REFERENCES TypeServices(IDType),
	CONSTRAINT FK_TableBooking FOREIGN KEY (TableBooking) REFERENCES TablesCustomer(TablesID),
	CONSTRAINT FK_BookingInvoice FOREIGN KEY (BookingInvoice) REFERENCES Invoice(InvoiceID),
	CONSTRAINT BookingStatus CHECK(BookingStatus LIKE 'Success' or BookingStatus LIKE 'Received' or BookingStatus LIKE 'Cancel'),
	--Trạng thái đặt bàn sẽ bao gồm xác nhận đặt bàn thành công, đã nhận bàn và huỷ đặt bàn
	CONSTRAINT RightNumberCustomer CHECK(NumberCustomer >= 1)
);


go
CREATE TABLE Staff_Position
(
	IDPosition nvarchar(10) CONSTRAINT Staff_PositionIDkey PRIMARY KEY,
	Position nvarchar(50) NOT NULL
);

CREATE TABLE Staff
(
	StaffID nvarchar(10) CONSTRAINT StaffIDkey PRIMARY KEY,
	NameStaff nvarchar(100) NOT NULL,
	NumberPhone nvarchar(20) NOT NULL,
	Position nvarchar(10) NOT NULL,
	CONSTRAINT RightStaffID CHECK(StaffID LIKE 'STA%'),
	CONSTRAINT FK_Position FOREIGN KEY (Position) REFERENCES Staff_Position(IDPosition)
);

---Thêm vào ERD
CREATE TABLE Account
(
	AccountID nvarchar(10) CONSTRAINT AccountIDkey PRIMARY KEY,
	Passwords nvarchar(20) NOT NULL,
	CONSTRAINT FK_AccountID FOREIGN KEY (AccountID) REFERENCES Staff(StaffID)
);

CREATE TABLE Product_Type
(
	IDType nvarchar(10) CONSTRAINT Product_Typekey PRIMARY KEY,
	ProductType nvarchar(50) NOT NULL
);

CREATE TABLE Product
(
	ProductID nvarchar(10) CONSTRAINT Productkey PRIMARY KEY,
	NameProduct nvarchar(100) NOT NULL,
	Price BIGINT NOT NULL,
	Description nvarchar(500),
	ProductState bit, -- 2 tình trạng còn (1), hết (0)
	Product_Type nvarchar(10),
	CONSTRAINT FK_Product_Type FOREIGN KEY (Product_Type) REFERENCES Product_Type(IDType),
	CONSTRAINT RightProductID CHECK(ProductID LIKE 'PRO%'),
	CONSTRAINT RightPriceProduct CHECK(Price >= 0)
);

CREATE TABLE Service_Product 
(
	IDProduct nvarchar(10) ,
	IDServices nvarchar(10) ,
	CONSTRAINT Service_Combokey PRIMARY KEY(IDProduct,IDServices),
	CONSTRAINT FK_IDCombo FOREIGN KEY (IDProduct) REFERENCES Product(ProductID),
	CONSTRAINT FK_IDServices FOREIGN KEY (IDServices) REFERENCES TypeServices(IDType)
);

CREATE TABLE Orders
(
	OrderID nvarchar(10) CONSTRAINT Orderskey PRIMARY KEY,
	DatetimeOrder datetime NOT NULL,
	Total_Unit_Price BIGINT NOT NULL,
	StateOrder bit NOT NULL,
	CustomerOrder nvarchar(10),
	OrderStaff nvarchar(10),
	Invoice nvarchar(10),
	CONSTRAINT RightOrderID CHECK(OrderID LIKE 'ORD%'),
	CONSTRAINT RightTotal_Unit_Price CHECK(Total_Unit_Price >= 0),
);

CREATE TABLE OrderDetails
(
	OrderDetailsID nvarchar(10) ,
	ProductID nvarchar(10),
	Quantity int NOT NULL,
	OrderID nvarchar(10),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
---	CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

---------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
/*																																			*/
/*																		INSERT DATA															*/
/*																																			*/
---------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
go
INSERT INTO Staff_Position(IDPosition,Position) VALUES
('POS001',N'Quản lí'),
('POS002',N'Thu Ngân'),
('POS003',N'Phục vụ')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Staff(StaffID,NameStaff,NumberPhone,Position) VALUES
('STA001',N'Nguyễn Trường An','0364969450','POS001'),
('STA002',N'Nguyễn Thành Lợi','0364125263','POS001'),
('STA003',N'Huỳnh Minh Trí','0364956256','POS001'),
('STA004',N'Trần Đỗ Thanh An','0364562321','POS001'),
('STA005',N'Mai Anh Khoa','0364562321','POS002'),
('STA006',N'Lê Minh Anh','0364562321','POS002'),
('STA007',N'Trần Đức Trung','0364562321','POS003'),
('STA008',N'Nguyễn Văn Hoàng','0364562321','POS003'),
('STA009',N'Lê Xuân Huỳnh','0364562321','POS003')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Account(AccountID,Passwords) VALUES
('STA001','@123456'),
('STA002','@123456'),
('STA003','@123456'),
('STA004','@123456'),
('STA005','@123456'),
('STA006','@123456'),
('STA007','@123456'),
('STA008','@123456'),
('STA009','@123456')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Customers (CustomerID, NameCustomer, NumberPhone)VALUES
('CUS001', 'John Smith', '123-456-7890'),
('CUS002', 'Jane Doe', '555-555-1212'),
('CUS003', 'Bob Johnson', '999-999-9999'),
('CUS004', 'Sarah Johnson', '555-123-4567'),
('CUS005', 'David Lee', '777-888-9999'),
('CUS006', 'Emily Chen', '123-456-7890'),
('CUS007', 'Jason White', '443-234-9820'),
('CUS008', 'William Holmes', '531-238-4920'),
('CUS009', 'Martin Abbott', '321-235-1123'),
('CUS010', 'Susan Bafford', '320-123-4029'),
('CUS011', 'Emily Watson', '123-342-2048'),
('CUS012', 'Thiago Silva', '130-452-1938'),
('CUS013', 'Edouard Mendy', '372-381-8753'),
('CUS014', 'Mason Mount', '333-123-5482'),
('CUS015', 'Joao Felix', '123-319-1219'),
('CUS016', 'Hakim Ziyech', '343-339-3821'),
('CUS017', 'LeBron James', '333-112-3462'),
('CUS018', 'Nikola Jokic', '172-001-3481'),
('CUS019', 'Stephen Curry', '772-092-1893'),
('CUS020', 'Trae Young', '871-333-2917'),
('CUS021', 'Kevon Looney', '882-198-4781'),
('CUS022', 'Bol Bol', '222-111-3339'),
('CUS023', 'Leonardo DiCaprio', '103-838-3920'),
('CUS024', 'Michael Jordan', '131-332-4910'),
('CUS025', 'Kevin Hart', '910-312-4456'),
('CUS026', 'Dwayne Johnson', '392-222-3213'); 
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO StatusInvoice(StatusInvoiceID, NameStatusInvoice) VALUES
('STATUS001', 'Pending'),
('STATUS002', 'Paid'),
('STATUS003', 'Cancelled'),
('STATUS004', 'Checked in'),
('STATUS005', 'Checked out')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO StatusInvoice_Details(InvoiceDetailsID, CheckIn_Time, CheckOut_Time, StatusInvoice) VALUES
('DEID001', null, null, 'STATUS002'),
('DEID002', null, null, 'STATUS002'),
('DEID003', null, null, 'STATUS001'),
('DEID004', '09:49:12', null, 'STATUS004'),
('DEID005', null, null, 'STATUS003'),
('DEID006', '12:30:23', '13:41:32', 'STATUS005'),
('DEID007', null, null, 'STATUS002'),
('DEID008', null, null, 'STATUS003'),
('DEID009', '18:22:32', null, 'STATUS004'),
('DEID010', '08:13:21', '09:32:02', 'STATUS005'),
('DEID011', null, null, 'STATUS001'),
('DEID012', '18:32:32', '19:32:32', 'STATUS005'),
('DEID013', '15:33:23', '16:32:32', 'STATUS005'),
('DEID014', '09:00:32', '10:32:32', 'STATUS005'),
('DEID015', '11:10:21', '12:32:01', 'STATUS005'),
('DEID016', '08:00:11', '09:15:21', 'STATUS005'),
('DEID017', '18:21:33', '19:00:32', 'STATUS005'),
('DEID018', null, null, 'STATUS002'),
('DEID019', '20:00:32', '21:12:09', 'STATUS005'),
('DEID020', '17:00:32', '18:18:09', 'STATUS005'),
('DEID021', '14:52:33', '16:10:11', 'STATUS005'),
('DEID022', '19:01:22', '20:09:31', 'STATUS005'),
('DEID023', '13:32:32', '14:32:32', 'STATUS005'),
('DEID024', '18:54:21', '20:00:03', 'STATUS005'),
('DEID025', '15:33:11', '16:32:32', 'STATUS005'),
('DEID026', '18:32:43', '19:32:32', 'STATUS005'),
('DEID027', '07:23:01', '08:13:03', 'STATUS002'),
('DEID028', '13:00:00', null, 'STATUS004'),
('DEID029', null, null, 'STATUS003'),
('DEID030', '18:00:32', null, 'STATUS004'),
('DEID031', null, null, 'STATUS002'),
('DEID032', null, null, 'STATUS003'),
('DEID033', '17:41:32', '19:10:00', 'STATUS002'),
('DEID034', null, null, 'STATUS003'),
('DEID035', null, null, 'STATUS001'),
('DEID036', null, null, 'STATUS001')

-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Invoice(InvoiceID, CreationTime, Price,Discount, InvoiceDetails) VALUES
('IN001', '2023/02/12 18:32:43', 1220000,0, 'DEID001'),
('IN002', '2023/03/12 14:11:43', 84000,0, 'DEID002'),
('IN003', '2022/07/11 06:32:43', 428000,0, 'DEID003'),
('IN004', '2021/04/16 13:11:21', 290000,0, 'DEID004'),
('IN005', '2023/01/01 23:11:43', 1900000,0, 'DEID005'),
('IN006', '2019/12/05 14:11:43', 160000,0, 'DEID006'),
('IN007', '2022/08/31 16:10:32', 420000,0, 'DEID007'),
('IN008', '2023/01/31 18:40:43', 270000,0, 'DEID008'),
('IN009', '2021/06/23 19:11:43', 1920000,0, 'DEID009'),
('IN010', '2022/03/22 23:32:43', 300000,0, 'DEID010'),
('IN011', '2022/02/14 12:32:43', 2180000,0, 'DEID011'),
('IN012', '2022/09/01 10:11:23', 3600000,0, 'DEID012'),
('IN013', '2021/01/12 09:00:12', 2500000,0, 'DEID013'),
('IN014', '2022/06/27 07:40:43', 202000,0, 'DEID014'),
('IN015', '2022/03/27 11:32:43', 190000,0, 'DEID015'),
('IN016', '2023/03/20 18:00:01', 340000,0, 'DEID016'),
('IN017', '2023/05/02 18:55:43', 360000,0, 'DEID017'),
('IN018', '2023/02/26 20:17:12', 210000,0, 'DEID018'),
('IN019', '2023/02/12 20:32:12', 2450000,0, 'DEID019'),
('IN020', '2021/05/17 19:10:17', 1560000,0, 'DEID020'),
('IN021', '2021/09/30 13:19:41', 390000,0, 'DEID021'),
('IN022', '2022/04/12 14:12:03', 720000,0, 'DEID022'),
('IN023', '2022/11/06 15:16:06', 345000,0, 'DEID023'),
('IN024', '2021/12/12 10:18:07', 186000,0, 'DEID024'),
('IN025', '2022/03/04 18:12:01', 200000,0, 'DEID025'),
('IN026', '2023/01/05 20:32:43', 400000,0, 'DEID026'),
('IN027', '2023/02/04 08:12:02', 150000,0, 'DEID027'),
('IN028', '2023/02/04 14:13:02', 1020000,0, 'DEID028'),
('IN029', '2023/03/01 18:30:32', 200000,0, 'DEID029'),
('IN030', '2023/01/19 17:30:32', 800000,0, 'DEID030'),
('IN031', '2023/03/22 21:00:01', 640000,0, 'DEID031'),
('IN032', '2023/04/11 22:01:49', 250000,0, 'DEID032'),
('IN033', '2023/04/04 19:02:00', 72000,0, 'DEID033'),
('IN034', '2023/02/28 10:32:11', 100000,0, 'DEID034'),
('IN035', '2023/01/28 12:48:21', 20000,0, 'DEID035'),
('IN036', '2023/05/01 13:50:21', 60000,0, 'DEID036')

-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Services(IDServices ,NameServices) VALUES 
('SER111', 'Room services'),
('SER222', 'Attachment services'),
('SER333', 'Promotion services')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO TypeServices(IDType,NameType,IDServices,Price) VALUES
('TYP111', 'Buffet room','SER111',400000),
('TYP112', 'Normal private room','SER111',200000),
('TYP113', 'VIP private room','SER111',300000),
('TYP114', 'Common dining room','SER111',50000),
('TYP211', 'Event organization','SER222',20000000),
('TYP212', 'VIP service staff','SER222',100000),
('TYP311', 'Guitar music','SER333',0), --combo tình nhân
('TYP312', 'Piano music','SER333',0),  --combo gia đình
('TYP313', 'Karaoke','SER333',0)		  --combo bạn bè


-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO TablesCustomer(TablesID,MaxSeats,RoomType,Status) VALUES
('TAB001', 4,'TYP111',1),
('TAB002', 4,'TYP111',1),
('TAB003', 4,'TYP111',1),
('TAB004', 5,'TYP112',1),
('TAB005', 5,'TYP112',1),
('TAB006', 5,'TYP112',1),
('TAB007', 6,'TYP113',1),
('TAB008', 6,'TYP113',1),
('TAB009', 6,'TYP113',1),
('TAB010', 5,'TYP114',1),
('TAB011', 5,'TYP114',1),
('TAB012', 5,'TYP114',1),
('TAB013', 8,'TYP111',0),
('TAB014', 6,'TYP112',0),
('TAB015', 4,'TYP114',0),
('TAB016', 2,'TYP113',0),
('TAB017', 2,'TYP114',0),
('TAB018', 2,'TYP111',0),
('TAB019', 2,'TYP112',0),
('TAB020', 2,'TYP113',0),
('TAB021', 4,'TYP114',0),
('TAB022', 4,'TYP111',0);
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Customer_TypeServices(CustomerID, IDTypeServices, Quantity, TotalMoney) VALUES
('CUS001', 'TYP111',1,400000),
('CUS002', 'TYP112',1,200000),
('CUS003', 'TYP113',1,300000),
('CUS004', 'TYP114',1,50000),
('CUS005', 'TYP211',1,20000000),
('CUS006', 'TYP212',1,100000),
('CUS007', 'TYP311',1,0),
('CUS008', 'TYP312',1,0),
('CUS009', 'TYP313',1,0),
('CUS010', 'TYP111',1,400000),
('CUS011', 'TYP112',1,200000),
('CUS012', 'TYP113',1,300000),
('CUS013', 'TYP114',1,50000),
('CUS014', 'TYP211',1,20000000),
('CUS015', 'TYP212',1,100000),
('CUS016', 'TYP311',1,0),
('CUS017', 'TYP312',1,0),
('CUS018', 'TYP313',1,0),
('CUS019', 'TYP111',1,400000),
('CUS020', 'TYP112',1,200000),
('CUS021', 'TYP113',1,300000),
('CUS022', 'TYP114',1,50000),
('CUS023', 'TYP211',1,20000000),
('CUS024', 'TYP212',1,100000),
('CUS025', 'TYP311',1,0),
('CUS026', 'TYP312',1,0);
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Booking (BookingID,BookingDate,BookingStatus,Duration,Note,NumberCustomer,CustomerBooking,ServiceBooking,TableBooking,BookingInvoice) VALUES	
('BI001','2022/03/04','Success',3,'None note',1,'CUS001','TYP111','TAB001','IN001'),
('BI002','2021/03/04','Received',4,'None note',2,'CUS002','TYP112','TAB002','IN002'),
('BI003','2023/06/01','Cancel',5,'None note',3,'CUS003','TYP113','TAB003','IN003'),
('BI004','2023/06/04','Success',2,'None note',4,'CUS004','TYP114','TAB004','IN004'),
('BI005','2023/01/04','Received',6,'None note',5,'CUS005','TYP111','TAB005','IN005'),
('BI006','2022/02/04','Cancel',3,'None note',4,'CUS006','TYP112','TAB006','IN006'),
('BI007','2022/03/03','Success',3,'None note',3,'CUS007','TYP113','TAB007','IN007'),
('BI008','2022/03/05','Cancel',2,'None note',3,'CUS008','TYP114','TAB008','IN008'),
('BI009','2022/03/07','Success',3,'None note',2,'CUS009','TYP111','TAB009','IN009'),
('BI010','2023/03/08','Success',4,'None note',2,'CUS010','TYP112','TAB010','IN010'),
('BI011','2023/03/09','Received',3,'None note',6,'CUS011','TYP113','TAB011','IN011'),
('BI012','2022/05/04','Success',5,'None note',7,'CUS012','TYP114','TAB012','IN012'),
('BI013','2022/06/04','Success',3,'None note',5,'CUS013','TYP111','TAB001','IN013'),
('BI014','2022/08/04','Received',2,'None note',5,'CUS014','TYP112','TAB002','IN014'),
('BI015','2022/07/04','Success',3,'None note',3,'CUS015','TYP113','TAB003','IN015'),
('BI016','2022/03/06','Success',4,'None note',5,'CUS016','TYP114','TAB004','IN016'),
('BI017','2022/03/05','Received',4,'None note',5,'CUS017','TYP111','TAB005','IN017'),
('BI018','2022/06/04','Success',3,'None note',5,'CUS018','TYP112','TAB006','IN018'),
('BI019','2022/04/04','Received',5,'None note',6,'CUS019','TYP113','TAB007','IN019'),
('BI020','2022/03/04','Success',5,'None note',2,'CUS020','TYP114','TAB008','IN020'),
('BI021','2022/02/04','Success',3,'None note',7,'CUS021','TYP111','TAB009','IN021'),
('BI022','2022/03/04','Cancel',3,'None note',3,'CUS022','TYP112','TAB010','IN022'),
('BI023','2022/01/04','Cancel',3,'None note',3,'CUS023','TYP113','TAB011','IN023'),
('BI024','2022/02/04','Success',2,'None note',5,'CUS024','TYP114','TAB012','IN024'),
('BI025','2022/03/01','Success',3,'None note',6,'CUS025','TYP111','TAB011','IN025'),
('BI026','2022/03/02','Success',4,'None note',6,'CUS026','TYP112','TAB001','IN026'),
('BI027','2023/01/02','Success',4,'None note',6,'CUS001','TYP112','TAB001','IN027'),
('BI028','2023/01/21','Received',4,'None note',6,'CUS002','TYP113','TAB009','IN028'),
('BI029','2022/12/31','Cancel',4,'None note',6,'CUS003','TYP112','TAB010','IN029'),
('BI030','2022/11/29','Success',4,'None note',6,'CUS004','TYP114','TAB012','IN030'),
('BI031','2023/03/02','Received',4,'None note',6,'CUS005','TYP112','TAB011','IN031'),
('BI032','2023/01/02','Cancel',4,'None note',6,'CUS006','TYP113','TAB010','IN032'),
('BI033','2023/04/02','Success',4,'None note',6,'CUS007','TYP114','TAB012','IN033'),
('BI034','2023/02/02','Cancel',4,'None note',6,'CUS008','TYP112','TAB002','IN034'),
('BI035','2023/01/02','Received',4,'None note',6,'CUS009','TYP112','TAB004','IN035'),
('BI036','2023/04/02','Received',4,'None note',6,'CUS010','TYP114','TAB004','IN036')

-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Product_Type (IDType, ProductType) VALUES
('PROTYPE001', 'Barbecue'),
('PROTYPE002', 'Hotpot'),
('PROTYPE003', 'Snack'),
('PROTYPE004', 'Soft drink'),
('PROTYPE005', 'Beer'),
('PROTYPE006', 'Wine'),
('PROTYPE007', 'Milk tea');
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Product (ProductID, NameProduct, Price, Description, ProductState, Product_Type) VALUES 
('PRO001', 'Combo BBQ 1', 200000, 'Beef brisket, green catfish, octopus',  1, 'PROTYPE001'),
('PRO002', 'Combo BBQ 2', 150000, 'Beef chuck eye roll, beef rib finger', 1, 'PROTYPE001'),
('PRO003', 'Combo BBQ 3', 200000, 'Prawn, squid with salt & chilli sauce, green catfish, foil grilled yellowtail catfish', 1, 'PROTYPE001'),
('PRO004', 'Combo BBQ 4', 100000, 'Pork ribs, pork collar, pork belly', 1, 'PROTYPE001'),
('PRO005', 'Mushroom broth', 300000, 'Chuck steak, minced beef stuffed in bamboo', 1, 'PROTYPE002'),
('PRO006', 'Tomyum broth', 320000, 'Green mussels, giant river prawn', 1, 'PROTYPE002'),
('PRO007', 'Sukiyaki broth', 300000, 'Beef volcano, short plate, blossom brisket', 1, 'PROTYPE002'),
('PRO008', 'Bulgogi broth', 250000, 'Pork belly, tofu', 1, 'PROTYPE002'),
('PRO009', 'Sichuan broth', 340000, 'Tuna fillet, red tilapia fillet', 1, 'PROTYPE002'),
('PRO010', 'Fried potato', 30000, 'Fried potato with cheese shake', 1, 'PROTYPE003'),
('PRO011', 'Soup', 20000, 'Chicken bones broth and eggs, crab meat', 1, 'PROTYPE003'),
('PRO012', 'Coca Cola', 10000, 'Soft drink', 1, 'PROTYPE004'),
('PRO013', 'Sprite', 10000, 'Soft drink with lemon flavor', 1, 'PROTYPE004'),
('PRO014', 'Fanta', 10000, 'Soft drink with orange flavor', 1, 'PROTYPE004'),
('PRO015', 'Heineken', 12000, 'Beer', 1, 'PROTYPE005'),
('PRO016', 'Budweiser', 12000, 'Beer', 1, 'PROTYPE005'),
('PRO017', 'Penfolds', 50000, 'Australia wine', 1, 'PROTYPE006'),
('PRO018', 'Scharzhof', 52000, 'German wine', 1, 'PROTYPE006'),
('PRO019', 'Hong Kong tranditional milk tea', 30000, 'matcha tea with milk and bubble', 1, 'PROTYPE007'),
('PRO020', 'Koi milk tea', 30000, 'Black tea and milk mixed with bubbles or fruit jelly', 1, 'PROTYPE007'),
('PRO021', 'Taiwanese milk tea', 25000, 'Brown sugar syrup and strong black tea with creamy milk', 1, 'PROTYPE007');
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Orders (OrderID, DatetimeOrder, Total_Unit_Price, StateOrder, CustomerOrder, OrderStaff, Invoice) VALUES 
('ORD001', '2023/02/12', 1200000, 1, 'CUS001', 'STA001', 'IN001'),
('ORD002', '2023/03/12', 24000, 1, 'CUS002', 'STA005', 'IN002'),
('ORD003', '2022/07/11', 108000, 1, 'CUS003', 'STA005', 'IN003'),
('ORD004', '2021/04/16', 90000, 1, 'CUS004', 'STA004', 'IN004'),
('ORD005', '2023/01/01', 1000000, 1, 'CUS006', 'STA006', 'IN006'),
('ORD006', '2023/01/03', 60000, 1,'CUS006', 'STA006', 'IN006'),
('ORD007', '2022/08/31', 100000, 1, 'CUS007', 'STA002', 'IN007'),
('ORD008', '2023/01/31', 90000, 1, 'CUS008', 'STA001', 'IN008'),
('ORD009', '2021/06/23', 1600000, 1, 'CUS009', 'STA009', 'IN009'),
('ORD010', '2022/03/22', 200000, 1, 'CUS010', 'STA006', 'IN010'),
('ORD011', '2022/02/14', 1500000, 1, 'CUS011', 'STA003', 'IN011'),
('ORD012', '2022/09/01', 2100000, 1, 'CUS012', 'STA004', 'IN012'),
('ORD013', '2021/01/12', 1000000, 1, 'CUS013', 'STA008', 'IN013'),
('ORD014', '2022/06/27', 150000, 1, 'CUS014', 'STA003', 'IN014'),
('ORD015', '2022/03/27', 40000, 1, 'CUS015', 'STA006', 'IN015'),
('ORD016', '2023/03/20', 250000, 1, 'CUS016', 'STA007', 'IN016'),
('ORD017', '2023/05/02', 200000, 1, 'CUS017', 'STA007', 'IN017'),
('ORD018', '2023/02/26', 10000, 1, 'CUS018', 'STA002', 'IN018'),
('ORD019', '2023/02/12', 2400000, 1, 'CUS019', 'STA009', 'IN019'),
('ORD020', '2021/05/17', 1500000, 1, 'CUS020', 'STA008', 'IN020'),
('ORD021', '2021/09/30', 240000, 1, 'CUS021', 'STA002', 'IN021'),
('ORD022', '2022/04/12', 40000, 1, 'CUS022', 'STA008', 'IN022'),
('ORD023', '2022/11/06', 270000, 1, 'CUS023', 'STA003', 'IN023'),
('ORD024', '2021/12/12', 156000, 1, 'CUS024', 'STA004', 'IN024'),
('ORD025', '2022/03/04', 200000, 1, 'CUS025', 'STA005', 'IN025'),
('ORD026', '2023/01/05', 400000, 1, 'CUS026', 'STA001', 'IN026'),
('ORD027', '2023/02/12', 20000, 1, null, 'STA001', null),
('ORD028', '2023/03/12', 60000, 1, null, 'STA005', null),
('ORD029', '2022/07/11', 320000, 1, null, 'STA005', null),
('ORD030', '2021/04/16', 200000, 1, null, 'STA004', null),
('ORD031', '2022/02/21', 900000, 1, null, 'STA005', null),
('ORD032', '2023/01/03', 100000, 1,null, 'STA006', null),
('ORD033', '2022/08/31', 320000, 1,null, 'STA002',null),
('ORD034', '2023/01/31', 180000, 1, null, 'STA001', null),
('ORD035', '2021/06/23', 320000, 1,null, 'STA009',null),
('ORD036', '2022/03/22', 100000, 1, null, 'STA006',null),
('ORD037', '2022/02/14', 680000, 1,null, 'STA003', null),
('ORD038', '2022/09/01', 1500000, 1, null, 'STA004', null),
('ORD039', '2021/01/12', 1500000, 1, null, 'STA008', null),
('ORD040', '2022/06/27', 52000, 1, null, 'STA003', null),
('ORD041', '2022/03/27', 150000, 1,null, 'STA006',null),
('ORD042', '2023/03/20', 90000, 1, null, 'STA007', null),
('ORD043', '2023/05/02', 160000, 1,null, 'STA007',null),
('ORD044', '2023/02/26', 200000, 1, null, 'STA002', null),
('ORD045', '2023/02/12', 50000, 1, null, 'STA009', null),
('ORD046', '2021/05/17', 60000, 1, null, 'STA008',null),
('ORD047', '2021/09/30', 150000, 1, null, 'STA002', null),
('ORD048', '2022/04/12', 680000, 1,null, 'STA008',null),
('ORD049', '2022/11/06', 75000, 1, null, 'STA003', null),
('ORD050', '2021/12/12', 30000, 1, null, 'STA004', null),
('ORD051', '2023/02/04', 150000, 1, 'CUS001', 'STA002', 'IN027'),
('ORD052', '2023/02/04', 1020000, 1, 'CUS002', 'STA003', 'IN028'),
('ORD053', '2023/03/01', 200000, 1, 'CUS003', 'STA004', 'IN029'),
('ORD054', '2023/01/19', 800000, 1, 'CUS004', 'STA005', 'IN030'),
('ORD055', '2023/03/22', 640000, 1, 'CUS005', 'STA006', 'IN031'),
('ORD056', '2023/04/11', 250000, 1, 'CUS006', 'STA007', 'IN032'),
('ORD057', '2023/04/04', 72000, 1, 'CUS007', 'STA008', 'IN033'),
('ORD058', '2023/02/28', 100000, 1, 'CUS008', 'STA009', 'IN034'),
('ORD059', '2023/01/28', 20000, 1, 'CUS009', 'STA004', 'IN035'),
('ORD060', '2023/05/01', 60000, 1, 'CUS010', 'STA001', 'IN036')

-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO OrderDetails (OrderDetailsID, ProductID, Quantity, OrderID) VALUES
('ODETAIL001', 'PRO007', '4', 'ORD001'),
('ODETAIL002', 'PRO016', '2', 'ORD002'),
('ODETAIL003', 'PRO015', '9', 'ORD003'),
('ODETAIL004', 'PRO012', '9', 'ORD004'),
('ODETAIL005', 'PRO003', '5', 'ORD005'),
('ODETAIL006', 'PRO010', '2', 'ORD006'),
('ODETAIL007', 'PRO011', '5', 'ORD007'),
('ODETAIL008', 'PRO019', '3', 'ORD008'),
('ODETAIL009', 'PRO001', '8', 'ORD009'),
('ODETAIL010', 'PRO004', '2', 'ORD010'),
('ODETAIL011', 'PRO008', '6', 'ORD011'),
('ODETAIL012', 'PRO007', '7', 'ORD012'),
('ODETAIL013', 'PRO003', '5', 'ORD013'),
('ODETAIL014', 'PRO021', '6', 'ORD014'),
('ODETAIL015', 'PRO013', '4', 'ORD015'),
('ODETAIL016', 'PRO017', '5', 'ORD016'),
('ODETAIL017', 'PRO018', '1', 'ORD017'),
('ODETAIL018', 'PRO012', '1', 'ORD018'),
('ODETAIL019', 'PRO005', '8', 'ORD019'),
('ODETAIL020', 'PRO002', '10', 'ORD020'),
('ODETAIL021', 'PRO020', '8', 'ORD021'),
('ODETAIL022', 'PRO014', '4', 'ORD022'),
('ODETAIL023', 'PRO010', '9', 'ORD023'),
('ODETAIL024', 'PRO018', '3', 'ORD024'),
('ODETAIL025', 'PRO003', '1', 'ORD025'),
('ODETAIL026', 'PRO004', '4', 'ORD026'),
('ODETAIL027', 'PRO012', '2', 'ORD027'),
('ODETAIL028', 'PRO016', '5', 'ORD028'),
('ODETAIL029', 'PRO006', '1', 'ORD029'),
('ODETAIL030', 'PRO001', '1', 'ORD030'),
('ODETAIL031', 'PRO007', '3', 'ORD031'),
('ODETAIL032', 'PRO011', '5', 'ORD032'),
('ODETAIL033', 'PRO006', '1', 'ORD033'),
('ODETAIL034', 'PRO010', '6', 'ORD034'),
('ODETAIL035', 'PRO006', '1', 'ORD035'),
('ODETAIL036', 'PRO004', '1', 'ORD036'),
('ODETAIL037', 'PRO009', '2', 'ORD037'),
('ODETAIL038', 'PRO005', '3', 'ORD038'),
('ODETAIL039', 'PRO008', '2', 'ORD039'),
('ODETAIL040', 'PRO018', '1', 'ORD040'),
('ODETAIL041', 'PRO021', '6', 'ORD041'),
('ODETAIL042', 'PRO010', '3', 'ORD042'),
('ODETAIL043', 'PRO011', '8', 'ORD043'),
('ODETAIL044', 'PRO001', '1', 'ORD044'),
('ODETAIL045', 'PRO017', '1', 'ORD045'),
('ODETAIL046', 'PRO015', '5', 'ORD046'),
('ODETAIL047', 'PRO002', '1', 'ORD047'),
('ODETAIL048', 'PRO009', '2', 'ORD048'),
('ODETAIL049', 'PRO021', '3', 'ORD049'),
('ODETAIL050', 'PRO020', '1', 'ORD050'),
('ODETAIL051', 'PRO002', '1', 'ORD051'),
('ODETAIL052', 'PRO009', '3', 'ORD052'),
('ODETAIL053', 'PRO017', '4', 'ORD053'),
('ODETAIL054', 'PRO001', '4', 'ORD054'),
('ODETAIL055', 'PRO006', '2', 'ORD055'),
('ODETAIL056', 'PRO008', '1', 'ORD056'),
('ODETAIL057', 'PRO015', '6', 'ORD057'),
('ODETAIL058', 'PRO021', '4', 'ORD058'),
('ODETAIL059', 'PRO014', '2', 'ORD059'),
('ODETAIL060', 'PRO010', '2', 'ORD060'),
('ODETAIL061', 'PRO010', '1', 'ORD001'),
('ODETAIL062', 'PRO011', '1', 'ORD001'),
('ODETAIL063', 'PRO008', '3', 'ORD001'),
('ODETAIL064', 'PRO002', '4', 'ORD002'),
('ODETAIL065', 'PRO010', '2', 'ORD002'),
('ODETAIL066', 'PRO012', '5', 'ORD002'),
('ODETAIL067', 'PRO019', '1', 'ORD003'),
('ODETAIL068', 'PRO015', '2', 'ORD004'),
('ODETAIL069', 'PRO011', '1', 'ORD004'),
('ODETAIL070', 'PRO002', '1', 'ORD001'),
('ODETAIL071', 'PRO004', '2', 'ORD001');
-------------------------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Service_Product (IDProduct, IDServices) VALUES
('PRO001', 'TYP111'),
('PRO002', 'TYP112'),
('PRO003', 'TYP113'),
('PRO004', 'TYP114'),
('PRO005', 'TYP211'),
('PRO006', 'TYP212'),
('PRO007', 'TYP311'),
('PRO008', 'TYP312'),
('PRO009', 'TYP313'),
('PRO010', 'TYP313'),
('PRO011', 'TYP312'),
('PRO012', 'TYP111'),
('PRO013', 'TYP111'),
('PRO014', 'TYP112'),
('PRO015', 'TYP112'),
('PRO016', 'TYP113'),
('PRO017', 'TYP113'),
('PRO018', 'TYP114'),
('PRO019', 'TYP114'),
('PRO020', 'TYP212'),
('PRO021', 'TYP311');

---------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
/*																																			*/
/*																			TRIGGER															*/
/*																																			*/
---------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
--GO
--CREATE OR ALTER TRIGGER tg_DeleteCustomer
--ON	  Customers
--FOR	  DELETE
--AS
--	DECLARE 	@IDCus 	nvarchar(10)
--	SELECT @IDCus = CustomerID
--	FROM DELETED
	
--	DELETE FROM Customer_TypeServices WHERE CustomerID =@IDCus
--	DELETE FROM Booking WHERE CustomerBooking =@IDCus
--	DELETE FROM Orders WHERE CustomerOrder =@IDCus

--GO
--CREATE OR ALTER TRIGGER tg_DeleteStaff
--ON	  Staff
--FOR	  DELETE
--AS
--	DECLARE 	@StaID 	nvarchar(10)
--	SELECT @StaID=StaffID
--	FROM DELETED
	
--	DELETE FROM Orders WHERE OrderStaff=@StaID
--	DELETE FROM Account WHERE AccountID=@StaID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteStaff_Position
--ON	  Staff_Position
--FOR	  DELETE
--AS
--	DECLARE 	@IDPos 	nvarchar(10)
--	SELECT @IDPos=IDPosition
--	FROM DELETED
	
--	DELETE FROM Staff WHERE Position=@IDPos

--GO
--CREATE OR ALTER TRIGGER tg_DeleteProduct
--ON	  Product
--FOR	  DELETE
--AS
--	DECLARE 	@ProID 	nvarchar(10)
--	SELECT @ProID=ProductID
--	FROM DELETED
	
--	DELETE FROM OrderDetails WHERE ProductID=@ProID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteProduct_Type
--ON	  Product_Type
--FOR	  DELETE
--AS
--	DECLARE 	@IDTypePro 	nvarchar(10)
--	SELECT @IDTypePro=IDType
--	FROM DELETED
	
--	DELETE FROM Product WHERE Product_Type=@IDTypePro

--GO
--CREATE OR ALTER TRIGGER tg_DeleteServices
--ON	  Services
--FOR	  DELETE
--AS
--	DECLARE 	@IDSer 	nvarchar(10)
--	SELECT @IDSer=IDServices
--	FROM DELETED
	
--	DELETE FROM TypeServices WHERE IDType= @IDSer

--GO
--CREATE OR ALTER TRIGGER tg_DeleteTypeServices
--ON	  TypeServices
--FOR	  DELETE
--AS
--	DECLARE 	@IDTypeSer 	nvarchar(10)
--	SELECT @IDTypeSer=IDType
--	FROM DELETED
	
--	DELETE FROM TablesCustomer WHERE RoomType= @IDTypeSer
--	DELETE FROM Customer_TypeServices WHERE IDTypeServices= @IDTypeSer
--	DELETE FROM Booking WHERE ServiceBooking= @IDTypeSer

--GO
--CREATE OR ALTER TRIGGER tg_DeleteTablesCustomer
--ON	  TablesCustomer
--FOR	  DELETE
--AS
--	DECLARE 	@TabID 	nvarchar(10)
--	SELECT @TabID=TablesID
--	FROM DELETED
	
--	DELETE FROM Booking WHERE TableBooking= @TabID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteInvoice
--ON	  Invoice
--FOR	  DELETE
--AS
--	DECLARE 	@InvID 	nvarchar(10)
--	SELECT @InvID=InvoiceID
--	FROM DELETED
	
--	DELETE FROM Booking WHERE BookingInvoice= @InvID
--	DELETE FROM Orders WHERE Invoice= @InvID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteStatusInvoice
--ON	  StatusInvoice
--FOR	  DELETE
--AS
--	DECLARE 	@StatusInvID 	nvarchar(10)
--	SELECT @StatusInvID=StatusInvoiceID
--	FROM DELETED
	
--	DELETE FROM StatusInvoice_Details WHERE StatusInvoice= @StatusInvID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteStatusInvoice_Details
--ON	  StatusInvoice_Details
--FOR	  DELETE
--AS
--	DECLARE 	@InvDetailsID 	nvarchar(10)
--	SELECT @InvDetailsID=InvoiceDetailsID
--	FROM DELETED
	
--	DELETE FROM Invoice WHERE InvoiceDetails= @InvDetailsID

--GO
--CREATE OR ALTER TRIGGER tg_DeleteOrderDetails
--ON	  OrderDetails
--FOR	  DELETE
--AS
--	DECLARE 	@OrderID 	nvarchar(10)
--	SELECT @OrderID=OrderID
--	FROM DELETED
	
--	DELETE FROM Orders WHERE OrderID= @OrderID
---------------------------------------------------------------------------------------------------------------------------------------------------------
--GO

--CREATE OR ALTER TRIGGER tg_Combo
--ON	  OrderDetails
--FOR	  INSERT, UPDATE
--AS
--	DECLARE 	@OrderID 	nvarchar(10), @TypSerID 	nvarchar(10), @ProID 	nvarchar(10)
--	SELECT @OrderID = i.OrderID, @TypSerID= sp.IDServices, @ProID = i.ProductID
--	FROM INSERTED i INNER JOIN Service_Product sp ON i.ProductID = sp.IDProduct

--	IF @ProID NOT IN (SELECT IDProduct FROM Service_Product)
--		return;
--	DECLARE 	@CusOrder 	nvarchar(10)
--	SELECT @CusOrder = CustomerOrder
--	FROM Orders 
--	WHERE OrderID = @OrderID

--	INSERT INTO Customer_TypeServices(CustomerID,IDTypeServices,Quantity,TotalMoney)
--	VALUES (@CusOrder,@TypSerID,1,0)
---------------------------------------------------------------------------------------------------------------------------------------------------------
--GO
--CREATE OR ALTER TRIGGER tg_CustomersInsertInvalidvalue
--ON	  Customers
--FOR	  INSERT, UPDATE
--AS
--BEGIN
--	DECLARE 	@CusID 	nvarchar(10), @NumPhone 	nvarchar(10)
--	SELECT @CusID = i.CustomerID, @NumPhone= i.NumberPhone
--	FROM INSERTED i

--	IF @CusID IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'CustomerID NOT NULL'
--	END
--	ELSE IF @CusID NOT LIKE 'CUS%'
--	BEGIN
--		UPDATE Customers SET CustomerID = CONCAT('CUS',@CusID) WHERE CustomerID = @CusID
--	END
--	ELSE IF (SELECT COUNT(CustomerID) FROM  Customers WHERE CustomerID = @CusID) > 1
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'CustomerID already exist'
--	END
--	IF @NumPhone IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'NumberPhone NOT NULL'
--	END
--END

--GO
--CREATE OR ALTER TRIGGER tg_ServicesInsertInvalidvalue
--ON	  Services
--FOR	  INSERT, UPDATE
--AS
--BEGIN
--	DECLARE 	@IDSer 	nvarchar(10), @NameSer 	nvarchar(100)
--	SELECT @IDSer = i.IDServices, @NameSer= i.NameServices
--	FROM INSERTED i

--	IF @IDSer IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDServices NOT NULL'
--	END
--	ELSE IF @IDSer NOT LIKE 'SER%'
--	BEGIN
--		UPDATE Services SET IDServices = CONCAT('SER',@IDSer) WHERE IDServices = @IDSer
--	END
--	ELSE IF (SELECT COUNT(IDServices) FROM  Services WHERE IDServices = @IDSer) > 1
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDServices already exist'
--	END
--	IF @NameSer IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT '@NameSer NOT NULL'
--	END
--	ELSE IF @NameSer IN (SELECT NameServices FROM  Services)
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'NameServices already exist'
--	END
--END

--GO
--CREATE OR ALTER TRIGGER tg_TypeServicesInsertInvalidvalue
--ON	  TypeServices
--FOR	  INSERT, UPDATE
--AS
--BEGIN 
--	DECLARE 	@IDType 	nvarchar(10), @NameType 	nvarchar(100)
--	, @IDSer 	nvarchar(10), @Price BIGINT
--	SELECT @IDType = i.IDType , @NameType= i.NameType, @IDSer= i.IDServices, @Price =i.Price
--	FROM INSERTED i

--	IF @IDType IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDType NOT NULL'
--	END
--	ELSE IF @IDType NOT LIKE 'SER%'
--	BEGIN
--		UPDATE TypeServices SET IDType = CONCAT('TYP3',@IDType) WHERE IDType = @IDType
--	END
--	ELSE IF (SELECT COUNT(IDType) FROM  TypeServices WHERE IDType = @IDType) > 1
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDType already exist'
--	END

--	IF @NameType IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'NameType NOT NULL'
--	END
--	ELSE IF (SELECT COUNT(NameType) FROM  TypeServices WHERE IDType = @NameType) > 1
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'NameServices already exist'
--	END

--	IF @IDSer IS NULL
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDServices NOT NULL'
--	END
--	ELSE IF @IDSer LIKE 'TYP3%'
--	BEGIN
--		UPDATE TypeServices SET Price = 0 WHERE IDType = @IDType
--	END
--	ELSE IF @IDSer NOT LIKE 'TYP1%' and @IDType NOT LIKE 'TYP2%' and @IDType NOT LIKE 'TYP3%'
--	BEGIN
--		UPDATE TypeServices SET IDServices = CONCAT('SER',@IDSer) WHERE IDType = @IDType
--	END
--	ELSE IF @IDSer NOT IN (SELECT IDServices FROM  Services)
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'IDServices not in Services'
--	END

--	IF @Price<0
--		UPDATE TypeServices SET Price = 0 WHERE IDType = @IDType
--END

--GO
--CREATE OR ALTER TRIGGER tg_Customer_TypeServicesInsertInvalidvalue
--ON	  Customer_TypeServices
--FOR	  INSERT, UPDATE
--AS
--BEGIN 
--	DECLARE 	@Quantity 	int, @TotalMoney 	BIGINT, @CusID nvarchar(10),@IDTypeSer nvarchar(10)

--	SELECT @Quantity = i.Quantity , @TotalMoney= i.TotalMoney, @CusID = CustomerID, @IDTypeSer =IDTypeServices
--	FROM INSERTED i

--	IF @Quantity <= 0
--		UPDATE Customer_TypeServices SET Quantity =1 WHERE CustomerID = @CusID and IDTypeServices = @IDTypeSer
--	IF @TotalMoney < 0
--		UPDATE Customer_TypeServices SET TotalMoney =0 WHERE CustomerID = @CusID and IDTypeServices = @IDTypeSer

--END

--GO
--CREATE OR ALTER TRIGGER tg_TablesCustomerInsertInvalidvalue
--ON	  TablesCustomer
--FOR	  INSERT, UPDATE
--AS
--BEGIN 
--	DECLARE 	@MaxSeats 	int, @TabID nvarchar(10)

--	SELECT @MaxSeats = i.MaxSeats , @TabID= i.TablesID
--	FROM INSERTED i
--	IF @TabID NOT LIKE 'TAB%'
--		UPDATE TablesCustomer SET TablesID = CONCAT('TAB',@TabID) WHERE TablesID = @TabID
--	IF @MaxSeats <=0 
--		UPDATE TablesCustomer SET MaxSeats = 1 WHERE TablesID = @TabID
--	IF @MaxSeats >10
--		UPDATE TablesCustomer SET MaxSeats = 10 WHERE TablesID = @TabID
--	UPDATE TablesCustomer SET Status = 0 WHERE TablesID = @TabID
--END


----InsertOrderDetails
GO
CREATE OR ALTER TRIGGER tg_InsertOrderDetails
ON	  OrderDetails 
FOR	  INSERT
AS
BEGIN 
    SET NOCOUNT ON;
	DECLARE @OrderDetailsID nvarchar(10), @ProductID nvarchar(10)
	SELECT @OrderDetailsID = i.OrderDetailsID, @ProductID =i.ProductID FROM INSERTED i
	IF (SELECT count(*) FROM  OrderDetails WHERE OrderDetailsID =@OrderDetailsID AND ProductID= @ProductID AND OrderDetailsID IS NOT NULL) >1
	BEGIN
		ROLLBACK TRAN
		PRINT 'OrderDetailsID already exist'
		RETURN
	END 
	
	SET @OrderDetailsID = CONCAT('ODETAIL',CAST(RAND() * 10000 AS INT));
	WHILE @OrderDetailsID IN (SELECT OrderDetailsID FROM OrderDetails)
	BEGIN
		SET @OrderDetailsID = CONCAT('ODETAIL',CAST(RAND() * 10000 AS INT));
	END

	UPDATE OrderDetails
    SET OrderDetailsID = @OrderDetailsID
    WHERE OrderDetailsID IS NULL OR OrderDetailsID NOT LIKE 'ODETAIL%';
END

--INSERT INTO OrderDetails (ProductID, Quantity, OrderID) VALUES
--('PRO003', '4', 'ORD001')

----Check FK Order can null

GO
CREATE OR ALTER TRIGGER Check_FKN_Order
ON Orders
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @CustomerOrder nvarchar(10),@OrderStaff nvarchar(10), @Invoice nvarchar(10)
	SELECT @CustomerOrder = CustomerOrder,@OrderStaff = OrderStaff , @Invoice = Invoice 
	FROM INSERTED
    
    IF (@CustomerOrder IS NOT NULL) AND (NOT EXISTS(SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerOrder))
    BEGIN
		ROLLBACK TRAN
		PRINT 'Invalid CustomerOrder'
		RETURN;
    END;

    IF (@OrderStaff IS NOT NULL) AND (NOT EXISTS(SELECT StaffID FROM Staff WHERE StaffID = @OrderStaff))
    BEGIN
        ROLLBACK TRAN
		PRINT'Invalid OrderStaff';
        RETURN;
    END;

    IF (@Invoice IS NOT NULL) AND (NOT EXISTS(SELECT InvoiceID FROM Invoice WHERE InvoiceID = @Invoice))
    BEGIN
        ROLLBACK TRAN
		PRINT'Invalid Invoice';
        RETURN;
    END;
END
/*
INSERT INTO Orders (OrderID, DatetimeOrder, Total_Unit_Price, StateOrder) VALUES 
('ORD0111', '2023/02/12', 1200000, 1)
INSERT INTO Orders (OrderID, DatetimeOrder, Total_Unit_Price, StateOrder,CustomerOrder) VALUES 
('ORD0111', '2023/02/12', 1200000, 1,'CUS027')
*/
--Xóa Orders thì không ảnh hưởng các bảng khác nên không cần trigger
--DeleteOrderDetails
GO
CREATE OR ALTER TRIGGER tg_DeleteOrderDetails
ON	  OrderDetails
FOR	  DELETE
AS
	DECLARE 	@OrderID 	nvarchar(10)
	SELECT @OrderID=OrderID
	FROM DELETED
	IF @OrderID NOT IN (SELECT OrderID FROM OrderDetails)
	BEGIN
		DELETE FROM Orders WHERE OrderID= @OrderID
	END

--DELETE FROM OrderDetails WHERE OrderID ='ORD001'

-- check khóa ngoại có thể null
GO
CREATE OR ALTER TRIGGER Check_FKN_Invoice
ON Invoice
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @InvoiceDetails nvarchar(10)
	SELECT @InvoiceDetails = InvoiceDetails 
	FROM INSERTED
    
    IF (@InvoiceDetails IS NOT NULL) AND (NOT EXISTS(SELECT InvoiceDetailsID FROM StatusInvoice_Details WHERE InvoiceDetailsID = @InvoiceDetails))
    BEGIN
		ROLLBACK TRAN
		PRINT 'Invalid InvoiceDetails'
		RETURN;
    END;
END
-- Insert Invoice
GO
CREATE OR ALTER TRIGGER tg_InsertInvoice
ON	  Invoice 
FOR	  INSERT
AS
BEGIN 
	DECLARE  @IDDet nvarchar(10), @IDInv nvarchar(10)

	SELECT @IDInv = i.InvoiceID
	FROM INSERTED i

	IF (SELECT count(*) FROM  Invoice WHERE InvoiceID =@IDInv AND InvoiceID IS NOT NULL) >1
	BEGIN
		ROLLBACK TRAN
		PRINT 'InvoiceID already exist'
		RETURN
	END 

	SET @IDDet = CONCAT('DEID',CAST(RAND() * 10000 AS INT));
	WHILE @IDDet IN (SELECT InvoiceDetailsID FROM StatusInvoice_Details)
	BEGIN
		SET @IDDet = CONCAT('DEID',CAST(RAND() * 10000 AS INT));
	END

	INSERT INTO StatusInvoice_Details(InvoiceDetailsID,CheckIn_Time,CheckOut_Time,StatusInvoice) 
	VALUES (@IDDet,null,null,'STATUS001'); --'STA001' là chưa thanh toán 

	UPDATE Invoice SET InvoiceDetails = @IDDet WHERE InvoiceID = @IDInv 
END
/*
INSERT INTO Invoice(InvoiceID, CreationTime, Price, InvoiceDetails) VALUES
('IN11111', GETDATE(), 1220000, NULL)
*/
---------------------------------------------------------------------------------------------------------------------------------------------
/*																																			*/
/*																			VIEW															*/
/*																																			*/
---------------------------------------------------------------------------------------------------------------------------------------------

Go
CREATE OR ALTER VIEW FoodsView
AS
SELECT	p.ProductID ,p.NameProduct, p.Price, p.Description, p.ProductState, p.Product_Type
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND	(pt.ProductType = 'Barbecue' 
		OR	pt.ProductType = 'Hotpot' 
		OR	pt.ProductType = 'Snack')
--SELECT * FROM FoodsView

Go
CREATE OR ALTER VIEW DrinksView
AS
SELECT	p.ProductID ,p.NameProduct, p.Price, p.Description, p.ProductState, p.Product_Type
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND (pt.ProductType = 'Soft drink' 
		OR pt.ProductType = 'Beer'
		OR pt.ProductType = 'Wine'
		OR pt.ProductType = 'Milk tea')
--SELECT * FROM DrinksView

Go
CREATE OR ALTER VIEW ServicesView
AS
SELECT	s.NameServices, ts.NameType, ts.Price
FROM	Services s, TypeServices ts
WHERE	s.IDServices = ts.IDServices
--SELECT * FROM ServicesView

Go
CREATE OR ALTER VIEW CustomerBookingView
AS
SELECT	c.NameCustomer, c.NumberPhone, i.InvoiceID, b.BookingDate, i.Price, s.NameStatusInvoice
FROM	Customers c, Invoice i, Booking b, StatusInvoice_Details sd, StatusInvoice s
WHERE	i.InvoiceDetails = sd.InvoiceDetailsID
		AND sd.StatusInvoice = s.StatusInvoiceID
		AND c.CustomerID = b.CustomerBooking
		AND i.InvoiceID = b.BookingInvoice	
--SELECT * FROM CustomerBookingView
----------------------------------------------------------------------VIEW INVOICE ODER
Go
CREATE OR ALTER VIEW InvoiceOrderView
AS
SELECT	i.InvoiceID,p.NameProduct, i.CreationTime,od.Quantity, p.Price, (p.Price * od.Quantity) as TotalPrice,i.Discount, (p.Price * od.Quantity * (1-i.Discount * 0.01)) as TotalPriceAfterDiscount, si.NameStatusInvoice, s.CheckIn_Time, s.CheckOut_Time
FROM	OrderDetails od, Orders o, Invoice i, Product p, StatusInvoice_Details s, StatusInvoice si
WHERE	i.InvoiceID = o.Invoice
		AND o.OrderID = od.OrderID
		AND p.ProductID = od.ProductID
		AND s.InvoiceDetailsID = i.InvoiceDetails
		AND s.StatusInvoice = si.StatusInvoiceID
--
--SELECT * FROM InvoiceOrderView

Go
CREATE OR ALTER VIEW  InvoiceBookingView
AS
SELECT	i.InvoiceID, b.BookingID, s.IDServices, 
		b.CustomerBooking, b.TableBooking, b.BookingDate, 
		b.BookingStatus, b.Duration, s.NameServices, 
		ts.Price, i.Price as TotalPrice, si.StatusInvoice
FROM	Invoice i, Booking b, Services s, TypeServices ts, StatusInvoice_Details si
WHERE	i.InvoiceID = b.BookingInvoice
		AND b.ServiceBooking = ts.IDType
		AND ts.IDServices = s.IDServices
		AND i.InvoiceDetails = si.InvoiceDetailsID
--SELECT * FROM InvoiceBookingView

--Drop Table
/*
Drop table Service_Product
Drop table Account
Drop table Booking
Drop table TypeServices
Drop table Invoice
Drop table StatusInvoice_Details
Drop table StatusInvoice
Drop table Orders
Drop table OrderDetails
Drop table TablesCustomer
Drop table Staff
Drop table Staff_Position
Drop table Customer_TypeServices
Drop table Customers
Drop table TypeServices
Drop table Services 
Drop table Product
Drop table Product_Type
*/



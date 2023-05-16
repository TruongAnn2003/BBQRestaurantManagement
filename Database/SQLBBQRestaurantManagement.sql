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
	InvoiceID nvarchar(10) CONSTRAINT InvoiceIDkey PRIMARY KEY,
	CreationTime datetime NOT NULL,
	Price BIGINT NOT NULL,
	InvoiceDetails nvarchar(10),
	CONSTRAINT FK_InvoiceDetails FOREIGN KEY (InvoiceDetails) REFERENCES StatusInvoice_Details(InvoiceDetailsID),
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
	CONSTRAINT RightOrderID CHECK(OrderID LIKE 'ORD%'),
	CONSTRAINT RightTotal_Unit_Price CHECK(Total_Unit_Price >= 0),
	CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerOrder) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_OrderStaff FOREIGN KEY (OrderStaff) REFERENCES Staff(StaffID)
);
ALTER TABLE Orders
ADD Invoice nvarchar(10);

ALTER TABLE Orders
ADD CONSTRAINT FK_Invoice FOREIGN KEY (Invoice) REFERENCES Invoice(InvoiceID);

CREATE TABLE OrderDetails
(
	OrderDetailsID nvarchar(10) ,
	ProductID nvarchar(10),
	Quantity int NOT NULL,
	OrderID nvarchar(10),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
	CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);



-------INSERT DATA--------------------------
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
('DEID026', '18:32:43', '19:32:32', 'STATUS005');
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Invoice(InvoiceID, CreationTime, Price, InvoiceDetails) VALUES
('IN001', '2023/02/12 18:32:43', 1200000, 'DEID001'),
('IN002', '2023/03/12 14:11:43', 24000, 'DEID002'),
('IN003', '2022/07/11 06:32:43', 108000, 'DEID003'),
('IN004', '2021/04/16 13:11:21', 90000, 'DEID004'),
('IN005', '2023/01/01 23:11:43', 1000000, 'DEID005'),
('IN006', '2019/12/05 14:11:43', 60000, 'DEID006'),
('IN007', '2022/08/31 16:10:32', 100000, 'DEID007'),
('IN008', '2023/01/31 18:40:43', 90000, 'DEID008'),
('IN009', '2021/06/23 19:11:43', 1600000, 'DEID009'),
('IN010', '2022/03/22 23:32:43', 200000, 'DEID010'),
('IN011', '2022/02/14 12:32:43', 1500000, 'DEID011'),
('IN012', '2022/09/01 10:11:23', 2100000, 'DEID012'),
('IN013', '2021/01/12 09:00:12', 1000000, 'DEID013'),
('IN014', '2022/06/27 07:40:43', 150000, 'DEID014'),
('IN015', '2022/03/27 11:32:43', 40000, 'DEID015'),
('IN016', '2023/03/20 18:00:01', 250000, 'DEID016'),
('IN017', '2023/05/02 18:55:43', 200000, 'DEID017'),
('IN018', '2023/02/26 20:17:12', 10000, 'DEID018'),
('IN019', '2023/02/12 20:32:12', 2400000, 'DEID019'),
('IN020', '2021/05/17 19:10:17', 1500000, 'DEID020'),
('IN021', '2021/09/30 13:19:41', 240000, 'DEID021'),
('IN022', '2022/04/12 14:12:03', 40000, 'DEID022'),
('IN023', '2022/11/06 15:16:06', 270000, 'DEID023'),
('IN024', '2021/12/12 10:18:07', 156000, 'DEID024'),
('IN025', '2022/03/04 18:12:01', 200000, 'DEID025'),
('IN026', '2023/01/05 20:32:43', 400000, 'DEID026');
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
('TAB012', 5,'TYP114',1);
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
('BI026','2022/03/02','Success',4,'None note',6,'CUS026','TYP112','TAB001','IN026');

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
('ORD026', '2023/01/05', 400000, 1, 'CUS026', 'STA001', 'IN026');
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
('ODETAIL026', 'PRO004', '4', 'ORD026');



-----TRIGGER----------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER TRIGGER tg_DeleteCustomer
ON	  Customers
FOR	  DELETE
AS
	DECLARE 	@IDCus 	nvarchar(10)
	SELECT @IDCus = CustomerID
	FROM DELETED
	
	DELETE FROM Customer_TypeServices WHERE CustomerID =@IDCus
	DELETE FROM Booking WHERE CustomerBooking =@IDCus
	DELETE FROM Orders WHERE CustomerOrder =@IDCus

GO
CREATE OR ALTER TRIGGER tg_DeleteStaff
ON	  Staff
FOR	  DELETE
AS
	DECLARE 	@StaID 	nvarchar(10)
	SELECT @StaID=StaffID
	FROM DELETED
	
	DELETE FROM Orders WHERE OrderStaff=@StaID
	DELETE FROM Account WHERE AccountID=@StaID

GO
CREATE OR ALTER TRIGGER tg_DeleteStaff_Position
ON	  Staff_Position
FOR	  DELETE
AS
	DECLARE 	@IDPos 	nvarchar(10)
	SELECT @IDPos=IDPosition
	FROM DELETED
	
	DELETE FROM Staff WHERE Position=@IDPos

GO
CREATE OR ALTER TRIGGER tg_DeleteProduct
ON	  Product
FOR	  DELETE
AS
	DECLARE 	@ProID 	nvarchar(10)
	SELECT @ProID=ProductID
	FROM DELETED
	
	DELETE FROM OrderDetails WHERE ProductID=@ProID

GO
CREATE OR ALTER TRIGGER tg_DeleteProduct_Type
ON	  Product_Type
FOR	  DELETE
AS
	DECLARE 	@IDTypePro 	nvarchar(10)
	SELECT @IDTypePro=IDType
	FROM DELETED
	
	DELETE FROM Product WHERE Product_Type=@IDTypePro

GO
CREATE OR ALTER TRIGGER tg_DeleteServices
ON	  Services
FOR	  DELETE
AS
	DECLARE 	@IDSer 	nvarchar(10)
	SELECT @IDSer=IDServices
	FROM DELETED
	
	DELETE FROM TypeServices WHERE IDType= @IDSer

GO
CREATE OR ALTER TRIGGER tg_DeleteTypeServices
ON	  TypeServices
FOR	  DELETE
AS
	DECLARE 	@IDTypeSer 	nvarchar(10)
	SELECT @IDTypeSer=IDType
	FROM DELETED
	
	DELETE FROM TablesCustomer WHERE RoomType= @IDTypeSer
	DELETE FROM Customer_TypeServices WHERE IDTypeServices= @IDTypeSer
	DELETE FROM Booking WHERE ServiceBooking= @IDTypeSer

GO
CREATE OR ALTER TRIGGER tg_DeleteTablesCustomer
ON	  TablesCustomer
FOR	  DELETE
AS
	DECLARE 	@TabID 	nvarchar(10)
	SELECT @TabID=TablesID
	FROM DELETED
	
	DELETE FROM Booking WHERE TableBooking= @TabID

GO
CREATE OR ALTER TRIGGER tg_DeleteInvoice
ON	  Invoice
FOR	  DELETE
AS
	DECLARE 	@InvID 	nvarchar(10)
	SELECT @InvID=InvoiceID
	FROM DELETED
	
	DELETE FROM Booking WHERE BookingInvoice= @InvID
	DELETE FROM Orders WHERE Invoice= @InvID

GO
CREATE OR ALTER TRIGGER tg_DeleteStatusInvoice
ON	  StatusInvoice
FOR	  DELETE
AS
	DECLARE 	@StatusInvID 	nvarchar(10)
	SELECT @StatusInvID=StatusInvoiceID
	FROM DELETED
	
	DELETE FROM StatusInvoice_Details WHERE StatusInvoice= @StatusInvID

GO
CREATE OR ALTER TRIGGER tg_DeleteStatusInvoice_Details
ON	  StatusInvoice_Details
FOR	  DELETE
AS
	DECLARE 	@InvDetailsID 	nvarchar(10)
	SELECT @InvDetailsID=InvoiceDetailsID
	FROM DELETED
	
	DELETE FROM Invoice WHERE InvoiceDetails= @InvDetailsID

GO
CREATE OR ALTER TRIGGER tg_DeleteOrderDetails
ON	  OrderDetails
FOR	  DELETE
AS
	DECLARE 	@OrderID 	nvarchar(10)
	SELECT @OrderID=OrderID
	FROM DELETED
	
	DELETE FROM Orders WHERE OrderID= @OrderID
-------------------------------------------------------------------------------------------------------------------------------------------------------
GO

CREATE OR ALTER TRIGGER tg_Combo
ON	  OrderDetails
FOR	  INSERT, UPDATE
AS
	DECLARE 	@OrderID 	nvarchar(10), @TypSerID 	nvarchar(10), @ProID 	nvarchar(10)
	SELECT @OrderID = i.OrderID, @TypSerID= sp.IDServices, @ProID = i.ProductID
	FROM INSERTED i INNER JOIN Service_Product sp ON i.ProductID = sp.IDProduct

	IF @ProID NOT IN (SELECT IDProduct FROM Service_Product)
		return;
	DECLARE 	@CusOrder 	nvarchar(10)
	SELECT @CusOrder = CustomerOrder
	FROM Orders 
	WHERE OrderID = @OrderID

	INSERT INTO Customer_TypeServices(CustomerID,IDTypeServices,Quantity,TotalMoney)
	VALUES (@CusOrder,@TypSerID,1,0)
-------------------------------------------------------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER TRIGGER tg_CustomersInsertInvalidvalue
ON	  Customers
FOR	  INSERT, UPDATE
AS
BEGIN
	DECLARE 	@CusID 	nvarchar(10), @NumPhone 	nvarchar(10)
	SELECT @CusID = i.CustomerID, @NumPhone= i.NumberPhone
	FROM INSERTED i

	IF @CusID IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'CustomerID NOT NULL'
	END
	ELSE IF @CusID NOT LIKE 'CUS%'
	BEGIN
		UPDATE Customers SET CustomerID = CONCAT('CUS',@CusID) WHERE CustomerID = @CusID
	END
	ELSE IF (SELECT COUNT(CustomerID) FROM  Customers WHERE CustomerID = @CusID) > 1
	BEGIN
		ROLLBACK TRAN
		PRINT 'CustomerID already exist'
	END
	IF @NumPhone IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'NumberPhone NOT NULL'
	END
END

GO
CREATE OR ALTER TRIGGER tg_ServicesInsertInvalidvalue
ON	  Services
FOR	  INSERT, UPDATE
AS
BEGIN
	DECLARE 	@IDSer 	nvarchar(10), @NameSer 	nvarchar(100)
	SELECT @IDSer = i.IDServices, @NameSer= i.NameServices
	FROM INSERTED i

	IF @IDSer IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDServices NOT NULL'
	END
	ELSE IF @IDSer NOT LIKE 'SER%'
	BEGIN
		UPDATE Services SET IDServices = CONCAT('SER',@IDSer) WHERE IDServices = @IDSer
	END
	ELSE IF (SELECT COUNT(IDServices) FROM  Services WHERE IDServices = @IDSer) > 1
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDServices already exist'
	END
	IF @NameSer IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT '@NameSer NOT NULL'
	END
	ELSE IF @NameSer IN (SELECT NameServices FROM  Services)
	BEGIN
		ROLLBACK TRAN
		PRINT 'NameServices already exist'
	END
END

GO
CREATE OR ALTER TRIGGER tg_TypeServicesInsertInvalidvalue
ON	  TypeServices
FOR	  INSERT, UPDATE
AS
BEGIN 
	DECLARE 	@IDType 	nvarchar(10), @NameType 	nvarchar(100)
	, @IDSer 	nvarchar(10), @Price BIGINT
	SELECT @IDType = i.IDType , @NameType= i.NameType, @IDSer= i.IDServices, @Price =i.Price
	FROM INSERTED i

	IF @IDType IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDType NOT NULL'
	END
	ELSE IF @IDType NOT LIKE 'SER%'
	BEGIN
		UPDATE TypeServices SET IDType = CONCAT('TYP3',@IDType) WHERE IDType = @IDType
	END
	ELSE IF (SELECT COUNT(IDType) FROM  TypeServices WHERE IDType = @IDType) > 1
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDType already exist'
	END

	IF @NameType IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'NameType NOT NULL'
	END
	ELSE IF (SELECT COUNT(NameType) FROM  TypeServices WHERE IDType = @NameType) > 1
	BEGIN
		ROLLBACK TRAN
		PRINT 'NameServices already exist'
	END

	IF @IDSer IS NULL
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDServices NOT NULL'
	END
	ELSE IF @IDSer LIKE 'TYP3%'
	BEGIN
		UPDATE TypeServices SET Price = 0 WHERE IDType = @IDType
	END
	ELSE IF @IDSer NOT LIKE 'TYP1%' and @IDType NOT LIKE 'TYP2%' and @IDType NOT LIKE 'TYP3%'
	BEGIN
		UPDATE TypeServices SET IDServices = CONCAT('SER',@IDSer) WHERE IDType = @IDType
	END
	ELSE IF @IDSer NOT IN (SELECT IDServices FROM  Services)
	BEGIN
		ROLLBACK TRAN
		PRINT 'IDServices not in Services'
	END

	IF @Price<0
		UPDATE TypeServices SET Price = 0 WHERE IDType = @IDType
END

GO
CREATE OR ALTER TRIGGER tg_Customer_TypeServicesInsertInvalidvalue
ON	  Customer_TypeServices
FOR	  INSERT, UPDATE
AS
BEGIN 
	DECLARE 	@Quantity 	int, @TotalMoney 	BIGINT, @CusID nvarchar(10),@IDTypeSer nvarchar(10)

	SELECT @Quantity = i.Quantity , @TotalMoney= i.TotalMoney, @CusID = CustomerID, @IDTypeSer =IDTypeServices
	FROM INSERTED i

	IF @Quantity <= 0
		UPDATE Customer_TypeServices SET Quantity =1 WHERE CustomerID = @CusID and IDTypeServices = @IDTypeSer
	IF @TotalMoney < 0
		UPDATE Customer_TypeServices SET TotalMoney =0 WHERE CustomerID = @CusID and IDTypeServices = @IDTypeSer

END

GO
CREATE OR ALTER TRIGGER tg_TablesCustomerInsertInvalidvalue
ON	  TablesCustomer
FOR	  INSERT, UPDATE
AS
BEGIN 
	DECLARE 	@MaxSeats 	int, @TabID nvarchar(10)

	SELECT @MaxSeats = i.MaxSeats , @TabID= i.TablesID
	FROM INSERTED i
	IF @TabID NOT LIKE 'TAB%'
		UPDATE TablesCustomer SET TablesID = CONCAT('TAB',@TabID) WHERE TablesID = @TabID
	IF @MaxSeats <=0 
		UPDATE TablesCustomer SET MaxSeats = 1 WHERE TablesID = @TabID
	IF @MaxSeats >10
		UPDATE TablesCustomer SET MaxSeats = 10 WHERE TablesID = @TabID
	UPDATE TablesCustomer SET Status = 0 WHERE TablesID = @TabID
END

GO
CREATE OR ALTER TRIGGER tg_InsertInvoice
ON	  Invoice 
FOR	  INSERT
AS
BEGIN 
	DECLARE  @IDDet nvarchar(10), @IDInv nvarchar(10)

	SELECT @IDInv = i.InvoiceID
	FROM INSERTED i

	SELECT @IDDet = COUNT(*) + 1
	FROM StatusInvoice_Details

	INSERT INTO StatusInvoice_Details(InvoiceDetailsID,CheckIn_Time,CheckOut_Time,StatusInvoice) 
	VALUES (@IDDet,GETDATE(),null,'STA001'); --'STA001' là chưa thanh toán 

	UPDATE Invoice SET InvoiceDetails = @IDDet WHERE InvoiceID = @IDInv
END
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

	UPDATE OrderDetails
    SET OrderDetailsID = CONCAT('ODETAIL', (SELECT COUNT(*) FROM OrderDetails))
    WHERE OrderDetailsID IS NULL OR OrderDetailsID NOT LIKE 'ODETAIL%';
END
/*
INSERT INTO OrderDetails (ProductID, Quantity, OrderID) VALUES
('PRO007', '4', 'ORD001')
*/
-----VIEW-------------------------------

Go
CREATE VIEW FoodsView
AS
SELECT	p.NameProduct, p.Price, p.Description, p.ProductState
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND	(pt.ProductType = 'Barbecue' 
		OR	pt.ProductType = 'Hotpot' 
		OR	pt.ProductType = 'Snack')
--SELECT * FROM FoodsView

Go
CREATE VIEW DrinksView
AS
SELECT	p.NameProduct, p.Price, p.Description, p.ProductState
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND (pt.ProductType = 'Soft drink' 
		OR pt.ProductType = 'Beer'
		OR pt.ProductType = 'Wine'
		OR pt.ProductType = 'Milk tea')
--SELECT * FROM DrinksView

Go
CREATE VIEW ServicesView
AS
SELECT	s.NameServices, ts.NameType, ts.Price
FROM	Services s, TypeServices ts
WHERE	s.IDServices = ts.IDServices
--SELECT * FROM ServicesView

Go
CREATE VIEW CustomerBookingView
AS
SELECT	c.NameCustomer, c.NumberPhone, i.InvoiceID, b.BookingDate, i.Price, s.NameStatusInvoice
FROM	Customers c, Invoice i, Booking b, StatusInvoice_Details sd, StatusInvoice s
WHERE	i.InvoiceDetails = sd.InvoiceDetailsID
		AND sd.StatusInvoice = s.StatusInvoiceID
		AND c.CustomerID = b.CustomerBooking
		AND i.InvoiceID = b.BookingInvoice	
--SELECT * FROM CustomerBookingView

-----STORED-PROCEDURE/FUNCTION----------

------- Lấy sản phẩm theo loại
go
CREATE OR ALTER PROC proc_GetAllProductsByTypeID(@typeProductID nvarchar(10))
AS
BEGIN
	SELECT *
	FROM Product
	WHERE Product_Type = @typeProductID
END
/*
	Exec proc_GetAllProductsByTypeID 'PROTYPE001'
*/
------- Check In 
go
CREATE OR ALTER PROC proc_CheckIn(@invoiceID nvarchar(10))
AS
BEGIN
	UPDATE StatusInvoice_Details 
	SET CheckIn_Time = GETDATE(), StatusInvoice = N'STA004'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec CheckIn 'IN001'
*/
------ Check out
go
CREATE OR ALTER PROC proc_CheckOut(@invoiceID nvarchar(10))
AS
BEGIN
	UPDATE StatusInvoice_Details 
	SET CheckOut_Time = GETDATE(), StatusInvoice = N'STA005'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec CheckOut 'IN001'
*/
------  Hủy
go
CREATE OR ALTER PROC proc_Cancel(@invoiceID nvarchar(10))
AS
BEGIN
	UPDATE StatusInvoice_Details 
	SET  StatusInvoice = N'STA003'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec Cancel 'IN001'
*/
------  Lọc Sản phẩm theo loại
go
CREATE OR ALTER PROC proc_GetAllProductsByTypeName(@typeProductTypeName nvarchar(50))
AS
BEGIN
	SELECT * 
	FROM Product P, Product_Type T
	WHERE P.Product_Type = T.IDType 
	AND T.ProductType = @typeProductTypeName
END
/*
	Exec proc_GetAllProductsByTypeName 'Milk tea'
*/
------ Lọc hóa đơn theo Tháng Năm
go
CREATE OR ALTER PROC proc_GetAllInvoicesByYearMonth(@date DateTime)
AS
BEGIN
	SELECT *
	FROM Invoice 
	WHERE Year(CreationTime) = Year(@date) And Month(CreationTime) = Month(@date)
END

/*
	Exec proc_GetAllInvoicesByYearMonth '2021-04-01'
*/

------ Lọc hóa đơn theo Ngày
go
CREATE OR ALTER PROC proc_GetAllInvoicesByDate(@date DateTime)
AS
BEGIN
	SELECT *
	FROM Invoice 
	WHERE Year(CreationTime) = Year(@date) And Month(CreationTime) = Month(@date) And Day(CreationTime) = Day(@date)
END

/*
	Exec proc_GetAllInvoicesByDate '2021-01-12'
*/
------ Lọc bàn trống
go
CREATE OR ALTER PROC proc_GetAllTablesIsEmptyByRoomType(@roomtype nvarchar(10))
AS
BEGIN
	SELECT *
	FROM TablesCustomer 
	WHERE RoomType = @roomtype And Status = 0
END

/*
	Exec proc_GetAllTablesIsEmptyByRoomType 'TYP111'
*/
------ Lấy danh sách sản phẩm order
go
CREATE OR ALTER FUNCTION func_GetOrders(@orderID nvarchar(10)) RETURNS @ProductOrders Table (OrderID nvarchar(10),ProductID nvarchar(10),ProductName nvarchar(100),Quantity int,Price bigint,TotalPrice bigint)
AS
BEGIN
	INSERT INTO @ProductOrders(OrderID,ProductID,ProductName,Quantity,Price,TotalPrice)
	SELECT O.OrderID,P.ProductID,P.NameProduct,O.Quantity,P.Price, O.Quantity * P.Price
	FROM OrderDetails O, Product P
	WHERE O.OrderID = @orderID AND O.ProductID = P.ProductID
	RETURN 
END


/*
	Select * from  func_GetOrders('ORD001')
*/ 
------ Tính tổng tiền hóa đơn của order
go
CREATE OR ALTER FUNCTION func_Bill(@OrderID nvarchar(10)) RETURNS bigint
AS
BEGIN
	Declare @TotalPriceInvoice bigint;
	SET @TotalPriceInvoice =0;
	SELECT @TotalPriceInvoice = SUM(TotalPrice) 
	FROM func_GetOrders(@OrderID)
	RETURN @TotalPriceInvoice
END

/*
print dbo.func_Bill('ORD001')
*/
------ Kiểm Tra Login
go
CREATE OR ALTER FUNCTION func_CheckLogin(@accID nvarchar(10),@password nvarchar(20)) RETURNS Bit
AS
BEGIN
	IF @accID is null RETURN 0
	IF @password is null RETURN 0
	DECLARE @pass nvarchar(20);
	SELECT @pass = Passwords
	FROM Account 
	WHERE AccountID = @accID
	IF @pass = @password RETURN 1
	RETURN 0
END

/*
print dbo.func_CheckLogin('STA001','@123456')
*/

-----TRANSACTION------------------------



--Drop Table
/*
Drop table Service_Product
Drop table Product
Drop table Product_Type
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
*/



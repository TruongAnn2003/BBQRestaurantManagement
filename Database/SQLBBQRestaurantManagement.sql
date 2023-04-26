USE BBQRestaurantManagement
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

CREATE TABLE StatusInvoive
(
	StatusInvoiceID nvarchar(10) CONSTRAINT StatusInvoivekey PRIMARY KEY,
	NameStatusInvoive nvarchar(100) NOT NULL,
)

CREATE TABLE StatusInvoive_Details
(
	InvoiceDetailsID nvarchar(10) CONSTRAINT IDInvoiceDetailskey PRIMARY KEY,
	CheckIn_Time time NOT NULL,
	CheckOut_Time time ,
	StatusInvoive nvarchar(10),
	CONSTRAINT FK_StatusInvoive FOREIGN KEY (StatusInvoive) REFERENCES StatusInvoive(StatusInvoiceID),
	CONSTRAINT RightCheck_Time CHECK(CheckIn_Time<CheckOut_Time)
)

CREATE TABLE Invoive
(
	InvoiceID nvarchar(10) CONSTRAINT InvoiceIDkey PRIMARY KEY,
	CreationTime datetime NOT NULL,
	Price BIGINT NOT NULL,
	InvoiceDetails nvarchar(10),
	CONSTRAINT FK_InvoiceDetails FOREIGN KEY (InvoiceDetails) REFERENCES StatusInvoive_Details(InvoiceDetailsID),
	CONSTRAINT RightPriceInvoive CHECK(Price >= 0)
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
	CONSTRAINT FK_BookingInvoice FOREIGN KEY (BookingInvoice) REFERENCES Invoive(InvoiceID),
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

---Thêm vào ERD
CREATE TABLE Service_Product 
(
	IDProduct nvarchar(10) ,
	IDServices nvarchar(10) ,
	CONSTRAINT Service_Combokey PRIMARY KEY(IDProduct,IDServices),
	CONSTRAINT FK_IDCombo FOREIGN KEY (IDProduct) REFERENCES Product(ProductID),
	CONSTRAINT FK_IDServices FOREIGN KEY (IDServices) REFERENCES TypeServices(IDType)
);

CREATE TABLE OrderDetails
(
	OrderDetailsID nvarchar(10) CONSTRAINT OrderDetailskey PRIMARY KEY,
	Quantity nvarchar(100) NOT NULL,
	IntoMoney BIGINT NOT NULL,
	CONSTRAINT RightOrderDetailsID CHECK(OrderDetailsID LIKE 'OD%'),
	CONSTRAINT RightIntoMoney CHECK(IntoMoney >= 0)
);

CREATE TABLE ProductOrderDetails
(
	OrderDetailsID nvarchar(10),
	ProductID nvarchar(10),
	CONSTRAINT FK_OrderDetails FOREIGN KEY (OrderDetailsID) REFERENCES OrderDetails(OrderDetailsID),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
	CONSTRAINT keyID_POD PRIMARY KEY(OrderDetailsID,ProductID),
);

CREATE TABLE Orders
(
	OrderID nvarchar(10) CONSTRAINT Orderskey PRIMARY KEY,
	DatetimeOrder datetime NOT NULL,
	Total_Unit_Price BIGINT NOT NULL,
	StateOrder bit NOT NULL,
	CustomerOrder nvarchar(10),
	DetailsID nvarchar(10),
	OrderStaff nvarchar(10),
	CONSTRAINT RightOrderID CHECK(OrderID LIKE 'ORD%'),
	CONSTRAINT RightTotal_Unit_Price CHECK(Total_Unit_Price >= 0),
	CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerOrder) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_DetailsID FOREIGN KEY (DetailsID) REFERENCES OrderDetails(OrderDetailsID),
	CONSTRAINT FK_OrderStaff FOREIGN KEY (OrderStaff) REFERENCES Staff(StaffID)
);

---INSERT DATA--------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Staff(StaffID,NameStaff,NumberPhone,Position) VALUES
('STA001',N'Nguyễn Trường An','0364969450','Manager'),
('STA002',N'Nguyễn Thành Lợi','0364125263','Manager'),
('STA003',N'Huỳnh Minh Trí','0364956256','Manager'),
('STA004',N'Trần Đỗ Thanh An','0364562321','Manager'),
('STA005',N'Mai Anh Khoa','0364562321','Cashier'),
('STA006',N'Lê Minh Anh','0364562321','Cashier'),
('STA007',N'Trần Đức Trung','0364562321','Waitresses'),
('STA008',N'Nguyễn Văn Hoàng','0364562321','Waitresses'),
('STA009',N'Lê Xuân Huỳnh','0364562321','Waitresses')
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
INSERT INTO Customers (CustomerID, NameCustomer, NumberPhone)
VALUES ('CUS001', 'John Smith', '123-456-7890'),
       ('CUS002', 'Jane Doe', '555-555-1212'),
       ('CUS003', 'Bob Johnson', '999-999-9999'),
	   ('CUS004', 'Sarah Johnson', '555-123-4567'),
       ('CUS005', 'David Lee', '777-888-9999'),
       ('CUS006', 'Emily Chen', '123-456-7890');
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Services(IDServices ,NameServices)
VALUES ('SER111', 'Room services'),
       ('SER222', 'Attachment services'),
       ('SER333', 'Promotion services')
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO TypeServices(IDType,NameType,IDServices,Price)
VALUES ('TYP111', 'Buffet room','SER111',400000),
       ('TYP112', 'Normal private room','SER111',200000),
       ('TYP113', 'VIP private room','SER111',300000),
       ('TYP114', 'Common dining room','SER111',50000),
       ('TYP211', 'Event organization','SER222',20000000),
       ('TYP212', 'VIP service staff','SER222',100000),
       ('TYP311', 'Guitar music','SER333',0), --combo tình nhân
       ('TYP312', 'Piano music','SER333',0),  --combo gia đình
       ('TYP313', 'Karaoke','SER333',0)		  --combo bạn bè
-------------------------------------------------------------------------------------------------------------------------------------------------------
-----TRIGGER----------------------------
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
	
	DELETE FROM ProductOrderDetails WHERE ProductID=@ProID

GO
CREATE OR ALTER TRIGGER tg_DeleteProductOrderDetails
ON	  ProductOrderDetails
FOR	  DELETE
AS
	DECLARE 	@OrdDetailsID 	nvarchar(10)
	SELECT @OrdDetailsID=OrderDetailsID
	FROM DELETED
	
	DELETE FROM Orders WHERE DetailsID=@OrdDetailsID

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
CREATE OR ALTER TRIGGER tg_DeleteInvoive
ON	  Invoive
FOR	  DELETE
AS
	DECLARE 	@InvID 	nvarchar(10)
	SELECT @InvID=InvoiceID
	FROM DELETED
	
	DELETE FROM Booking WHERE BookingInvoice= @InvID

GO
CREATE OR ALTER TRIGGER tg_DeleteStatusInvoive
ON	  StatusInvoive
FOR	  DELETE
AS
	DECLARE 	@StatusInvID 	nvarchar(10)
	SELECT @StatusInvID=StatusInvoiceID
	FROM DELETED
	
	DELETE FROM StatusInvoive_Details WHERE StatusInvoive= @StatusInvID

GO
CREATE OR ALTER TRIGGER tg_DeleteStatusInvoive_Details
ON	  StatusInvoive_Details
FOR	  DELETE
AS
	DECLARE 	@InvDetailsID 	nvarchar(10)
	SELECT @InvDetailsID=InvoiceDetailsID
	FROM DELETED
	
	DELETE FROM Invoive WHERE InvoiceDetails= @InvDetailsID


-----VIEW-------------------------------
-----STORED-PROCEDURE/FUNCTION----------
-----TRANSACTION------------------------
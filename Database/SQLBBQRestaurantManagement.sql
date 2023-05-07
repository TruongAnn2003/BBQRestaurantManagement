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
ADD Invoive nvarchar(10);

ALTER TABLE Orders
ADD CONSTRAINT FK_Invoive FOREIGN KEY (Invoive) REFERENCES Invoive(InvoiceID);

CREATE TABLE OrderDetails
(
	OrderDetailsID nvarchar(10) ,
	ProductID nvarchar(10),
	Quantity int NOT NULL,
	OrderID nvarchar(10),
	CONSTRAINT RightOrderDetailsID CHECK(OrderDetailsID LIKE 'OD%'),
	CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
	CONSTRAINT OrderDetailskey PRIMARY KEY(OrderDetailsID,ProductID),
	CONSTRAINT FK_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

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
CREATE OR ALTER TRIGGER tg_DeleteInvoive
ON	  Invoive
FOR	  DELETE
AS
	DECLARE 	@InvID 	nvarchar(10)
	SELECT @InvID=InvoiceID
	FROM DELETED
	
	DELETE FROM Booking WHERE BookingInvoice= @InvID
	DELETE FROM Orders WHERE Invoive= @InvID

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
ON	  Invoive 
FOR	  INSERT
AS
BEGIN 
	DECLARE  @IDDet int, @IDInv int

	SELECT @IDInv = i.InvoiceID
	FROM INSERTED i

	SELECT @IDDet = COUNT(*) + 1
	FROM StatusInvoive_Details

	INSERT INTO StatusInvoive_Details(InvoiceDetailsID,CheckIn_Time,CheckOut_Time,StatusInvoive) 
	VALUES (@IDDet,GETDATE(),null,'1'); --'1' là chưa thanh toán 

	UPDATE Invoive SET InvoiceDetails = @IDDet WHERE InvoiceID = @IDInv
END


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
INSERT INTO Orders (OrderID, DatetimeOrder, Total_Unit_Price, StateOrder, CustomerOrder, OrderStaff) VALUES 
('ORD001', '2023/02/12', 400000, 1, 'CUS001', 'STA001'),
('ORD002', '2023/03/12', 270000, 1, 'CUS002', 'STA005'),
('ORD003', '2022/07/11', 40000, 1, 'CUS003', 'STA005'),
('ORD004', '2021/04/16', 156000, 1, 'CUS004', 'STA004'),
('ORD005', '2023/01/01', 240000, 1, 'CUS005', 'STA007'),
('ORD006', '2019/12/05', 1500000, 1, 'CUS006', 'STA006'),
('ORD007', '2022/08/31', 200000, 1, 'CUS007', 'STA002'),
('ORD008', '2023/01/31', 800000, 1, 'CUS008', 'STA001'),
('ORD009', '2021/06/23', 90000, 1, 'CUS009', 'STA009'),
('ORD010', '2022/03/22', 1600000, 1, 'CUS010', 'STA006'),
('ORD011', '2022/02/14', 100000, 1, 'CUS011', 'STA003'),
('ORD012', '2022/09/01', 90000, 1, 'CUS012', 'STA004'),
('ORD013', '2021/01/12', 60000, 1, 'CUS013', 'STA008'),
('ORD014', '2022/06/27', 108000, 1, 'CUS014', 'STA003'),
('ORD015', '2022/03/27', 1000000, 1, 'CUS015', 'STA006'),
('ORD016', '2023/03/20', 24000, 1, 'CUS016', 'STA007'),
('ORD017', '2023/05/02', 1500000, 1, 'CUS017', 'STA007'),
('ORD018', '2023/02/26', 52000, 1, 'CUS018', 'STA002'),
('ORD019', '2023/02/12', 10000, 1, 'CUS019', 'STA009'),
('ORD020', '2021/05/17', 250000, 1, 'CUS020', 'STA008'),
('ORD021', '2021/09/30', 2100000, 1, 'CUS021', 'STA002'),
('ORD022', '2022/04/12', 40000, 1, 'CUS022', 'STA008'),
('ORD023', '2022/11/06', 2400000, 1, 'CUS023', 'STA003'),
('ORD024', '2021/12/12', 150000, 1, 'CUS024', 'STA004'),
('ORD025', '2022/03/04', 200000, 1, 'CUS025', 'STA005'),
('ORD026', '2023/01/05', 1000000, 1, 'CUS026', 'STA001');
-------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO OrderDetails (OrderDetailsID, ProductID, Quantity, OrderID) VALUES
('ODETAIL001', 'PRO007', '4', 'ORD008'),
('ODETAIL002', 'PRO016', '2', 'ORD016'),
('ODETAIL003', 'PRO015', '9', 'ORD014'),
('ODETAIL004', 'PRO012', '9', 'ORD012'),
('ODETAIL005', 'PRO003', '5', 'ORD015'),
('ODETAIL006', 'PRO010', '2', 'ORD013'),
('ODETAIL007', 'PRO011', '5', 'ORD011'),
('ODETAIL008', 'PRO019', '3', 'ORD009'),
('ODETAIL009', 'PRO001', '8', 'ORD010'),
('ODETAIL010', 'PRO004', '2', 'ORD025'),
('ODETAIL011', 'PRO008', '6', 'ORD017'),
('ODETAIL012', 'PRO007', '7', 'ORD021'),
('ODETAIL013', 'PRO003', '5', 'ORD026'),
('ODETAIL014', 'PRO021', '6', 'ORD024'),
('ODETAIL015', 'PRO013', '4', 'ORD022'),
('ODETAIL016', 'PRO017', '5', 'ORD020'),
('ODETAIL017', 'PRO018', '1', 'ORD018'),
('ODETAIL018', 'PRO012', '1', 'ORD019'),
('ODETAIL019', 'PRO005', '8', 'ORD023'),
('ODETAIL020', 'PRO002', '10', 'ORD006'),
('ODETAIL021', 'PRO020', '8', 'ORD005'),
('ODETAIL022', 'PRO014', '4', 'ORD003'),
('ODETAIL023', 'PRO010', '9', 'ORD002'),
('ODETAIL024', 'PRO018', '3', 'ORD004'),
('ODETAIL025', 'PRO003', '1', 'ORD007'),
('ODETAIL026', 'PRO004', '4', 'ORD001');

-----VIEW-------------------------------

Go
CREATE VIEW FoodsView
AS
SELECT	p.NameProduct, p.Price, p.Description
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND 
		pt.ProductType = 'Food' 
--SELECT * FROM FoodsView

Go
CREATE VIEW DrinksView
AS
SELECT	p.NameProduct, p.Price, p.Description
FROM	Product p, Product_Type pt
WHERE	pt.IDType = p.Product_Type	
		AND 
		pt.ProductType = 'Drink' 
--SELECT * FROM DrinksView

Go
CREATE VIEW ServicesView
AS
SELECT	s.NameServices, ts.NameType, ts.Price
FROM	Services s, TypeServices ts
WHERE	s.IDServices = ts.IDServices
--SELECT * FROM ServicesView

Go 
CREATE VIEW BuffetView
AS
SELECT	pt.ProductType, Description, Price, ProductState
FROM	Product p, Product_Type pt, Service_Product sp, Services s
WHERE	p.Product_Type = pt.IDType
		AND sp.IDProduct = p.ProductID
		AND sp.IDServices = s.IDServices
		AND s.NameServices = 'Buffet'

--SELECT * FROM BuffetView

Go
CREATE VIEW CustomerBookingView
AS
SELECT	c.NameCustomer, c.NumberPhone, i.InvoiceID, b.BookingDate, i.Price, sd.StatusInvoive
FROM	Customers c, Booking b, Invoive i, StatusInvoive_Details sd, TablesCustomer tc, TypeServices ts
WHERE	c.CustomerID = b.CustomerBooking
		AND sd.InvoiceDetailsID = i.InvoiceID
		AND i.InvoiceID = b.BookingInvoice
		--AND tc.RoomType = ts.IDType 
		--AND ts.IDType = b.ServiceBooking
		--AND tc.TablesID = b.TableBooking
--SELECT * FROM CustomerBookingView

-----STORED-PROCEDURE/FUNCTION----------

------- Lấy sản phẩm theo loại
go
CREATE OR ALTER PROC proc_GetAllProductsByType(@typeProductID varchar)
AS
BEGIN
	SELECT *
	FROM Product
	WHERE Product_Type = @typeProductID
END
------- Check In 
go
CREATE OR ALTER PROC CheckIn(@invoiceID varchar)
AS
BEGIN
	UPDATE StatusInvoive_Details 
	SET CheckIn_Time = GETDATE(), StatusInvoive = '1'
	WHERE InvoiceDetailsID = (	SELECT InvoiceDetails
								FROM Invoive
								WHERE InvoiceID = @invoiceID)
END
------ Check out
go
CREATE OR ALTER PROC CheckOut(@invoiceID varchar)
AS
BEGIN
	UPDATE StatusInvoive_Details 
	SET CheckOut_Time = GETDATE(), StatusInvoive = '2'
	WHERE InvoiceDetailsID = (	SELECT InvoiceDetails
								FROM Invoive
								WHERE InvoiceID = @invoiceID)
END

------  Hủy
go
CREATE OR ALTER PROC Cancel(@invoiceID varchar)
AS
BEGIN
	UPDATE StatusInvoive_Details 
	SET  StatusInvoive = '0'
	WHERE InvoiceDetailsID = (	SELECT InvoiceDetails
								FROM Invoive
								WHERE InvoiceID = @invoiceID)
END
------  Lọc Sản phẩm theo loại
go
CREATE OR ALTER PROC GetAllProductsByType(@typeProductName nvarchar)
AS
BEGIN
	SELECT * 
	FROM Product P, Product_Type T
	WHERE P.Product_Type = T.IDType 
	AND T.ProductType = @typeProductName
END
------ Lọc hóa đơn theo ngày
go
CREATE OR ALTER PROC GetAllInvoicesByDate(@date DateTime)
AS
BEGIN
	SELECT *
	FROM Invoive I
	WHERE I.CreationTime = @date
END
------ Lọc bàn trống


------ Tạo hóa đơn



------ Tính tổng tiền hóa đơn
--go
--CREATE OR ALTER FUNCTION  Bill(@invoiceID varchar) RETURNS float
--AS
--BEGIN
	
--END

------ Kiểm Tra Login


-----TRANSACTION------------------------



--Drop Table

--Drop table ProductOrderDetails
--Drop table Service_Product
--Drop table Product
--Drop table Product_Type
--Drop table Account
--Drop table Booking
--Drop table TypeServices
--Drop table Invoive
--Drop table StatusInvoive_Details
--Drop table StatusInvoive
--Drop table Orders
--Drop table OrderDetails
--Drop table TablesCustomer
--Drop table Staff
--Drop table Staff_Position
--Drop table Customer_TypeServices
--Drop table Customers
--Drop table TypeServices
--Drop table Services 




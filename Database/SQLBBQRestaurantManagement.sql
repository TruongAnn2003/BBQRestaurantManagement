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
	CONSTRAINT FK_Customer_Services FOREIGN KEY (IDTypeServices) REFERENCES TypeServices(IDType),
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
	CustomerBooking nvarchar(10),
	ServiceBooking nvarchar(10),
	TableBooking nvarchar(10), 
	BookingInvoice nvarchar(10),
	CONSTRAINT FK_CustomerBooking FOREIGN KEY (CustomerBooking) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_ServiceBooking FOREIGN KEY (ServiceBooking) REFERENCES TypeServices(IDType),
	CONSTRAINT FK_TableBooking FOREIGN KEY (TableBooking) REFERENCES TablesCustomer(TablesID),
	CONSTRAINT FK_BookingInvoice FOREIGN KEY (BookingInvoice) REFERENCES Invoive(InvoiceID),
	CONSTRAINT BookingStatus CHECK(BookingStatus LIKE 'Success' or BookingStatus LIKE 'Received' or BookingStatus LIKE 'Cancel')
	--Trạng thái đặt bàn sẽ bao gồm xác nhận đặt bàn thành công, đã nhận bàn và huỷ đặt bàn
);

CREATE TABLE Staff
(
	StaffID nvarchar(10) CONSTRAINT StaffIDkey PRIMARY KEY,
	NameStaff nvarchar(100) NOT NULL,
	NumberPhone nvarchar(20) NOT NULL,
	Position nvarchar(50) NOT NULL,
	CONSTRAINT RightStaffID CHECK(StaffID LIKE 'STA%')
);

CREATE TABLE Account
(
	AccountID nvarchar(10) CONSTRAINT AccountIDkey PRIMARY KEY,
	Passwords nvarchar(20) NOT NULL,
	CONSTRAINT FK_AccountID FOREIGN KEY (AccountID) REFERENCES Staff(StaffID)
);

CREATE TABLE Product
(
	ProductID nvarchar(10) CONSTRAINT Productkey PRIMARY KEY,
	NameProduct nvarchar(100) NOT NULL,
	Price BIGINT NOT NULL,
	Describe nvarchar(500),
	ProductState bit, -- 2 tình trạng còn (1), hết (0)
	CONSTRAINT RightProductID CHECK(ProductID LIKE 'PRO%'),
	CONSTRAINT RightPriceProduct CHECK(Price >= 0)
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
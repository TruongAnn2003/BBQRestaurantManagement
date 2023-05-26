--Create Database BBQRestaurantManagement
--go
--USE BBQRestaurantManagement
-----------------------------------------------------------------------------------

CREATE TABLE Customers
(
	CustomerID nvarchar(10) CONSTRAINT IDkey PRIMARY KEY,
	NameCustomer nvarchar(100),
	NumberPhone nvarchar(20) NOT NULL,
	CONSTRAINT RightID CHECK(CustomerID LIKE 'CUS%')
);

CREATE TABLE TablesCustomer
(
	TablesID nvarchar(10) CONSTRAINT TablesCustomerkey PRIMARY KEY,
	MaxSeats int  NOT NULL,
	CONSTRAINT RightTablesID CHECK(TablesID LIKE 'TAB%')
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

CREATE TABLE BookingStatus
(
	IDStatus  nvarchar(10) CONSTRAINT IDStatuskey PRIMARY KEY,
	NameStatus nvarchar(50) NOT NULL,
	CONSTRAINT NameStatus CHECK(NameStatus LIKE 'Success' or NameStatus LIKE 'Received' or NameStatus LIKE 'Cancel')
);


CREATE TABLE Booking
(
	BookingID nvarchar(10) CONSTRAINT IDBookingkey PRIMARY KEY,
	BookingDate date NOT NULL,
	BookingStatus nvarchar(10),
	Duration int,
	Note nvarchar(100),
	NumberCustomer int,
	CustomerBooking nvarchar(10),
	TableBooking nvarchar(10), 
	BookingInvoice nvarchar(10),
	CONSTRAINT FK_CustomerBooking FOREIGN KEY (CustomerBooking) REFERENCES Customers(CustomerID),
	CONSTRAINT FK_TableBooking FOREIGN KEY (TableBooking) REFERENCES TablesCustomer(TablesID),
	CONSTRAINT FK_BookingInvoice FOREIGN KEY (BookingInvoice) REFERENCES Invoice(InvoiceID),
	CONSTRAINT FK_BookingStatus FOREIGN KEY (BookingStatus) REFERENCES BookingStatus(IDStatus),
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
	CONSTRAINT RightStaffID CHECK(StaffID LIKE 'ADMIN%' OR StaffID LIKE 'CAS%' OR  StaffID LIKE 'MAN%' OR StaffID LIKE 'WAIT%'),
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

CREATE TABLE Orders
(
	OrderID nvarchar(10) CONSTRAINT Orderskey PRIMARY KEY,
	DatetimeOrder datetime NOT NULL,
	--Total_Unit_Price BIGINT NOT NULL,
	StateOrder bit NOT NULL,
	CustomerOrder nvarchar(10),
	OrderStaff nvarchar(10),
	Invoice nvarchar(10),
	TableID nvarchar(10),
	CONSTRAINT RightOrderID CHECK(OrderID LIKE 'ORD%'),
	--CONSTRAINT RightTotal_Unit_Price CHECK(Total_Unit_Price >= 0),
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


--Drop Table


--Drop table Account
--Drop table Booking
--Drop table BookingStatus
--Drop table Invoice
--Drop table StatusInvoice_Details
--Drop table StatusInvoice
--Drop table Orders
--Drop table OrderDetails
--Drop table TablesCustomer
--Drop table Staff
--Drop table Staff_Position
--Drop table Customers
--Drop table Product
--Drop table Product_Type

USE BBQRestaurantManagement
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*																																															*/
/*																					FUNCTIONS/ STORED PROCEDURES																			*/
/*																																															*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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

-------------------------------- ADD ORDER PRODUCT --------------------------------------------------
----thêm 1 sản phẩm được order theo OrderID
go
CREATE OR ALTER PROC proc_AddOrderProduct(@orderID nvarchar(10),@productID nvarchar(10), @quantity int)
AS
BEGIN
	BEGIN TRANSACTION
	--Kiểm tra order có tồn tại không
	 IF EXISTS
	 (	
		SELECT 1
		FROM Orders
		WHERE OrderID = @orderID 
	 )
	BEGIN
		--Kiểm tra OrderDetail có tồn tại không
		IF EXISTS
		 (	
			SELECT 1
			FROM OrderDetails
			WHERE OrderID = @orderID 
			And ProductID = @productID
		 )
		BEGIN --có:
			--Kiểm tra số lượng sản phẩm có hợp lệ không
			DECLARE @totalQuantity int;
			SELECT @totalQuantity = Quantity + @quantity
			FROM OrderDetails
			WHERE OrderID = @orderID AND ProductID = @productID
			IF (@totalQuantity > 0)
			BEGIN 
				--Cập nhật tiếp OrderDetail nếu đã có OrderDetail trước đó và số lượng cập nhật hợp lệ
				UPDATE OrderDetails 
				SET Quantity = @totalQuantity 
				WHERE OrderID = @orderID AND ProductID = @productID
				COMMIT TRANSACTION;
			END
			ELSE
				ROLLBACK TRANSACTION;
		END
		ELSE
		BEGIN 
			-- không tồn tại OrderDetail thì Insert cái mới
			INSERT INTO OrderDetails(ProductID,Quantity,OrderID) 
			VALUES (@productID,@quantity,@orderID)
			COMMIT TRANSACTION;
		END
	END
	ELSE
	  BEGIN
		-- Nếu không tồn tại thì hủy giao dịch và in ra thông báo lỗi
		ROLLBACK TRANSACTION;
		RAISERROR ('Order bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại', 16, 1)
	  END
END
-----------Check -----------------------
/*
	Exec proc_AddOrderProduct 'ORD019','PRO001',5
	SELECT * FROM OrderDetails
	Exec proc_AddOrderProduct 'ORD019','PRO001',2
	SELECT * FROM OrderDetails
	Exec proc_AddOrderProduct 'ORD019','PRO001',-15
	SELECT * FROM OrderDetails
*/
------------------------------------------------GET ORDERS BY ORDER ID ----------------------------------------------------------
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

-----------Check -----------------------
/*
	Select * from  func_GetOrders('ORD001')
*/ 
------------------------------------------------- BILL BY ORDER ID------------------------------------------------------------------------------
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
-----------Check -----------------------
/*
print dbo.func_Bill('ORD001')
*/
----------------------------------------------------------- CHECK  LOGIN -----------------------------------------------------------------------------------
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



---------------Add, delete, update, search (Services)---------------

----------------------------------------------------ADD, DELETE, UPDATE, SEARCH (SERVICES) ---------------------------------
Go
CREATE OR ALTER PROC proc_AddServices(@idServices nvarchar(10), @nameServices nvarchar(100))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchServices(@idServices)
	IF @count = 0
	BEGIN
		INSERT INTO Services(IDServices, NameServices)
		VALUES(@idServices, @nameServices)
	END
	ELSE
	BEGIN
		SELECT 'Da ton tai IDService nay' AS Message
	END
END
/*
	exec proc_AddServices 'SER444', 'test'
	select * from Services
*/
Go
CREATE OR ALTER PROC proc_UpdateServices(@idServices nvarchar(10), @new_NameServices nvarchar(50))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchServices(@idServices)
	IF @count != 0
	BEGIN
		UPDATE Services
		SET NameServices = @new_NameServices
		WHERE IDServices = @idServices
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai IDService nay' AS Message
	END
END
/*
	exec proc_UpdateServices 'SER444', 'TEST'
*/
Go
CREATE OR ALTER PROC proc_DeleteServices(@idServices nvarchar(10))
AS
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchServices(@idServices)
	IF @count != 0
	BEGIN
		DELETE FROM Services
		WHERE IDServices = @idServices
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai IDService nay' AS Message
	END
END
/*
exec proc_DeleteServices 'SER444'
*/
Go
CREATE OR ALTER FUNCTION func_SearchServices(@idServices nvarchar(10))
RETURNS	@ServicesTable
TABLE	(IdServices nvarchar(10), NameServices nvarchar(50))
AS 
BEGIN
	INSERT INTO @ServicesTable(IdServices, NameServices)
	SELECT * FROM Services
	WHERE IDServices = @idServices
	RETURN
END
--go
--DECLARE @ResultCount INT;
--SELECT @ResultCount = COUNT(*)
--FROM dbo.func_SearchServices('SER555');
--IF @ResultCount = 0
--BEGIN
--    SELECT 'Khong tim thay' AS Message;
--END
--ELSE
--BEGIN
--    Select * from dbo.func_SearchServices('SER555')
--END
go

----------------------------------------------------ADD, DELETE, UPDATE, SEARCH (STAFFS) ---------------------------------
Go
CREATE OR ALTER PROC proc_AddStaff(@staffID nvarchar(10), @nameStaff nvarchar(100), @numberPhone nvarchar(20), @position nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchStaff(@staffID)
	IF @count = 0
	BEGIN
		INSERT INTO Staff(StaffID, NameStaff, NumberPhone, Position)
		VALUES(@staffID, @nameStaff, @numberPhone, @position)
	END
	ELSE
	BEGIN
		SELECT 'Da ton tai StaffID nay' AS Message
	END
END
/*
	select * from Staff_Position
	exec proc_AddStaff 'STA010', 'test', 'test', 'POS001'
	select * from Staff
*/
Go
CREATE OR ALTER PROC proc_UpdateStaff(@staffID nvarchar(10), @new_NameStaff nvarchar(100), @new_NumberPhone nvarchar(20), @new_Position nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchStaff(@staffID)
	IF @count != 0
	BEGIN
		UPDATE Staff
		SET NameStaff = @new_NameStaff, NumberPhone = @new_NumberPhone, Position = @new_Position
		WHERE StaffID = @staffID
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai StaffID nay' AS Message
	END
END
/*
	exec proc_UpdateStaff 'STA010', 'TEST', 'TEST', 'POS002'
*/
Go
CREATE OR ALTER PROC proc_DeleteStaff(@staffID nvarchar(10))
AS
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchStaff(@staffID)
	IF @count != 0
	BEGIN
		DELETE FROM Staff
		WHERE StaffID = @staffID
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai StaffID nay' AS Message
	END
END
/*
	exec proc_DeleteStaff 'STA010'
*/
Go
CREATE OR ALTER FUNCTION func_SearchStaff(@staffID nvarchar(10))
RETURNS	@StaffTable
TABLE	(StaffID nvarchar(10), NameStaff nvarchar(100), NumberPhone nvarchar(20), Position nvarchar(10))
AS 
BEGIN
	INSERT INTO @StaffTable(StaffID, NameStaff, NumberPhone, Position)
	SELECT * FROM Staff
	WHERE StaffID = @staffID
	RETURN
END
--go
--DECLARE @ResultCount INT;
--SELECT @ResultCount = COUNT(*)
--FROM dbo.func_SearchStaff('STA001');
--IF @ResultCount = 0
--BEGIN
--    SELECT 'Khong tim thay' AS Message;
--END
--ELSE
--BEGIN
--    Select * from dbo.func_SearchStaff('STA001')
--END
Go

----------------------------------------------------ADD, DELETE, UPDATE, SEARCH (ORDER) ---------------------------------
Go
CREATE OR ALTER PROC proc_AddOrders(@orderID nvarchar(10), @datetimeOrder datetime, @total_Unit_Price bigint, @stateOrder bit, @customerOrder nvarchar(10), @orderStaff nvarchar(10), @invoice nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchOrders(@orderID)
	IF @count = 0
	BEGIN
		INSERT INTO Orders(OrderID, DatetimeOrder, Total_Unit_Price, StateOrder, CustomerOrder, OrderStaff, Invoice)
		VALUES(@orderID, @datetimeOrder, @total_Unit_Price, @stateOrder, @customerOrder, @orderStaff, @invoice)
	END
	ELSE
	BEGIN
		SELECT 'Da ton tai OrderID nay' AS Message
	END
END
--exec proc_AddOrders 'ORD061', '2023/02/12', 1200000, 1, 'CUS001', 'STA001', 'IN001'
--select * from Orders

Go
CREATE OR ALTER PROC proc_UpdateOrders(@orderID nvarchar(10), @new_DatetimeOrder datetime, @new_Total_Unit_Price bigint, @new_StateOrder bit, @new_CustomerOrder nvarchar(10), @new_OrderStaff nvarchar(10), @new_Invoice nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchOrders(@orderID)
	IF @count != 0
	BEGIN
		UPDATE Orders
		SET DatetimeOrder = @new_DatetimeOrder, Total_Unit_Price = @new_Total_Unit_Price, StateOrder = @new_StateOrder, CustomerOrder = @new_CustomerOrder, OrderStaff = @new_OrderStaff, Invoice = @new_Invoice
		WHERE OrderID = @orderID
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai OrderID nay' AS Message
	END
END
--exec proc_UpdateOrders 'ORD061', '2023/02/12', 1200000, 0, 'CUS001', 'STA001', 'IN001'

Go
CREATE OR ALTER PROC proc_DeleteOrders(@orderID nvarchar(10))
AS
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchOrders(@orderID)
	IF @count != 0
	BEGIN
		DELETE FROM Orders
		WHERE OrderID = @orderID
	END
	ELSE
	BEGIN
		SELECT 'Khong ton tai OderID nay' AS Message
	END
END
--exec proc_DeleteOrders 'ORD061'


--go
--DECLARE @ResultCount INT;
--SELECT @ResultCount = COUNT(*)
--FROM dbo.func_SearchOrders('ORD001');
--IF @ResultCount = 0
--BEGIN
--    SELECT 'Khong tim thay' AS Message;
--END
--ELSE
--BEGIN
--    Select * from dbo.func_SearchOrders('ORD001')
--END

-----------
--xóa order
go
CREATE OR ALTER PROC proc_DeleteOrder(@OrderID nvarchar(10)) 
AS
BEGIN
	DELETE FROM OrderDetails WHERE OrderID = @OrderID;
	--Không có xóa trong Order vì có trigger tg_DeleteOrderDetails xóa giúp
END

--exec proc_DeleteOrder 'ORD025'
--select * from Orders
--select * from OrderDetails


/*
print dbo.func_CheckLogin('STA001','@123456')
*/

--------------------------------------------------------------------------------------------------
--ADD, UPDATE, DELETE, SEARCH BY ID PROCEDURE OF Accounts, Customers, Products TABLE-----------
--------ADD PROC OF Account, Customers, Product TABLE-------------
GO
CREATE OR ALTER PROC SP_Account_Add
(@id nvarchar(10), @password nvarchar(20))
AS
	INSERT INTO dbo.Account(AccountID, Passwords)
	VALUES (@id, @password)

GO
CREATE OR ALTER PROC SP_Customers_Add
(@id nvarchar(10), @name nvarchar(100), @phone nvarchar(20))
AS
	INSERT INTO dbo.Customers(CustomerID, NameCustomer, NumberPhone)
	VALUES (@id, @name, @phone)

GO
CREATE OR ALTER PROC SP_Product_Add
(@id nvarchar(10), @name nvarchar(100), @price bigint, @description nvarchar(500), @state bit, @type nvarchar(10))
AS
	INSERT INTO dbo.Product(ProductID, NameProduct, Price, Description, ProductState, Product_Type)
	VALUES(@id, @name, @price, @description, @state, @type)

--------UPDATE PROC OF Account, Customers, Product TABLE-------------
GO
CREATE OR ALTER PROC SP_Account_Update
(@id nvarchar(10), @password nvarchar(20))
AS
	UPDATE dbo.Account
	SET Passwords = @password
	WHERE AccountID = @id

GO
CREATE OR ALTER PROC SP_Customers_Update
(@id nvarchar(10), @name nvarchar(100), @phone nvarchar(20))
AS
	UPDATE dbo.Customers
	SET NameCustomer = @name,
		NumberPhone = @phone
	WHERE CustomerID = @id

GO
CREATE OR ALTER PROC SP_Product_Update
(@id nvarchar(10), @name nvarchar(100), @price bigint, @description nvarchar(500), @state bit, @typeID nvarchar(10))
AS
	UPDATE dbo.Product
	SET NameProduct = @name,
		Price = @price,
		Description = @description,
		ProductState = @state,
		Product_Type = @typeID
	WHERE ProductID = @id

--------DELETE PROC OF Account, Customers, Product TABLE-------------
GO
CREATE OR ALTER PROC SP_Account_Delete
(@id nvarchar(10))
AS
	DELETE FROM dbo.Account
	WHERE AccountID = @id

GO
CREATE OR ALTER PROC SP_Customers_Delete
(@id nvarchar(10))
AS
	DELETE FROM dbo.Customers
	WHERE CustomerID = @id

	GO
CREATE OR ALTER PROC SP_Product_Delete
(@id nvarchar(10))
AS
	DELETE FROM dbo.Product
	WHERE ProductID = @id

--------SEARCH PROC OF Account, Customers, Product TABLE BY ID-------------
GO
CREATE OR ALTER PROC SP_Account_Search
(@id nvarchar(10))
AS
	SELECT * FROM dbo.Account
	WHERE AccountID = @id

GO
CREATE OR ALTER PROC SP_Customers_Search
(@id nvarchar(10))
AS
	SELECT * FROM dbo.Customers
	WHERE CustomerID = @id

GO
CREATE OR ALTER PROC SP_Product_Search
(@id nvarchar(10))
AS
	SELECT * FROM dbo.Product
	WHERE ProductID = @id

------------------------------------------------------------SEARCH ORDERS BY ORDER ID-------------------------------------------------
Go
CREATE OR ALTER FUNCTION func_SearchOrders(@orderID nvarchar(10))
RETURNS	@OrdersTable
TABLE	(OrderID nvarchar(10), DatetimeOrder datetime, Total_Unit_Price bigint, StateOrder bit, CustomerOrder nvarchar(10), OrderStaff nvarchar(10), Invoice nvarchar(10))
AS 
BEGIN
	INSERT INTO @OrdersTable(OrderID, DatetimeOrder, Total_Unit_Price, StateOrder, CustomerOrder, OrderStaff, Invoice)
	SELECT * FROM Orders
	WHERE OrderID = @orderID
	RETURN
END
------------------------------------------------------ --GET INVOICE BOOKING VIEW BY BOOKING ID---------------------------------------------
Go
CREATE OR ALTER FUNCTION func_GetInvoiceBookingDetails(@bookingID nvarchar(10))
RETURNS @InvoiceBookingDetailsTable
TABLE (InvoiceID nvarchar(10), BookingID nvarchar(10), IDServices nvarchar(10), CustomerBooking nvarchar(10), TableBooking nvarchar(10), BookingDate date, BookingStatus nvarchar(50), Duration int, NameServices nvarchar(100), Price bigint, TotalPrice bigint, StatusInvoice nvarchar(10))
AS 
BEGIN
	INSERT INTO @InvoiceBookingDetailsTable(InvoiceID, BookingID, IDServices, CustomerBooking, TableBooking, BookingDate,BookingStatus, Duration, NameServices, Price, TotalPrice, StatusInvoice)
	SELECT * FROM InvoiceBookingView
	WHERE BookingID = @bookingID
	RETURN
END
--select * from dbo.func_GetInvoiceBookingDetails('BI002')
--------------------------------------------------------------GET INVOICE ORDER DETAILS VIEW BY INVOICE ID-------------------------
go
CREATE OR ALTER FUNCTION func_GetInvoiceOrderDetails(@invoiceID nvarchar(10)) 
RETURNS @InvoiceOrderDetailsTable 
Table  (InvoiceID nvarchar(10),ProductName nvarchar(100),CreationTime datetime,Quantity int,Price bigint,TotalPrice bigint,Discount int,TotalPriceAfterDiscount bigint,NameStatusInvoice nvarchar(10),CheckInTime datetime,CheckOutTime datetime)
AS
BEGIN
	INSERT INTO @InvoiceOrderDetailsTable(InvoiceID,ProductName,CreationTime,Quantity,Price,TotalPrice,Discount,TotalPriceAfterDiscount,NameStatusInvoice,CheckInTime,CheckOutTime)
	SELECT * FROM InvoiceOrderView
	WHERE InvoiceID = @invoiceID
	RETURN 
END

/*
Select * from func_GetInvoiceOrderDetails('IN001')
*/
--------------------------------------------------------------TOTAL THE INVOICE BY INVOICE ID-------------------------------------------------
go
CREATE OR ALTER FUNCTION func_TotalTheInvoice(@invoiceID nvarchar(10)) RETURNS bigint
AS
BEGIN
	Declare @TotalPriceInvoice bigint;
	SET @TotalPriceInvoice =0;
	SELECT @TotalPriceInvoice = SUM(TotalPriceAfterDiscount)
	FROM func_GetInvoiceOrderDetails(@invoiceID)
	RETURN @TotalPriceInvoice
END

/*
print dbo.func_TotalTheInvoice('IN001')
*/

go
CREATE OR ALTER PROC proc_TotalTheInvoice(@invoiceID nvarchar(10),@result bigint out) 
AS
BEGIN
	BEGIN TRANSACTION
	IF EXISTS
    (
      -- Lấy bản ghi có mã chi tiết đơn trùng với tham số đầu vào
      SELECT 1
      FROM Invoice
      WHERE InvoiceID = @invoiceID
    )
	BEGIN
		BEGIN TRY
			SET @result = dbo.func_TotalTheInvoice(@invoiceID)
			UPDATE Invoice SET Price = @result WHERE InvoiceID = @invoiceID
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			RAISERROR('Tính tổng tiền hóa đơn không thành công!', 16, 1)
		END CATCH
	END		
	ELSE
	BEGIN 
		ROLLBACK TRANSACTION
		RAISERROR ('Hóa đơn bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại!', 16, 1)
	END
END

/*
	declare @result bigint
	exec proc_TotalTheInvoice 'IN008',  @result out
	Select @result;
	Select * from Invoice
*/

-------------------------------------------------------------CREATE INVOICE--------------------------------------------------------------
go
CREATE OR ALTER PROC proc_CreateNewInvoice(@orderID nvarchar(10),@invoiceID nvarchar(10))
AS
BEGIN
	BEGIN TRANSACTION
	IF EXISTS
    (
      -- Lấy bản ghi có mã chi tiết đơn trùng với tham số đầu vào
      SELECT 1
      FROM Orders
      WHERE OrderID = @orderID
    )
	BEGIN
		BEGIN TRY
			INSERT INTO Invoice(InvoiceID,CreationTime,Price,Discount,InvoiceDetails)
			VALUES (@invoiceID,GETDATE(),0,0,NULL);
			UPDATE Orders SET Invoice = @invoiceID 
			WHERE OrderID = @orderID
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			RAISERROR('Tạo hóa đơn không thành công!', 16, 1)
		END CATCH
	END		
	ELSE
	BEGIN 
		ROLLBACK TRANSACTION
		RAISERROR ('Order bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại!', 16, 1)
	END
END

/*
	Select * from Orders
	Select * from Invoice
	Select * from StatusInvoice_Details
	exec proc_CreateNewInvoice 'ORD040','IN111'

*/
------------------------------------------------------ SHOW INVOICE ORDER VIEW BY INVOICE ID---------------------------------------------
--show các sản phẩm được order của hoá đơn trong invoiceOderView
go
CREATE OR ALTER PROC proc_ShowInvoiceDetailsView(@invoiceID nvarchar(10)) 
AS
BEGIN
IF EXISTS
    (
      SELECT 1
      FROM Invoice
      WHERE InvoiceID = @invoiceID
    )
	BEGIN
		SELECT * FROM func_GetInvoiceOrderDetails(@invoiceID)
	END
	ELSE
		RAISERROR ('Hóa đơn bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại!', 16, 1)
END
/*
exec proc_ShowInvoiceDetailsView 'IN001'
*/
-------------------------------------------------------------DESTROY INVOICE--------------------------------------------------------------
go
CREATE OR ALTER PROC proc_DesTroyInvoice(@orderID nvarchar(10),@invoiceID nvarchar(10))
AS
BEGIN
	BEGIN TRANSACTION
	IF EXISTS
    (
      SELECT 1
      FROM Orders
      WHERE OrderID = @orderID
    )
	BEGIN
		IF EXISTS
		(
		  SELECT 1
		  FROM Invoice
		  WHERE InvoiceID = @invoiceID
		)
		BEGIN
			BEGIN TRY
				---Cập nhật orders
				UPDATE Orders 
				SET Invoice = null 
				WHERE OrderID = @orderID
				--Xóa hóa đơn
				DELETE FROM Invoice
				WHERE InvoiceID = @invoiceID
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
				RAISERROR('Hủy hóa đơn không thành công!', 16, 1)
			END CATCH
		END
		ELSE
	BEGIN 
		ROLLBACK TRANSACTION
		RAISERROR ('Hóa đơn bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại!', 16, 1)
	END
	END		
	ELSE
	BEGIN 
		ROLLBACK TRANSACTION
		RAISERROR ('Order bạn yêu cầu không tồn tại! Vui lòng kiểm tra lại!', 16, 1)
	END
END;

/*
	Select * from Orders
	Select * from Invoice
	exec proc_DesTroyInvoice 'ORD040','IN111'
*/
---------------------------------------------------------UPDATE DISCOUNT THE INVOICE--------------------------------------
go
CREATE OR ALTER PROC UpdateDiscountTheInvoice(@invoiceID nvarchar(10), @discount int)
AS
BEGIN
	BEGIN TRANSACTION
	IF(@discount <0 OR @discount > 100)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR ('Giảm giá phải từ 0 đến 100 !', 16, 1)
	END
	ELSE
	BEGIN
		BEGIN TRY
			UPDATE Invoice SET Discount = @discount WHERE InvoiceID = @invoiceID
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			RAISERROR('Giảm giá không thành công!', 16, 1)
		END CATCH		
	END
END

/*
exec UpdateDiscountTheInvoice 'IN007',35
Select * from Invoice
*/

-------------------------------------------Pay The Invoice ------------------------------------------------
go
CREATE OR ALTER PROC PayTheInvoice(@invoiceID nvarchar(10))
AS
BEGIN
	BEGIN TRANSACTION
	IF EXISTS
	(
		SELECT 1
		FROM Invoice
		WHERE InvoiceID = @invoiceID
	)
	BEGIN
		BEGIN TRY
			UPDATE StatusInvoice_Details SET StatusInvoice = 'STATUS002' FROM Invoice AS I WHERE I.InvoiceID = @invoiceID AND InvoiceDetailsID = I.InvoiceDetails
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			RAISERROR('Thanh toán không thành công!', 16, 1)
		END CATCH		
	END
	ELSE
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Hóa đơn yêu cầu không tồn tại!', 16, 1)
	END
		
END

/*
Select * from Invoice
Select * from StatusInvoice_Details

exec PayTheInvoice 'IN036'
*/
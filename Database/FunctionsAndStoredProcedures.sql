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
	SET CheckIn_Time = GETDATE(), StatusInvoice = N'STATUS004'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec proc_CheckIn 'IN001'
*/
------ Check out
go
CREATE OR ALTER PROC proc_CheckOut(@invoiceID nvarchar(10))
AS
BEGIN
	UPDATE StatusInvoice_Details 
	SET CheckOut_Time = GETDATE(), StatusInvoice = N'STATUS005'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec proc_CheckOut 'IN001'
*/
------  Hủy
go
CREATE OR ALTER PROC proc_Cancel(@invoiceID nvarchar(10))
AS
BEGIN
	UPDATE StatusInvoice_Details 
	SET  StatusInvoice = N'STATUS005'
	WHERE InvoiceDetailsID in (	SELECT InvoiceDetails
								FROM Invoice
								WHERE InvoiceID = @invoiceID)
END
/*
	Exec proc_Cancel 'IN001'
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
CREATE OR ALTER PROC proc_GetAllTablesIsEmpty
AS
BEGIN
	SELECT *
	FROM TablesCustomer 
	WHERE Status = 0
END

/*
	Exec proc_GetAllTablesIsEmpty 
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
		BEGIN TRY
			INSERT INTO Staff(StaffID, NameStaff, NumberPhone, Position)
			VALUES(@staffID, @nameStaff, @numberPhone, @position)
		END TRY
		BEGIN CATCH
			RAISERROR('Thêm nhân viên không thành công!', 16, 1)
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('ID đã tồn tại!', 16, 1)
	END
END
/*
	select * from Staff_Position
	exec proc_AddStaff 'CAS005', 'test', 'test', 'POS001'
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
		BEGIN TRY
			UPDATE Staff
			SET NameStaff = @new_NameStaff, NumberPhone = @new_NumberPhone, Position = @new_Position
			WHERE StaffID = @staffID
		END TRY
		BEGIN CATCH
			RAISERROR('Cập nhật nhân viên không thành công!', 16, 1)
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('ID không tồn tại!', 16, 1)
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
		BEGIN TRY
			DELETE FROM Staff
			WHERE StaffID = @staffID
		END TRY
		BEGIN CATCH
			RAISERROR('Xóa nhân viên không thành công!', 16, 1)
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('ID không tồn tại!', 16, 1)
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
CREATE OR ALTER PROC proc_AddOrders(@orderID nvarchar(10), @datetimeOrder datetime, @stateOrder bit, @customerOrder nvarchar(10), @orderStaff nvarchar(10), @invoice nvarchar(10),@tableID nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchOrders(@orderID)
	IF @count = 0
	BEGIN
		BEGIN TRY
			INSERT INTO Orders(OrderID, DatetimeOrder, StateOrder, CustomerOrder, OrderStaff, Invoice,TableID)
			VALUES(@orderID, @datetimeOrder, @stateOrder, @customerOrder, @orderStaff, @invoice,@tableID)
		END TRY
		BEGIN CATCH
			RAISERROR('Thêm Order không thành công!', 16, 1)
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('ID đã tồn tại!', 16, 1)
	END
END
--exec proc_AddOrders 'ORD061', '2023/02/12', 1200000, 1, 'CUS001', 'STA001', 'IN001'
--select * from Orders

Go
CREATE OR ALTER PROC proc_UpdateOrders(@orderID nvarchar(10), @new_DatetimeOrder datetime, @new_StateOrder bit, @new_CustomerOrder nvarchar(10), @new_OrderStaff nvarchar(10), @new_Invoice nvarchar(10),@tableID nvarchar(10))
AS 
BEGIN
	DECLARE @count INT;
	SELECT @count = COUNT(*)
	FROM dbo.func_SearchOrders(@orderID)
	IF @count != 0
	BEGIN
		BEGIN TRY
			UPDATE Orders
			SET DatetimeOrder = @new_DatetimeOrder, StateOrder = @new_StateOrder, CustomerOrder = @new_CustomerOrder, OrderStaff = @new_OrderStaff, Invoice = @new_Invoice,TableID = @tableID
			WHERE OrderID = @orderID
		END TRY
		BEGIN CATCH
			RAISERROR('Cập nhật Order không thành công!', 16, 1)
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('ID Không tồn tại!', 16, 1)
	END
END
--exec proc_UpdateOrders 'ORD061', '2023/02/12', 0, 'CUS001', 'STA001', 'IN001','TAB015'

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
	BEGIN TRY
		DELETE FROM OrderDetails WHERE OrderID = @OrderID;
	END TRY
	BEGIN CATCH
		RAISERROR('Xóa Order không thành công!', 16, 1)
	END CATCH
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
CREATE OR ALTER PROC proc_Account_Add
(@id nvarchar(10), @password nvarchar(20))
AS
BEGIN
	BEGIN TRY
		INSERT INTO Account (AccountID, Passwords)
		VALUES (@id, @password)
	END TRY
	BEGIN CATCH
		RAISERROR('Insert failed (Invalid AccountID)', 16, 1)
	END CATCH
END
--CHECK
--SELECT * FROM Account
--EXEC proc_Account_Add 'esfse', '23234234'
--EXEC proc_Account_Add 'STA009', '2342342'
--------

go
create or alter proc proc_Customers_Add
(@id nvarchar(10), @name nvarchar(100), @phone nvarchar(20))
as
begin
	declare @count int
	select @count = count(*)
	from dbo.Customers
	where CustomerID = @id
		
	if (@count > 0)
	begin
		raiserror('CustomerID existed', 16, 1)
	end
	else
	begin
		begin try
			insert into dbo.Customers (CustomerID, NameCustomer, NumberPhone)
			values (@id, @name, @phone)
		end try
		begin catch
			raiserror('Insert failed', 16, 1)
		end catch
	end
end
--check---
--select * from dbo.Customers
--exec SP_Customers_Add 'CUS027', 'Teo', '324242'
----------
go
create or alter proc proc_Product_Add
(@id nvarchar(10), @name nvarchar(100), @price bigint, @description nvarchar(500), @state bit, @typeID nvarchar(10))
as
begin
	declare @count int
	select @count = count(*) from dbo.Product
	where ProductID = @id
	if (@count > 0)
	begin
		raiserror('ProductID existed', 16, 1)
	end
	else
	begin
		begin try
			insert into dbo.Product (ProductID, NameProduct, Price, Description, ProductState, Product_Type)
			values (@id, @name, @price, @description, @state, @typeID)
		end try
		begin catch
			raiserror('Insert failed', 16, 1)
		end catch
	end
end
--check--
--select * from dbo.Product
--exec SP_Product_Add 'PRO022', 'sdf', 332334, 'haha', 1, 'PROTYPE007'
---------
--------UPDATE PROC OF Account, Customers, Product TABLE-------------
GO
CREATE OR ALTER PROC proc_Account_Update
(@id nvarchar(10), @password nvarchar(20))
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.Account
	WHERE AccountID = @id
	IF (@count = 0)
	BEGIN
		RAISERROR('ID không tồn tại!', 16, 1)
	END
	ELSE
	BEGIN
		BEGIN TRY
			UPDATE Account SET Passwords = @password WHERE AccountID = @id
		END TRY
		BEGIN CATCH
			RAISERROR('Cập nhật thất bại!', 16, 1)
		END CATCH
	END
END
--CHECK--
--SELECT * FROM dbo.Account
--EXEC SP_Account_Update 'uawef', '@3433'
--EXEC SP_Account_Update 'STA009', '@123456'
---------
GO
CREATE OR ALTER PROC proc_Customers_Update
(@id nvarchar(10), @name nvarchar(100), @phone nvarchar(20))
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.Customers
	WHERE CustomerID = @id
	IF (@count = 0)
	BEGIN
		RAISERROR('ID does not exist', 16, 1)
	END
	ELSE
	BEGIN
		BEGIN TRY
		UPDATE Customers 
		SET NameCustomer = @name,
			NumberPhone = @phone
		WHERE CustomerID = @id
		END TRY
		BEGIN CATCH
			RAISERROR('Update failed!', 16, 1)
		END CATCH
	END
END
--CHECK--
--SELECT * FROM Customers
--EXEC SP_Customers_Update 'awef', 'Hưng', '2388888888'
--EXEC SP_Customers_Update 'CUS026', 'Hưng', '2388888888'
---------
GO
CREATE OR ALTER PROC proc_Product_Update
(@id nvarchar(10), @name nvarchar(100), @price bigint, @description nvarchar(500), @state bit, @typeID nvarchar(10))
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.Product
	WHERE ProductID = @id
	IF (@count = 0)
	BEGIN
		RAISERROR('ID does not exist!', 16, 1)
	END
	ELSE
	BEGIN
		BEGIN TRY
			UPDATE dbo.Product
			SET NameProduct = @name,
				Price = @price,
				Description = @description,
				ProductState = @state,
				Product_Type = @typeID
			WHERE ProductID = @id
		END TRY
		BEGIN CATCH
			RAISERROR('Update failed (Product_Type does not exist)!', 16, 1)
		END CATCH
	END
END
--CHECK
/*
SELECT * FROM dbo.Product
EXEC proc_Product_Update 'DWEF', 'ABC', '23409', 'haha', 1, 'PROTYPE007'
EXEC proc_Product_Update 'PRO021', 'ABC', '23409', 'haha', 1, 'AWEF'
EXEC proc_Product_Update 'PRO021', 'ABC', '23409', 'haha', 1, 'PROTYPE007'
*/
--------
--------DELETE PROC OF Account, Customers, Product TABLE-------------
go
create or alter proc proc_Account_Delete
(@id nvarchar(10))
as
begin
	declare @count int
	select @count = count(*) from dbo.Account
	where AccountID = @id
		
	if (@count = 0)
	begin
		raiserror('Account does not exist', 16, 1)
	end
	else
	begin
		begin try
			delete from dbo.Account
			where AccountID = @id
		end try
		begin catch
			raiserror('Delete failed', 16, 1)
		end catch
	end
end
--check
/*
select * from dbo.Account
exec proc_Account_Delete 'Sw4t'
*/
-----

go
create or alter proc proc_Customers_Delete
(@id nvarchar(10))
as
begin
	declare @count int
	select @count = count(*) from dbo.Customers
	where CustomerID = @id
		
	if (@count = 0)
	begin
		raiserror('Customer does not exist', 16, 1)
	end
	else
	begin
		begin try
			delete from dbo.Customers
			where CustomerID = @id
		end try
		begin catch
			raiserror('Delete failed', 16, 1)
		end catch
	end
end
--check
/*
select * from dbo.Customers
exec proc_Customers_Delete 'CUS027'
*/
-----

go
create or alter proc proc_Product_Delete
(@id nvarchar(10))
as
begin
	declare @count int
	select @count = count(*) from dbo.Product
	where ProductID = @id
		
	if (@count = 0)
	begin
		raiserror('Product does not exist', 16, 1)
	end
	else
	begin
		begin try
			delete from dbo.Product
			where ProductID = @id
		end try
		begin catch
			raiserror('Delete failed', 16, 1)
		end catch
	end
end
--check
/*
select * from dbo.Product
exec proc_Product_Delete 'PRO022'
*/
-----

--------SEARCH PROC OF Account, Customers, Product TABLE BY ID-------------
go
create or alter proc proc_Account_Search
(@id nvarchar(10))
as
begin
	declare @count int
	select @count = count(*) from dbo.Account
	where AccountID = @id
	if (@count = 0)
	begin
		raiserror('Account is not found', 16, 1)
	end
	else
	begin
		begin try
			select * from dbo.Account
			where AccountID = @id
		end try
		begin catch
			raiserror('Search failed', 16, 1)
		end catch
	end
end
----check-----
--select * from dbo.Account
--exec proc_Account_Search 'STA00d9'
--------------

go
create or alter proc proc_Customers_Search
(@id nvarchar(10))
as
begin
	begin try
		declare @count int
		select @count = count(*) from dbo.Customers
		where CustomerID = @id
		if (@count = 0)
		begin
			raiserror('Customer is not found', 16, 1)
		end
		else
		begin
			select * from dbo.Customers
			where CustomerID = @id
		end
	end try
	begin catch
		raiserror('Search failed', 16, 1)
	end catch
end
--check--
--select * from dbo.Customers
--exec proc_Customers_Search 'CUS004'
---------

go
create or alter proc proc_Product_Search
(@id nvarchar(10))
as
begin
	begin try
		declare @count int
		select @count = count(*)
		from dbo.Product
		where ProductID = @id
		if (@count = 0)
		begin
			raiserror('Product is not found', 16, 1)
		end
		else
		begin
			select * from dbo.Product
			where ProductID = @id
		end
	end try
	begin catch
		raiserror('Search failed', 16, 1)
	end catch
end
--check----
--select * from dbo.Product
--exec proc_Product_Search 'see'
-----------

------------------------------------------------------------SEARCH ORDERS BY ORDER ID-------------------------------------------------
Go
CREATE OR ALTER FUNCTION func_SearchOrders(@orderID nvarchar(10))
RETURNS	@OrdersTable
TABLE	(OrderID nvarchar(10), DatetimeOrder datetime, StateOrder bit, CustomerOrder nvarchar(10), OrderStaff nvarchar(10), Invoice nvarchar(10),TableID nvarchar(10))
AS 
BEGIN
	INSERT INTO @OrdersTable(OrderID, DatetimeOrder, StateOrder, CustomerOrder, OrderStaff, Invoice,TableID)
	SELECT * FROM Orders
	WHERE OrderID = @orderID
	RETURN
END

--------------------------------------------------------------GET INVOICE ORDER DETAILS VIEW BY INVOICE ID-------------------------
go
CREATE OR ALTER FUNCTION func_GetInvoiceOrderDetails(@invoiceID nvarchar(10)) 
RETURNS @InvoiceOrderDetailsTable 
Table  (InvoiceID nvarchar(10),TableID nvarchar(10),ProductName nvarchar(100),CreationTime datetime,Quantity int,Price bigint,TotalPrice bigint,Discount int,TotalPriceAfterDiscount bigint,NameStatusInvoice nvarchar(50),CheckInTime datetime,CheckOutTime datetime)
AS
BEGIN
	INSERT INTO @InvoiceOrderDetailsTable(InvoiceID,TableID,ProductName,CreationTime,Quantity,Price,TotalPrice,Discount,TotalPriceAfterDiscount,NameStatusInvoice,CheckInTime,CheckOutTime)
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

--Top 10 Best Selling Foods
CREATE OR ALTER FUNCTION func_ListTop10Food() 
RETURNS @ListTop10Food TABLE(Title nvarchar(100),Value bigint)
AS
BEGIN
	INSERT INTO @ListTop10Food(Title,Value)
	SELECT TOP(10) f.NameProduct ,sum(Quantity) as value 
	FROM FoodsView f inner join OrderDetails o on f.ProductID = o.ProductID 
	GROUP BY f.NameProduct 
	ORDER BY value DESC
	RETURN
END
--SELECT * FROM dbo.func_ListTop10Food();
GO
CREATE OR ALTER FUNCTION func_ListStatisticsMonth (@Month int) 
RETURNS @ListStatistics TABLE(Title nvarchar(20),Value bigint)
AS
BEGIN
	INSERT INTO @ListStatistics(Title,Value)
	SELECT CreationTime , SUM(Price) FROM Invoice WHERE MONTH(CreationTime) = @Month and YEAR(CreationTime) = YEAR(GETDATE()) GROUP BY CreationTime
	RETURN
END 

Select * from Invoice
Select * from func_ListStatisticsMonth(1)


GO
CREATE OR ALTER FUNCTION func_ListStatisticsYear (@Year int = null) 
RETURNS @ListStatistics TABLE(Title nvarchar(20),Value bigint)
AS
BEGIN
	if @Year is null
		set @Year = YEAR(GETDATE())
	INSERT INTO @ListStatistics(Title,Value)
	SELECT DATEPART(month, CreationTime) AS months , SUM(Price) FROM Invoice WHERE YEAR(CreationTime) = @Year GROUP BY DATEPART(month, CreationTime)
	RETURN
END 
/*
Select * from Invoice
Select * from func_ListStatisticsYear(2022)
*/


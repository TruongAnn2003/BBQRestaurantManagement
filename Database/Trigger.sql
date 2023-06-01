---------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
/*																																			*/
/*																			TRIGGER															*/
/*																																			*/
---------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------

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
    DECLARE @CustomerOrder nvarchar(10),@OrderStaff nvarchar(10), @Invoice nvarchar(10), @TableID nvarchar(10)
	SELECT @CustomerOrder = CustomerOrder,@OrderStaff = OrderStaff , @Invoice = Invoice , @TableID = TableID
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

	IF (@TableID IS NOT NULL) AND (NOT EXISTS(SELECT TablesID FROM TablesCustomer WHERE TablesID = @TableID))
    BEGIN
		ROLLBACK TRAN
		PRINT 'Invalid TableID'
		RETURN;
    END;
END
/*
INSERT INTO Orders (OrderID, DatetimeOrder, StateOrder,OrderStaff) VALUES 
('ORD152', '2023/02/12', 1,'CAS008')
INSERT INTO Orders (OrderID, DatetimeOrder, Total_Unit_Price, StateOrder,CustomerOrder) VALUES 
('ORD152', '2023/02/12', 1200000, 1,'CUS027')
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



Insert Staff
GO
CREATE OR ALTER TRIGGER tg_InsertStaff
ON	  Staff 
FOR	  INSERT,UPDATE
AS
BEGIN 
	DECLARE  @ID nvarchar(10), @IDPos nvarchar(10)

	SELECT @ID = i.StaffID, @IDPos = i.Position
	FROM INSERTED i
	IF( @ID like 'ADMIN%' or @ID like 'MAN%' and @IDPos LIKE 'POS001' ) OR ( @ID like 'CAS%' and @IDPos LIKE 'POS002' ) OR ( @ID like 'WAIT%' and @IDPos LIKE 'POS003' )
	BEGIN
		RETURN
	END 

	ROLLBACK TRAN
	PRINT 'StaffID and Position are not connected to each other !!'

END

--GO
--CREATE OR ALTER TRIGGER tg_InsertCustomer
--ON	  Customers 
--FOR	  INSERT
--AS
--BEGIN 
--	DECLARE  @IDCus nvarchar(10), @IDCused nvarchar(10)

--	SELECT @IDCus = i.CustomerID, @IDCused = i.CustomerID
--	FROM INSERTED i

--	IF ((SELECT count(*) FROM  Customers WHERE CustomerID =@IDCus AND CustomerID IS NOT NULL) >1)
--	BEGIN
--		ROLLBACK TRAN
--		PRINT 'CustomerID already exist'
--		RETURN
--	END 

--	SET @IDCus = CONCAT('CUS',CAST(RAND() * 10000 AS INT));
--	WHILE @IDCus IN (SELECT CustomerID FROM Customers)
--	BEGIN
--		SET @IDCus = CONCAT('CUS',CAST(RAND() * 10000 AS INT));
--	END

--	UPDATE Customers SET CustomerID = @IDCus WHERE CustomerID = @IDCused or CustomerID IS NULL
--END
--/*
--INSERT INTO Customers(CustomerID, NameCustomer, NumberPhone) VALUES
--(null, 'Jeni', '09281626222')
--*/
--GO
--CREATE OR ALTER TRIGGER Check_FK_Booking
--ON Booking
--FOR INSERT, UPDATE
--AS
--BEGIN
--    DECLARE @CusID nvarchar(10)
--	SELECT @CusID = CustomerBooking
--	FROM INSERTED
    
--    IF (@CusID NOT IN (SELECT CustomerID FROM Customers))
--    BEGIN
--		ROLLBACK TRAN
--		PRINT 'Invalid CustomerID'
--		RETURN;
--    END;
--END
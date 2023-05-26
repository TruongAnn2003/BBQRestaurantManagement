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

--Insert Staff
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
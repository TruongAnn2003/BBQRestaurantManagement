USE BBQRestaurantManagement
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

--Go
--CREATE OR ALTER VIEW CustomerBookingView
--AS
--SELECT	c.NameCustomer, c.NumberPhone, i.InvoiceID, b.BookingDate, i.Price, s.NameStatusInvoice
--FROM	Customers c, Invoice i, Booking b, StatusInvoice_Details sd, StatusInvoice s
--WHERE	i.InvoiceDetails = sd.InvoiceDetailsID
--		AND sd.StatusInvoice = s.StatusInvoiceID
--		AND c.CustomerID = b.CustomerBooking
--		AND i.InvoiceID = b.BookingInvoice	
----SELECT * FROM CustomerBookingView
----------------------------------------------------------------------VIEW INVOICE ODER
Go
CREATE OR ALTER VIEW InvoiceOrderView
AS
SELECT	i.InvoiceID,o.TableID,p.NameProduct, i.CreationTime,od.Quantity, p.Price, (p.Price * od.Quantity) as TotalPrice,i.Discount, (p.Price * od.Quantity * (1-i.Discount * 0.01)) as TotalPriceAfterDiscount, si.NameStatusInvoice, s.CheckIn_Time, s.CheckOut_Time
FROM	OrderDetails od, Orders o, Invoice i, Product p, StatusInvoice_Details s, StatusInvoice si
WHERE	i.InvoiceID = o.Invoice
		AND o.OrderID = od.OrderID
		AND p.ProductID = od.ProductID
		AND s.InvoiceDetailsID = i.InvoiceDetails
		AND s.StatusInvoice = si.StatusInvoiceID
--
--SELECT * FROM InvoiceOrderView

--Go
--CREATE OR ALTER VIEW  InvoiceBookingView
--AS
--SELECT	i.InvoiceID, b.BookingID, 
--		b.CustomerBooking, b.TableBooking, b.BookingDate, 
--		b.BookingStatus, b.Duration, 
--		ts.Price, i.Price as TotalPrice, si.StatusInvoice
--FROM	Invoice i, Booking b, TypeServices ts, StatusInvoice_Details si
--WHERE	i.InvoiceID = b.BookingInvoice
--		AND b.ServiceBooking = ts.IDType
--		AND i.InvoiceDetails = si.InvoiceDetailsID
--SELECT * FROM InvoiceBookingView
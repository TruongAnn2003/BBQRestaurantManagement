--Phân quyền Manager
CREATE ROLE MANAGER  
--Gán các quyền trên table cho role MANAGER
GRANT SELECT, REFERENCES ON Account TO MANAGER
GRANT SELECT, INSERT, UPDATE, REFERENCES ON Staff TO MANAGER
GRANT SELECT ON Staff_Position TO MANAGER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Customers TO MANAGER
GRANT SELECT, REFERENCES ON StatusInvoice TO MANAGER
GRANT SELECT, REFERENCES ON StatusInvoice_Details TO MANAGER
GRANT SELECT, REFERENCES ON Invoice TO MANAGER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON TablesCustomer TO MANAGER
GRANT SELECT, REFERENCES ON Booking TO MANAGER
GRANT SELECT, REFERENCES ON Product_Type TO MANAGER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Product TO MANAGER
GRANT SELECT, REFERENCES ON Orders TO MANAGER
GRANT SELECT, REFERENCES ON OrderDetails TO MANAGER
-- Gán quyền thực thi trên các procedure, function cho role MANAGER
GRANT EXECUTE TO MANAGER

--Phân quyền Cashier
CREATE ROLE CASHIER
--Gán các quyền trên table cho role CASHIER
GRANT SELECT, REFERENCES ON Account TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Customers TO CASHIER
GRANT SELECT, REFERENCES ON StatusInvoice TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON StatusInvoice_Details TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Invoice TO CASHIER
GRANT SELECT, REFERENCES ON TablesCustomer TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Booking TO CASHIER
GRANT SELECT, REFERENCES ON Product_Type TO CASHIER
GRANT SELECT, REFERENCES ON Product TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON Orders TO CASHIER
GRANT SELECT, INSERT, DELETE, UPDATE, REFERENCES ON OrderDetails TO CASHIER
-- Gán quyền thực thi trên các procedure, function cho role MANAGER
GRANT EXECUTE TO CASHIER

--Phân quyền Customers
CREATE ROLE CUSTOMER
--Gán các quyền trên table cho role CASHIER
GRANT SELECT, INSERT, UPDATE, REFERENCES ON Customers TO CUSTOMER
GRANT SELECT, UPDATE, REFERENCES ON TablesCustomer TO CUSTOMER
GRANT SELECT, INSERT, REFERENCES ON Booking TO CUSTOMER
GRANT SELECT, REFERENCES ON Product_Type TO CUSTOMER
GRANT SELECT, REFERENCES ON Product TO CUSTOMER

-- Gán quyền thực thi trên các procedure, function cho role Customers
GRANT EXECUTE TO CUSTOMER


-- Trigger dành cho phân quyền
go 
CREATE OR ALTER TRIGGER tg_CreateSQLAccount 
ON Account
FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @userName varchar(30), @passWord varchar(255)
	SELECT @userName=AccountID, @passWord=Passwords
	FROM inserted

	SET XACT_ABORT ON
	BEGIN TRAN
		BEGIN TRY
			DECLARE @sqlString nvarchar(2000)
			
			
			IF NOT EXISTS (SELECT 1 FROM sys.syslogins WHERE name = @userName)
			BEGIN
				SET @sqlString= 'CREATE LOGIN [' + @userName +'] WITH PASSWORD='''+ @passWord 
				+''', DEFAULT_DATABASE=[BBQRestaurantManagement], CHECK_EXPIRATION=OFF, 
				CHECK_POLICY=OFF'
				EXEC (@sqlString)

				SET @sqlString= 'CREATE USER ' + @userName +' FOR LOGIN '+ @userName
				EXEC (@sqlString)

				IF (@userName like 'ADMIN%')
					SET @sqlString = 'ALTER SERVER ROLE sysadmin ADD MEMBER ' + @userName;
				ELSE IF (@userName like 'MAN%')
					SET @sqlString = 'ALTER ROLE MANAGER ADD MEMBER ' + @userName;
				ELSE IF (@userName like 'CAS%')
					SET @sqlString = 'ALTER ROLE CASHIER ADD MEMBER ' + @userName;
				exec (@sqlString)
			END
			ELSE
			BEGIN
				SET @sqlString= 'ALTER LOGIN [' + @userName +'] WITH PASSWORD='''+ @passWord +''''
				EXEC (@sqlString)
			END

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK
			DECLARE @err nvarchar(255)
			SELECT @err = N'Lỗi: ' + ERROR_MESSAGE()
			print(@err)
		END CATCH
END

CREATE LOGIN [PublicCustomer] WITH PASSWORD='@123456', DEFAULT_DATABASE=[BBQRestaurantManagement], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF 
CREATE USER  PublicCustomer  FOR LOGIN PublicCustomer
ALTER ROLE CUSTOMER ADD MEMBER PublicCustomer

INSERT INTO Account(AccountID,Passwords) VALUES
('MAN011','@123456')
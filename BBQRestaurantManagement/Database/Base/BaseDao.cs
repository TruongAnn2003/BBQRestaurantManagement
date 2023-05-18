using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.RightsManagement;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database.Base
{
    public class BaseDao
    {
        protected const string ACCOUNT_TABLE = "Account";
        public const string ACCOUNT_PASSWORD = "Passwords";
        public const string ACCOUNT_ID = "AccountID";

        public const string FOODS_VIEW = "FoodsView";
        public const string DRINKS_VIEW = "DrinksView";
        public const string SERVICES_VIEW = "ServicesView";

        public const string INVOICE_ORDER_DETAILS_VIEW = "InvoiceOrderView";
        public const string INVOICE_ORDER_DETAILS_INVOICE_ID = "InvoiceID";
        public const string INVOICE_ORDER_DETAILS_PRODUCT_ID = "ProductID";
        public const string INVOICE_ORDER_DETAILS_PRODUCT_NAME = "ProductName";
        public const string INVOICE_ORDER_DETAILS_QUANTITY = "Quantity";
        public const string INVOICE_ORDER_DETAILS_CREATED_TIME = "CreationTime";
        public const string INVOICE_ORDER_DETAILS_PRICE = "Price";
        public const string INVOICE_ORDER_DETAILS_TOTAL_PRICE = "TotalPrice";
        public const string INVOICE_ORDER_DETAILS_STATUS_INVOICE = "StatusInvoice";
        public const string INVOICE_ORDER_DETAILS_CHECKIN_TIME = "CheckInTime";
        public const string INVOICE_ORDER_DETAILS_CHECKOUT_TIME = "CheckOutTime";

        protected const string BOOKING_TABLE = "Booking";
        public const string BOOKING_ID = "BookingID";
        public const string BOOKING_DATE = "BookingDate";
        public const string BOOKING_STATUS = "BookingStatus";
        public const string BOOKING_DURATION = "Duration";
        public const string BOOKING_NOTE = "Note";
        public const string BOOKING_NUMBER_CUSTOMER = "NumberCustomer";
        public const string BOOKING_CUSTOMER_BOOKING = "CustomerBooking";
        public const string BOOKING_SERVICE_BOOKING = "ServiceBooking";
        public const string BOOKING_TABLE_BOOKING = "TableBooking";
        public const string BOOKING_INVOICE = "BookingInvoice";

        protected const string PRODUCT_TABLE = "Product";
        public const string PRODUCT_ID = "ProductID";
        public const string PRODUCT_NAME = "NameProduct";
        public const string PRODUCT_PRICE = "Price";
        public const string PRODUCT_DESCRIPTION = "Description";
        public const string PRODUCT_STATE = "ProductState";
        public const string PRODUCT_TYPE = "Product_Type";

        protected const string ORDER_TABLE = "Orders";
        public const string ORDER_ID = "OrderID";
        public const string ORDER_DATETIME_ORDER = "DatetimeOrder";
        public const string ORDER_TOTAL_UNIT_PRICE = "Total_Unit_Price";
        public const string ORDER_STATE = "StateOrder";
        public const string ORDER_CUSTOMER_ORDER = "CustomerOrder";
        public const string ORDER_ORDER_STAFF = "OrderStaff";
        public const string ORDER_INVOICE = "Invoice";

        protected const string ORDER_DETAILS_TABLE = "OrderDetails";
        public const string ORDER_DETAILS_ID = "OrderDetailsID";
        public const string ORDER_DETAILS_PRODUCT_ID = "ProductID";
        public const string ORDER_DETAILS_QUANTITY = "Quantity";
        public const string ORDER_DETAILS_ORDER_ID = "OrderID";

        protected const string STAFF_TABLE = "Staff";
        public const string STAFF_ID = "StaffID";
        public const string STAFF_NAME = "NameStaff";
        public const string STAFF_NUMBER_PHONE = "NumberPhone";
        public const string STAFF_POSITION = "Position";

        protected const string SERVICES_TABLE = "Services";
        public const string SERVICES_ID = "IDServices";
        public const string SERVICES_NAME_SERVICES = "NameServices";

        protected const string TYPE_SERVICES_TABLE = "TypeServices";
        public const string TYPE_SERVICES_ID = "IDType";
        public const string TYPE_SERVICES_NAME = "NameType";
        public const string TYPE_SERVICES_ID_SERVICES = "IDServices";
        public const string TYPE_SERVICES_PRICE = "Price";

        protected const string CUSTOMER_TYPE_SERVICES_TABLE = "Customer_TypeServices";
        public const string CUSTOMER_TYPE_SERVICES_CUSTOMER_ID = "CustomerID";
        public const string CUSTOMER_TYPE_SERVICES_ID_TYPE_SERVICES = "IDTypeServices";
        public const string CUSTOMER_TYPE_SERVICES_QUANTITY = "Quantity";
        public const string CUSTOMER_TYPE_SERVICES_TOTAL_MONEY = "TotalMoney";

        protected const string TABLES_CUSTOMER_TABLE = "TablesCustomer";
        public const string TABLES_CUSTOMER_ID = "TablesID";
        public const string TABLES_CUSTOMER_MAX_SEATS = "MaxSeats";
        public const string TABLES_CUSTOMER_ROOM_TYPE = "RoomType";
        public const string TABLES_CUSTOMER_STATUS = "Status";

        protected const string CUSTOMERS_TABLE = "Customers";
        public const string CUSTOMERS_ID = "CustomerID";
        public const string CUSTOMERS_NAME = "NameCustomer";
        public const string CUSTOMERS_PHONE = "NumberPhone";

        protected const string STATUS_INVOICE_TABLE = "StatusInvoice";
        public const string STATUS_INVOICE_ID = "StatusInvoiceID";
        public const string STATUS_INVOICE_NAME = "NameStatusInvoice";

        protected DBConnection dbConnection = new DBConnection();
       // SqlTransaction transaction = dbConnection..BeginTransaction();
    }
}

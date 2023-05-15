using System;
using System.Collections.Generic;
using System.Linq;
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

        protected DBConnection dbConnection = new DBConnection();
    }
}

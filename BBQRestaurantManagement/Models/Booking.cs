using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class Booking
    {
        private string id;
        private DateTime date;
        private string status;
        private int duration;
        private string note;
        private int numberCustomer;
        private string customerID;
        private string typeServiceID;
        private string tablesID;
        private string invoiceID;

        public string ID { get => id; set => id = value; }
        public DateTime Date { get => date; set => date = value; }
        public string Status { get => status; set => status = value; }
        public int Duration { get => duration; set => duration = value; }
        public string Note { get => note; set => note = value; }
        public int NumberCustomer { get => numberCustomer; set => numberCustomer = value; }
        public string CustomerID { get => customerID; set => customerID = value; }
        public string TypeServiceID { get => typeServiceID; set => typeServiceID = value; }
        public string TablesID { get => tablesID; set => tablesID = value; }
        public string InvoiceID { get => invoiceID; set => invoiceID = value; }


        public Booking() { }

        public Booking(string id, DateTime date, string status, int duration, string note, int numberCustomer, string customerID, string typeServiceID, string tablesID, string invoiceID)
        {
            this.id = id;
            this.date = date;
            this.status = status;
            this.duration = duration;
            this.note = note;
            this.numberCustomer = numberCustomer;
            this.customerID = customerID;
            this.typeServiceID = typeServiceID;
            this.tablesID = tablesID;
            this.invoiceID = invoiceID;
        }

        public Booking(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.BOOKING_ID];
                date = (DateTime)reader[BaseDao.BOOKING_DATE];
                status = (string)reader[BaseDao.BOOKING_STATUS];
                duration = (int)reader[BaseDao.BOOKING_DURATION];
                note = (string)reader[BaseDao.BOOKING_NOTE];
                numberCustomer = (int)reader[BaseDao.BOOKING_NUMBER_CUSTOMER];
                customerID = (string)reader[BaseDao.BOOKING_CUSTOMER_BOOKING];
                typeServiceID = (string)reader[BaseDao.BOOKING_SERVICE_BOOKING];
                tablesID = (string)reader[BaseDao.BOOKING_TABLE_BOOKING];
                invoiceID = (string)reader[BaseDao.BOOKING_INVOICE];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Booking), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

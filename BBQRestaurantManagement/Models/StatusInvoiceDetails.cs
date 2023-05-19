using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Data.SqlClient;

namespace BBQRestaurantManagement.Models
{
    public class StatusInvoiceDetails
    {
        private string id;
        private DateTime checkIn;
        private DateTime checkOut;
        private string statusInvoiceID;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public DateTime CheckIn
        {
            get { return checkIn; }
            set { checkIn = value; }
        }

        public DateTime CheckOut
        {
            get { return checkOut; }
            set { checkOut = value; }
        }

        public string StatusInvoiceID
        {
            get { return statusInvoiceID; }
            set { statusInvoiceID = value; }
        }

        public StatusInvoiceDetails() { }

        public StatusInvoiceDetails(string id, DateTime checkin, DateTime checkout, string statusID)
        {
            this.id = id;
            this.checkIn = checkin;
            this.checkOut = checkout;
            this.statusInvoiceID = statusID;
        }

        public StatusInvoiceDetails(SqlDataReader rdr)
        {
            try
            {
                this.id = rdr[BaseDao.STATUS_INVOICE_DETAILS_ID].ToString();
                this.checkIn = Convert.ToDateTime(rdr[BaseDao.STATUS_INVOICE_DETAILS_CHECK_IN]);
                this.checkOut = Convert.ToDateTime(rdr[BaseDao.STATUS_INVOICE_DETAILS_CHECK_OUT]);
                this.statusInvoiceID = rdr[BaseDao.STATUS_INVOICE_DETAILS_STATUS_INVOICE_ID].ToString();
            }
            catch(Exception e)
            {
                Log.Instance.Error(nameof(StatusInvoiceDetails), "CAST ERROR: " + e.Message);
            }
        }
    }
}

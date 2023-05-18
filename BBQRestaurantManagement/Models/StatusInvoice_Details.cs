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
    public class StatusInvoice_Details
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

        public StatusInvoice_Details() { }

        public StatusInvoice_Details(string id, DateTime checkin, DateTime checkout, string statusID)
        {
            this.id = id;
            this.checkIn = checkin;
            this.checkOut = checkout;
            this.statusInvoiceID = statusID;
        }

        public StatusInvoice_Details(SqlDataReader rdr)
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
                Log.Instance.Error(nameof(StatusInvoice_Details), "CAST ERROR: " + e.Message);
            }
        }
    }
}

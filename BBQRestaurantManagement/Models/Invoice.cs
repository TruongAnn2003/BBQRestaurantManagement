using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace BBQRestaurantManagement.Models
{
    public class Invoice
    {
        private string id;
        private DateTime creationTime;
        private decimal price;
        private string details;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public DateTime CreationTime
        {
            get { return creationTime; }
            set { creationTime = value; }
        }

        public decimal Price
        {
            get { return price; }
            set { price = value; }
        }

        public string Details
        {
            get { return details; }
            set { details = value; }
        }

        public Invoice() { }

        public Invoice(string id, DateTime create, decimal price, string details)
        {
            this.id = id;
            this.creationTime = create;
            this.price = price;
            this.details = details;
        }

        public Invoice(SqlDataReader rdr)
        {
            try
            {
                this.id = rdr[BaseDao.INVOICE_ID].ToString();
                this.creationTime = Convert.ToDateTime(rdr[BaseDao.INVOICE_CREATION_TIME]);
                this.price = Convert.ToDecimal(rdr[BaseDao.INVOICE_PRICE]);
                this.details = rdr[BaseDao.INVOICE_DETAILS].ToString();
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(Invoice), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

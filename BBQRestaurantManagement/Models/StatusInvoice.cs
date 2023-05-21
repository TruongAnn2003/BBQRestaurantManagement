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
    public class StatusInvoice
    {
        private string id;
        private string name;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public StatusInvoice() { }

        public StatusInvoice(string id, string name)
        {
            this.id = id;
            this.name = name;
        }

        public StatusInvoice(SqlDataReader rdr)
        {
            try
            {
                this.id = (string)rdr[BaseDao.STATUS_INVOICE_ID];
                this.name = (string)rdr[BaseDao.STATUS_INVOICE_NAME];
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(StatusInvoice), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

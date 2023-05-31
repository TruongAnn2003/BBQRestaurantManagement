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
    public class TablesCustomer
    {
        private string tablesID;
        private int maxSeats;
        private int status;
        private string statusTable;

        public string TablesID
        {
            get { return tablesID; }
            set { tablesID = value; }
        }

        public int MaxSeats
        {
            get { return maxSeats; }
            set { maxSeats = value; }
        }

        public int Status
        {
            get { return status; }
            set { status = value; }
        }

        public string StatusTable
        {
            get
            {
                if (Status == 0)
                    return "Empty";             
                else
                    return "Occupied";
            }
            set => statusTable = value;
        }


        public TablesCustomer() { }

        public TablesCustomer(string id, int max, int status)
        {
            this.tablesID = id;
            this.maxSeats = max;          
            this.status = status;
        }

        public TablesCustomer(SqlDataReader reader)
        {
            try
            {
                this.tablesID = (string)reader[BaseDao.TABLES_CUSTOMER_ID];
                this.maxSeats = Convert.ToInt32(reader[BaseDao.TABLES_CUSTOMER_MAX_SEATS]);
                this.status = Convert.ToInt32( reader[BaseDao.TABLES_CUSTOMER_STATUS]);
            }
            catch(Exception e)
            {
                Log.Instance.Error(nameof(TablesCustomer), "CAST ERROR: " + e.Message);
            }
        }
    }
}

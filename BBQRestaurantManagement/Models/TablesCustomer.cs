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
        private string roomType;

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

        public string RoomType
        {
            get { return roomType; }
            set { roomType = value; }
        }

        public TablesCustomer() { }

        public TablesCustomer(string id, int max, string roomType)
        {
            this.tablesID = id;
            this.maxSeats = max;
            this.roomType = roomType;
        }

        public TablesCustomer(SqlDataReader reader)
        {
            try
            {
                this.tablesID = (string)reader[BaseDao.TABLES_CUSTOMER_ID];
                this.maxSeats = (int)reader[BaseDao.TABLES_CUSTOMER_MAX_SEATS];
                this.roomType = (string)reader[BaseDao.TABLES_CUSTOMER_ROOM_TYPE];
            }
            catch(Exception e)
            {
                Log.Instance.Error(nameof(TablesCustomer), "CAST ERROR: " + e.Message);
            }
        }
    }
}

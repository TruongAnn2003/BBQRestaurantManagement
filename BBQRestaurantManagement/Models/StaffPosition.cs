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
    public class StaffPosition
    {
        private string id;
        private string position;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string Position
        {
            get { return position; }
            set { position = value; }
        }

        public StaffPosition() { }

        public StaffPosition(string id, string pos)
        {
            this.id = id;
            this.position = pos;
        }

        public StaffPosition(SqlDataReader rdr)
        {
            try
            {
                this.id = rdr[BaseDao.STAFF_POSITION_ID].ToString();
                this.position = rdr[BaseDao.STAFF_POSITION_POSITION].ToString();
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(StaffPosition), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

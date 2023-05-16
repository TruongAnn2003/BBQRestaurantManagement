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
    public class Staff
    {
        private string id;
        public string ID { get => id; set => id = value; }

        private string name;
        public string Name { get => name; set => name = value; }

        private string numberPhone;
        public string NumberPhone { get => numberPhone; set => numberPhone = value; }

        private string position;
        public string Position { get => position; set => position = value; }

        public Staff() { }
        public Staff(string id, string name, string numberphone, string position)
        {
            this.id = id;
            this.name = name;
            this.numberPhone = numberphone; 
            this.position = position;   
        }
        public Staff(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.STAFF_ID];
                name = (string)reader[BaseDao.STAFF_NAME];
                numberPhone = (string)reader[BaseDao.STAFF_NUMBER_PHONE];
                position = (string)reader[BaseDao.STAFF_POSITION];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Account), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

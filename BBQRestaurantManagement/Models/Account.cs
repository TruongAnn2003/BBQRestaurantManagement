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
    public class Account
    {
        private string id;
        private string password;
        public string ID { get => id; set => id = value; }
        public string Password { get => password; set => id = password; }
        public Account() { }
        public Account(string id,string password) 
        {
            this.id = id;
            this.password = password;
        }
        public Account(SqlDataReader reader)
        {
            try
            {
                Password = (string)reader[BaseDao.ACCOUNT_PASSWORD];
                ID = (string)reader[BaseDao.ACCOUNT_ID];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Account), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

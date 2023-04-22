using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class BaseDao
    {
        protected const string ACCOUNT_TABLE = "Account";
        public const string ACCOUNT_PASSWORD = "Passwords";
        public const string ACCOUNT_ID = "AccountID";

        protected DBConnection dbConnection = new DBConnection();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database.Base
{
    public class BaseDao
    {
        protected const string ACCOUNT_TABLE = "Account";
        public const string ACCOUNT_PASSWORD = "Passwords";
        public const string ACCOUNT_ID = "AccountID";

        public const string FOODS_VIEW = "FoodsView";
        public const string DRINKS_VIEW = "DrinksView";
        public const string SERVICES_VIEW = "ServicesView";

        protected DBConnection dbConnection = new DBConnection();
    }
}

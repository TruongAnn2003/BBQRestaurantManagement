using BBQRestaurantManagement.Database.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class TransactionsDao : BaseDao
    {
        public void CommitTransaction()
        {
            dbConnection.ExecuteNonQuery("Commit");
        }

        public void BeginTransaction()
        {
            dbConnection.ExecuteNonQuery("Bigin Tran");
        }

        public void RollBackTransaction()
        {
            dbConnection.ExecuteNonQuery("RollBack");
        }
    }
}

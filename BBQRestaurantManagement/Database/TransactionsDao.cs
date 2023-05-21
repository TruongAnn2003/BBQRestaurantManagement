using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
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
            Log.Instance.Information(nameof(TransactionsDao), "Commit transaction!");
            dbConnection.ExecuteNonQuery("COMMIT");
        }

        public void BeginTransaction()
        {
            Log.Instance.Information(nameof(TransactionsDao), "Begin transaction!");
            dbConnection.ExecuteNonQuery("SET TRANSACTION ISOLATION LEVEL READ COMMITTED BEGIN TRANSACTION");
        }
        
        public void RollBackTransaction()
        {
            Log.Instance.Information(nameof(TransactionsDao), "RollBack transaction!");
            dbConnection.ExecuteNonQuery("ROLLBACK");
        }
    }
}

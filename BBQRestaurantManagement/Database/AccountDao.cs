using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;

namespace BBQRestaurantManagement.Databases
{
    public class AccountDao : BaseDao
    {
        public void Add(Account account)
        {
            string sqlStr = $"INSERT INTO {ACCOUNT_TABLE} ({ACCOUNT_ID}, {ACCOUNT_PASSWORD})" +
                            $"VALUES ({account.ID},{account.Password})";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Delete(string accountID)
        {
            string sqlStr = $"DELETE FROM {ACCOUNT_TABLE} WHERE {ACCOUNT_ID}='{accountID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Update(Account account)
        {
            string sqlStr = $"UPDATE {ACCOUNT_TABLE} SET " +
                            $"{ACCOUNT_PASSWORD}='{account.Password}' WHERE {ACCOUNT_ID}='{account.ID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public Staff SearchByAccountID(string accID)
        {
            string sqlStr = $"SELECT * FROM {STAFF_TABLE} WHERE {STAFF_ID}='{accID}'";
            return (Staff)dbConnection.GetSingleObject(sqlStr, reader => new Staff(reader));
        }
        public AccountDao()
        {

        }
    }
}

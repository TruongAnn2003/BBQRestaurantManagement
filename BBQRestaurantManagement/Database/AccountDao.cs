using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;

namespace BBQRestaurantManagement.Databases
{
    public class AccountDao : BaseDao
    {
        #region Add, Update, Delete

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

        #endregion
        #region Search

        public Staff SearchByAccountID(string accID)
        {
            string sqlStr = $"SELECT * FROM {STAFF_TABLE} WHERE {STAFF_ID}='{accID}'";
            return (Staff)dbConnection.GetSingleObject(sqlStr, reader => new Staff(reader));
        }

        #endregion
        #region Stored Procedures
        //code Stored Procedures trong đây
        public void SP_Account_Add(Account acc)
        {
            string sqlStr = $"exec SP_Account_Add '{acc.ID}', '{acc.Password}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void SP_Account_Delete(string id)
        {
            string sqlStr = $"exec SP_Account_Delete '{id}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void SP_Account_Update(Account acc)
        {
            string sqlStr = $"exec SP_Account_Add '{acc.ID}', '{acc.Password}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public Account SP_Account_Search(string id)
        {
            string sqlStr = $"exec SP_Account_Search '{id}'";
            return (Account)dbConnection.GetSingleObject(sqlStr, reader => new Account(reader));
        }
        #endregion
        #region Functions
        public int CheckLogin(string accountID, string password)
        {
            var result = dbConnection.GetSingleValueFromFunction($"Select dbo.func_CheckLogin('{accountID}','{password}')", null);
            return Convert.ToInt32(result);
        }

        #endregion
        #region Views
        //code Functions trong đây
        #endregion
    }
}

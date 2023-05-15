using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Services;
using System;
using System.Windows;

namespace BBQRestaurantManagement.Database
{
    public class FunctionDao : BaseDao
    {
        public int CheckLogin(string accountID, string password)
        {
            var result = dbConnection.GetSingleValueFromFunction($"Select dbo.func_CheckLogin('{accountID}','{password}')", null);
            return Convert.ToInt32(result);
        }
    }
}

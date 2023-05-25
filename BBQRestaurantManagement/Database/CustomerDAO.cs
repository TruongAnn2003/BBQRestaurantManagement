using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Numerics;

namespace BBQRestaurantManagement.Database
{
    public class CustomerDAO : BaseDao
    {
        #region Views
        public DataTable GetCustomerBookingView()
        {
            string sqlStr = $"SELECT * FROM dbo.CustomerBookingView"; 
            return dbConnection.DanhSach(sqlStr);
        }
        #endregion
    }
}

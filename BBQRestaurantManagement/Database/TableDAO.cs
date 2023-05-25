using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Numerics;

namespace BBQRestaurantManagement.Database
{
    public class TableDAO : BaseDao
    {
        #region Proc
        public void GetAllTablesIsEmptyByRoomType(string roomtype)
        {
            dbConnection.ExecuteNonQuery($"exec proc_GetAllTablesIsEmptyByRoomType '{roomtype}'");
        }
        #endregion
    }
}

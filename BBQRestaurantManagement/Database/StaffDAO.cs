using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Numerics;

namespace BBQRestaurantManagement.Database
{
    public class StaffDAO : BaseDao
    {
        #region Add, Update, Delete
        public void Add(string staffID, string nameStaff, string numberPhone, string position)
        {
            dbConnection.ExecuteNonQuery($"exec proc_AddStaff '{staffID}', '{nameStaff}', '{numberPhone}', '{position}'");
        }
        public void Update(string staffID, string newNameStaff, string newNumberPhone, string newPosition)
        {
            dbConnection.ExecuteNonQuery($"exec proc_UpdateStaff '{staffID}', '{newNameStaff}', '{newNumberPhone}', '{newPosition}'");
        }
        public void Delete(string staffID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_DeleteStaff '{staffID}'");
        }
        #endregion
        #region Search
        public List<Staff> Search(string staffID)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_SearchStaff(" + "'@'" + staffID + ")");
            return dbConnection.GetList(sqlStr, reader => new Staff(reader));
        }
        #endregion
    }
}

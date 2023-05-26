using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.Utilities;

namespace BBQRestaurantManagement.Database
{
    public class CustomerDao : BaseDao
    {
        #region Add, Update, Delete
        //code Add, Update, Delete trong đây
        public void Add(Customer cus)
        {
            string sqlStr = $"INSERT INTO {CUSTOMERS_TABLE} ({CUSTOMERS_ID}, {CUSTOMERS_NAME}, {CUSTOMERS_PHONE})" +
                            $"VALUES ({cus.ID}, {cus.Name}, {cus.PhoneNumber})";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Delete(string cusID)
        {
            string sqlStr = $"DELETE FROM {CUSTOMERS_TABLE} WHERE {CUSTOMERS_ID}='{cusID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Update(Customer cus)
        {
            string sqlStr = $"UPDATE {CUSTOMERS_TABLE} SET " +
                            $"{CUSTOMERS_NAME} = '{cus.Name}', {CUSTOMERS_PHONE} = '{cus.PhoneNumber}' WHERE {CUSTOMERS_ID} = '{cus.ID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }
        #endregion
        #region Search
        public Product SearchByProductID(string cusID)
        {
            string sqlStr = $"SELECT * FROM {CUSTOMERS_TABLE} WHERE {CUSTOMERS_ID}='{cusID}'";
            return (Product)dbConnection.GetSingleObject(sqlStr, reader => new Customer(reader));
        }
        #endregion
        #region Stored Procedures
        //code Stored Procedures trong đây
        public void SP_Customers_Add(Customer cus)
        {
            string sqlStr = $"exec SP_Customers_Add '{cus.ID}', '{cus.Name}', '{cus.PhoneNumber}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void SP_Customers_Update(Customer cus)
        {
            string sqlStr = $"exec SP_Customers_Update '{cus.ID}', '{cus.Name}', '{cus.PhoneNumber}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void SP_Customers_Delete(string id)
        {
            string sqlStr = $"exec SP_Customers_Delete '{id}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public Customer SP_Customers_Search(string id)
        {
            string sqlStr = $"exec SP_Customers_Search '{id}'";
            return (Customer)dbConnection.GetSingleObject(sqlStr, reader => new Customer(reader));
        }
        #endregion
        #region Functions
        //code Functions trong đây
        #endregion
        #region Views
        #endregion
    }
}

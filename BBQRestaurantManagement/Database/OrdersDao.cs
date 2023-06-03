using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;

namespace BBQRestaurantManagement.Database
{
    public class OrdersDao : BaseDao
    {
        #region Add, Update, Delete
 
        public void AddNonCustomerAndInvoice(Order order)
        {
            string sqlStr = $"INSERT INTO {ORDER_TABLE} ({ORDER_ID}, {ORDER_DATETIME_ORDER},{ORDER_STATE},{ORDER_ORDER_STAFF})" +
                            $"VALUES ('{order.ID}','{Utils.ToSQLFormat(order.DatetimeOrder)}',{order.State},'{order.StaffID}')";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Delete(string orderID) 
        {
            dbConnection.ExecuteNonQuery($"exec proc_DeleteOrder '{orderID}'");
        }

        #endregion
        #region Search
        public Order SearchByID(string orderID)
        {
            string sqlStr = $"SELECT * FROM {ORDER_TABLE} WHERE {ORDER_ID}='{orderID}'";
            return (Order)dbConnection.GetSingleObject(sqlStr, reader => new Order(reader));
        }
      
        public List<OrderDetails> SearchByOrderID(string id)
        {          
            string sqlStr = $"SELECT * FROM {ORDER_DETAILS_TABLE} WHERE {ORDER_DETAILS_ORDER_ID} = '{id}'";
            return dbConnection.GetList(sqlStr, reader => new OrderDetails(reader));           
        }
        #endregion
        #region Stored Procedures
        public void AddOrderProduct(string orderID, string productID, int quantity)
        {
            dbConnection.ExecuteNonQuery($"Exec proc_AddOrderProduct '{orderID}','{productID}','{quantity}'");
        }

        public List<TablesCustomer> ShowTableIsEmpty()
        {
            string sqlStr = $"Exec proc_GetAllTablesIsEmpty";
            return dbConnection.GetList(sqlStr, reader => new TablesCustomer(reader));
        }

        public List<TablesCustomer> ShowTableIsOccupied()
        {
            string sqlStr = $"Exec proc_GetAllTablesIsOccupied";
            return dbConnection.GetList(sqlStr, reader => new TablesCustomer(reader));
        }

        public void SelectTableOrder(string orderID,string tableID) 
        {
            dbConnection.ExecuteNonQuery($"exec proc_SelectTableOrder '{orderID}','{tableID}'");
        }
        #endregion
        #region Functions
        public string GenerateOrderID()
        {
            var result = dbConnection.GetSingleValueFromFunction($" select dbo.GenerateOrderID()", null);
            return Convert.ToString(result);
        }
        #endregion
        #region Views
        #endregion
    }
}

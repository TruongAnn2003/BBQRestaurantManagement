using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System.Collections.Generic;

namespace BBQRestaurantManagement.Database
{
    public class OrdersDao : BaseDao
    {
        #region Add, Update, Delete
        public void Add(Order order)
        {
            string sqlStr = $"INSERT INTO {ORDER_TABLE} ({ORDER_ID}, {ORDER_DATETIME_ORDER},{ORDER_TOTAL_UNIT_PRICE},{ORDER_STATE},{ORDER_CUSTOMER_ORDER},{ORDER_ORDER_STAFF},{ORDER_INVOICE})" +
                            $"VALUES ('{order.ID}','{Utils.ToSQLFormat(order.DatetimeOrder)}',{order.TotalUnitPrice},{order.State},'{order.CustomerID}','{order.StaffID}','{order.InvoiceID}')";
            Log.Instance.Information(nameof(OrdersDao),sqlStr);
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void AddNonCustomerAndInvoice(Order order)
        {
            string sqlStr = $"INSERT INTO {ORDER_TABLE} ({ORDER_ID}, {ORDER_DATETIME_ORDER},{ORDER_TOTAL_UNIT_PRICE},{ORDER_STATE},{ORDER_ORDER_STAFF})" +
                            $"VALUES ('{order.ID}','{Utils.ToSQLFormat(order.DatetimeOrder)}',{order.TotalUnitPrice},{order.State},'{order.StaffID}')";
            Log.Instance.Information(nameof(OrdersDao), sqlStr);
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
        #endregion
        #region Functions
        #endregion
        #region Views
        #endregion
    }
}

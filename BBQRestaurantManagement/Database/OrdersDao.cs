using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Numerics;

namespace BBQRestaurantManagement.Database
{
    public class OrdersDao : BaseDao
    {
        #region Add, Update, Delete
 
        public void AddNonCustomerAndInvoice(Order order)
        {
            string sqlStr = $"INSERT INTO {ORDER_TABLE} ({ORDER_ID}, {ORDER_DATETIME_ORDER},{ORDER_TOTAL_UNIT_PRICE},{ORDER_STATE},{ORDER_ORDER_STAFF})" +
                            $"VALUES ('{order.ID}','{Utils.ToSQLFormat(order.DatetimeOrder)}',{order.TotalUnitPrice},{order.State},'{order.StaffID}')";
            Log.Instance.Information(nameof(OrdersDao), sqlStr);
            dbConnection.ExecuteNonQuery(sqlStr);
        }
        public void Add(string orderID, DateTime dateTimeOrder, decimal totalUnitPrice, int stateOrder, string customerID, string orderStaff, string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_AddOrders '{orderID}', '{dateTimeOrder}', '{totalUnitPrice}', '{stateOrder}', '{customerID}', '{orderStaff}', '{invoiceID}'");
        }
        public void Update(string orderID, DateTime newDateTimeOrder, decimal newTotalUnitPrice, int newStateOrder, string newCustomerID, string newOrderStaff, string newInvoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_AddOrders '{orderID}', '{newDateTimeOrder}', '{newTotalUnitPrice}', '{newStateOrder}', '{newCustomerID}', '{newOrderStaff}', '{newInvoiceID}'");
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

        public List<Order> Search(string orderID)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_SearchOrders(" + "'@'" + orderID +")");
            return dbConnection.GetList(sqlStr, reader => new Order(reader));
        }
        #endregion
        #region Stored Procedures
        public void AddOrderProduct(string orderID, string productID, int quantity)
        {
            dbConnection.ExecuteNonQuery($"Exec proc_AddOrderProduct '{orderID}','{productID}','{quantity}'");
        }
        #endregion
        #region Functions
        public DataTable GetOrders(string orderID)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_GetOrders(" + "'@'" + orderID + ")");
            return dbConnection.DanhSach(sqlStr);
        }

        #endregion
        #region Views
        #endregion
    }
}

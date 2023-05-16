using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.IO.Packaging;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class OrdersDao : BaseDao
    {
        public void Add(Order order)
        {
            string sqlStr = $"INSERT INTO {ORDER_TABLE} ({ORDER_ID}, {ORDER_DATETIME_ORDER},{ORDER_TOTAL_UNIT_PRICE},{ORDER_STATE},{ORDER_CUSTOMER_ORDER},{ORDER_ORDER_STAFF},{ORDER_INVOICE})" +
                            $"VALUES ('{order.ID}','{order.DatetimeOrder}',{order.TotalUnitPrice},{order.State},'{order.CustomerID}','{order.StaffID}','{order.InvoiceID}')";
            dbConnection.ExecuteNonQuery(sqlStr);
        }
  
        public void Update(Order order)
        {
        }

        public void Delete(string orderID) { }

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
    }
}

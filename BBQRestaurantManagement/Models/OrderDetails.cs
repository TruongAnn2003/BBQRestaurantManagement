using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class OrderDetails
    {
        private string id;
        private string productID;
        private int quantity;
        private string orderID;
        private Product productIns = new Product();
        public string ID { get => id; set => id = value; }
        public string ProductID { get => productID; set => productID = value; }
        public int Quantity { get => quantity; set => quantity = value; }
        public string OrderID { get => orderID; set => orderID = value; }
        public Product ProductIns { get => productIns; set => productIns = value; }

        public OrderDetails() { }

        public OrderDetails(string id, string productID, int quantity, string orderID)
        {
            this.id = id;
            this.productID = productID;
            this.quantity = quantity;
            this.orderID = orderID;
        }

        public OrderDetails(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.ORDER_DETAILS_ID];
                productID = (string)reader[BaseDao.ORDER_DETAILS_PRODUCT_ID];
                quantity = Convert.ToInt32(reader[BaseDao.ORDER_DETAILS_QUANTITY]);
                orderID = (string)reader[BaseDao.ORDER_DETAILS_ORDER_ID];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(OrderDetails), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

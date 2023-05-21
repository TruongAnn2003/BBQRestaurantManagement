using BBQRestaurantManagement.Utilities;
using System;
using System.Data.SqlClient;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Database;

namespace BBQRestaurantManagement.Models
{
    public class Order
    {
        private string id = "";
        private DateTime datetimeOrder = DateTime.Now;
        private decimal totalUnitPrice = 0;
        private int state = 0;
        private string customerID = "";
        private string staffID = "";
        private string invoiceID = "";

        public static OrdersDao orderDao = new OrdersDao();
        public string ID { get => id; set => id = value; }
        public DateTime DatetimeOrder { get => datetimeOrder; set => datetimeOrder = value; }
        public decimal TotalUnitPrice { get => totalUnitPrice; set => totalUnitPrice = value; }
        public int State { get => state; set => state = value; }
        public string CustomerID { get => customerID; set => customerID = value; }
        public string StaffID { get => staffID; set => staffID = value; }
        public string InvoiceID { get => invoiceID; set => invoiceID = value; }


        public Order() { }

        public Order(string id, DateTime datetime_order, decimal total_unit_price, int state, string cus_ID, string staff_ID, string inv_ID)
        {
            this.id = id;
            this.datetimeOrder = datetime_order;
            this.totalUnitPrice = total_unit_price;
            this.state = state;
            this.customerID = cus_ID;
            this.staffID = staff_ID;
            this.invoiceID = inv_ID;
        }

        public Order(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.ORDER_ID];
                datetimeOrder = Convert.ToDateTime(reader[BaseDao.ORDER_DATETIME_ORDER]);
                totalUnitPrice =Convert.ToDecimal(reader[BaseDao.ORDER_TOTAL_UNIT_PRICE]);
                state = Convert.ToInt32(reader[BaseDao.ORDER_STATE]);
                customerID = (string)reader[BaseDao.ORDER_CUSTOMER_ORDER];
                staffID = (string)reader[BaseDao.ORDER_ORDER_STAFF];
                invoiceID = (string)reader[BaseDao.ORDER_INVOICE];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Order), "CAST ERROR: " + ex.Message);
            }
        }

        public static Order CreateOrderIns()
        {
            return new Order(AutoGenerateOrderID(), DateTime.Now, 0, 1,null, CurrentUser.Ins.Staff.ID, null);
        }

        public static string AutoGenerateOrderID()
        {
            string orderID;
            Random random = new Random();
            do
            {
                int number = random.Next(10000);
                orderID = $"ORD{number:0000}";
            } while (orderDao.SearchByID(orderID) != null);
            return orderID;
        }
    }
}

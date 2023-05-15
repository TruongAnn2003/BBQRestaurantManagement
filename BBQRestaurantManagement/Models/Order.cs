using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BBQRestaurantManagement.Database;

namespace BBQRestaurantManagement.Models
{
    public class Order
    {
        private string id;
        private DateTime datetime_order;
        private long total_unit_price;
        private bool state;
        private string customer_ID;
        private string staff_ID;
        private string invoice_ID;

        public string ID { get; set; }
        public string Datetime_order { get; set; }
        public long Total_unit_price { get; set; }
        public bool State { get; set; }
        public string Customer_ID { get; set; }
        public string Staff_ID { get; set; }
        public string Invoice_ID { get; set; }

        public Order() { }

        public Order(string id, DateTime datetime_order, long total_unit_price, bool state, string cus_ID, string staff_ID, string inv_ID)
        {
            this.id = id;
            this.datetime_order = datetime_order;
            this.total_unit_price = total_unit_price;
            this.state = state;
            this.customer_ID = cus_ID;
            this.staff_ID = staff_ID;
            this.invoice_ID = inv_ID;
        }

        public Order(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.ORDER_ID];
                datetime_order = (DateTime)reader[BaseDao.ORDER_DATETIME_ORDER];
                total_unit_price = (long)reader[BaseDao.ORDER_TOTAL_UNIT_PRICE];
                state = (bool)reader[BaseDao.ORDER_STATE];
                customer_ID = (string)reader[BaseDao.ORDER_CUSTOMER_ORDER];
                staff_ID = (string)reader[BaseDao.ORDER_ORDER_STAFF];
                invoice_ID = (string)reader[BaseDao.ORDER_INVOICE];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Order), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

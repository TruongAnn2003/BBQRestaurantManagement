using BBQRestaurantManagement.Database;
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
    public class Customer_TypeServices
    {
        private string customerID;
        private string idTypeServices;
        private int quantity;
        private long totalMoney;

        public string CustomerID
        {
            get { return customerID; }
            set { customerID = value; }
        }

        public string IDTypeServices
        {
            get { return idTypeServices; }
            set { idTypeServices = value; }
        }

        public int Quantity
        {
            get { return quantity; }
            set { quantity = value; }
        }

        public long TotalMoney
        {
            get { return totalMoney; }
            set { totalMoney = value; }
        }

        public Customer_TypeServices() { }

        public Customer_TypeServices(string cusID, string idType, int quantity, long money)
        {
            this.customerID = cusID;
            this.idTypeServices = idType;
            this.quantity = quantity;
            this.totalMoney = money;
        }

        public Customer_TypeServices(SqlDataReader reader)
        {
            try
            {
                this.customerID = (string)reader[BaseDao.CUSTOMER_TYPE_SERVICES_CUSTOMER_ID];
                this.idTypeServices = (string)reader[BaseDao.CUSTOMER_TYPE_SERVICES_ID_TYPE_SERVICES];
                this.quantity = (int)reader[BaseDao.CUSTOMER_TYPE_SERVICES_QUANTITY];
                this.totalMoney = (long)reader[BaseDao.CUSTOMER_TYPE_SERVICES_TOTAL_MONEY];
            }
            catch (Exception e)
            {
                Log.Instance.Error(nameof(Customer_TypeServices), "CAST ERROR: " + e.Message);
            }
        }
    }
}

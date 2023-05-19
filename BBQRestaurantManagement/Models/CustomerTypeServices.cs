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
    public class CustomerTypeServices
    {
        private string customerID;
        private string idTypeServices;
        private int quantity;
        private decimal totalMoney;

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

        public decimal TotalMoney
        {
            get { return totalMoney; }
            set { totalMoney = value; }
        }

        public CustomerTypeServices() { }

        public CustomerTypeServices(string cusID, string idType, int quantity, decimal money)
        {
            this.customerID = cusID;
            this.idTypeServices = idType;
            this.quantity = quantity;
            this.totalMoney = money;
        }

        public CustomerTypeServices(SqlDataReader reader)
        {
            try
            {
                this.customerID = (string)reader[BaseDao.CUSTOMER_TYPE_SERVICES_CUSTOMER_ID];
                this.idTypeServices = (string)reader[BaseDao.CUSTOMER_TYPE_SERVICES_ID_TYPE_SERVICES];
                this.quantity = (int)reader[BaseDao.CUSTOMER_TYPE_SERVICES_QUANTITY];
                this.totalMoney = Convert.ToDecimal(reader[BaseDao.CUSTOMER_TYPE_SERVICES_TOTAL_MONEY]);
            }
            catch (Exception e)
            {
                Log.Instance.Error(nameof(CustomerTypeServices), "CAST ERROR: " + e.Message);
            }
        }
    }
}

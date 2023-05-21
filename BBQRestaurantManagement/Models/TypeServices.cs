using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Data.SqlClient;

namespace BBQRestaurantManagement.Models
{
    public class TypeServices
    {
        private string idType;
        private string nameType;
        private string idServices;
        private decimal price;

        public string IDType
        {
            get { return idType; }
            set { idType = value; }
        }

        public string NameType
        {
            get { return nameType; }
            set { nameType = value; }
        }

        public string IDServices
        {
            get { return idServices; }
            set { idServices = value; }
        }

        public decimal Price
        {
            get { return price; }
            set { price = value; }
        }

        public TypeServices() { }

        public TypeServices(string id, string name, string idServices, decimal price)
        {
            this.idType = id;
            this.nameType = name;
            this.idServices = idServices;
            this.price = price;
        }

        public TypeServices(SqlDataReader reader)
        {
            try
            {
                idType = (string)reader[BaseDao.TYPE_SERVICES_ID];
                nameType = (string)reader[BaseDao.TYPE_SERVICES_NAME];
                idServices = (string)reader[BaseDao.TYPE_SERVICES_ID_SERVICES];
                price = Convert.ToDecimal(reader[BaseDao.TYPE_SERVICES_PRICE]);
            }
            catch(Exception e)
            {
                Log.Instance.Error(nameof(TypeServices), "CAST ERROR: " + e.Message);
            }
        }
    }
}

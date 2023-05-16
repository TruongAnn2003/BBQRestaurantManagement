using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Data.SqlClient;

namespace BBQRestaurantManagement.Models
{
    public class Product
    {
        private string id = "";
        private string name = "";
        private decimal price = 0;
        private string description = "";
        private int state = 0;
        private string typeID = "";

        public string ID { get => id; set => id = value; }
        public string Name { get => name; set => name = value; }
        public decimal Price { get => price; set => price = value; }
        public string Description { get => description; set=> description = value; }
        public int State { get => state; set => state = value; }
        public string TypeID { get => typeID; set=> typeID = value; }

        public Product() { }
        
        public Product(string id, string name, decimal price, string description, int state, string productType_ID)
        {
            this.id = id;
            this.name = name;
            this.price = price;
            this.description = description;
            this.state = state;
            this.typeID = productType_ID;
        }

        public Product(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.PRODUCT_ID];
                name = (string)reader[BaseDao.PRODUCT_NAME];
                price = Convert.ToDecimal(reader[BaseDao.PRODUCT_PRICE]);
                description = (string)reader[BaseDao.PRODUCT_DESCRIPTION];
                state = Convert.ToInt32(reader[BaseDao.PRODUCT_STATE]);
                typeID = (string)reader[BaseDao.PRODUCT_TYPE];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Product), "CAST ERROR: " + ex.Message);
            }
        }

    }
}

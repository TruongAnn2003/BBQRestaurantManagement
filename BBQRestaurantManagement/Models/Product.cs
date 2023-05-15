using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class Product
    {
        private string id;
        private string name;
        private long price;
        private string description;
        private bool state;
        private string productType_ID;

        public string ID { get; set; }
        public string Name { get; set; }
        public long Price { get; set; }
        public string Description { get; set; }
        public bool State { get; set; }
        public string ProductType_ID { get; set; }

        public Product() { }
        
        public Product(string id, string name, long price, string description, bool state, string productType_ID)
        {
            this.id = id;
            this.name = name;
            this.price = price;
            this.description = description;
            this.state = state;
            this.productType_ID = productType_ID;
        }

        public Product(SqlDataReader reader)
        {
            try
            {
                id = (string)reader[BaseDao.PRODUCT_ID];
                name = (string)reader[BaseDao.PRODUCT_NAME];
                price = (long)reader[BaseDao.PRODUCT_PRICE];
                description = (string)reader[BaseDao.PRODUCT_DESCRIPTION];
                state = (bool)reader[BaseDao.PRODUCT_STATE];
                productType_ID = (string)reader[BaseDao.PRODUCT_TYPE];
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Product), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

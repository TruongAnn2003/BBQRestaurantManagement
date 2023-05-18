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
    public class Product_Type
    {
        private string id;
        private string productType;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string ProductType
        {
            get { return productType; }
            set { productType = value; }
        }

        public Product_Type() { }

        public Product_Type(string id, string proType)
        {
            this.id = id;
            this.productType = proType;
        }

        public Product_Type(SqlDataReader rdr)
        {
            try
            {
                this.id = rdr[BaseDao.PRODUCT_TYPE_ID].ToString();
                this.productType = rdr[BaseDao.PRODUCT_TYPE_PRODUCT_TYPE].ToString();
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(Product_Type), "CAST OF: " + ex.Message);
            }
        }
    }
}

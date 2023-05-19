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
    public class ProductType
    {
        private string id;
        private string name;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public ProductType() { }

        public ProductType(string id, string proType)
        {
            this.id = id;
            this.name = proType;
        }

        public ProductType(SqlDataReader rdr)
        {
            try
            {
                this.id = rdr[BaseDao.PRODUCT_TYPE_ID].ToString();
                this.name = rdr[BaseDao.PRODUCT_TYPE_PRODUCT_TYPE].ToString();
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(Models.ProductType), "CAST OF: " + ex.Message);
            }
        }
    }
}

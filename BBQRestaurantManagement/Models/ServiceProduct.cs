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
    public class ServiceProduct
    {
        private string idProduct;
        private string idServices;

        public string IDProduct
        {
            get { return idProduct; }
            set { idProduct = value; }
        }

        public string IDServices
        {
            get { return idServices; }
            set { idServices = value; }
        }

        public ServiceProduct() { }

        public ServiceProduct(string idProduct, string idServices)
        {
            this.idProduct = idProduct;
            this.idServices = idServices;
        }

        public ServiceProduct(SqlDataReader rdr)
        {
            try
            {
                this.idProduct = rdr[BaseDao.SERVICE_PRODUCT_ID_PRODUCT].ToString();
                this.idServices = rdr[BaseDao.SERVICE_PRODUCT_ID_SERVICES].ToString();
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(ServiceProduct), "CAST OF: " + ex.Message);
            }
        }
    }
}

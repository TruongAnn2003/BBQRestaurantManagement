using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class Services
    {
        private string id;
        private string nameServices;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string NameServices
        {
            get { return nameServices; }
            set { nameServices = value; }
        }

        public Services() { }

        public Services(string id, string name)
        {
            this.id = id;
            this.nameServices = name;
        }

        public Services(SqlDataReader reader)
        {
            try
            {
                this.id = (string)reader[BaseDao.SERVICES_ID];
                this.nameServices = (string)reader[BaseDao.SERVICES_NAME_SERVICES];
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(Services), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

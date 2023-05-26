using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class ServicesRestaurantDao : BaseDao
    {
        #region Add, Update, Delete
        //code Add, Update, Delete trong đây
        #endregion
        #region Search
       
        public List<ServicesRestaurant> Search(string idServices)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_SearchServices(" + "'@'" + idServices + ")");
            return dbConnection.GetList(sqlStr, reader => new ServicesRestaurant(reader));
        }

        #endregion
        #region Stored Procedures
        //code Stored Procedures trong đây
        #endregion
        #region Functions
        //code Functions trong đây
        #endregion
        #region Views
        public List<Product> GetServicesView()
        {
            string sqlStr = $"SELECT * FROM {SERVICES_VIEW}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        #endregion
    }
}

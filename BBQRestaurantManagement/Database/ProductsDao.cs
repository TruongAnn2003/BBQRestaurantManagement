using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class ProductsDao : BaseDao
    {
        #region Add, Update, Delete
        //code Add, Update, Delete trong đây
        #endregion
        #region Search
        //code Search trong đây
        #endregion
        #region Stored Procedures
        public List<Product> GetAllProductsByTypeID(string typeProductID)
        {
            string sqlStr = string.Format("exec proc_GetAllProductsByTypeID" + "'" + typeProductID + "'");
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        public void GetAllProductsByTypeName(string typeProductTypeName)
        {
            dbConnection.ExecuteNonQuery($"exec proc_GetAllProductsByTypeName '{typeProductTypeName}'");
        }

        #endregion
        #region Functions
        //code Functions trong đây
        #endregion
        #region Views

        public List<Product> GetFoodsView()
        {
            string sqlStr = $"SELECT * FROM {FOODS_VIEW}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        public List<Product> GetDrinksView()
        {
            string sqlStr = $"SELECT * FROM {DRINKS_VIEW}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        #endregion
    }
}

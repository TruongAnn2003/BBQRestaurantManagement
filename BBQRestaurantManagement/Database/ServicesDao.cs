using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xaml;

namespace BBQRestaurantManagement.Database
{
    public class ServicesDao : BaseDao
    {
        #region Add, Update, Delete
        public void Add(string idServices, string nameServices)
        {
            dbConnection.ExecuteNonQuery($"exec proc_AddServices '{idServices}','{nameServices}'");
        }
        public void Update(string idServices, string newNameServices)
        {
            dbConnection.ExecuteNonQuery($"exec proc_UpdateServices '{idServices}','{newNameServices}'");
        }
        public void Delete(string idServices)
        {
            dbConnection.ExecuteNonQuery($"exec proc_DeleteServices '{idServices}'");
        }
        #endregion
        #region Search
        /*
        public List<Services> Search(string idServices)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_SearchServices(" + "'@'" + idServices + ")");
            return dbConnection.GetList(sqlStr, reader => new Services(reader));
        }
        */
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

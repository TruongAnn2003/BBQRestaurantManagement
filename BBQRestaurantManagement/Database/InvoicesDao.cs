using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class InvoicesDao : BaseDao
    {
        #region Add, Update, Delete
        public Invoice SearchByID(string invoiceID)
        {
            string sqlStr = $"SELECT * FROM {INVOICE_TABLE} WHERE {INVOICE_ID}='{invoiceID}'";
            return (Invoice)dbConnection.GetSingleObject(sqlStr, reader => new Invoice(reader));
        }

        #endregion
        #region Search
        //code Search trong đây
        #endregion
        #region Stored Procedures
        //code Stored Procedures trong đây
        #endregion
        #region Functions
        //code Functions trong đây
        #endregion
        #region Views
        //code Views trong đây
        #endregion
    }
}

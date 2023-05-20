using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
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
        public void CreateNewInvoice(string orderID, string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_CreateNewInvoice '{orderID}', '{invoiceID}'");
        }

        public void DestroyInvoice(string orderID, string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_DesTroyInvoice '{orderID}', '{invoiceID}'");
        }
        #endregion
        #region Search

        public Invoice SearchByID(string invoiceID)
        {
            string sqlStr = $"SELECT * FROM {INVOICE_TABLE} WHERE {INVOICE_ID}='{invoiceID}'";
            return (Invoice)dbConnection.GetSingleObject(sqlStr, reader => new Invoice(reader));
        }

        #endregion
        #region Stored Procedures
        #endregion
        #region Functions
        public decimal TotalTheInvoice(string invoiceID,int discount)
        {
            var result = dbConnection.GetSingleValueFromFunction($"Select dbo.func_TotalTheInvoice ('{invoiceID}',{discount})", null);
            return (decimal)result;
        }
        #endregion
        #region Views
        //code Views trong đây
        #endregion
    }
}

﻿using BBQRestaurantManagement.Database.Base;
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
    public class InvoicesDao : BaseDao
    {
        #region Add, Update, Delete
       

        #endregion
        #region Search

        public Invoice SearchByID(string invoiceID)
        {
            string sqlStr = $"SELECT * FROM {INVOICE_TABLE} WHERE {INVOICE_ID}='{invoiceID}'";
            return (Invoice)dbConnection.GetSingleObject(sqlStr, reader => new Invoice(reader));
        }

        #endregion
        #region Stored Procedures

        public decimal TotalTheInvoice(string invoiceID)
        {
            var result = dbConnection.GetSingleValueFromFunction($"declare @result bigint " +
                                                                 $"exec proc_TotalTheInvoice '{invoiceID}', @result out " +
                                                                 $"Select @result;", null);
            return Convert.ToDecimal(result);
        }

        public void CreateNewInvoice(string orderID, string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_CreateNewInvoice '{orderID}', '{invoiceID}'");
        }

        public void DestroyInvoice(string orderID, string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_DesTroyInvoice '{orderID}', '{invoiceID}'");
        }

        public void UpdateDiscountTheInvoice(string invoiceID, int discount)
        {
            dbConnection.ExecuteNonQuery($"exec UpdateDiscountTheInvoice '{invoiceID}',{discount}");
        }

        public void PayTheInvoice(string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec PayTheInvoice '{invoiceID}'");
        }
        #endregion
        #region Functions

        #endregion
        #region Views
        //code Views trong đây
        #endregion
    }
}

using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Data;
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

        public void GetAllInvoicesByYearMonth(DateTime date)
        {
            dbConnection.ExecuteNonQuery($"exec proc_GetAllInvoicesByYearMonth '{date}'");
        }
        public void GetAllInvoicesByDate(DateTime date)
        {
            dbConnection.ExecuteNonQuery($"exec proc_GetAllInvoicesByDate '{date}'");
        }

        public void CheckIn(string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_CheckIn '{invoiceID}'");
        }
        public void CheckOut(string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_CheckOut '{invoiceID}'");
        }

        public void Cancel(string invoiceID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_Cancel '{invoiceID}'");
        }
        #endregion
        #region Functions
        public DataTable GetInvoiceBookingDetails(string bookingID)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_GetInvoiceBookingDetails(" + "'@'" + bookingID + ")");
            return dbConnection.DanhSach(sqlStr);
        }

        public DataTable GetInvoiceOrderDetails(string invoiceID)
        {
            string sqlStr = string.Format("SELECT * FROM dbo.func_GetInvoiceOrderDetails(" + "'@'" + invoiceID + ")");
            return dbConnection.DanhSach(sqlStr);
        }

        public decimal Bill(string OrderID)
        {
            var result = dbConnection.GetSingleValueFromFunction($"Select dbo.func_Bill('{OrderID}')", null);
            return Convert.ToDecimal(result);
        }

        #endregion
        #region Views
        public DataTable GetInvoiceOrderView()
        {
            string sqlStr = $"SELECT * FROM dbo.InvoiceOrderView";
            return dbConnection.DanhSach(sqlStr);
        }
        public DataTable GetInvoiceBookingView()
        {
            string sqlStr = $"SELECT * FROM dbo.InvoiceBookingView";
            return dbConnection.DanhSach(sqlStr);
        }
        #endregion
    }
}

using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class InvoiceOrderDetailsDao : BaseDao
    {
        #region Add, Update, Delete
        //code Add, Update, Delete trong đây
        #endregion
        #region Search
        //code Search trong đây
        #endregion
        #region Stored Procedures
        public List<InvoiceOrderDetail> GetInvoiceDetailsView(string invoiceID)
        {
            string sqlStr = $"exec proc_ShowInvoiceDetailsView '{invoiceID}'";
            return dbConnection.GetList(sqlStr, reader => new InvoiceOrderDetail(reader));
        }

        #endregion
        #region Functions

        #endregion
        #region Views
        //code Functions trong đây
        #endregion
    }
}

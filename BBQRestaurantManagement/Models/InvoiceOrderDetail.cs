using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls.Primitives;

namespace BBQRestaurantManagement.Models
{
    public class InvoiceOrderDetail
    {
        private string invoiceID;
        private string productID;
        private string productName;
        private DateTime createdTime;
        private decimal price;
        private int quantity;
        private decimal totalPrice;
        private string statusInvoiceID;
        private DateTime checkInTime;
        private DateTime checkOutTime;

        public string InvoiceID { get => invoiceID; set => invoiceID = value; }
        public string ProductID { get => productID; set => productID = value; }
        public string ProductName { get => productName; set => productName = value; }
        public DateTime CreatedTime { get => createdTime; set => createdTime = value; }
        public decimal Price { get => price; set => price = value; }
        public int Quantity { get => quantity; set => quantity = value; }
        public decimal TotalPrice { get => totalPrice; set => totalPrice = value; }
        public string StatusInvoiceID { get => statusInvoiceID; set => statusInvoiceID = value; }
        public DateTime CheckInTime { get => checkInTime; set => checkInTime = value; }
        public DateTime CheckOutTime { get => checkOutTime; set => checkOutTime = value; }

        public InvoiceOrderDetail(string invoiceID, string productID, string productName, DateTime createTime, decimal price, int quantity, decimal totalPrice, string statusInvoiceID, DateTime checkInTime, DateTime checkOutTime)
        {
            this.invoiceID = invoiceID;
            this.productID = productID;
            this.productName = productName;
            this.quantity = quantity;
            this.totalPrice = totalPrice;
            this.statusInvoiceID = statusInvoiceID;
            this.checkInTime = checkInTime;
            this.checkOutTime = checkOutTime;
            this.price = price;
            this.createdTime = createTime;
        }

        public InvoiceOrderDetail(SqlDataReader reader)
        {
            try
            {
                invoiceID = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_INVOICE_ID];
                productID = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_PRODUCT_ID];
                productName = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_PRODUCT_NAME];
                quantity = Convert.ToInt32(reader[BaseDao.INVOICE_ORDER_DETAILS_QUANTITY]);
                totalPrice = Convert.ToDecimal(reader[BaseDao.INVOICE_ORDER_DETAILS_TOTAL_PRICE]);
                statusInvoiceID = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_STATUS_INVOICE];
                checkInTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CHECKIN_TIME]);
                checkOutTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CHECKOUT_TIME]);
                price = Convert.ToDecimal(reader[BaseDao.INVOICE_ORDER_DETAILS_PRICE]);
                createdTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CREATED_TIME]);
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(Order), "CAST ERROR: " + ex.Message);
            }
        }

    }
}

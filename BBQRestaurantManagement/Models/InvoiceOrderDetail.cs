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
        private string tableID;
        private string productName;
        private DateTime createdTime;
        private decimal price;
        private int quantity;
        private decimal totalPrice;
        private string statusInvoice;
        private DateTime checkInTime;
        private DateTime checkOutTime;
        private int discount;
        private decimal totalPriceAfterDiscount;

        public string InvoiceID { get => invoiceID; set => invoiceID = value; }
        public string TableID { get => tableID; set => tableID = value; }
        public string ProductName { get => productName; set => productName = value; }
        public DateTime CreatedTime { get => createdTime; set => createdTime = value; }
        public decimal Price { get => price; set => price = value; }
        public int Quantity { get => quantity; set => quantity = value; }
        public decimal TotalPrice { get => totalPrice; set => totalPrice = value; }
        public string StatusInvoice { get => statusInvoice; set => statusInvoice = value; }
        public DateTime CheckInTime { get => checkInTime; set => checkInTime = value; }
        public DateTime CheckOutTime { get => checkOutTime; set => checkOutTime = value; }
        public int Discount { get => discount; set => discount = value; }
        public decimal TotalPriceAfterDiscount { get => totalPriceAfterDiscount; set => totalPriceAfterDiscount = value; }
        public InvoiceOrderDetail() { }

        public InvoiceOrderDetail(SqlDataReader reader)
        {
            try
            {
                InvoiceID = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_INVOICE_ID];
                TableID = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_TABLE_ID];
                CreatedTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CREATED_TIME]);
                ProductName = Convert.ToString( reader[BaseDao.INVOICE_ORDER_DETAILS_PRODUCT_NAME]);
                Quantity = Convert.ToInt32(reader[BaseDao.INVOICE_ORDER_DETAILS_QUANTITY]);
                Price = Convert.ToDecimal(reader[BaseDao.INVOICE_ORDER_DETAILS_PRICE]);
                TotalPrice = Convert.ToDecimal(reader[BaseDao.INVOICE_ORDER_DETAILS_TOTAL_PRICE]);
                Discount = Convert.ToInt32(reader[BaseDao.INVOICE_ORDER_DETAILS_DISCOUNT]);
                TotalPriceAfterDiscount = Convert.ToDecimal(reader[BaseDao.INVOICE_ORDER_DETAILS_TOTAL_PRICE_AFTER_DISCOUNT]);
                StatusInvoice = (string)reader[BaseDao.INVOICE_ORDER_DETAILS_STATUS_INVOICE];
                CheckInTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CHECKIN_TIME]);
                CheckOutTime = Convert.ToDateTime(reader[BaseDao.INVOICE_ORDER_DETAILS_CHECKOUT_TIME]);
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(InvoiceOrderDetail), "CAST ERROR: " + ex.Message);
            }
        }

    }
}

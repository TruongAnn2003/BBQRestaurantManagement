using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Windows.Documents;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class InvoiceViewModel : BaseViewModel
    {
        private Invoice invoiceIns;
        public Invoice InvoiceIns { get => invoiceIns; set => invoiceIns = value; }

        private List<InvoiceOrderDetail> listInvoiceOrderDetails;
        public List<InvoiceOrderDetail> ListInvoiceOrderDetails 
        { get => listInvoiceOrderDetails; set { listInvoiceOrderDetails = value; OnPropertyChanged(); } }

        private InvoiceOrderDetailsDao invoiceOrderDetailsDao = new InvoiceOrderDetailsDao();

        public InvoiceViewModel() 
        {
            SetCommands();
            LoadListInvoiceOrderDetails();
        }

        private void SetCommands()
        {

        }

        public void LoadListInvoiceOrderDetails()
        {
            var listItem = invoiceOrderDetailsDao.GetInvoiceOrderDetailsView(InvoiceIns.ID);
            ListInvoiceOrderDetails = listItem;
        }
    }
}

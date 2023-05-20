using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class InvoiceViewModel : BaseViewModel
    {
        private Invoice invoiceIns = new Invoice();
        public Invoice InvoiceIns { get => invoiceIns; set { invoiceIns = value; OnPropertyChanged(); } }

        public string InvoiceID { get => InvoiceIns.ID; set => InvoiceIns.ID = value; }
        public DateTime CreationTime { get => InvoiceIns.CreationTime; set => InvoiceIns.CreationTime = value; }
        public decimal Price { get => InvoiceIns.Price; set => InvoiceIns.Price = value; }

        private Staff staffCreation = CurrentUser.Ins.Staff;
        public Staff StaffCreation { get => staffCreation; set => staffCreation = value; }

        private ObservableCollection<InvoiceOrderDetail> listInvoiceOrderDetails;
        public ObservableCollection<InvoiceOrderDetail> ListInvoiceOrderDetails 
        { get => listInvoiceOrderDetails; set { listInvoiceOrderDetails = value; OnPropertyChanged(); } }

        private InvoiceOrderDetailsDao invoiceOrderDetailsDao = new InvoiceOrderDetailsDao();
        private InvoicesDao invoicesDao = new InvoicesDao();

        public ICommand PaymentCommand { get; private set; }

        public InvoiceViewModel() 
        {
            SetCommands();
        }

        private void SetCommands()
        {
            PaymentCommand = new RelayCommand<object>(ExecutePaymentCommand);
        }

        private void ExecutePaymentCommand(object obj)
        {
            throw new NotImplementedException();
        }

        public void LoadListInvoiceOrderDetails()
        {
            var listItem = invoiceOrderDetailsDao.GetInvoiceDetailsView(InvoiceIns.ID);
            InvoiceIns.Price = invoicesDao.TotalTheInvoice(InvoiceIns.ID, 0);
            ListInvoiceOrderDetails = new ObservableCollection<InvoiceOrderDetail>( listItem);
        }
    }
}

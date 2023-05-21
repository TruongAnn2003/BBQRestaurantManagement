using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.ObjectModel;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class InvoiceViewModel : BaseViewModel
    {
        private Invoice invoiceIns = new Invoice();
        public Invoice InvoiceIns { get => invoiceIns; set { invoiceIns = value; } }

        public string InvoiceID { get => InvoiceIns.ID; set { InvoiceIns.ID = value; OnPropertyChanged(); } }
        public DateTime CreationTime { get => InvoiceIns.CreationTime; set { InvoiceIns.CreationTime = value; OnPropertyChanged(); } }
        public decimal Price { get => InvoiceIns.Price; set { InvoiceIns.Price = value; OnPropertyChanged(); } }

        public Action<object> MoveToTheInvoiceView { get; set; }

        public int Discount 
        {   
            get => InvoiceIns.Discount; 
            set 
            { 
                InvoiceIns.Discount = value; 
                UpdateDiscountInvoiceIns(); 
                TotalTheInvoice(); 
                OnPropertyChanged(); 
            } 
        }

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
            invoicesDao.PayTheInvoice(InvoiceID);
            LoadListInvoiceOrderDetails();
            AlertDialogService dialog = new AlertDialogService(
                "Hóa đơn",
                "Thanh toán thánh công!Bạn có muốn quay lại Menu!",
               () =>
               { 
                   MoveToTheInvoiceView(null); 
               }, null);
            dialog.Show();
        }

        public void LoadListInvoiceOrderDetails()
        {
            var listItem = invoiceOrderDetailsDao.GetInvoiceDetailsView(InvoiceIns.ID);
            ListInvoiceOrderDetails = new ObservableCollection<InvoiceOrderDetail>(listItem);
            TotalTheInvoice();        
        }

        public void UpdateDiscountInvoiceIns()
        {
            invoicesDao.UpdateDiscountTheInvoice(InvoiceID,Discount);
            LoadListInvoiceOrderDetails();
        }


        private void TotalTheInvoice()
        {
            Price = invoicesDao.TotalTheInvoice(InvoiceID);
            LoadInvoiceIns();
        }

        private void LoadInvoiceIns()
        {
            InvoiceIns = invoicesDao.SearchByID(InvoiceID);
        }
    }
}

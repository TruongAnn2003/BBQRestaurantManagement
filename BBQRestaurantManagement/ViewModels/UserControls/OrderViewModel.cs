using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.ViewModels.Base;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class OrderViewModel : BaseViewModel
    {
        private MenuUC MenuView = new MenuUC();
        private InvoiceUC InvoiceView = new InvoiceUC();
        private TableEmptyUC TableEmptyView = new TableEmptyUC();
        private CheckInOutUC CheckInOutView = new CheckInOutUC();

        private Order orderIns;

        public Order OrderIns { get => orderIns; set => orderIns = value; }


        private bool statusMenuView = false;
        public bool StatusMenuView { get => statusMenuView; set { statusMenuView = value; OnPropertyChanged(); } }

        private bool statusInvoiceView = false;
        public bool StatusInvoiceView { get => statusInvoiceView; set { statusInvoiceView = value; OnPropertyChanged(); } }

        private bool statusTableEmptyView = false;
        public bool StatusTableEmptyView { get => statusTableEmptyView; set { statusTableEmptyView = value; OnPropertyChanged(); } }

        private bool statusCheckInOutView = false;
        public bool StatusCheckInOutView { get => statusCheckInOutView; set { statusCheckInOutView = value; OnPropertyChanged(); } }

        private List<OrderDetails> listOrderItem;
        public List<OrderDetails> ListOrderItem { get => listOrderItem; set { listOrderItem = value; OnPropertyChanged(); } }

        private ContentControl currentChildView = new ContentControl();
        public ContentControl CurrentChildView { get { return currentChildView; } set { currentChildView = value; OnPropertyChanged(); } }

        public ICommand ShowMenuView { get; set; }
        public ICommand ShowInvoiceView { get; set; }
        public ICommand ShowTableEmptyView { get; set; }
        public ICommand ShowCheckInOutView { get; set; }
        public ICommand PlusCommand { get; private set; }
        public ICommand MinusCommand { get; private set; }
        public ICommand CancelOrderCommand { get; private set; }

        private OrdersDao ordersDao = new OrdersDao();
        private InvoicesDao invoicesDao = new InvoicesDao();


        public OrderViewModel()
        {
            SetCommand();            
        }

        private void LoadOrderItem(string id)
        {
            ListOrderItem = ordersDao.SearchByOrderID(id);           
        }

        private void SetCommand()
        {
            ShowMenuView = new RelayCommand<object>(ExecuteShowMenuView);
            ShowInvoiceView = new RelayCommand<object>(ExecuteShowInvoiceView);
            ShowTableEmptyView = new RelayCommand<object>(ExecuteShowTableEmptyView);
            ShowCheckInOutView = new RelayCommand<object>(ExecuteShowCheckInOutView);
            PlusCommand = new RelayCommand<OrderDetails>(ExecutePlusCommand);
            MinusCommand = new RelayCommand<OrderDetails>(ExecuteMinusCommand);
            CancelOrderCommand = new RelayCommand<object>(ExecuteCancelOrderCommand);
        }

        private void ExecuteCancelOrderCommand(object obj)
        {
            if (orderIns != null)
            {
                AlertDialogService dialog = new AlertDialogService(
                 "Order",
                 "Cancel order?",
                 () =>
                 {
                     //Delete
                     ordersDao.Delete(OrderIns.ID);
                     //ReturnView
                     MenuView.DataContext = new MenuViewModel();
                     ((MenuViewModel)(MenuView.DataContext)).LoadOrderItemView = new Action<string>(LoadOrderItem);
                     CurrentChildView = MenuView;
                     ((MenuViewModel)MenuView.DataContext).OrderIns = null;
                     ListOrderItem = new List<OrderDetails>();
                     OrderIns = new Order();
                 }, null);
                dialog.Show();
            }    
        }

        private void ExecuteMinusCommand(OrderDetails orderDetails)
        {
            if (orderDetails.Quantity == 0) return;
            ordersDao.AddOrderProduct(orderDetails.OrderID, orderDetails.ProductID, -1);
            LoadOrderItem(orderDetails.OrderID);
        }

        private void ExecutePlusCommand(OrderDetails orderDetails)
        {
            ordersDao.AddOrderProduct(orderDetails.OrderID, orderDetails.ProductID, 1);
            LoadOrderItem(orderDetails.OrderID);
        }

        private void ExecuteShowCheckInOutView(object obj)
        {
            CurrentChildView = CheckInOutView;
            StatusCheckInOutView = true;
        }

        private void ExecuteShowTableEmptyView(object obj)
        {
            CurrentChildView = TableEmptyView;
            StatusTableEmptyView = true;
        }

        private void ExecuteShowInvoiceView(object obj)
        {        
            AlertDialogService dialog = new AlertDialogService(
              "Order",
              "Create Invoice?",
              () =>
              {
                  InvoiceView.DataContext = new InvoiceViewModel();
                  var newInvoie = Invoice.CreateInvoiceIns();
                  invoicesDao.CreateNewInvoice(OrderIns.ID, newInvoie.ID);
                  ((InvoiceViewModel)InvoiceView.DataContext).InvoiceIns = newInvoie;
                  ((InvoiceViewModel)InvoiceView.DataContext).LoadListInvoiceOrderDetails();
                  CurrentChildView = InvoiceView;
                  StatusInvoiceView = true;
              }, null);
            dialog.Show();          
        }

        private void ExecuteShowMenuView(object obj)
        {
            MenuView.DataContext = new MenuViewModel();
            AlertDialogService dialog = new AlertDialogService(
               "Order",
               "Create new order?",
               () => 
               {
                   OrderIns = Order.CreateOrderIns();
                   ordersDao.AddNonCustomerAndInvoice(OrderIns);
                   ((MenuViewModel)MenuView.DataContext).OrderIns = OrderIns;
               }, null);
            dialog.Show();
            ((MenuViewModel)(MenuView.DataContext)).LoadOrderItemView = new Action<string>(LoadOrderItem);
            CurrentChildView = MenuView;
            StatusMenuView = true;
        }

    }
}

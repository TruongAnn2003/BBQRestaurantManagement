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
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class MainViewModel : BaseViewModel
    {
        private MenuUC MenuView = new MenuUC();
        private InvoiceUC InvoiceView = new InvoiceUC();
        private TableEmptyUC TableEmptyView = new TableEmptyUC();
        private CheckInOutUC CheckInOutView = new CheckInOutUC();
        private UserInfomationUC UserView = new UserInfomationUC();

        private Order orderIns;

        public Order OrderIns { get => orderIns; set => orderIns = value; }

        private Visibility visibilityOrderDetailsView = Visibility.Visible;
        public Visibility VisibilityOrderDetailsView { get => visibilityOrderDetailsView; set { visibilityOrderDetailsView = value; OnPropertyChanged(); } }

        private bool statusMenuView = false;
        public bool StatusMenuView { get => statusMenuView; set { statusMenuView = value; OnPropertyChanged(); } }

        private bool statusInvoiceView = false;
        public bool StatusInvoiceView { get => statusInvoiceView; set { statusInvoiceView = value; OnPropertyChanged(); } }

        private bool statusTableEmptyView = false;
        public bool StatusTableEmptyView { get => statusTableEmptyView; set { statusTableEmptyView = value; OnPropertyChanged(); } }

        private bool statusCheckInOutView = false;
        public bool StatusCheckInOutView { get => statusCheckInOutView; set { statusCheckInOutView = value; OnPropertyChanged(); } }

        private bool statusUserView = false;
        public bool StatusUserView { get => statusUserView; set { statusUserView = value; OnPropertyChanged(); } }

        private bool statusStatisticsView = false;
        public bool StatusStatisticsView { get => statusStatisticsView; set { statusStatisticsView = value; OnPropertyChanged(); } }

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
        public ICommand ShowUserView { get; private set; }
        public ICommand ShowStatisticsView { get; private set; }

        private OrdersDao ordersDao = new OrdersDao();
        private InvoicesDao invoicesDao = new InvoicesDao();


        public MainViewModel()
        {
            SetCommand();
            ExecuteShowUserView(null);
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
            ShowUserView = new RelayCommand<object>(ExecuteShowUserView);
            ShowStatisticsView = new RelayCommand<object>(ExecuteShowStatisticsView);
            PlusCommand = new RelayCommand<OrderDetails>(ExecutePlusCommand);
            MinusCommand = new RelayCommand<OrderDetails>(ExecuteMinusCommand);
            CancelOrderCommand = new RelayCommand<object>(ExecuteCancelOrderCommand);
        }

        private void ExecuteShowStatisticsView(object obj)
        {
            VisibilityOrderDetailsView = Visibility.Collapsed;
            CurrentChildView = new StatisticsUC();
            StatusStatisticsView = true;
        }

        private void ExecuteShowUserView(object obj)
        {
            UserView.DataContext = new UserInfomationViewModel();
            CurrentChildView = UserView;
            StatusUserView = true;
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
                     ResetOrder();
                     ExecuteShowMenuView(null);
                 }, null);
                dialog.Show();
            }    
        }

        private void ResetOrder()
        {
            ordersDao.Delete(OrderIns.ID);
            OrderIns = null;
            ListOrderItem = new List<OrderDetails>();
        }
        private void CompleteTheOrder(object o)
        {
               ListOrderItem = new List<OrderDetails>();
                OrderIns = null;
                CurrentChildView = MenuView;
                ExecuteShowMenuView(null);     
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
            if (StatusMenuView == true && OrderIns != null)
            {
                AlertDialogService dialog = new AlertDialogService(
                "Order",
                "Cancel order?",
                () =>
                {
                    ResetOrder();
                }, null);
                dialog.Show();
            }    
                
            if (orderIns == null)
            {
                CurrentChildView = CheckInOutView;
                StatusCheckInOutView = true;
            }              
        }

        private void ExecuteShowTableEmptyView(object obj)
        {
            CurrentChildView = TableEmptyView;
            StatusTableEmptyView = true;
        }

        private void ExecuteShowInvoiceView(object obj)
        {
           if(OrderIns != null) 
            {
                AlertDialogService dialog = new AlertDialogService(
                 "Order",
                 "Create Invoice?",
                 () =>
                 {
                     VisibilityOrderDetailsView = Visibility.Collapsed;
                     InvoiceView.DataContext = new InvoiceViewModel();
                     var newInvoie = Invoice.CreateInvoiceIns();
                     invoicesDao.CreateNewInvoice(OrderIns.ID, newInvoie.ID);
                     ((InvoiceViewModel)InvoiceView.DataContext).InvoiceIns = newInvoie;
                     ((InvoiceViewModel)InvoiceView.DataContext).LoadListInvoiceOrderDetails();
                     ((InvoiceViewModel)(InvoiceView.DataContext)).MoveToTheInvoiceView = new Action<object>(CompleteTheOrder);
                     CurrentChildView = InvoiceView;
                     StatusInvoiceView = true;
                 }, null);
                dialog.Show();
            }               
        }

        private void ExecuteShowMenuView(object obj)
        {
            if(orderIns == null)
            {               
                MenuView.DataContext = new MenuViewModel();
                CreateOrderIns(null);
                ((MenuViewModel)(MenuView.DataContext)).LoadOrderItemView = new Action<string>(LoadOrderItem);
                ((MenuViewModel)(MenuView.DataContext)).CreateOrder = new Action<object>(CreateOrderIns);   
            }
            VisibilityOrderDetailsView = Visibility.Visible;
            CurrentChildView = MenuView;
            StatusMenuView = true;
        }
        private void CreateOrderIns(object obj)
        {
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
        }

    }
}

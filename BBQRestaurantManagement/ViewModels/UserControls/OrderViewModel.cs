using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
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
        private MenuUC menuView = new MenuUC();
        private InvoiceUC InvoiceView = new InvoiceUC();
        private TableEmptyUC TableEmptyView = new TableEmptyUC();
        private CheckInOutUC CheckInOutView = new CheckInOutUC();

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

        private OrdersDao orderDao = new OrdersDao();
        private TransactionsDao transactionsDao = new TransactionsDao();

        public OrderViewModel()
        {
            SetCommand();
            ExecuteShowMenuView(null);
            
        }

        private void LoadOrderItem(string  id)
        {
            ListOrderItem = orderDao.SearchByOrderID(id);
            Log.Instance.Information(nameof(OrderViewModel), "cout item = " + ListOrderItem.Count.ToString());
        }

        private void SetCommand()
        {
            ShowMenuView = new RelayCommand<object>(ExecuteShowMenuView);
            ShowInvoiceView = new RelayCommand<object>(ExecuteShowInvoiceView);
            ShowTableEmptyView = new RelayCommand<object>(ExecuteShowTableEmptyView);
            ShowCheckInOutView = new RelayCommand<object>(ExecuteShowCheckInOutView);
            PlusCommand = new RelayCommand<OrderDetails>(ExecutePlusCommand);
            MinusCommand = new RelayCommand<OrderDetails>(ExecuteMinusCommand);
        }
        private void ExecuteMinusCommand(OrderDetails orderDetails)
        {
            if (orderDetails.Quantity == 0) return;
            orderDetails.Quantity = orderDetails.Quantity - 1;
        }

        private void ExecutePlusCommand(OrderDetails orderDetails)
        {
            orderDetails.Quantity = orderDetails.Quantity + 1;
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
            CurrentChildView = InvoiceView;
            StatusInvoiceView = true;
        }

        private void ExecuteShowMenuView(object obj)
        {
            menuView.DataContext = new MenuViewModel();
            var newOrder = CreateOrderIns();
            orderDao.Add(newOrder);
            ((MenuViewModel)menuView.DataContext).OrderIns = newOrder;
            ((MenuViewModel)(menuView.DataContext)).LoadOrderItemView = new Action<string>(LoadOrderItem);
            CurrentChildView = menuView;
            StatusMenuView = true;
        }

        private Order CreateOrderIns()
        {
            return new Order(AutoGenerateID(), DateTime.Now, 0, 1, "", CurrentUser.Ins.Staff.ID, "");
        }

        private string AutoGenerateID()
        {
            string orderID;
            Random random = new Random();
            do
            {
                int number = random.Next(10000000);
                orderID = $"ORD{number:0000000}";
            } while (orderDao.SearchByID(orderID) != null);
            return orderID;
        }
    }
}

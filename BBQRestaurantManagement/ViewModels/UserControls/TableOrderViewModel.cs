using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class TableOrderViewModel : BaseViewModel
    {
        public Order OrderIns { get; set; }

        private List<TablesCustomer> listTableIsEmpty;
        public List<TablesCustomer> ListTableIsEmpty { get => listTableIsEmpty; set { listTableIsEmpty = value; OnPropertyChanged(); } }

        private List<TablesCustomer> listTableIsOccupied;
        public List<TablesCustomer> ListTableIsOccupied { get => listTableIsOccupied; set { listTableIsOccupied = value; OnPropertyChanged(); } }

        private OrdersDao ordersDao = new OrdersDao();

        public Action<string> LoadOrderItemView { get; set; }
        public Action<Order> ReceiveOrderIns { get; set; }

        public ICommand AddTableOrderCommand { get; set; }

        public TableOrderViewModel()
        {
            AddTableOrderCommand = new RelayCommand<string>(ExecuteAddTableOrderCommand);
            LoadData();
        }

        private void ExecuteAddTableOrderCommand(string tableID)
        {
            if (OrderIns == null) return;
            AlertDialogService dialog = new AlertDialogService(
                 "Chọn Bàn",
                 $"Bạn có muốn chọn bàn {tableID} !",
                () => {                  
                    OrderIns.TableID = tableID;
                    ordersDao.SelectTableOrder(OrderIns.ID, tableID);
                    LoadData();
                    ReceiveOrderIns(OrderIns);
                    LoadOrderItemView(OrderIns.ID);
                }, null);
            dialog.Show();
          
        }

        private void LoadData()
        {
            ListTableIsEmpty = ordersDao.ShowTableIsEmpty();
            ListTableIsOccupied = ordersDao.ShowTableIsOccupied();
        }
    }
}

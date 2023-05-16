using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class MenuViewModel : BaseViewModel
    {
        private Order orderIns;
        public Order OrderIns { get => orderIns; set => orderIns = value; }

        private ObservableCollection<Product> foods;
        public ObservableCollection<Product> Foods { get => foods; set { foods = value; OnPropertyChanged(); } }

        private ObservableCollection<Product> drinks;
        public ObservableCollection<Product> Drinks { get => drinks; set { drinks = value; OnPropertyChanged(); } }

        private Action<string> loadOrderItemView;
        public Action<string> LoadOrderItemView { get => loadOrderItemView; set { loadOrderItemView = value; OnPropertyChanged(); } }

        private ViewsDao viewDao = new ViewsDao();     
        private OrdersDao ordersDao = new OrdersDao();
        private StoredProceduresDao proceduresDao = new StoredProceduresDao();

        public ICommand AddCommand { get; private set; }

        public MenuViewModel() 
        {
            LoadViewMenu();
            SetCommand();
           
        }

        private void SetCommand()
        {
            AddCommand = new RelayCommand<Product>(ExecuteAddCommand);
        }

        private void ExecuteAddCommand(Product product)
        {         
            if(OrderIns == null)
            {
                AlertDialogService dialog = new AlertDialogService(
                  "Order",
                  "Create new order?",
                  () =>
                  {
                      OrderIns = Order.CreateOrderIns();
                      ordersDao.Add(OrderIns);               
                  }, null);
                dialog.Show();
            }
            proceduresDao.AddOrderProduct(OrderIns.ID, product.ID, 1);
            LoadOrderItemView(OrderIns.ID);
        }

        private void LoadViewMenu()
        {
            Foods = new ObservableCollection<Product>(viewDao.GetFoodsView());
            Drinks = new ObservableCollection<Product>(viewDao.GetDrinksView());
        }

    
    }
}

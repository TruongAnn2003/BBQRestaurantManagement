using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
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
        private StoredProceduresDao proceduresDao = new StoredProceduresDao();

        public ICommand PlusCommand { get;private set; }
        public ICommand MinusCommand { get; private set; }
        public ICommand AddCommand { get; private set; }

        public MenuViewModel() 
        {
            LoadViewMenu();
            SetCommand();
        }

        private void SetCommand()
        {
            PlusCommand = new RelayCommand<Product>(ExecutePlusCommand);
            MinusCommand = new RelayCommand<Product>(ExecuteMinusCommand);
            AddCommand = new RelayCommand<Product>(ExecuteAddCommand);
        }

        private void ExecuteAddCommand(Product product)
        {
            LoadOrderItemView(OrderIns.ID);
            proceduresDao.AddOrderProduct(OrderIns.ID,product.ID,1);
            Log.Instance.Information(nameof(MenuViewModel), "OrderID = "+ OrderIns.ID + ", ProductID = " + product.ID);
        }

        private void ExecuteMinusCommand(Product product)
        {
            if (product.QuantityOrder == 0) return;
            product.QuantityOrder = product.QuantityOrder - 1;
            Log.Instance.Information(nameof(MenuViewModel), product.QuantityOrder.ToString());
        }

        private void ExecutePlusCommand(Product product)
        {
            product.QuantityOrder = product.QuantityOrder + 1;
            Log.Instance.Information(nameof(MenuViewModel), product.QuantityOrder.ToString());
        }

        private void LoadViewMenu()
        {
            Foods = new ObservableCollection<Product>(viewDao.GetFoodsView());
            Drinks = new ObservableCollection<Product>(viewDao.GetDrinksView());
        }

    
    }
}

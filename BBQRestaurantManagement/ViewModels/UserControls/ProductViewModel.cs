using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class ProductViewModel : BaseViewModel
    {

        private ObservableCollection<Product> products;
        public ObservableCollection<Product> Products { get {  return products; } set { products = value; OnPropertyChanged();} }

        private string id;
        public string ID { get { return id; } set { id = value; OnPropertyChanged(); } }

        private string name;
        public string Name { get { return name; } set { name = value; OnPropertyChanged(); } }

        private string description;
        public string Description 
        { 
            get { return description; }
            set
            {
                description = value;
                OnPropertyChanged();
            } 
        }

        private int state;
        public int State 
        {
            get { return state; }
            set
            {
                state = value;
                OnPropertyChanged();
            }
        }

        private string typeID;
        public string TypeID { get { return typeID; } set { typeID = value; OnPropertyChanged(); } }

        private decimal price;
        public decimal Price { get { return price; } set { price = value; OnPropertyChanged(); } }

        private List<ProductType> productTypes;
        public List<ProductType> ProductTypes { get => productTypes; set { productTypes = value; OnPropertyChanged(); } }

        private ProductType selectedProductType;
        public ProductType SelectedProductType { get{return selectedProductType; } set { selectedProductType = value; OnPropertyChanged();  } }

        public ICommand AddCommand { get; set; }
        public ICommand UpdateCommand { get; set; }
        public ICommand DeleteCommand { get; set; }
        public ICommand SelectedProductCommand { get; set; }
        public ICommand ReLoadCommand { get;set; }

        private ProductsDao productsDao = new ProductsDao();

        public ProductViewModel()
        {
            productTypes = productsDao.GetAllType();
            SetCommands();
            LoadData();
        }

        private void SetCommands()
        {
            AddCommand = new RelayCommand<object>(ExecuteAddCommand);
            UpdateCommand = new RelayCommand<object>(ExecuteUpdateCommand);
            DeleteCommand = new RelayCommand<object>(ExecuteDeleteCommand);
            SelectedProductCommand = new RelayCommand<Product>(ExecuteSelectedProductCommand);
            ReLoadCommand = new RelayCommand<object>(ExecuteReLoadCommand);
        }

        private void ExecuteReLoadCommand(object obj)
        {
            Name = "";
            Price = 0;
            Description = "";
            State = 0;
            TypeID ="";
            ID = "";
            LoadData();
        }

        private void ExecuteSelectedProductCommand(Product product)
        {
            if(product == null) return;
            Name = product.Name;
            Price = product.Price;
            Description = product.Description;
            State = product.State;
            TypeID = product.TypeID;
            ID = product.ID;
        }

        private void ExecuteDeleteCommand(object obj)
        {
            Product product = new Product(ID,Name,Price,Description,State,TypeID);
            productsDao.Delete(ID);
            LoadData();
        }

        private void ExecuteUpdateCommand(object obj)
        {
            Product product = new Product(ID, Name, Price, Description, State, TypeID);
            productsDao.Update(product);
            LoadData();
        }

        private void ExecuteAddCommand(object obj)
        {
            Product product = new Product(ID, Name, Price, Description, State, TypeID);
            productsDao.Add(product);
            LoadData();
        }

        private void LoadData()
        {
            Products = new ObservableCollection<Product>( productsDao.GetAll());
        }
    }
}

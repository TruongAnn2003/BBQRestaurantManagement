using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BBQRestaurantManagement.Utilities;
using System.Windows.Input;
using BBQRestaurantManagement.Databases;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.ViewModels.Base;
using BBQRestaurantManagement.Database;
using System.Windows;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class LoginViewModel : BaseViewModel
    {
        private string id="";

        private string password="";

        public string ID { get { return id; } set { id = value; OnPropertyChanged(); } }

        public string Password { get { return password; } set { password = value; OnPropertyChanged(); } }

        public ICommand LoginCommand { get; set; }

        private Action<object> loginOrderView;

        public Action<object> LoginOrderView { get => loginOrderView; set { loginOrderView = value; OnPropertyChanged(); } }

        private FunctionDao functionDao = new FunctionDao();

        public LoginViewModel()
        {
            LoginCommand = new RelayCommand<object>(ExecuteLoginCommand);
        }

        private void ExecuteLoginCommand(object obj)
        {
            if (functionDao.CheckLogin(ID,Password)==1)
            {
                LoginOrderView(null);
                return;
            }
            AlertDialogService dialog = new AlertDialogService(
                "Error",
                "Tài khoản không tồn tại !",
                () => { }, null);
            dialog.Show();
        }
    }
}

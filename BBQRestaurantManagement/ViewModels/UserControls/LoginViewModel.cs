using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using BBQRestaurantManagement.ViewModels.Base;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class LoginViewModel : BaseViewModel
    {
        public ICommand LoginCommand { get; set; }
        private Action<object> loginOrderView;
        public Action<object> LoginOrderView { get => loginOrderView; set { loginOrderView = value; OnPropertyChanged(); } }
        public LoginViewModel()
        {
            LoginCommand = new RelayCommand<object>(ExecuteLoginCommand);
        }

        private void ExecuteLoginCommand(object obj)
        {
            LoginOrderView(null);
        }
    }
}

using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.Dialogs
{
    public class AlertDialogViewModel : BaseViewModel
    {
        private string title = "";
        public string Title { get => title; set { title = value; OnPropertyChanged(); } }

        private string message = "";
        public string Message { get => message; set { message = value; OnPropertyChanged(); } }

        public ICommand YesCommand { get; set; }
        public ICommand NoCommand { get; set; }
    }
}

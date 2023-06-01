using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class BookingCustomerViewModel : BaseViewModel
    {
        private DataTable listCustomersBooking;
        public DataTable ListCustomersBooking { get => listCustomersBooking; set { listCustomersBooking = value; OnPropertyChanged(); } }

        private BookingDao bookingDao = new BookingDao();

        private string textToSearch = "";
        public string TextToSearch { get => textToSearch; set {  textToSearch = value; OnPropertyChanged(); } }

        private Visibility visibilityApprovalBooking = Visibility.Collapsed;
        public Visibility VisibilityApprovalBooking { get => visibilityApprovalBooking; set { visibilityApprovalBooking = value; OnPropertyChanged(); } }

        private Visibility visibilityCompleteBooking = Visibility.Collapsed;
        public Visibility VisibilityCompleteBooking { get => visibilityCompleteBooking; set { visibilityCompleteBooking = value; OnPropertyChanged(); } }

        public ICommand BookingApprovalCommand { get; set; }
        public ICommand BookingCancelCommand { get; set; }
        public ICommand BookingCompleteCommand { get; set; }
        public ICommand FindBookingCommandCommand { get; set; }

        public BookingCustomerViewModel()
        {
            LoadAll();
            SetCommand();
            if (CurrentUser.StatusLogin == true)
            {
                VisibilityCompleteBooking = Visibility.Visible;
                VisibilityApprovalBooking = Visibility.Visible;
            }    
        }

        private void SetCommand ()
        {
            BookingApprovalCommand = new RelayCommand<string>(ExecuteBookingApprovalCommand);
            BookingCancelCommand = new RelayCommand<string>(ExecuteBookingCancelCommand);
            BookingCompleteCommand = new RelayCommand<string>(ExecuteBookingCompleteCommand);
            FindBookingCommandCommand = new RelayCommand<object>(ExecuteFindBookingCommand);
        }

        

        private void ExecuteFindBookingCommand(object obj)
        {
            TextToSearch = TextToSearch.Trim();
            ListCustomersBooking = bookingDao.SearchCustomerBookingView(TextToSearch);
        }

        private void ExecuteBookingCompleteCommand(string id)
        {
            bookingDao.BookingComplete(id);
            LoadAll();
        }

        private void ExecuteBookingCancelCommand(string id)
        {
            bookingDao.BookingCancel(id);
            LoadAll();
        }

        private void ExecuteBookingApprovalCommand(string id)
        {
           
             bookingDao.BookingApproval(id);
            LoadAll();
        }

        private void LoadAll()
        {
            if (CurrentUser.StatusLogin == true)
                ListCustomersBooking = bookingDao.GetAllCustomerBookingView();
            if (CurrentUser.StatusLogin == false && TextToSearch != "")
                ExecuteFindBookingCommand(null);
        }
    }
}

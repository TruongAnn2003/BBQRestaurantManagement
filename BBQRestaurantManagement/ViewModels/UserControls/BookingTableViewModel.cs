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
    public class BookingTableViewModel : BaseViewModel
    {
        private List<TablesCustomer> listTableIsEmpty;
        public List<TablesCustomer> ListTableIsEmpty { get => listTableIsEmpty; set { listTableIsEmpty = value; OnPropertyChanged(); } }

        private OrdersDao ordersDao = new OrdersDao();
        private BookingDao bookingDao = new BookingDao();

        private string fullName ="";
        public string FullName { get => fullName; set { fullName = value; OnPropertyChanged(); } }

        private string numberPhone = "";
        public string NumberPhone { get => numberPhone; set { numberPhone = value; OnPropertyChanged(); } } 

        private DateTime bookingDate = DateTime.Now;
        public DateTime BookingDate { get => bookingDate; set { bookingDate = value; OnPropertyChanged(); } }

        private string notes = "";
        public string Notes { get => notes; set
            {
                notes = value;
                OnPropertyChanged();
            } }

        private int duration = 0;
        public int Duration { get => duration; set
            {
                duration = value;
                OnPropertyChanged();
            } }

        private int numberOfPeople = 0;
        public int NumberOfPeople
        {
            get => numberOfPeople; set
            {
                numberOfPeople = value;
                OnPropertyChanged();
            }
        }

        private string tableID = "";
        public string TableID { get => tableID; set
            {
                tableID = value;
                OnPropertyChanged();
            } }

        public ICommand SelectedTableCommand { get; set; }
        public ICommand CreateBookingCommand { get; set; }
        public ICommand ResetCommand { get; set; }
        public ICommand NextDayCommand { get; set; }
        public ICommand BackDayCommand { get; set; }

        public BookingTableViewModel()
        {
            SelectedTableCommand = new RelayCommand<TablesCustomer>(ExecuteSelectedTableCommand);
            CreateBookingCommand = new RelayCommand<object>(ExecuteCreateBookingCommand);
            ResetCommand = new RelayCommand<object>(ExecuteResetCommand);
            NextDayCommand = new RelayCommand<object>(ExecuteNextDayCommand);
            BackDayCommand = new RelayCommand<object>(ExecuteBackDayCommand);
            LoadData();

        }

        private void ExecuteBackDayCommand(object obj)
        {
            BookingDate = BookingDate.AddDays(-1);           
        }

        private void ExecuteNextDayCommand(object obj)
        {
            BookingDate = BookingDate.AddDays(1);            
        }

        private void ExecuteResetCommand(object obj)
        {
            Reset();
            LoadData();
        }

        private void ExecuteCreateBookingCommand(object obj)
        {
            AlertDialogService dialog = new AlertDialogService(
                 "Booking",
                 $"Create Booking?",
                () => {
                    bookingDao.CreateBooking(BookingDate, Duration, Notes, NumberOfPeople, FullName, NumberPhone, TableID);
                    Reset();
                }, null);
            dialog.Show();
          
        }

        private void Reset()
        {
            FullName = "";
            BookingDate = DateTime.Now;
            Duration =0;
            NumberPhone = "";
            NumberOfPeople = 0;
            Notes = "";
        }

        private void ExecuteSelectedTableCommand(TablesCustomer table)
        {
            if(table == null) return;
            TableID = table.TablesID;
        }

        private void LoadData()
        {
            ListTableIsEmpty = ordersDao.ShowTableIsEmpty();
        }

    }
}

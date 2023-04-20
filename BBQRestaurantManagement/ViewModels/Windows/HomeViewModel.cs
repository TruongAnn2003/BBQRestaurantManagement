using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.ViewModels.Base;
using BBQRestaurantManagement.ViewModels.UserControls;
using BBQRestaurantManagement.Views.UserControls;
using MaterialDesignThemes.Wpf;
using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.Windows
{
    public class HomeViewModel : BaseViewModel
    {
        private LoginUC LoginView = new LoginUC();
        private ReservationUC ReservationView = new ReservationUC();
        private OrderUC OrderView = new OrderUC();
        private HomeViewUC HomeView = new HomeViewUC();
        private HomeViewMenuUC HomeViewMenuView = new HomeViewMenuUC();
        private HomeViewServicesUC HomeViewServicesView = new HomeViewServicesUC();

        private bool statusLoginView = false;
        public bool StatusLoginView { get => statusLoginView; set { statusLoginView = value; OnPropertyChanged(); } }

        private bool statusReservationView = false;
        public bool StatusReservationView { get => statusReservationView; set { statusReservationView = value; OnPropertyChanged(); } }

        private bool statusHomeViewMenuView = false;
        public bool StatusHomeViewMenuView { get => statusHomeViewMenuView; set { statusHomeViewMenuView = value; OnPropertyChanged(); } }

        private bool statusHomeViewServicesView = false;
        public bool StatusHomeViewServicesView { get => statusHomeViewServicesView; set { statusHomeViewServicesView = value; OnPropertyChanged(); } }

        private ContentControl currentChildView = new ContentControl();
        public ContentControl CurrentChildView { get { return currentChildView; } set { currentChildView = value; OnPropertyChanged(); } }

        private Visibility visibilityTabView = Visibility.Visible;
        public Visibility VisibilityTabView { get { return visibilityTabView; } set { visibilityTabView = value; OnPropertyChanged(); } }

        public ICommand ShowLoginView { get; set; }
        public ICommand ShowReservationView { get; set; }
        public ICommand ShowHomeView { get; set; }
        public ICommand ShowHomeViewMenuView { get; set; }
        public ICommand ShowHomeViewServicesView { get; set; }

        public HomeViewModel()
        {
            SetCommand();
            ExecuteShowHomeView(null);
        }

        private void SetCommand()
        {
            ShowLoginView = new RelayCommand<object>(ExecuteShowLoginView);
            ShowReservationView = new RelayCommand<object>(ExecuteShowReservationView);
            ShowHomeView = new RelayCommand<object>(ExecuteShowHomeView);
            ShowHomeViewServicesView = new RelayCommand<object>(ExecuteShowHomeViewServicesView);
            ShowHomeViewMenuView = new RelayCommand<object>(ExecuteShowHomeViewMenuView);
        }

        private void ExecuteShowHomeViewMenuView(object obj)
        {
            CurrentChildView = HomeViewMenuView;
            StatusHomeViewMenuView = true; 
        }

        private void ExecuteShowHomeViewServicesView(object obj)
        {
            CurrentChildView = HomeViewServicesView;
            StatusHomeViewServicesView = true;
        }

        private void ExecuteShowHomeView(object obj)
        {
            VisibilityTabView = Visibility.Visible;
            CurrentChildView = HomeView;
            StatusReservationView = false;
            StatusLoginView = false;     
        }

        private void ExecuteShowReservationView(object obj)
        {
            CurrentChildView = ReservationView;
            StatusReservationView = true;
        }

        private void ShowOrderView(object b)
        {
            CurrentChildView = OrderView;
            VisibilityTabView = Visibility.Collapsed;
        }

        private void ExecuteShowLoginView(object obj)
        {
            CurrentChildView = LoginView;
            ((LoginViewModel)(LoginView.DataContext)).LoginOrderView = new Action<object>(ShowOrderView);
            StatusLoginView = true;
        }
    }
}

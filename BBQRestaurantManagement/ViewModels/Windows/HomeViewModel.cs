using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
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
        private ReservationUC ReservationView = new ReservationUC();
        private HomeViewUC HomeView = new HomeViewUC();
      
        private bool statusLoginView = false;
        public bool StatusLoginView { get => statusLoginView; set { statusLoginView = value; OnPropertyChanged(); } }

        private bool statusReservationView = false;
        public bool StatusReservationView { get => statusReservationView; set { statusReservationView = value; OnPropertyChanged(); } }

        private bool statusHomeViewMenuView = false;
        public bool StatusHomeViewMenuView { get => statusHomeViewMenuView; set { statusHomeViewMenuView = value; OnPropertyChanged(); } }

        private ContentControl currentChildView = new ContentControl();
        public ContentControl CurrentChildView { get { return currentChildView; } set { currentChildView = value; OnPropertyChanged(); } }

        private Visibility visibilityTabView = Visibility.Visible;
        public Visibility VisibilityTabView { get { return visibilityTabView; } set { visibilityTabView = value; OnPropertyChanged(); } }

        public ICommand ShowLoginView { get; set; }
        public ICommand ShowReservationView { get; set; }
        public ICommand ShowHomeView { get; set; }
        public ICommand ShowHomeViewMenuView { get; set; }

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
        }
      
        private void ExecuteShowHomeView(object obj)
        {
            if (CurrentUser.StatusLogin == true)
            {
                AlertDialogService dialog = new AlertDialogService(
                 "Đăng xuất",
                 "Bạn có muốn đăng xuất khỏi tài khoản!",
                 () => {
                     VisibilityTabView = Visibility.Visible;
                     CurrentChildView = HomeView;
                     StatusReservationView = false;
                     StatusLoginView = false;
                     CurrentUser.Ins.Staff = null;
                     CurrentUser.Ins.AccountLogin = new Account(BaseDao.UserName, BaseDao.Passwords);
                     CurrentUser.StatusLogin = false;
                 }, null);
                    dialog.Show();
            }
            else
            {
                VisibilityTabView = Visibility.Visible;
                CurrentChildView = HomeView;
                StatusReservationView = false;
                StatusLoginView = false;
            }
           
        }

        private void ExecuteShowReservationView(object obj)
        {
            CurrentChildView = ReservationView;
            StatusReservationView = true;
        }

        private void ShowOrderView(object b)
        {
            CurrentChildView = new MainUC();
            VisibilityTabView = Visibility.Collapsed;
        }

        private void ExecuteShowLoginView(object obj)
        {
            CurrentChildView = new LoginUC();
            ((LoginViewModel)(CurrentChildView.DataContext)).LoginOrderView = new Action<object>(ShowOrderView);
            StatusLoginView = true;
        }
    }
}

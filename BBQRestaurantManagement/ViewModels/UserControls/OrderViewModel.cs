using BBQRestaurantManagement.ViewModels.Base;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class OrderViewModel : BaseViewModel
    {
        private MenuUC MenuView = new MenuUC();
        private InvoiceUC InvoiceView = new InvoiceUC();
        private TableEmptyUC TableEmptyView = new TableEmptyUC();
        private CheckInOutUC CheckInOutView = new CheckInOutUC();

        private bool statusMenuView = false;
        public bool StatusMenuView { get => statusMenuView; set { statusMenuView = value; OnPropertyChanged(); } }

        private bool statusInvoiceView = false;
        public bool StatusInvoiceView { get => statusInvoiceView; set { statusInvoiceView = value; OnPropertyChanged(); } }

        private bool statusTableEmptyView = false;
        public bool StatusTableEmptyView { get => statusTableEmptyView; set { statusTableEmptyView = value; OnPropertyChanged(); } }

        private bool statusCheckInOutView = false;
        public bool StatusCheckInOutView { get => statusCheckInOutView; set { statusCheckInOutView = value; OnPropertyChanged(); } }


        private ContentControl currentChildView = new ContentControl();
        public ContentControl CurrentChildView { get { return currentChildView; } set { currentChildView = value; OnPropertyChanged(); } }

        public ICommand ShowMenuView { get; set; }
        public ICommand ShowInvoiceView { get; set; }
        public ICommand ShowTableEmptyView { get; set; }
        public ICommand ShowCheckInOutView { get; set; }
        public OrderViewModel()
        {
            SetCommand();
            ExecuteShowMenuView(null);
        }

        private void SetCommand()
        {
            ShowMenuView = new RelayCommand<object>(ExecuteShowMenuView);
            ShowInvoiceView = new RelayCommand<object>(ExecuteShowInvoiceView);
            ShowTableEmptyView = new RelayCommand<object>(ExecuteShowTableEmptyView);
            ShowCheckInOutView = new RelayCommand<object>(ExecuteShowCheckInOutView);
        }
        private void ExecuteShowCheckInOutView(object obj)
        {
            CurrentChildView = CheckInOutView;
            StatusCheckInOutView = true;
        }

        private void ExecuteShowTableEmptyView(object obj)
        {
            CurrentChildView = TableEmptyView;
            StatusTableEmptyView = true;
        }

        private void ExecuteShowInvoiceView(object obj)
        {
            CurrentChildView = InvoiceView;
            StatusInvoiceView = true;
        }

        private void ExecuteShowMenuView(object obj)
        {
            CurrentChildView = MenuView;
            StatusMenuView = true;
        }
    }
}

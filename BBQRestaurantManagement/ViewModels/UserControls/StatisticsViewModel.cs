using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Linq;
using LiveChartsCore;
using LiveChartsCore.Defaults;
using LiveChartsCore.Drawing;
using LiveChartsCore.Measure;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore.SkiaSharpView.Painting;
using SkiaSharp;
using System.Windows.Controls;
using BBQRestaurantManagement.Views.UserControls;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class StatisticsViewModel : BaseViewModel
    {
        private ContentControl currentChildView; 
        public ContentControl CurrentChildView { get => currentChildView; set { currentChildView = value;OnPropertyChanged(); } }

        private bool statusTopSellingProductsView = false;
        public bool StatusTopSellingProductsView { get => statusTopSellingProductsView; set { statusTopSellingProductsView = value; OnPropertyChanged(); } }

        private bool statusCurrentDayRevenueView = false;
        public bool StatusCurrentDayRevenueView { get => statusCurrentDayRevenueView; set { statusCurrentDayRevenueView = value; OnPropertyChanged(); } }

        private bool statusMonthlyRevenueView = false;
        public bool StatusMonthlyRevenueView { get => statusMonthlyRevenueView; set { statusMonthlyRevenueView = value; OnPropertyChanged(); } }

        private bool statusYearlyRevenueView = false;
        public bool StatusYearlyRevenueView { get => statusYearlyRevenueView; set { statusYearlyRevenueView = value; OnPropertyChanged(); } }

        public ICommand ShowTopSellingProductsViewCommand { get; set; }
        public ICommand ShowCurrentDayRevenueViewCommand { get; set; }
        public ICommand ShowMonthlyRevenueViewCommand { get; set; }
        public ICommand ShowYearlyRevenueViewCommand { get; set; }

        public StatisticsViewModel()
        {
            ExecuteShowTopSellingProductsView(null);
            SetCommands();
        }

        private void SetCommands()
        {
            ShowTopSellingProductsViewCommand = new RelayCommand<object>(ExecuteShowTopSellingProductsView);
            ShowCurrentDayRevenueViewCommand = new RelayCommand<object>(ExecuteShowCurrentDayRevenueView);
            ShowMonthlyRevenueViewCommand = new RelayCommand<object>(ExecuteShowMonthlyRevenueView);
            ShowYearlyRevenueViewCommand = new RelayCommand<object>(ExecuteShowYearlyRevenueView);
        }

        private void ExecuteShowYearlyRevenueView(object obj)
        {
            CurrentChildView = new YearlyRevenueUC();
            StatusYearlyRevenueView = true;
        }

        private void ExecuteShowTopSellingProductsView(object obj)
        {
            CurrentChildView = new TopSellingProductsUC();
            StatusTopSellingProductsView = true;
        }

        private void ExecuteShowCurrentDayRevenueView(object obj)
        {
            CurrentChildView = new CurrentDayRevenueUC();
            StatusCurrentDayRevenueView = true;
        }

        private void ExecuteShowMonthlyRevenueView(object obj)
        {
            CurrentChildView = new MonthlyRevenueUC();
            StatusMonthlyRevenueView = true;
        }
    }
}

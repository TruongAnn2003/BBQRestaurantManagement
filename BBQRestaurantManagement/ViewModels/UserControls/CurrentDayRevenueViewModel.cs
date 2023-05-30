using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class CurrentDayRevenueViewModel : BaseViewModel
    {
        private DataTable invoicesHistory;
        public DataTable InvoicesHistory { get => invoicesHistory; set { invoicesHistory = value; OnPropertyChanged(); } }

        private DateTime selectedDay = DateTime.Now;
        public DateTime SelectedDay { get => selectedDay; set {  selectedDay = value; OnPropertyChanged(); LoadData(); } }

        private decimal revenueToDay = 0;
        public decimal RevenueToDay { get => revenueToDay; set { revenueToDay = value; OnPropertyChanged(); } }    

        private StatisticsDao statisticsDao = new StatisticsDao();  

        public CurrentDayRevenueViewModel ()
        {
            LoadData();
        }

        public void LoadData()
        {
            InvoicesHistory = statisticsDao.GetInvoiceHistory(SelectedDay);
            RevenueToDay = statisticsDao.GetRevenueByDay(SelectedDay);
        }
    }
}

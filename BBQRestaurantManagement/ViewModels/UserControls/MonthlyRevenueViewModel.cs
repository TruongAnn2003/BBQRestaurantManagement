using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using LiveChartsCore.Defaults;
using LiveChartsCore.Measure;
using LiveChartsCore.SkiaSharpView.Painting;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore;
using SkiaSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using BBQRestaurantManagement.Database;
using System.Windows;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class MonthlyRevenueViewModel : BaseViewModel
    {
        private List<StatisticalUnit> initialData;
        public List<StatisticalUnit> InitialData { get => initialData; set { initialData = value; OnPropertyChanged(); } }

        private List<ISeries> series;
        public List<ISeries> Series { get => series; set { series = value; OnPropertyChanged(); } }

        private int monthValue;
        public int MonthValue { get => monthValue; set { monthValue = value; OnPropertyChanged(); } } 

        public List<int> MonthList { get;set; } = new List<int>() {1,2,3,4,5,6,7,8,9,10,11,12};

        private Axis[] xAxes;
        public Axis[] XAxes { get => xAxes; set { xAxes = value; OnPropertyChanged(); } }

        private Axis[] yAxes;
        public Axis[] YAxes { get => yAxes; set { yAxes = value; OnPropertyChanged(); } }

        private StatisticsDao statisticsDao = new StatisticsDao();

        public ICommand ShowViewByMonth { get; set; }
        public ICommand ShowViewByCurrentMonth { get; set; }

        public MonthlyRevenueViewModel()
        {
            MonthValue = DateTime.Now.Month;
            ShowViewByCurrentMonth = new RelayCommand<object>(ExecuteShowViewByCurrentMonth);
            ShowViewByMonth = new RelayCommand<int>(ExecuteShowViewByMonth);
            ExecuteShowViewByCurrentMonth(null);
        }

        private void ExecuteShowViewByMonth(int month)
        {
            InitialData = statisticsDao.GetDataMonthlyRevenue(month);
            DrawChart();
        }

        private void ExecuteShowViewByCurrentMonth(object obj)
        {
            InitialData = statisticsDao.GetDataMonthlyRevenue();
            DrawChart();
        }

        public void DrawChart()
        {
            Series = new List<ISeries>()
            {
                new ColumnSeries<ObservableValue>()
                {
                    Values = InitialData.Select(p=> new ObservableValue(Convert.ToInt32( p.ValueIns))).ToList(),
                    Stroke = null,
                },
                new LineSeries<ObservableValue>()
               {
                   Values =InitialData.Select(p=> new ObservableValue(Convert.ToInt32( p.ValueIns))).ToList(),
                   Fill= null,
               }
            };

            XAxes = new Axis[]
                   {
                        new Axis
                        {
                            Name = "Ngày",
                            Labels =InitialData.Select(p=> p.Title).ToList(),
                            LabelsRotation = 15,
                        }
                   };

            YAxes = new Axis[]
                    {
                        new Axis
                        {
                            Name = "Doanh Thu",
                            NamePadding = new LiveChartsCore.Drawing.Padding(0, 15),

                            LabelsPaint = new SolidColorPaint
                            {
                                Color = SKColors.Gray,
                                FontFamily = "Times New Roman",
                                SKFontStyle = new SKFontStyle(SKFontStyleWeight.ExtraBold, SKFontStyleWidth.Normal, SKFontStyleSlant.Italic)
                            },
                            Labeler = Labelers.Currency
                        }
                    };
        }
    }
}

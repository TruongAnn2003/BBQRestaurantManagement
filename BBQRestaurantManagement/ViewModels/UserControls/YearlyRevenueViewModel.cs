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
using BBQRestaurantManagement.Database;
using System.Windows.Input;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class YearlyRevenueViewModel : BaseViewModel
    {
        private List<StatisticalUnit> initialData;
        public List<StatisticalUnit> InitialData { get => initialData; set { initialData = value; OnPropertyChanged(); } }

        private List<ISeries> series;
        public List<ISeries> Series { get => series; set { series = value; OnPropertyChanged(); } }

        private int yearValue;
        public int YearValue { get => yearValue; set { yearValue = value; OnPropertyChanged(); } }

        public List<int> YearList { get; set; } = new List<int>() {2021, 2022, 2023};

        private Axis[] xAxes;
        public Axis[] XAxes { get => xAxes; set { xAxes = value; OnPropertyChanged(); } }

        private Axis[] yAxes;
        public Axis[] YAxes { get => yAxes; set { yAxes = value; OnPropertyChanged(); } }

        private StatisticsDao statisticsDao = new StatisticsDao();

        public ICommand ShowViewByYear { get; set; }
        public ICommand ShowViewByCurrentYear { get; set; }

        public YearlyRevenueViewModel()
        {
            YearValue = DateTime.Now.Year;
            ShowViewByCurrentYear = new RelayCommand<object>(ExecuteShowViewByCurrentYear);
            ShowViewByYear = new RelayCommand<int>(ExecuteShowViewByYear);
            ExecuteShowViewByCurrentYear(null);
        }

        private void ExecuteShowViewByYear(int month)
        {
            InitialData = statisticsDao.GetDataYearlyRevenue(month);
            DrawChart();
        }

        private void ExecuteShowViewByCurrentYear(object obj)
        {
            InitialData = statisticsDao.GetDataYearlyRevenue();
            DrawChart();
        }

        public void DrawChart()
        {
            Series = new List<ISeries>()
            {
                new ColumnSeries<ObservableValue>()
                {
                    Values = initialData.Select(p=> new ObservableValue(Convert.ToInt32( p.ValueIns))).ToList(),
                    Stroke = null,
                    DataLabelsPaint = new SolidColorPaint(new SKColor(245, 245, 245))
                    {
                        Color = new SKColor(255, 0, 0)
                    },
                    DataLabelsPosition = DataLabelsPosition.Top,
                    DataLabelsFormatter = point => $"{point.PrimaryValue.ToString("##,#")}$"
                },
                new LineSeries<ObservableValue>()
               {
                   Values =initialData.Select(p=> new ObservableValue(Convert.ToInt32( p.ValueIns))).ToList(),
                   Fill= null,
               }
            };

            XAxes = new Axis[]
                   {
                        new Axis
                        {
                            Name = "Tháng",
                            Labels =initialData.Select(p=> Convert.ToString( p.Title)).ToList(),
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

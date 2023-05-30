using BBQRestaurantManagement.ViewModels.Base;
using LiveChartsCore.Defaults;
using LiveChartsCore.Drawing;
using LiveChartsCore.Measure;
using LiveChartsCore.SkiaSharpView.Painting;
using LiveChartsCore.SkiaSharpView;
using LiveChartsCore;
using SkiaSharp;
using System;
using System.Collections.Generic;
using System.Linq;
using BBQRestaurantManagement.Models;
using System.Windows.Input;


namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class TopSellingProductsViewModel : BaseViewModel
    {
        private List<StatisticalUnit> initialData;

        private ISeries[] series;
        public ISeries[] Series { get => series; set { series = value; OnPropertyChanged(); } }

        private Axis[] xAxes = { new Axis { SeparatorsPaint = new SolidColorPaint(new SKColor(220, 220, 220)) } };
        public Axis[] XAxes { get => xAxes; set { xAxes = value; OnPropertyChanged(); } }

        private Axis[] yAxes = { new Axis { IsVisible = false } };
        public Axis[] YAxes { get => yAxes; set { yAxes = value; OnPropertyChanged(); } }

        public ICommand ShowTopSellingFoodsCommand { get; set; }
        public ICommand ShowTopSellingDrinksCommand { get; set; }

        public TopSellingProductsViewModel()
        {
            SetCommands();
            ExecuteShowTopSellingFoodsCommand(null);
            DrawChart();
        }
        private void SetCommands()
        {
            ShowTopSellingFoodsCommand = new RelayCommand<object>(ExecuteShowTopSellingFoodsCommand);
            ShowTopSellingDrinksCommand = new RelayCommand<object>(ExecuteShowTopSellingDrinksCommand);
        }

        private void ExecuteShowTopSellingDrinksCommand(object obj)
        {
            initialData = new List<StatisticalUnit> { new StatisticalUnit("trà sữa", 125), new StatisticalUnit("Bia", 263) };
            Series = new ISeries[] { };
            DrawChart();
        }

        private void ExecuteShowTopSellingFoodsCommand(object obj)
        {
            initialData = new List<StatisticalUnit> { new StatisticalUnit("Bò nướng", 25), new StatisticalUnit("Lẩu", 49) };
            Series = new ISeries[] { };
            DrawChart();
        }

        private void DrawChart()
        {
            Series = initialData
                .Select(x => new RowSeries<ObservableValue>
                {
                    Values = new[] { new ObservableValue(Convert.ToInt32(x.ValueIns)) },
                    Name = x.Title,
                    Stroke = null,
                    MaxBarWidth = 25,
                    DataLabelsPaint = new SolidColorPaint(new SKColor(245, 245, 245)),
                    DataLabelsPosition = DataLabelsPosition.End,
                    DataLabelsTranslate = new LvcPoint(-1, 0),
                    DataLabelsFormatter = point => $"{point.Context.Series.Name} {point.PrimaryValue}"
                })
                .OrderByDescending(x => ((ObservableValue[])x.Values!)[0].Value)
                .ToArray();
        }
    }
}

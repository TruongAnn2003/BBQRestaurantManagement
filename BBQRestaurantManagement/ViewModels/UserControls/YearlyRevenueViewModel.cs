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

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class YearlyRevenueViewModel : BaseViewModel
    {
        private List<StatisticalUnit> initialData;
        public List<StatisticalUnit> InitialData { get => initialData; private set => initialData = value; }

        private List<ISeries> series;
        public List<ISeries> Series { get => series; private set => series = value; }

        public Axis[] XAxes { get; set; }
        public Axis[] YAxes { get; set; }

        public YearlyRevenueViewModel()
        {
            LoadData();
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
                    DataLabelsFormatter = point => $"{point.PrimaryValue}$"
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
                            Name = "Thời Gian",
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

        private void LoadData()
        {
            initialData = new List<StatisticalUnit> { new StatisticalUnit("23/11/2023", 359), new StatisticalUnit("22/11/2023", 256), new StatisticalUnit("21/11/2023", 562) };
        }
    }
}

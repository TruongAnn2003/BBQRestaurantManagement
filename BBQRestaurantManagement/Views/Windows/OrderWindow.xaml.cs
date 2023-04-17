using System.Windows;
using BBQRestaurantManagement.ViewModels.Windows;
namespace BBQRestaurantManagement.Views.Windows
{
    /// <summary>
    /// Interaction logic for OrderWindow.xaml
    /// </summary>
    public partial class OrderWindow : Window
    {
        public OrderWindow()
        {
            InitializeComponent();
            DataContext = new OrderViewModel();
        }
    }
}

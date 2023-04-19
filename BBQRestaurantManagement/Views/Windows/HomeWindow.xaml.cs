using BBQRestaurantManagement.ViewModels.Windows;
using System.Windows;

namespace BBQRestaurantManagement.Views.Windows
{
    /// <summary>
    /// Interaction logic for HomeWindow.xaml
    /// </summary>
    public partial class HomeWindow : Window
    {
        public HomeWindow()
        {
            InitializeComponent();
            DataContext = new HomeViewModel();
        }
    }
}

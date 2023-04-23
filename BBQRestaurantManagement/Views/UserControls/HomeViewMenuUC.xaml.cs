using BBQRestaurantManagement.ViewModels.UserControls;
using System.Windows.Controls;

namespace BBQRestaurantManagement.Views.UserControls
{
    /// <summary>
    /// Interaction logic for HomeViewMenuUC.xaml
    /// </summary>
    public partial class HomeViewMenuUC : UserControl
    {
        public HomeViewMenuUC()
        {
            InitializeComponent();
            DataContext = new HomeViewMenuViewModel();
        }
    }
}

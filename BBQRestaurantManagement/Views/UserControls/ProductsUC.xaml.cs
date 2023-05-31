using BBQRestaurantManagement.ViewModels.UserControls;
using System.Windows.Controls;

namespace BBQRestaurantManagement.Views.UserControls
{
    /// <summary>
    /// Interaction logic for ProductsUC.xaml
    /// </summary>
    public partial class ProductsUC : UserControl
    {
        public ProductsUC()
        {
            InitializeComponent();
            DataContext = new ProductViewModel();
        }
    }
}

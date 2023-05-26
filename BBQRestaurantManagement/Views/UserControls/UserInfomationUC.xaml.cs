using BBQRestaurantManagement.ViewModels.UserControls;
using System.Windows.Controls;

namespace BBQRestaurantManagement.Views.UserControls
{
    /// <summary>
    /// Interaction logic for UserInfomationUC.xaml
    /// </summary>
    public partial class UserInfomationUC : UserControl
    {
        public UserInfomationUC()
        {
            InitializeComponent();
            DataContext = new UserInfomationViewModel();
        }
    }
}

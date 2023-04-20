using BBQRestaurantManagement.ViewModels.Dialogs;
using System.Windows;

namespace BBQRestaurantManagement.Views.Dialogs
{
    /// <summary>
    /// Interaction logic for AlertDialog.xaml
    /// </summary>
    public partial class AlertDialog : Window
    {
        public AlertDialogViewModel ViewModel { get; }

        public AlertDialog()
        {
            InitializeComponent();
            ViewModel = new AlertDialogViewModel();
            DataContext = ViewModel;
        }
    }
}

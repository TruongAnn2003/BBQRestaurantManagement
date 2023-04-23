using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class HomeViewMenuViewModel : BaseViewModel
    {
        private List<String> menu;
        public List<String> Menu { get { return menu; }  set { menu = value; OnPropertyChanged(); } }
        public HomeViewMenuViewModel() 
        {
            menu = new List<string>() { "Thịt lợn hầm (20)" , "THỊT GÀ HẦM (25)", "ỨC BÒ THÁI (30)" , "THỊT GÀ XÔNG KHÓI (23)" , "SƯỜN NƯỚNG (20)", "THỊT BÒ NƯỚNG TẢNG (25)", "HẢI SẢN NƯỚNG (30)", "SƯỜN HEO NƯỚNG (23)" };
        }
    }
}

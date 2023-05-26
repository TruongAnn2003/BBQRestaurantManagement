using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.ViewModels.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.ViewModels.UserControls
{
    public class UserInfomationViewModel : BaseViewModel
    {
        public string AvatarUserSource { get; set; }

        private Staff userIns = new Staff();
        public Staff UserIns { get => userIns; set => userIns = value;}

        public string ID { get => UserIns.ID; set { UserIns.ID = value; OnPropertyChanged(); } }
        public string Name { get => UserIns.Name; set { UserIns.Name = value; OnPropertyChanged(); } }
        public string NumberPhone  { get => UserIns.NumberPhone; set { UserIns.NumberPhone = value; OnPropertyChanged(); } }

        private string position = "";
        public string Position { get => position; set { position = value; OnPropertyChanged(); } }

        private string descriptionPermissions = "";
        public string DescriptionPermissions { get => descriptionPermissions; set { descriptionPermissions = value; OnPropertyChanged(); } }

        public UserInfomationViewModel()
        {
            UserIns = CurrentUser.Ins.Staff;
            if (UserIns.Position == BaseDao.Manager)
            {
                Position = "Manager";
                AvatarUserSource = "/Pictures/Manager.png";
                DescriptionPermissions = "#Mô tả các quyền của Quản Lý\n- quyền  1 \n- quyền 2";
            }
            else if(UserIns.Position == BaseDao.Cashier)
            {
                Position = "Cashier";
                AvatarUserSource = "/Pictures/Cashier.png";
                DescriptionPermissions = "Mô tả các quyền của Thu Ngân\n quyền  1 \n quyền 2";
            }    
        }

    }
}

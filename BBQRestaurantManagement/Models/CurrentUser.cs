using BBQRestaurantManagement.Database.Base;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class CurrentUser
    {
        private static CurrentUser instance;

        private Staff staff;
        public Staff Staff { get => staff; set => staff = value; }

        private Account accountLogin;
        public Account AccountLogin { get => accountLogin; set => accountLogin = value; }

        public static bool StatusLogin { get; set; } = false;

        public static CurrentUser Ins
        {
            get
            {
                if (instance == null)
                {
                    instance = new CurrentUser();
                }
                return instance;
            }
        }

        private CurrentUser()
        {
            staff = new Staff();
            accountLogin = new Account(BaseDao.UserName, BaseDao.Passwords);
        }

        private void Logout()
        {
            staff = new Staff();
        }
    }
}

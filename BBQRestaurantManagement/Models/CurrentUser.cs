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
        }

        private void Logout()
        {
            staff = new Staff();
        }
    }
}

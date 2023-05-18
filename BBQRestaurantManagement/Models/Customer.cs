﻿using BBQRestaurantManagement.Database;
using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.RightsManagement;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace BBQRestaurantManagement.Models
{
    public class Customer
    {
        private string id;
        private string name;
        private string phoneNumber;

        public string ID
        {
            get { return id; }
            set { id = value; }
        }

        public string Name
        {
            get { return name; }
            set { name = value; }
        }

        public string PhoneNumber
        {
            get { return phoneNumber; }
            set { phoneNumber = value; }
        }

        public Customer() { }

        public Customer(string id, string name, string phone)
        {
            this.id = id;
            this.name = name;
            this.phoneNumber = phone;
        }

        public Customer(SqlDataReader reader)
        {
            try
            {
                this.id = (string)reader[BaseDao.CUSTOMERS_ID];
                this.name = (string)reader[BaseDao.CUSTOMERS_NAME];
                this.phoneNumber = (string)reader[BaseDao.CUSTOMERS_PHONE];
            }
            catch(Exception ex)
            {
                Log.Instance.Error(nameof(Customer), "CAST ERROR: " + ex.Message);
            }
        }
    }
}

using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class StoredProceduresDao : BaseDao
    {
        public StoredProceduresDao() { }
        public void AddOrderProduct (string orderID, string productID, int quantity)
        {
            dbConnection.ExecuteNonQuery($"Exec proc_AddOrderProduct '{orderID}','{productID}','{quantity}'");
        }
    }
}

using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class BookingDao : BaseDao
    {
        public void CreateBooking(DateTime bookingdate,int duration,string notes,int numerofPeople,string nameCustomer,string numberPhone,string tableID)
        {
            dbConnection.ExecuteNonQuery($"exec proc_CreateBooking '{bookingdate}', {duration}, '{notes}', {numerofPeople},  N'{nameCustomer}', '{numberPhone}','{tableID}'");
        }
    }
}

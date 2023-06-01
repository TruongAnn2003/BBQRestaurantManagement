using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using System;
using System.Collections.Generic;
using System.Data;
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

        public DataTable GetAllCustomerBookingView()
        {
            string sqlStr = $"select * from CustomerBookingView ";
            return dbConnection.GetList(sqlStr);
        }

        public DataTable SearchCustomerBookingView(string numberPhone)
        {
            string sqlStr = $"exec proc_SearchCustomerBooking '{numberPhone}'";
            return dbConnection.GetList(sqlStr);
        }

        public void BookingApproval(string bookingid)
        {
            dbConnection.ExecuteNonQuery($"exec proc_BookingApproval '{bookingid}'");
        }

        public void BookingCancel(string bookingid)
        {
            dbConnection.ExecuteNonQuery($"exec proc_BookingCancel '{bookingid}'");
        }

        public void BookingComplete(string bookingid)
        {
            dbConnection.ExecuteNonQuery($"exec proc_BookingComplete '{bookingid}'");
        }

    }
}

using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class StatisticsDao : BaseDao
    {
        public List<StatisticalUnit> GetDataTopSellingFoods()
        {
            string sqlStr = $"SELECT * FROM dbo.func_ListTop10Food()";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public List<StatisticalUnit> GetDataTopSellingDrinks()
        {
            string sqlStr = $"Select * from func_ListTop10Drink()";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public List<StatisticalUnit> GetDataMonthlyRevenue(int month)
        {
            string sqlStr = $"Select * from func_ListStatisticsMonth({month})";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public List<StatisticalUnit> GetDataMonthlyRevenue()
        {
            string sqlStr = $"Select * from func_ListStatisticsMonth(null)";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public List<StatisticalUnit> GetDataYearlyRevenue(int year)
        {
            string sqlStr = $"Select * from func_ListStatisticsYear({year})";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public List<StatisticalUnit> GetDataYearlyRevenue()
        {
            string sqlStr = $"Select * from func_ListStatisticsYear(null)";
            return dbConnection.GetList(sqlStr, reader => new StatisticalUnit(reader));
        }

        public decimal GetRevenueByDay(DateTime date)
        {
            var result = dbConnection.GetSingleValueFromFunction($"Select dbo.func_GetRevenueDay('{date}')", null);
            return result == DBNull.Value ? 0 : Convert.ToDecimal(result);
        }
        public DataTable GetInvoiceHistory(DateTime date)
            {
                string sqlStr = $"Select * from func_InvoiceHistory('{date}')";
                return dbConnection.GetList(sqlStr);
            }
    }
}

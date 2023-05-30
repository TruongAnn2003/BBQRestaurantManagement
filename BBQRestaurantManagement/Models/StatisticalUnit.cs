using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Utilities;
using BBQRestaurantManagement.Views.UserControls;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Models
{
    public class StatisticalUnit
    {
        private string title;
        public string Title { get => title; set => title = value; }

        private decimal valueIns;
        public decimal ValueIns { get => valueIns; set => valueIns = value ; }

        public StatisticalUnit() { }

        public StatisticalUnit(string title, decimal valueIns)
        {
            this.title = title;
            this.valueIns = valueIns;
        }

        public StatisticalUnit(SqlDataReader reader)
        {
            try
            {
                title = (string)reader[BaseDao.TITLE_STATISTICAL_UNIT];          
                valueIns = Convert.ToDecimal(reader[BaseDao.VALUE_STATISTICAL_UNIT]);             
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(StatisticalUnit), "CAST ERROR: " + ex.Message);
            }
        }

    }
}

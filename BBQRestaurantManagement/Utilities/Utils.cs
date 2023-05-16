using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Utilities
{
    public class Utils
    {
        public static readonly DateTime emptyDate = new DateTime(2000, 1, 1, 7, 0, 0);
        private const string formatDateTime = "yyyy-MM-dd hh:mm:ss";

        public static string ToSQLFormat(DateTime dt)
        {
            return dt.ToString(formatDateTime);
        }

        public static int GetInt(IDataRecord record, string colName)
        {
            return GetValueOrDefault(record, colName, 0);
        }

        public static string GetString(IDataRecord record, string colName)
        {
            return GetValueOrDefault(record, colName, string.Empty);
        }

        public static DateTime GetDateTime(IDataRecord record, string colName)
        {
            return GetValueOrDefault(record, colName, emptyDate);
        }

        public static decimal GetDecimal(IDataRecord record, string colName)
        {
            return GetValueOrDefault(record, colName, (decimal)0);
        }

        private static T GetValueOrDefault<T>(IDataRecord record, string colName, T defaultVal)
        {
            return record[colName] == DBNull.Value ? defaultVal : (T)record[colName];
        }
    }
}

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BBQRestaurantManagement.Utilities;

namespace BBQRestaurantManagement.Database
{
    public class DBConnection
    {
        private SqlConnection conn;

        public DBConnection()
        {
            conn = new SqlConnection(Properties.Settings.Default.connStr);
        }

        public void ExecuteNonQuery(string command)
        {
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(command, conn);
                if (cmd.ExecuteNonQuery() > 0)
                {
                    Log.Instance.Information(nameof(DBConnection), "Completed");
                }
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(DBConnection), ex.Message);
            }
            finally
            {
                conn.Close();
            }
        }

        public object GetSingleObject<T>(string sqlStr, Func<SqlDataReader, T> converter)
        {
            List<T> list = GetList(sqlStr, converter);
            if(list.Count!=0)
                return list[0];
            else
            {
                Log.Instance.Information(nameof(DBConnection), "Not found account from database");
                return null;
            }    
           
        }

        public List<T> GetList<T>(string sqlStr, Func<SqlDataReader, T> converter)
        {
            List<T> list = new List<T>();
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sqlStr, conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                    list.Add(converter(reader));
                cmd.Dispose();
                reader.Close();
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(DBConnection), ex.Message);
            }
            finally
            {
                conn.Close();
            }
            return list;
        }
    }
}

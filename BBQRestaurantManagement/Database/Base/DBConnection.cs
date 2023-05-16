using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using BBQRestaurantManagement.Utilities;

namespace BBQRestaurantManagement.Database.Base
{
    public class DBConnection
    {
        private SqlConnection conn;

        public DBConnection()
        {
            string strConnection = "Data Source=LAPTOP-BOP0FMBM;Initial Catalog=BBQRestaurantManagement;Persist Security Info=True;User ID=sa;Password=123456";
            conn = new SqlConnection(strConnection);
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


        public object GetSingleValueFromFunction(string sqlStr, params SqlParameter[] param)
        {
            try
            {
                conn.Open();
                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = sqlStr;
                if (param != null)
                    foreach (SqlParameter p in param)
                    {
                        cmd.Parameters.Add(p);
                    }
                return cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(DBConnection), ex.Message);
            }
            finally
            {
                conn.Close();
            }
            return 0;
        }
    }

}

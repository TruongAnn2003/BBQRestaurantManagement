using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Windows;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Services;
using BBQRestaurantManagement.Utilities;

namespace BBQRestaurantManagement.Database.Base
{
    public class DBConnection
    {
        private SqlConnection conn;
       
        public DBConnection()
        {    
            string strConnection = $"Data Source=LAPTOP-BOP0FMBM;Initial Catalog=BBQRestaurantManagement;Persist Security Info=True;User ID={CurrentUser.Ins.AccountLogin.ID};Password={CurrentUser.Ins.AccountLogin.Password}";
            conn = new SqlConnection(strConnection);
        }
        
        public void ExecuteNonQuery(string command)
        {
            Log.Instance.Information(nameof(DbConnection), "ExecuteNonQuery Command: " + command);
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
                AlertDialogService dialog = new AlertDialogService(
                  $"Error from {nameof(DBConnection)}",
                  ex.Message,
                 () => { }, null);
                dialog.Show();
            }
            finally
            {
                conn.Close();
            }
        }

        public object GetSingleObject<T>(string sqlStr, Func<SqlDataReader, T> converter)
        {
            Log.Instance.Information(nameof(DbConnection), "GetSingleObject Command: " + sqlStr);
            List<T> list = GetList(sqlStr, converter);
            if(list.Count!=0)
                return list[0];
            else
            {
                Log.Instance.Information(nameof(DBConnection), "not founded object");
                return null;
            }    
           
        }

        public List<T> GetList<T>(string sqlStr, Func<SqlDataReader, T> converter)
        {
            Log.Instance.Information(nameof(DbConnection), "GetList Command: " + sqlStr);
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
                AlertDialogService dialog = new AlertDialogService(
                 $"Error from {nameof(DBConnection)}",
                 ex.Message,
                () => { }, null);
                dialog.Show();
            }
            finally
            {
                conn.Close();
            }
            return list;
        }

        public DataTable GetList(string sqlStr)
        {
            Log.Instance.Information(nameof(DbConnection), "GetList Command: " + sqlStr);
            DataTable dataTable = new DataTable();
            try
            {
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(sqlStr, conn);
                adapter.Fill(dataTable);
            }
            catch (Exception ex)
            {
                Log.Instance.Error(nameof(DBConnection), ex.Message);
                AlertDialogService dialog = new AlertDialogService(
                 $"Error from {nameof(DBConnection)}",
                 ex.Message,
                () => { }, null);
                dialog.Show();
            }
            finally
            {
                conn.Close();
            }
            return dataTable;
        }


        public object GetSingleValueFromFunction(string sqlStr, params SqlParameter[] param)
        {
            Log.Instance.Information(nameof(DbConnection), "GetSingleValueFromFunction Command: " + sqlStr);
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
                Log.Instance.Error(nameof(DBConnection),ex.Message);
                AlertDialogService dialog = new AlertDialogService(
                 $"Error from {nameof(DBConnection)}",
                 ex.Message,
                () => { }, null);
                dialog.Show();
            }
            finally
            {
                conn.Close();
            }
            return 0;
        }
    }

}

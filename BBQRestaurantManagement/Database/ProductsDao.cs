using BBQRestaurantManagement.Database.Base;
using BBQRestaurantManagement.Models;
using BBQRestaurantManagement.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BBQRestaurantManagement.Database
{
    public class ProductsDao : BaseDao
    {
        #region Add, Update, Delete
        //code Add, Update, Delete trong đây
        public void Add(Product product)
        {
            string sqlStr = $"INSERT INTO {PRODUCT_TABLE} ({PRODUCT_ID}, {PRODUCT_NAME}, {PRODUCT_PRICE}, {PRODUCT_DESCRIPTION}, {PRODUCT_STATE}, {PRODUCT_TYPE})" +
                            $"VALUES ({product.ID}, {product.Name}, {product.Price}, {product.Description}, {product.State}, {product.TypeID})";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Delete(string productID)
        {
            string sqlStr = $"DELETE FROM {PRODUCT_TABLE} WHERE {PRODUCT_ID}='{productID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Update(Product product)
        {
            string sqlStr = $"UPDATE {PRODUCT_TABLE} SET " +
                            $"{PRODUCT_NAME}='{product.Name}', {PRODUCT_PRICE} = '{product.Price}', {PRODUCT_DESCRIPTION} = '{product.Description}', {PRODUCT_STATE} = '{product.State}', {PRODUCT_TYPE} = '{product.TypeID}' WHERE {PRODUCT_ID} = '{product.ID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }
        #endregion
        #region Search
        public Product SearchByProductID(string productID)
        {
            string sqlStr = $"SELECT * FROM {PRODUCT_TABLE} WHERE {PRODUCT_ID}='{productID}'";
            return (Product)dbConnection.GetSingleObject(sqlStr, reader => new Product(reader));
        }
        #endregion
        #region Stored Procedures
        //code Stored Procedures trong đây
        public void SP_Product_Add(Product prod)
        {
            string sqlStr = $"exec SP_Product_Add '{prod.ID}', '{prod.Name}', '{prod.Price}', '{prod.Description}', '{prod.State}', '{prod.TypeID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void SP_Product_Delete(string id)
        {
            string sqlStr = $"exec SP_Product_Delete '{id}'";
        }

        public void SP_Product_Update(Product prod)
        {
            string sqlStr = $"exec SP_Product_Update '{prod.ID}', '{prod.Name}', '{prod.Price}', '{prod.Description}', '{prod.State}', '{prod.TypeID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public Product SP_Product_Search(string id)
        {
            string sqlStr = $"exec SP_Product_Search '{id}'";
            return (Product)dbConnection.GetSingleObject(sqlStr, reader => new Product(reader));
        }
        #endregion
        #region Functions
        //code Functions trong đây
        #endregion
        #region Views

        public List<Product> GetFoodsView()
        {
            string sqlStr = $"SELECT * FROM {FOODS_VIEW}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        public List<Product> GetDrinksView()
        {
            string sqlStr = $"SELECT * FROM {DRINKS_VIEW}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        #endregion
    }
}

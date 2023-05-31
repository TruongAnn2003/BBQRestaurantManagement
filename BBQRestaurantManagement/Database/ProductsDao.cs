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
            string sqlStr = $"exec proc_Product_Add '{product.ID}', '{product.Name}', {product.Price}, '{product.Description}', {product.State}, '{product.TypeID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Delete(string productID)
        {
            string sqlStr = $"exec proc_Product_Delete '{productID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }

        public void Update(Product product)
        {
            string sqlStr = $"exec proc_Product_Update '{product.ID}', '{product.Name}', {product.Price}, '{product.Description}', {product.State}, '{product.TypeID}'";
            dbConnection.ExecuteNonQuery(sqlStr);
        }
        #endregion
        #region Search
        public Product SearchByProductID(string productID)
        {
            string sqlStr = $"SELECT * FROM {PRODUCT_TABLE} WHERE {PRODUCT_ID}='{productID}'";
            return (Product)dbConnection.GetSingleObject(sqlStr, reader => new Product(reader));
        }

        public List<Product> GetAll()
        {
            string sqlStr = $"Select * from {PRODUCT_TABLE}";
            return dbConnection.GetList(sqlStr, reader => new Product(reader));
        }

        public List<ProductType> GetAllType()
        {
            string sqlStr = $"Select * from {PRODUCT_TYPE_TABLE}";
            return dbConnection.GetList(sqlStr, reader => new ProductType(reader));
        }

        public ProductType GetTypeProduct(string id)
        {
            string sqlStr = $"Select * from {PRODUCT_TYPE_TABLE} where {PRODUCT_TYPE_ID} = '{id}'";
            return (ProductType)dbConnection.GetSingleObject(sqlStr, reader => new ProductType(reader));
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

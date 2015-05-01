package com.am.model.dao;

import java.util.List;
import java.util.Map;

import com.am.model.bean.CategoryBean;
import com.am.model.bean.ProductBean;
import com.am.model.bean.ProductsBean;
import com.am.model.bean.TransactionBean;

public interface ProductDAO {
	public void getProductBalance(ProductBean product);
	public boolean addProduct(ProductBean product);
	public void getProductTransactions(ProductBean product,List<TransactionBean> transactions,Map<String,String> dates);
	public double getProductsDetails(int userid,List<ProductBean> products, int category);
	public void getProductDetails(ProductBean product);
	public boolean updateProduct(ProductBean product);
	public boolean deleteProduct(ProductBean product);
	public double getCategoryDetails(int userid, List<CategoryBean> categories);
	public boolean deleteCategory(CategoryBean category);
	public boolean updateCategory(CategoryBean category);
	public boolean addCategory(CategoryBean category);
	public boolean updateProductPrice(ProductsBean products);
}

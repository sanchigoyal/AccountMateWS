package com.am.model.bean;

import java.util.List;

import com.am.model.bean.ProductBean;

public class ProductsBean {

	private List<ProductBean> products;
	private int userID;
	private int productsCategory;
	

	public int getProductsCategory() {
		return productsCategory;
	}

	public void setProductsCategory(int productsCategory) {
		this.productsCategory = productsCategory;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public List<ProductBean> getProducts() {
		return products;
	}

	public void setProducts(List<ProductBean> products) {
		this.products = products;
	}
	
	
}

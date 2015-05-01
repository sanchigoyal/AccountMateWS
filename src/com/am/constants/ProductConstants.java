package com.am.constants;

public class ProductConstants {
	/*-----General Constants ----*/
	public static String PREVIOUS_BALANCE = "Previous Balance";
	/*-----Table Columns -------*/
	public static final String INVALUE = "IN_VALUE";
	public static final String OUTVALUE = "OUT_VALUE";
	public static final String PRODUCT_ID = "PRODUCT_ID";
	public static final String PRODUCT_NAME = "PRODUCT_NAME";
	public static final String START_DATE = "startdate";
	public static final String END_DATE = "enddate";
	public static final String STOCKID = "STOCK_ID";
	public static final String DETAIL = "DETAIL";
	public static final String TRANSACTION_TYPE_ID = "TRANSACTION_TYPE_ID";
	public static final String TRANSACTION_DATE = "TRANSACTION_DATE";
	public static final String INVOICE_ID = "INVOICE_ID";
	public static final String INVOICE_NUMBER = "INVOICE_NUMBER";
	public static final String PRODUCT_CATEGORY = "PRODUCT_CATEGORY";
	public static final String COST_PRICE = "COST_PRICE";
	public static final String DEALER_PRICE = "DEALER_PRICE";
	public static final String MARKET_PRICE = "MARKET_PRICE";
	public static final String OPENING_BALANCE = "OPENING_BALANCE";
	
	public static final String CATEGORY_ID = "CATEGORY_ID";
	public static final String CATEGORY = "CATEGORY";
	public static final String NO_OF_PRODUCTS = "NO_OF_PRODUCTS";
	public static final String STOCK_VALUE = "STOCK_VALUE";
	
	/*---- Stored Procedures -----*/
	public static final String GET_PRODUCT_BALANCE = "{call getProductBalance(?,?)}";
	public static final String ADD_PRODUCT = "{call AddNewProduct(?,?,?,?,?,?,?)}";
	public static final String ADD_CATEGORY = "{call AddNewCategory(?,?)}";
	public static final String GET_PRODUCT_NAME = "{call getProductName(?,?)}";
	public static final String GET_PRODUCT_TRANSACTION = "{call getProductTransactions(?,?,?,?)}";
	public static final String GET_PRODUCTS_DETAILS = "{call getProductsDetails(?,?)}";
	public static final String GET_PRODUCT_DETAILS = "{call getProductDetails(?,?)}";
	public static final String UPDATE_PRODUCT = "{call updateProduct(?,?,?,?,?,?,?,?)}";
	public static final String UPDATE_PRODUCT_PRICE = "{call updateProductPrice(?,?,?,?)}";
	public static final String UPDATE_CATEGORY = "{call updateCategory(?,?,?)}";
	public static final String DELETE_PRODUCT = "{call deleteProduct(?,?)}";
	public static final String DELETE_CATEGORY = "{call deleteCategory(?,?)}";
	public static final String GET_CATEGORY_DETAILS = "{call getCategoryDetails(?)}";
}

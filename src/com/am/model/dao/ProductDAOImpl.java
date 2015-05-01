package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.am.connection.Connect;
import com.am.constants.ProductConstants;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ProductBean;
import com.am.model.bean.ProductsBean;
import com.am.model.bean.TransactionBean;

public class ProductDAOImpl implements ProductDAO {
		static Logger LOGGER = Logger.getLogger(ProductDAOImpl.class.getName());
	
		public void getProductBalance(ProductBean product){
			Connection con = null;
			CallableStatement cs = null;
			ResultSet rs =null;
			try{
				con=Connect.doConnection();
				cs = con.prepareCall(ProductConstants.GET_PRODUCT_BALANCE);
				cs.setInt(1, product.getUserID());
		        cs.setInt(2, product.getProductID());
		        rs = cs.executeQuery();
		        while(rs.next()){
		        	product.setProductIn(rs.getDouble(ProductConstants.INVALUE));
		        	product.setProductOut(rs.getDouble(ProductConstants.OUTVALUE));
		        	product.setProductBalance(product.getProductIn()-product.getProductOut());
		        }
		        
			}
			catch(SQLException se){
				LOGGER.error(se.getMessage(), se);
			}finally {
				Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
		}
		
		public boolean addProduct(ProductBean pBean){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.ADD_PRODUCT);
		        cs.setString(1, pBean.getProductName());
		        cs.setInt(2, pBean.getOpeningBalance());
		        cs.setDouble(3, pBean.getCostPrice());
		        cs.setDouble(4, pBean.getDealerPrice());
		        cs.setDouble(5, pBean.getMarketPrice());
		        cs.setInt(6, pBean.getProductCategory());
		        cs.setInt(7, pBean.getUserID());
		        cs.execute();
		        flag=true;    
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		
		public boolean addCategory(CategoryBean category){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.ADD_CATEGORY);
		        cs.setString(1, category.getCategory());
		        cs.setInt(2, category.getUserID());
		        cs.execute();
		        flag=true;    
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		public void getProductTransactions(ProductBean product,List<TransactionBean> transactions,Map<String,String> dates){
			Connection con = null;
			CallableStatement cs = null;
			CallableStatement csProduct =null;
			ResultSet rs =null;
			ResultSet rsProduct=null;
			TransactionBean transaction;
			double totalBalance =0;
			double totalIn =0;
			double totalOut=0;
			double tempBalance =0;
			try{
				con=Connect.doConnection();
				csProduct = con.prepareCall(ProductConstants.GET_PRODUCT_NAME);
				csProduct.setInt(1, product.getUserID());
		        csProduct.setInt(2, product.getProductID());
		        rsProduct = csProduct.executeQuery();
		        if(rsProduct.next()){
		        	product.setProductName(rsProduct.getString(ProductConstants.PRODUCT_NAME));
		        }
		        
				cs = con.prepareCall(ProductConstants.GET_PRODUCT_TRANSACTION);
		        cs.setInt(1, product.getUserID());
		        cs.setInt(2, product.getProductID());
		        cs.setString(3, dates.get(ProductConstants.START_DATE));
		        cs.setString(4, dates.get(ProductConstants.END_DATE));
		        rs = cs.executeQuery();
		        while (rs.next()){
		        	transaction = new TransactionBean();
		        	transaction.setTransaction_id(rs.getInt(ProductConstants.STOCKID));
		        	transaction.setDescription(rs.getString(ProductConstants.DETAIL));
		        	transaction.setType(rs.getInt(ProductConstants.TRANSACTION_TYPE_ID));
		        	if(!transaction.getDescription().equals(ProductConstants.PREVIOUS_BALANCE)){
		        		transaction.setTransaction_date(rs.getDate(ProductConstants.TRANSACTION_DATE));
		        	}
		        	transaction.setDebit_value(rs.getDouble(ProductConstants.INVALUE));
		        	transaction.setCredit_value(rs.getDouble(ProductConstants.OUTVALUE));
		        	tempBalance = tempBalance+transaction.getDebit_value()-transaction.getCredit_value();
		        	transaction.setBalance(tempBalance);
		        	transaction.setReference(rs.getInt(ProductConstants.INVOICE_ID));
		        	transaction.setInvoice_number(rs.getString(ProductConstants.INVOICE_NUMBER));
		        	totalIn +=transaction.getDebit_value();
		        	totalOut +=transaction.getCredit_value();
		        	transactions.add(transaction);
		        }
		        totalBalance = totalIn-totalOut;
				product.setProductIn(totalIn);
				product.setProductOut(totalOut);
				product.setProductBalance(totalBalance);			        
			}
			catch(SQLException se){
				LOGGER.error(se.getMessage(),se);
			}finally {
				Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
		}
		
		public  double getProductsDetails(int userid,List<ProductBean> products, int category){
			Connection con = null;
			CallableStatement cs = null;
			ResultSet rs =null;
			ProductBean product = null;
			double totalStockValue =0;
			try{
				con=Connect.doConnection();
				cs = con.prepareCall(ProductConstants.GET_PRODUCTS_DETAILS);
		        cs.setInt(1, userid);
		        cs.setInt(2, category);
		        rs = cs.executeQuery();
		        while (rs.next()){
		        	product = new ProductBean();
		        	product.setProductID(rs.getInt(ProductConstants.PRODUCT_ID));
		        	product.setProductName(rs.getString(ProductConstants.PRODUCT_NAME));
		        	product.setTotalPurchase(rs.getDouble(ProductConstants.INVALUE));
		        	product.setTotalSales(rs.getDouble(ProductConstants.OUTVALUE));
		        	product.setProductBalance(product.getTotalPurchase()-product.getTotalSales());
		        	product.setProductCategoryName(rs.getString(ProductConstants.PRODUCT_CATEGORY));
		        	product.setCostPrice(rs.getDouble(ProductConstants.COST_PRICE));
		        	product.setDealerPrice(rs.getDouble(ProductConstants.DEALER_PRICE));
		        	product.setMarketPrice(rs.getDouble(ProductConstants.MARKET_PRICE));
		        	product.setStockValue(product.getProductBalance()*product.getCostPrice());
		        	totalStockValue += (product.getCostPrice() * product.getProductBalance());
		        	products.add(product);
		        }
				
			}
			catch(SQLException se){
				LOGGER.error(se.getMessage(),se);
			}finally {
				Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return totalStockValue;
		}
		
		public  double getCategoryDetails(int userid,List<CategoryBean> categories){
			Connection con = null;
			CallableStatement cs = null;
			ResultSet rs =null;
			CategoryBean category = null;
			double totalStockValue =0;
			try{
				con=Connect.doConnection();
				cs = con.prepareCall(ProductConstants.GET_CATEGORY_DETAILS);
		        cs.setInt(1, userid);
		        rs = cs.executeQuery();
		        while (rs.next()){
		        	category = new CategoryBean();
		        	category.setCategoryID(rs.getInt(ProductConstants.CATEGORY_ID));
		        	category.setCategory(rs.getString(ProductConstants.CATEGORY));
		        	category.setNoOfProducts(rs.getInt(ProductConstants.NO_OF_PRODUCTS));
		        	category.setStockValue(rs.getDouble(ProductConstants.STOCK_VALUE));
		        	totalStockValue += category.getStockValue();
		        	categories.add(category);
		        }
				
			}
			catch(SQLException se){
				LOGGER.error(se.getMessage(),se);
			}finally {
				Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return totalStockValue;
		}
		
		public void getProductDetails(ProductBean product){
			Connection con = null;
			CallableStatement cs = null;
			ResultSet rs =null;
			try{
				con=Connect.doConnection();
				cs = con.prepareCall(ProductConstants.GET_PRODUCT_DETAILS);
				cs.setInt(1, product.getUserID());
		        cs.setInt(2, product.getProductID());
		        rs = cs.executeQuery();
		        while(rs.next()){
		        	product.setProductName(rs.getString(ProductConstants.PRODUCT_NAME));
		        	product.setProductCategory(rs.getInt(ProductConstants.PRODUCT_CATEGORY));
		        	product.setOpeningBalance(rs.getInt(ProductConstants.OPENING_BALANCE));
		        	product.setCostPrice(rs.getDouble(ProductConstants.COST_PRICE));
		        	product.setDealerPrice(rs.getDouble(ProductConstants.DEALER_PRICE));
		        	product.setMarketPrice(rs.getDouble(ProductConstants.MARKET_PRICE));
		        }
		        
			}
			catch(SQLException se){
				LOGGER.error(se.getMessage(),se);
			}finally {
				Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
		}
		public boolean updateProduct(ProductBean pBean){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.UPDATE_PRODUCT);
		        cs.setString(1, pBean.getProductName());
		        cs.setInt(2, pBean.getOpeningBalance());
		        cs.setDouble(3, pBean.getCostPrice());
		        cs.setDouble(4, pBean.getDealerPrice());
		        cs.setDouble(5, pBean.getMarketPrice());
		        cs.setInt(6, pBean.getProductCategory());
		        cs.setInt(7, pBean.getUserID());
		        cs.setInt(8, pBean.getProductID());
		        cs.execute();
		        flag=true; 
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		
		
		public boolean updateProductPrice(ProductsBean products){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
				con.setAutoCommit(false);
				for(ProductBean product :products.getProducts()){
			        cs = con.prepareCall(ProductConstants.UPDATE_PRODUCT_PRICE);
			        cs.setInt(1, product.getProductID());
			        cs.setDouble(2, product.getCostPrice());
			        cs.setDouble(3, product.getDealerPrice());
			        cs.setDouble(4, product.getMarketPrice());
			        cs.execute();
				}
		        flag=true; 
		        con.commit();
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		        if (con != null) {
		            try {
		                con.rollback();
		                LOGGER.error("Rollbacking Current Transaction :: User - "+products.getUserID());
		            } catch (SQLException seInner) {
		                LOGGER.error(seInner.getMessage(),seInner);
		            }
		        }
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		
		public boolean deleteProduct(ProductBean product){
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.DELETE_PRODUCT);
		        cs.setInt(1, product.getUserID());
		        cs.setInt(2, product.getProductID());
		        cs.execute();
		        if(cs.getUpdateCount()==1){
		        	flag=true;
		        }   
		    } catch (SQLException se) {
		       LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		
		public boolean updateCategory(CategoryBean category){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.UPDATE_CATEGORY);
		        cs.setInt(1, category.getCategoryID());
		        cs.setString(2,category.getCategory());
		        cs.setInt(3,category.getUserID());
		        cs.execute();
		        flag=true; 
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
		
		public boolean deleteCategory(CategoryBean category){ 	
			Connection con=null;
			CallableStatement cs =null;
			boolean flag=false;
			try {
				con=Connect.doConnection();
		        cs = con.prepareCall(ProductConstants.DELETE_CATEGORY);
		        cs.setInt(1, category.getCategoryID());
		        cs.setInt(2,category.getUserID());
		        cs.execute();
		        flag=true; 
		    } catch (SQLException se) {
		        LOGGER.error(se.getMessage(),se);
		    }
		    finally {
		    	Connect.dropCallableObject(cs);
				Connect.dropConnection(con);
		    }
			return flag;
		}
}

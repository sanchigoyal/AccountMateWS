package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.am.connection.Connect;
import com.am.constants.ClientConstants;
import com.am.constants.ProductConstants;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ClientBean;
import com.am.model.bean.TransactionBean;

public class ClientDAOImpl  implements ClientDAO{
	
    static Logger LOGGER = Logger.getLogger(ClientDAOImpl.class.getName());
    
	public boolean deleteClient(ClientBean client){
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		try {
			con=Connect.doConnection();
	        cs = con.prepareCall(ClientConstants.DELETE_CLIENT);
	        cs.setInt(1, client.getUserID());
	        cs.setInt(2, client.getClientID());
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
	
	public void getClientLedger(ClientBean client,List<TransactionBean> transactions,Map<String,String> dates){
		Connection con = null;
		CallableStatement cs = null;
		CallableStatement csClient =null;
		ResultSet rs =null;
		ResultSet rsClient=null;
		TransactionBean transaction;
		double totalBalance =0;
		double totalCredit =0;
		double totalDebit=0;
		double tempBalance = 0;
		try{
			con=Connect.doConnection();
			csClient = con.prepareCall(ClientConstants.GET_CLIENT_NAME);
			csClient.setInt(1, client.getUserID());
	        csClient.setInt(2, client.getClientID());
	        rsClient = csClient.executeQuery();
	        if(rsClient.next()){
	        	client.setClientName(rsClient.getString(ClientConstants.ACCOUNT_NAME));
	        }
	        
			cs = con.prepareCall(ClientConstants.GET_CLIENT_TRANSACTION);
	        cs.setInt(1, client.getUserID());
	        cs.setInt(2, client.getClientID());
	        cs.setString(3, dates.get(ClientConstants.START_DATE));
	        cs.setString(4, dates.get(ClientConstants.END_DATE));
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	transaction = new TransactionBean();
	        	transaction.setTransaction_id(rs.getInt(ClientConstants.TRANSACTION_ID));
	        	transaction.setDescription(rs.getString(ClientConstants.TRANSACTION_DETAILS));
	        	transaction.setType(rs.getInt(ClientConstants.TRANSACTION_TYPE_ID));
	        	if(!transaction.getDescription().equals(ClientConstants.PREVIOUS_BALANCE)){
	        		transaction.setTransaction_date(rs.getDate(ClientConstants.TRANSACTION_DATE));
	        	}
	        	transaction.setDebit_value(rs.getDouble(ClientConstants.DEBIT_VALUE));
	        	transaction.setCredit_value(rs.getDouble(ClientConstants.CREDIT_VALUE));
	        	tempBalance += transaction.getDebit_value()-transaction.getCredit_value();
	        	transaction.setBalance(tempBalance);
	        	transaction.setReference(rs.getInt(ClientConstants.REFERENCE_ID));
	        	transaction.setInvoice_number(rs.getString(ClientConstants.REFERENCE_NUMBER));
	        	transaction.setReferenceType(rs.getString(ClientConstants.REFERENCE_TYPE));
	        	totalCredit +=transaction.getCredit_value();
	        	totalDebit +=transaction.getDebit_value();
	        	transactions.add(transaction);
	        }
	        totalBalance = totalDebit-totalCredit;
			client.setClientCredit(totalCredit);
			client.setClientDebit(totalDebit);
			client.setClientBalance(totalBalance);			        
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	}
	
	public void getClientDetails(ClientBean client){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ClientConstants.GET_CLIENT_DETAILS);
			cs.setInt(1, client.getUserID());
	        cs.setInt(2, client.getClientID());
	        rs = cs.executeQuery();
	        while(rs.next()){
	        	client.setContactFirstName(rs.getString(ClientConstants.FIRST_NAME));
	        	client.setContactLastName(rs.getString(ClientConstants.LAST_NAME));
	            client.setClientEmail(rs.getString(ClientConstants.EMAIL));
	            client.setClientName(rs.getString(ClientConstants.ACCOUNT_NAME));
	            client.setClientCategory(rs.getInt(ClientConstants.CLIENT_CATEGORY));
	            client.setClientPhoneNumber(rs.getString(ClientConstants.PHONE_NUMBER));
	            client.setClientAddress(rs.getString(ClientConstants.ADDRESS));
	            client.setClientState(rs.getString(ClientConstants.STATE));
	            client.setClientCountry(rs.getString(ClientConstants.COUNTRY));
	            client.setCustomDaysToPay(rs.getInt(ClientConstants.CUSTOM_DAYS_TO_PAY));
	            client.setOpeningBalance(rs.getDouble(ClientConstants.OPENING_BALANCE));
	            client.setClientTIN(rs.getString(ClientConstants.TIN_NUMBER));
	        }
	        
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	}
	
	public double getClientsDetails(int userid,List<ClientBean> clients, int category){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		ClientBean client = null;
		double totalBalance =0;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ClientConstants.GET_CLIENTS_DETAILS);
	        cs.setInt(1, userid);
	        cs.setInt(2, category);
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	client = new ClientBean();
	        	client.setUserID(userid);
	        	client.setClientID(rs.getInt(ClientConstants.CLIENT_ID));
	        	client.setClientName(rs.getString(ClientConstants.ACCOUNT_NAME));
	        	client.setContactFirstName(rs.getString(ClientConstants.FIRST_NAME));
	        	client.setContactLastName(rs.getString(ClientConstants.LAST_NAME));
	        	client.setClientEmail(rs.getString(ClientConstants.EMAIL));
	        	client.setClientPhoneNumber(rs.getString(ClientConstants.PHONE_NUMBER));
	        	client.setClientCountry(rs.getString(ClientConstants.COUNTRY));
	        	client.setClientState(rs.getString(ClientConstants.STATE));
	        	client.setClientAddress(rs.getString(ClientConstants.ADDRESS));
	        	client.setClientCategoryName(rs.getString(ClientConstants.CLIENT_CATEGORY));
	        	client.setClientTIN(rs.getString(ClientConstants.TIN_NUMBER));
	        	client.setClientDebit(rs.getDouble(ClientConstants.DEBIT));
	        	client.setClientCredit(rs.getDouble(ClientConstants.CREDIT));
	        	client.setClientBalance(client.getClientDebit()-client.getClientCredit());
	        	totalBalance +=client.getClientBalance();
	        	clients.add(client);
	        }
			
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		return totalBalance;
	}
	
	public boolean addClient(ClientBean client){ 	
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		try {
			con=Connect.doConnection();
	        cs = con.prepareCall(ClientConstants.ADD_NEW_CLIENT);
	        cs.setString(1, client.getContactFirstName());
	        cs.setString(2, client.getContactLastName());
	        cs.setString(3, client.getClientTIN());
	        cs.setString(4, client.getClientEmail());
	        cs.setString(5, client.getClientName());
	        cs.setInt(6, client.getClientCategory());
	        cs.setString(7, client.getClientPhoneNumber());
	        cs.setString(8, client.getClientAddress());
	        cs.setString(9, client.getClientState());
	        cs.setString(10, client.getClientCountry());
	        cs.setInt(11, client.getCustomDaysToPay());
	        cs.setDouble(12, client.getOpeningBalance());
	        cs.setInt(13, client.getUserID());
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
	
	public boolean updateClient(ClientBean client){ 	
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		try {
			con=Connect.doConnection();
	        cs = con.prepareCall(ClientConstants.UPDATE_CLIENT);
	        cs.setString(1, client.getContactFirstName());
	        cs.setString(2, client.getContactLastName());
	        cs.setString(3, client.getClientTIN());
	        cs.setString(4, client.getClientEmail());
	        cs.setString(5, client.getClientName());
	        cs.setInt(6, client.getClientCategory());
	        cs.setString(7, client.getClientPhoneNumber());
	        cs.setString(8, client.getClientAddress());
	        cs.setString(9, client.getClientState());
	        cs.setString(10, client.getClientCountry());
	        cs.setInt(11, client.getCustomDaysToPay());
	        cs.setDouble(12, client.getOpeningBalance());
	        cs.setInt(13, client.getUserID());
	        cs.setInt(14, client.getClientID());
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
	
	public void getCategoryDetails(List<CategoryBean> categories){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		CategoryBean category = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ClientConstants.GET_CLIENT_CATEGORY);
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	category = new CategoryBean();
	        	category.setCategoryID(rs.getInt(ProductConstants.CATEGORY_ID));
	        	category.setCategory(rs.getString(ProductConstants.CATEGORY));
	        	categories.add(category);
	        }
			
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	}
}


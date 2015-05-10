package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.am.connection.Connect;
import com.am.constants.ClientConstants;
import com.am.constants.InvoiceConstants;
import com.am.constants.ProductConstants;
import com.am.model.bean.ClientBean;
import com.am.model.bean.InvoiceBean;
import com.am.model.bean.ItemBean;

public class InvoiceDAOImpl implements InvoiceDAO {
	
	static Logger LOGGER = Logger.getLogger(InvoiceDAOImpl.class.getName());

	public boolean savePurchaseInvoice(InvoiceBean invoice){	
		Connection con=null;
		CallableStatement cs =null;
		CallableStatement cs2 = null;
		ResultSet rs = null;
		boolean flag=false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
	        cs = con.prepareCall(InvoiceConstants.SAVE_PURCHASE_INVOICE);
	        cs.setInt(1, invoice.getClientID());
	        cs.setString(2, invoice.getClientTIN());
	        cs.setString(3,formatter.format(invoice.getDate()));
	        cs.setString(4, invoice.getBillNumber());
	        cs.setString(5, invoice.getReference());
	        cs.setString(6, invoice.getShippedMethod());
	        cs.setString(7, invoice.getShippedTo());
	        cs.setDouble(8, invoice.getSubTotal());
	        cs.setDouble(9, invoice.getVatTotal());
	        cs.setDouble(10, invoice.getTotal());
	        cs.setInt(11, invoice.getUserID());
	        cs.setInt(12, invoice.getCustomDaysToPay());
	        rs=cs.executeQuery();
	        if(rs.next()){
	        	invoice.setInvoiceID(rs.getInt(InvoiceConstants.INVOICE_ID));
	        }
	        //get the invoice id generated
	        //use the invoice id to create entries in item table
	        if(invoice.getInvoiceID() !=0){
	        	cs2 = con.prepareCall(InvoiceConstants.SAVE_PURCHASE_ITEM_DETAILS);
	        	for(ItemBean item: invoice.getItems()){
					cs2.setInt(1,item.getProductID());
					cs2.setInt(2, invoice.getInvoiceID());
					cs2.setInt(3, item.getQuantity());
					cs2.setDouble(4,item.getPriceWithoutVat());
					cs2.setDouble(5,item.getVatPercent());
					cs2.setDouble(6,item.getPriceWithVat());
					cs2.setDouble(7,item.getTotal());
					cs2.setString(8,formatter.format(invoice.getDate()));
					cs2.setInt(9,invoice.getClientID());
					cs2.setBoolean(10,item.isUpdateCP());
					cs2.execute();
					cs2.clearParameters();
				}
	        }
	        flag = true;
	        con.commit();
	    } catch (SQLException se) {
	        LOGGER.error(se.getMessage(),se);
	        if (con != null) {
	            try {
	                con.rollback();
	                LOGGER.error("Rollbacking Current Transaction :: User - "+invoice.getUserID());
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
		
	public boolean saveSalesInvoice(InvoiceBean invoice){	
		Connection con=null;
		CallableStatement cs =null;
		CallableStatement cs2 = null;
		ResultSet rs = null;
		boolean flag = false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
	        cs = con.prepareCall(InvoiceConstants.SAVE_SALES_INVOICE);
	        cs.setInt(1, invoice.getClientID());
	        cs.setString(2, invoice.getClientTIN());
	        cs.setString(3,formatter.format(invoice.getDate()));
	        cs.setInt(4,invoice.getInvoiceTypeID());
	        cs.setString(5, invoice.getReference());
	        cs.setString(6, invoice.getShippedMethod());
	        cs.setString(7, invoice.getShippedTo());
	        cs.setDouble(8, invoice.getSubTotal());
	        cs.setDouble(9, invoice.getVatTotal());
	        cs.setDouble(10, invoice.getTotal());
	        cs.setInt(11, invoice.getUserID());
	        cs.setInt(12, invoice.getCustomDaysToPay());
	        rs=cs.executeQuery();
	        if(rs.next()){
	        	invoice.setInvoiceID(rs.getInt(InvoiceConstants.INVOICE_ID));
	        	invoice.setBillNumber(rs.getString(InvoiceConstants.INVOICE_NUMBER));
	        }
	        LOGGER.debug("INVOICE ID - "+invoice.getInvoiceID()+" :: Invoice Number - "+invoice.getBillNumber()+" :: User - "+invoice.getUserID());
	        //get the invoice id generated
	        //use the invoice id to create entries in item table
	        if(invoice.getInvoiceID() !=0){
	        	cs2 = con.prepareCall(InvoiceConstants.SAVE_SALES_ITEM_DETAILS);
	        	for(ItemBean itBean: invoice.getItems()){
					cs2.setInt(1,itBean.getProductID());
					cs2.setInt(2, invoice.getInvoiceID());
					cs2.setInt(3, itBean.getQuantity());
					cs2.setDouble(4,itBean.getPriceWithoutVat());
					cs2.setDouble(5,itBean.getVatPercent());
					cs2.setDouble(6,itBean.getPriceWithVat());
					cs2.setDouble(7,itBean.getTotal());
					cs2.setString(8,formatter.format(invoice.getDate()));
					cs2.setInt(9,invoice.getClientID());
					cs2.execute();
					cs2.clearParameters();
				}
	        }
	        flag = true;
	        con.commit();
	    } catch (SQLException se) {
	       LOGGER.error(se.getMessage(),se);
	        if (con != null) {
	            try {
	                con.rollback();
	                LOGGER.error("Rollbacking Current Transaction :: User - "+invoice.getUserID());
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
		
	public void getInvoiceDetails(InvoiceBean invoice){
		Connection con = null;
		CallableStatement cs = null;
		CallableStatement csClient =null;
		ResultSet rs =null;
		ResultSet rsClient=null;
		List<ItemBean> items = new ArrayList<ItemBean>();
		ItemBean item = null;
		try{
			con=Connect.doConnection();
			csClient = con.prepareCall(InvoiceConstants.GET_INVOICE_DETAILS);
			csClient.setInt(1, invoice.getUserID());
	        csClient.setInt(2, invoice.getInvoiceID());
	        rsClient = csClient.executeQuery();
	        while(rsClient.next()){
	        	invoice.setClientID(rsClient.getInt(ClientConstants.CLIENT_ID));
	        	invoice.setClientName(rsClient.getString(ClientConstants.ACCOUNT_NAME));
	        	invoice.setClientTIN(rsClient.getString(ClientConstants.TIN_NUMBER));
	        	invoice.setDate(rsClient.getDate(InvoiceConstants.INVOICE_DATE));
	        	invoice.setBillNumber(rsClient.getString(InvoiceConstants.INVOICE_NUMBER));
	        	invoice.setInvoice_type(rsClient.getString(InvoiceConstants.INVOICE_TYPE));
	        	invoice.setReference(rsClient.getString(InvoiceConstants.REFERENCE));
	        	invoice.setShippedMethod(rsClient.getString(InvoiceConstants.SHIPPED_METHOD));
	        	invoice.setShippedTo(rsClient.getString(InvoiceConstants.SHIPPED_TO));
	        	invoice.setSubTotal(rsClient.getDouble(InvoiceConstants.SUB_TOTAL));
	        	invoice.setVatTotal(rsClient.getDouble(InvoiceConstants.VAT_TOTAL));
	        	invoice.setTotal(rsClient.getDouble(InvoiceConstants.TOTAL));
	        	invoice.setOutstandingAmount(rsClient.getDouble(InvoiceConstants.OUTSTANDING_AMT));
	        	invoice.setInvoiceStatus(rsClient.getString(InvoiceConstants.INVOICE_STATUS));
	        	invoice.setCustomDaysToPay(rsClient.getInt(InvoiceConstants.CUSTOM_DAYS_TO_PAY));
	        	invoice.setPaymentStatus(rsClient.getString(InvoiceConstants.PAYMENT_STATUS));
	        	invoice.setDateDiff(rsClient.getInt(InvoiceConstants.DATE_DIFF));
	        }
			cs = con.prepareCall(InvoiceConstants.GET_INVOICE_ITEM);
	        cs.setInt(1, invoice.getUserID());
	        cs.setInt(2, invoice.getInvoiceID());
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	item = new ItemBean();
	        	item.setProductName(rs.getString(ProductConstants.PRODUCT_NAME));
	        	item.setQuantity(rs.getInt(InvoiceConstants.QUANTITY));
	        	item.setPriceWithoutVat(rs.getDouble(InvoiceConstants.PRICE_WITHOUT_VAT));
	        	item.setVatPercent(rs.getDouble(InvoiceConstants.VAT_PERCENT));
	        	item.setPriceWithVat(rs.getDouble(InvoiceConstants.PRICE_WITH_VAT));
	        	item.setTotal(rs.getDouble(InvoiceConstants.ITEM_TOTAL));	
	        	items.add(item);
	        }
	        invoice.setItems(items);
	        updateInvoicePaymentStatus(invoice);
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	}

	public List<InvoiceBean> getUnpaidInvoiceList(ClientBean client,int invoiceType){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		List<InvoiceBean> invoices = new ArrayList<InvoiceBean>();
		InvoiceBean invoice = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(InvoiceConstants.GET_UNPAID_INVOICE_LIST);
			cs.setInt(1, client.getUserID());
			cs.setInt(2, client.getClientID());
			cs.setInt(3, invoiceType);
			rs = cs.executeQuery();
	        while(rs.next()){
	        	invoice = new InvoiceBean();
	        	invoice.setInvoiceID(rs.getInt(InvoiceConstants.INVOICE_ID));
	        	invoice.setBillNumber(rs.getString(InvoiceConstants.INVOICE_NUMBER));
	        	invoices.add(invoice);
	        }
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		return invoices;
	}
	public void getInvoicesDetails(List<InvoiceBean> invoicesPaid,List<InvoiceBean> invoicesUnPaid,List<InvoiceBean> deletedInvoices, Map<String, String> dates,
			int userid,int invoiceTypeID) {
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		InvoiceBean invoice = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(InvoiceConstants.GET_INVOICES_DETAILS);
	        cs.setInt(1, userid);
	        cs.setString(2, dates.get(InvoiceConstants.START_DATE));
	        cs.setString(3, dates.get(InvoiceConstants.END_DATE));
	        cs.setInt(4,invoiceTypeID);
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	invoice = new InvoiceBean();
	        	invoice.setInvoiceID(rs.getInt(InvoiceConstants.INVOICE_ID));
	        	invoice.setClientName(rs.getString(ClientConstants.ACCOUNT_NAME));
	        	invoice.setClientTIN(rs.getString(ClientConstants.TIN_NUMBER));
	        	invoice.setDate(rs.getDate(InvoiceConstants.INVOICE_DATE));
	        	invoice.setBillNumber(rs.getString(InvoiceConstants.INVOICE_NUMBER));
	        	invoice.setTotal(rs.getDouble(InvoiceConstants.TOTAL));
	        	invoice.setOutstandingAmount(rs.getDouble(InvoiceConstants.OUTSTANDING_AMT));
	        	invoice.setInvoiceStatus(rs.getString(InvoiceConstants.INVOICE_STATUS));
	        	invoice.setCustomDaysToPay(rs.getInt(InvoiceConstants.CUSTOM_DAYS_TO_PAY));
	        	invoice.setPaymentStatus(rs.getString(InvoiceConstants.PAYMENT_STATUS));
	        	invoice.setDateDiff(rs.getInt(InvoiceConstants.DATE_DIFF));
	        	updateInvoicePaymentStatus(invoice);
	        	if(invoice.getInvoiceStatus().equals("ACTIVE")){
		        	if(invoice.getOutstandingAmount() == 0){
		        		invoicesPaid.add(invoice);
		        	}
		        	else{
		        		invoicesUnPaid.add(invoice);
		        	}
	        	}
	        	else{
	        		deletedInvoices.add(invoice);
	        	}
	        }        
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		
	}
	public void getLatestBillingDates(Map<Integer, String> dates,int userid) {
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(InvoiceConstants.GET_LATEST_BILLING_DATE);
	        cs.setInt(1, userid);
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	dates.put(rs.getInt(InvoiceConstants.INVOICE_TYPE_ID),rs.getString(InvoiceConstants.INVOICE_DATE));
	        }        
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		
	}
	
	public boolean deleteInvoice(InvoiceBean invoice){
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		try {
			con=Connect.doConnection();
	        cs = con.prepareCall(InvoiceConstants.DELETE_INVOICE);
	        cs.setInt(1, invoice.getUserID());
	        cs.setInt(2, invoice.getInvoiceID());
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
	
	/**
	 * Method to update invoice payment status
	 * @param invoice
	 */
	void updateInvoicePaymentStatus(InvoiceBean invoice){
		
		if(invoice.getOutstandingAmount()==0){
			//PAID
			invoice.setPaymentStatus("PAID");
		}
		else if((invoice.getTotal()-invoice.getOutstandingAmount()) !=0 && invoice.getDateDiff()>invoice.getCustomDaysToPay()){
			//DUE+PARTIALLY PAID
			invoice.setPaymentStatus("DUE/PARTIALLY PAID");
		}
		else if((invoice.getTotal()-invoice.getOutstandingAmount())==0 && invoice.getDateDiff()>invoice.getCustomDaysToPay()){
		//DUE+UNPAID
			invoice.setPaymentStatus("DUE/UNPAID");
		}
		else if((invoice.getTotal()-invoice.getOutstandingAmount()) !=0){
		//PARTIALLY PAID
			invoice.setPaymentStatus("PARTIALLY PAID");
		}
		else{
			invoice.setPaymentStatus("UNPAID");
		}
		//UNPAID
	}
}

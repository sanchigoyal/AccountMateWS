package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.log4j.Logger;

import com.am.connection.Connect;
import com.am.model.bean.InvoiceBean;
import com.am.model.bean.ReceiptBean;

public class ReceiptDAOImpl implements ReceiptDAO {
	static Logger LOGGER = Logger.getLogger(ReceiptDAOImpl.class.getName());
	
	/*public double getCashBalance(int userID){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		double balance = 0;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall("{call getCashBalance(?)}");
			cs.setInt(1, userID);
			rs = cs.executeQuery();
	        if(rs.next()){
	        	balance = rs.getDouble("balance");
	        }
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		return balance;	
	}*/
	public boolean saveBillWiseReceipt(ReceiptBean receipt){	
		Connection con=null;
		CallableStatement cs =null;
		CallableStatement cs2 = null;
		ResultSet rs = null;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag=false;
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
	        cs = con.prepareCall("{call saveReceipt(?,?,?,?,?,?,?,?,?)}");
	        cs.setInt(1, receipt.getClientID());
	        cs.setDouble(2,receipt.getPaidAmount());
	        if(receipt.getModeOfPaymentID() ==1){
	        	cs.setInt(3,1);
	        	cs.setString(4,receipt.getCashDetails());
	        	cs.setInt(5,0);
	        	cs.setString(6,"");
	        }
	        else{
	        	cs.setInt(3,2);
	        	cs.setString(4,"");
	        	cs.setInt(5,receipt.getBankID());
	        	cs.setString(6,receipt.getChequeNumber());
	        }
	        cs.setInt(7, receipt.getUserID());
	        cs.setString(8, formatter.format(receipt.getReceiptDate()));
	        cs.setString(9,"Y");
	        rs=cs.executeQuery();
	        if(rs.next()){
	        	receipt.setReceiptID(rs.getInt("RECEIPT_ID"));
	        }
	        else{
	        	receipt.setReceiptID(0);
	        }
	        
	        if(receipt.getReceiptID() !=0){
	        	cs2 = con.prepareCall("{call saveInvoiceWiseReceipt(?,?,?,?)}");
	        	for(int invoiceid: receipt.getInvoiceList().keySet()){
					cs2.setInt(1,receipt.getReceiptID());
					cs2.setInt(2,invoiceid);
					cs2.setDouble(3,receipt.getInvoiceList().get(invoiceid));
					if(receipt.getInvoiceList().get(invoiceid) == 0){
						cs2.setString(4, "Y");
					}
					else{
						cs2.setString(4, "N");
					}
					cs2.execute();
					cs2.clearParameters();
				}
	        	
	        }
	        flag =true;
	        con.commit();
	    } catch (SQLException se) {
	    	LOGGER.error(se.getMessage(),se);
	        if (con != null) {
	            try {
	                con.rollback();
	                LOGGER.error("Rollbacking Current Transaction :: User - "+receipt.getUserID());
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
	
	public boolean saveReceipt(ReceiptBean receipt){	
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			//con.setAutoCommit(false);
	        cs = con.prepareCall("{call saveReceipt(?,?,?,?,?,?,?,?,?)}");
	        cs.setInt(1, receipt.getClientID());
	        cs.setDouble(2,receipt.getPaidAmount());
	        if(receipt.getModeOfPaymentID() ==1){
	        	cs.setInt(3,1);
	        	cs.setString(4,receipt.getCashDetails());
	        	cs.setInt(5,0);
	        	cs.setString(6,"");
	        }
	        else{
	        	cs.setInt(3,2);
	        	cs.setString(4,"");
	        	cs.setInt(5,receipt.getBankID());
	        	cs.setString(6,receipt.getChequeNumber());
	        }
	        cs.setInt(7, receipt.getUserID());
	        cs.setString(8, formatter.format(receipt.getReceiptDate()));
	        cs.setString(9,"N");
	        cs.execute();
	        flag =true;
	        //con.commit();
	    } catch (SQLException se) {
	    	LOGGER.error(se.getMessage(),se);
	    }
	    finally {
	    	Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
		return flag;
	}

	public void getReceiptDetails(ReceiptBean receipt,List<InvoiceBean> invoices) {
		Connection con = null;
		CallableStatement cs = null;
		CallableStatement cs2 = null;
		ResultSet rs =null;
		ResultSet rs2 = null;
		InvoiceBean invoice = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall("{call getReceiptDetails(?,?)}");
			cs.setInt(1,receipt.getReceiptID());
			cs.setInt(2,receipt.getUserID());
			rs = cs.executeQuery();
	        if(rs.next()){
	        	receipt.setReceiptDate(rs.getDate("receipt_date"));
	        	receipt.setPaidAmount(rs.getDouble("amount_paid"));
	        	receipt.setClientName(rs.getString("client_name"));
	        	receipt.setModeOfPayment(rs.getString("mop"));
	        	receipt.setBillWise(rs.getString("billWise"));
	        	receipt.setCashDetails(rs.getString("cash_details"));
	        	receipt.setBankName(rs.getString("bank_name"));
	        	receipt.setChequeNumber(rs.getString("cheque_number"));
	        	
	        }
	        
	        cs2 = con.prepareCall("{call getReceiptInvoicesDetails(?,?)}");
	        cs2.setInt(1,receipt.getReceiptID());
			cs2.setInt(2,receipt.getUserID());
			rs2 = cs2.executeQuery();
	        if(rs2.next()){
	        	invoice = new InvoiceBean();
	        	invoice.setBillNumber(rs2.getString("invoice_number"));
	        	invoice.setSubTotal(rs2.getDouble("sub_total"));
	        	invoice.setVatTotal(rs2.getDouble("vat_total"));
	        	invoice.setTotal(rs2.getDouble("total"));
	        	invoice.setOutstandingAmount(rs2.getDouble("receipt_amount"));
	        	invoices.add(invoice);
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


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
import com.am.model.bean.PaymentBean;

public class PaymentDAOImpl implements PaymentDAO {
	static Logger LOGGER = Logger.getLogger(PaymentDAOImpl.class.getName());
	
	public double getCashBalance(int userID){
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
	}
	public boolean saveBillWisePayment(PaymentBean payment){	
		Connection con=null;
		CallableStatement cs =null;
		CallableStatement cs2 = null;
		ResultSet rs = null;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag=false;
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
	        cs = con.prepareCall("{call savePayment(?,?,?,?,?,?,?,?,?)}");
	        cs.setInt(1, payment.getClientID());
	        cs.setDouble(2,payment.getPaidAmount());
	        if(payment.getModeOfPayment() ==1){
	        	cs.setInt(3,1);
	        	cs.setString(4,payment.getCashDetails());
	        	cs.setInt(5,0);
	        	cs.setString(6,"");
	        }
	        else{
	        	cs.setInt(3,2);
	        	cs.setString(4,"");
	        	cs.setInt(5,payment.getBankID());
	        	cs.setString(6,payment.getChequeNumber());
	        }
	        cs.setInt(7, payment.getUserID());
	        cs.setString(8, formatter.format(payment.getPaymentDate()));
	        cs.setString(9,"Y");
	        rs=cs.executeQuery();
	        if(rs.next()){
	        	payment.setPaymentID(rs.getInt("PAYMENT_ID"));
	        }
	        else{
	        	payment.setPaymentID(0);
	        }
	        
	        if(payment.getPaymentID() !=0){
	        	cs2 = con.prepareCall("{call saveInvoiceWisePayment(?,?,?,?)}");
	        	for(int invoiceid: payment.getInvoiceList().keySet()){
					cs2.setInt(1,payment.getPaymentID());
					cs2.setInt(2,invoiceid);
					cs2.setDouble(3,payment.getInvoiceList().get(invoiceid));
					if(payment.getInvoiceList().get(invoiceid) == 0){
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
	                LOGGER.error("Rollbacking Current Transaction :: User - "+payment.getUserID());
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
	
	public boolean savePayment(PaymentBean payment){	
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			//con.setAutoCommit(false);
	        cs = con.prepareCall("{call savePayment(?,?,?,?,?,?,?,?,?)}");
	        cs.setInt(1, payment.getClientID());
	        cs.setDouble(2,payment.getPaidAmount());
	        if(payment.getModeOfPayment() ==1){
	        	cs.setInt(3,1);
	        	cs.setString(4,payment.getCashDetails());
	        	cs.setInt(5,0);
	        	cs.setString(6,"");
	        }
	        else{
	        	cs.setInt(3,2);
	        	cs.setString(4,"");
	        	cs.setInt(5,payment.getBankID());
	        	cs.setString(6,payment.getChequeNumber());
	        }
	        cs.setInt(7, payment.getUserID());
	        cs.setString(8, formatter.format(payment.getPaymentDate()));
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

	public void getPaymentDetails(PaymentBean payment,List<InvoiceBean> invoices) {
		Connection con = null;
		CallableStatement cs = null;
		CallableStatement cs2 = null;
		ResultSet rs =null;
		ResultSet rs2 = null;
		InvoiceBean invoice = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall("{call getPaymentDetails(?,?)}");
			cs.setInt(1,payment.getPaymentID());
			cs.setInt(2,payment.getUserID());
			rs = cs.executeQuery();
	        if(rs.next()){
	        	payment.setPaymentDate(rs.getDate("payment_date"));
	        	payment.setPaidAmount(rs.getDouble("amount_paid"));
	        	payment.setClientName(rs.getString("client_name"));
	        	payment.setMop(rs.getString("mop"));
	        	payment.setBillWise(rs.getString("billWise"));
	        	payment.setCashDetails(rs.getString("cash_details"));
	        	payment.setBankName(rs.getString("bank_name"));
	        	payment.setChequeNumber(rs.getString("cheque_number"));
	        	
	        }
	        
	        cs2 = con.prepareCall("{call getPaymentInvoicesDetails(?,?)}");
	        cs2.setInt(1,payment.getPaymentID());
			cs2.setInt(2,payment.getUserID());
			rs2 = cs2.executeQuery();
	        if(rs2.next()){
	        	invoice = new InvoiceBean();
	        	invoice.setBillNumber(rs2.getString("invoice_number"));
	        	invoice.setSubTotal(rs2.getDouble("sub_total"));
	        	invoice.setVatTotal(rs2.getDouble("vat_total"));
	        	invoice.setTotal(rs2.getDouble("total"));
	        	invoice.setOutstandingAmount(rs2.getDouble("paid_amount"));
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

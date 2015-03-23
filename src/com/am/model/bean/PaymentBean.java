package com.am.model.bean;

import java.util.Date;
import java.util.Map;

public class PaymentBean {

	private int paymentID;
	private int clientID;
	private String clientName;
	private Map<Integer,Double> invoiceList;
	private double paidAmount;
	private int modeOfPayment;
	private String mop;
	private String billWise;
	private String cashDetails;
	private int bankID;
	private String bankName;
	private String chequeNumber;
	private Date paymentDate;
	private int userID;
	
	
	
	public String getMop() {
		return mop;
	}

	public void setMop(String mop) {
		this.mop = mop;
	}

	public String getBillWise() {
		return billWise;
	}

	public void setBillWise(String billWise) {
		this.billWise = billWise;
	}

	public String getClientName() {
		return clientName;
	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public void setInvoiceList(Map<Integer, Double> invoiceList) {
		this.invoiceList = invoiceList;
	}
	
	public Map<Integer, Double> getInvoiceList() {
		return invoiceList;
	}

	public int getPaymentID() {
		return paymentID;
	}
	public void setPaymentID(int paymentID) {
		this.paymentID = paymentID;
	}
	public int getClientID() {
		return clientID;
	}
	public void setClientID(int clientID) {
		this.clientID = clientID;
	}
	public double getPaidAmount() {
		return paidAmount;
	}
	public void setPaidAmount(double paidAmount) {
		this.paidAmount = paidAmount;
	}
	public int getModeOfPayment() {
		return modeOfPayment;
	}
	public void setModeOfPayment(int modeOfPayment) {
		this.modeOfPayment = modeOfPayment;
	}
	public String getCashDetails() {
		return cashDetails;
	}
	public void setCashDetails(String cashDetails) {
		this.cashDetails = cashDetails;
	}
	public int getBankID() {
		return bankID;
	}
	public void setBankID(int bankID) {
		this.bankID = bankID;
	}
	public String getChequeNumber() {
		return chequeNumber;
	}
	public void setChequeNumber(String chequeNumber) {
		this.chequeNumber = chequeNumber;
	}
	public Date getPaymentDate() {
		return paymentDate;
	}
	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}
	
	
}

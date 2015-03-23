package com.am.model.bean;

import java.util.Date;
import java.util.Map;

public class ReceiptBean {
	
	private int receiptID;
	private int clientID;
	private String clientName;
	private Map<Integer,Double> invoiceList;
	private double paidAmount;
	private int modeOfPaymentID;
	private String modeOfPayment;
	private String billWise;
	private String cashDetails;
	private int bankID;
	private String bankName;
	private String chequeNumber;
	private Date receiptDate;
	private int userID;
	public int getReceiptID() {
		return receiptID;
	}
	public void setReceiptID(int receipyID) {
		this.receiptID = receipyID;
	}
	public int getClientID() {
		return clientID;
	}
	public void setClientID(int clientID) {
		this.clientID = clientID;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	public Map<Integer, Double> getInvoiceList() {
		return invoiceList;
	}
	public void setInvoiceList(Map<Integer, Double> invoiceList) {
		this.invoiceList = invoiceList;
	}
	public double getPaidAmount() {
		return paidAmount;
	}
	public void setPaidAmount(double paidAmount) {
		this.paidAmount = paidAmount;
	}
	public int getModeOfPaymentID() {
		return modeOfPaymentID;
	}
	public void setModeOfPaymentID(int modeOfPaymentID) {
		this.modeOfPaymentID = modeOfPaymentID;
	}
	public String getModeOfPayment() {
		return modeOfPayment;
	}
	public void setModeOfPayment(String modeOfPayment) {
		this.modeOfPayment = modeOfPayment;
	}
	public String getBillWise() {
		return billWise;
	}
	public void setBillWise(String billWise) {
		this.billWise = billWise;
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
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getChequeNumber() {
		return chequeNumber;
	}
	public void setChequeNumber(String chequeNumber) {
		this.chequeNumber = chequeNumber;
	}
	public Date getReceiptDate() {
		return receiptDate;
	}
	public void setReceiptDate(Date receiptDate) {
		this.receiptDate = receiptDate;
	}
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	
	
}

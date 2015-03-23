package com.am.model.bean;

import java.util.Date;
import java.util.List;

public class InvoiceBean {
	private int invoiceID;
	private int clientID;
	private String clientTIN;
	private String billNumber;
	private Date date;
	private String shippedTo;
	private String shippedMethod;
	private String reference;
	List<ItemBean> items;
	private double subTotal;
	private double vatTotal;
	private double total;
	private int userID;
	private String clientName;
	private int invoiceTypeID;
	private String invoice_type;
	private double outstandingAmount;
	
	
	public double getOutstandingAmount() {
		return outstandingAmount;
	}
	public void setOutstandingAmount(double outstandingAmount) {
		this.outstandingAmount = outstandingAmount;
	}
	
	public int getInvoiceTypeID() {
		return invoiceTypeID;
	}
	public void setInvoiceTypeID(int invoiceTypeID) {
		this.invoiceTypeID = invoiceTypeID;
	}
	public String getInvoice_type() {
		return invoice_type;
	}
	public void setInvoice_type(String invoice_type) {
		this.invoice_type = invoice_type;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public int getInvoiceID() {
		return invoiceID;
	}
	public void setInvoiceID(int invoiceID) {
		this.invoiceID = invoiceID;
	}
	public int getClientID() {
		return clientID;
	}
	public void setClientID(int clientID) {
		this.clientID = clientID;
	}
	public String getClientTIN() {
		return clientTIN;
	}
	public void setClientTIN(String clientTIN) {
		this.clientTIN = clientTIN;
	}
	public String getBillNumber() {
		return billNumber;
	}
	public void setBillNumber(String billNumber) {
		this.billNumber = billNumber;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getShippedTo() {
		return shippedTo;
	}
	public void setShippedTo(String shippedTo) {
		this.shippedTo = shippedTo;
	}
	public String getShippedMethod() {
		return shippedMethod;
	}
	public void setShippedMethod(String shippedMethod) {
		this.shippedMethod = shippedMethod;
	}
	public String getReference() {
		return reference;
	}
	public void setReference(String reference) {
		this.reference = reference;
	}
	public List<ItemBean> getItems() {
		return items;
	}
	public void setItems(List<ItemBean> items) {
		this.items = items;
	}
	public double getSubTotal() {
		return subTotal;
	}
	public void setSubTotal(double subTotal) {
		this.subTotal = subTotal;
	}
	public double getVatTotal() {
		return vatTotal;
	}
	public void setVatTotal(double vatTotal) {
		this.vatTotal = vatTotal;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	
}

package com.am.model.bean;

import java.util.Date;

public class TransactionBean {
	
	private int transaction_id;
	private int client_id;
	private int user_id;
	private String description;
	private int type;
	private Date transaction_date;
	private Double debit_value;
	private Double credit_value;
	private Double balance;
	private int reference;
	private String invoice_number;
	private String referenceType;
	
	
	
	public String getReferenceType() {
		return referenceType;
	}
	public void setReferenceType(String referenceType) {
		this.referenceType = referenceType;
	}
	public String getInvoice_number() {
		return invoice_number;
	}
	public void setInvoice_number(String invoice_number) {
		this.invoice_number = invoice_number;
	}
	public int getReference() {
		return reference;
	}
	public void setReference(int reference) {
		this.reference = reference;
	}
	public int getTransaction_id() {
		return transaction_id;
	}
	public void setTransaction_id(int transaction_id) {
		this.transaction_id = transaction_id;
	}
	public int getClient_id() {
		return client_id;
	}
	public void setClient_id(int client_id) {
		this.client_id = client_id;
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public Date getTransaction_date() {
		return transaction_date;
	}
	public void setTransaction_date(Date transaction_date) {
		this.transaction_date = transaction_date;
	}
	public Double getDebit_value() {
		return debit_value;
	}
	public void setDebit_value(Double debit_value) {
		this.debit_value = debit_value;
	}
	public Double getCredit_value() {
		return credit_value;
	}
	public void setCredit_value(Double credit_value) {
		this.credit_value = credit_value;
	}
	public Double getBalance() {
		return balance;
	}
	public void setBalance(Double balance) {
		this.balance = balance;
	}
	
	

}

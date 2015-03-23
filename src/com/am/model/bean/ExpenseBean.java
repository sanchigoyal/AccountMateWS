package com.am.model.bean;

import java.util.Date;

public class ExpenseBean {
	private int expenseID;
	private int expenseCategoryID;
	private String expenseCategory;
	private String description;
	private double amount;
	private int transactionBy;
	private String modeOfPayment;
	private int bankID;
	private String bankName;
	private String chequeNumber;
	private int userID;
	private Date expenseDate;
	
	
	public Date getExpenseDate() {
		return expenseDate;
	}
	public void setExpenseDate(Date expenseDate) {
		this.expenseDate = expenseDate;
	}
	public String getModeOfPayment() {
		return modeOfPayment;
	}
	public void setModeOfPayment(String modeOfPayment) {
		this.modeOfPayment = modeOfPayment;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public int getExpenseID() {
		return expenseID;
	}
	public void setExpenseID(int expenseID) {
		this.expenseID = expenseID;
	}
	public int getExpenseCategoryID() {
		return expenseCategoryID;
	}
	public void setExpenseCategoryID(int expenseCategoryID) {
		this.expenseCategoryID = expenseCategoryID;
	}
	public String getExpenseCategory() {
		return expenseCategory;
	}
	public void setExpenseCategory(String expenseCategory) {
		this.expenseCategory = expenseCategory;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public int getTransactionBy() {
		return transactionBy;
	}
	public void setTransactionBy(int transactionBy) {
		this.transactionBy = transactionBy;
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
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	
	
	
}

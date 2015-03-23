package com.am.model.bean;

import java.util.Date;
import java.util.List;

public class ExpenseBeanList {
	private Date date;
	private List<ExpenseBean> expenses;
	private double totalCash;
	private double totalCheque;
	private double total;
	private int userID;
	
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public List<ExpenseBean> getExpenses() {
		return expenses;
	}
	public void setExpenses(List<ExpenseBean> expenses) {
		this.expenses = expenses;
	}
	public double getTotalCash() {
		return totalCash;
	}
	public void setTotalCash(double totalCash) {
		this.totalCash = totalCash;
	}
	public double getTotalCheque() {
		return totalCheque;
	}
	public void setTotalCheque(double totalCheque) {
		this.totalCheque = totalCheque;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	
	
}

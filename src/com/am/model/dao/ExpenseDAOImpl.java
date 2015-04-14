package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.am.connection.Connect;
import com.am.constants.ExpenseConstants;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ExpenseBean;
import com.am.model.bean.ExpenseBeanList;

public class ExpenseDAOImpl implements ExpenseDAO {
	static Logger LOGGER = Logger.getLogger(ExpenseDAOImpl.class.getName());
	
	public void getExpenseCategories(List<CategoryBean> categories){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		CategoryBean category = null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ExpenseConstants.GET_EXPENSE_CATEGORY);
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	category = new CategoryBean();
	        	category.setCategoryID(rs.getInt(ExpenseConstants.CATEGORY_ID));
	        	category.setCategory(rs.getString(ExpenseConstants.CATEGORY));
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
	
	public void getExpenseDetails(ExpenseBean expense){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ExpenseConstants.GET_EXPENSE_DETAILS);
			cs.setInt(1,expense.getExpenseID());
			cs.setInt(2, expense.getUserID());
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	expense.setExpenseCategoryID(rs.getInt(ExpenseConstants.CATEGORY_ID));
	        	expense.setExpenseCategory(rs.getString(ExpenseConstants.CATEGORY));
	        	expense.setDescription(rs.getString(ExpenseConstants.DESCRIPTION));
	        	expense.setAmount(rs.getDouble(ExpenseConstants.AMOUNT));
	        	expense.setExpenseDate(rs.getDate(ExpenseConstants.EXPENSE_DATE));
	        	expense.setTransactionBy(rs.getInt(ExpenseConstants.MODE_OF_PAYMENT_ID));
	        	expense.setModeOfPayment(rs.getString(ExpenseConstants.MODE_OF_PAYMENT));
	        	expense.setBankID(rs.getInt(ExpenseConstants.BANK_ID));
	        	expense.setBankName(rs.getString(ExpenseConstants.BANK_NAME));
	        	expense.setChequeNumber(rs.getString(ExpenseConstants.CHEQUE_NUMBER));
	        }        
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	 }
	
	public void getExpensesDetails(List<ExpenseBeanList> expensesDetails,int userID,Map<String,String> dates){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		ExpenseBean expense = null;
		Map<Integer,ExpenseBeanList> temp = new HashMap<Integer,ExpenseBeanList>();
		ExpenseBeanList expenseList = null; 
		List<ExpenseBean> expenses = null;
		double tempTotal = 0;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall(ExpenseConstants.GET_EXPENSES_DETAILS);
			cs.setInt(1,userID);
			cs.setString(2,dates.get(ExpenseConstants.START_DATE));
			cs.setString(3,dates.get(ExpenseConstants.END_DATE));
	        rs = cs.executeQuery();
	        while (rs.next()){
	        	expense = new ExpenseBean();
	        	expense.setExpenseID(rs.getInt(ExpenseConstants.EXPENSE_ID));
	        	expense.setExpenseCategoryID(rs.getInt(ExpenseConstants.CATEGORY_ID));
	        	expense.setExpenseCategory(rs.getString(ExpenseConstants.CATEGORY));
	        	expense.setDescription(rs.getString(ExpenseConstants.DESCRIPTION));
	        	expense.setAmount(rs.getDouble(ExpenseConstants.AMOUNT));
	        	expense.setTransactionBy(rs.getInt(ExpenseConstants.MODE_OF_PAYMENT_ID));
	        	expense.setModeOfPayment(rs.getString(ExpenseConstants.MODE_OF_PAYMENT));
	        	expense.setBankID(rs.getInt(ExpenseConstants.BANK_ID));
	        	expense.setBankName(rs.getString(ExpenseConstants.BANK_NAME));
	        	expense.setChequeNumber(rs.getString(ExpenseConstants.CHEQUE_NUMBER));
	        	expense.setExpenseDate(rs.getDate(ExpenseConstants.EXPENSE_DATE));
	        	if(temp.containsKey(expense.getExpenseCategoryID())){
	        		expenseList = temp.get(expense.getExpenseCategoryID());
	        		expenses = expenseList.getExpenses();
	        		expenses.add(expense);
	        		expenseList.setExpenses(expenses);
	        		tempTotal = expenseList.getTotal();
	        		tempTotal += expense.getAmount();
	        		expenseList.setTotal(tempTotal);
	        		temp.put(expense.getExpenseCategoryID(), expenseList);
	        	}
	        	else{
	        		expenseList = new ExpenseBeanList();
	        		expenses = new ArrayList<ExpenseBean>();
	        		expenses.add(expense);
	        		expenseList.setExpenses(expenses);
	        		tempTotal = expense.getAmount();
	        		expenseList.setTotal(tempTotal);
	        		temp.put(expense.getExpenseCategoryID(), expenseList);
	        	}
	        }
	      convertMapToList(expensesDetails,temp);
		}
		catch(SQLException se){
			LOGGER.error(se.getMessage(),se);
		}finally {
			Connect.dropCallableObject(cs);
			Connect.dropConnection(con);
	    }
	 }
	private void convertMapToList(List<ExpenseBeanList> expensesDetails,Map<Integer,ExpenseBeanList> temp){
		for(int key :temp.keySet()){
			expensesDetails.add(temp.get(key));
		}
	}
	public boolean saveExpenses(ExpenseBeanList expenses){
		boolean flag= false;
		Connection con=null;
		CallableStatement cs =null;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
        	cs = con.prepareCall(ExpenseConstants.SAVE_EXPENSE);
        	for(ExpenseBean expense: expenses.getExpenses()){
				cs.setInt(1,expense.getExpenseCategoryID());
				cs.setString(2,expense.getDescription());
				cs.setDouble(3,expense.getAmount());
				cs.setInt(4,expense.getTransactionBy());
				cs.setInt(5,expense.getBankID());
				cs.setString(6,expense.getChequeNumber());
				cs.setString(7,formatter.format(expenses.getDate()));
				cs.setInt(8,expenses.getUserID());
				cs.execute();
				cs.clearParameters();
			}
	        flag = true;
	        con.commit();
	    } catch (SQLException se) {
	        LOGGER.error(se.getMessage(),se);
	        if (con != null) {
	            try {
	                con.rollback();
	                LOGGER.error("Rollbacking Current Transaction :: User - "+expenses.getUserID());
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
	
	public boolean updateExpense(ExpenseBean expense){
		boolean flag= false;
		Connection con=null;
		CallableStatement cs =null;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con=Connect.doConnection();
			con.setAutoCommit(false);
			cs = con.prepareCall(ExpenseConstants.UPDATE_EXPENSE);
			cs.setInt(1, expense.getExpenseID());
			cs.setInt(2,expense.getExpenseCategoryID());
			cs.setString(3,expense.getDescription());
			cs.setDouble(4,expense.getAmount());
			cs.setInt(5,expense.getTransactionBy());
			cs.setInt(6,expense.getBankID());
			cs.setString(7,expense.getChequeNumber());
			cs.setString(8,formatter.format(expense.getExpenseDate()));
			cs.setInt(9,expense.getUserID());
			cs.execute();
	        flag = true;
	        con.commit();
	    } catch (SQLException se) {
	        LOGGER.error(se.getMessage(),se);
	        if (con != null) {
	            try {
	                con.rollback();
	                LOGGER.error("Rollbacking Current Transaction :: User - "+expense.getUserID());
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
	
	public boolean deleteExpense(ExpenseBean expense){
		Connection con=null;
		CallableStatement cs =null;
		boolean flag=false;
		try {
			con=Connect.doConnection();
	        cs = con.prepareCall(ExpenseConstants.DELETE_EXPENSE);
	        cs.setInt(1, expense.getUserID());
	        cs.setInt(2, expense.getExpenseID());
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
}

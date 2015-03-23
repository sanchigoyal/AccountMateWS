package com.am.model.dao;

import java.util.List;



import java.util.Map;

import com.am.model.bean.CategoryBean;
import com.am.model.bean.ExpenseBean;
import com.am.model.bean.ExpenseBeanList;


public interface ExpenseDAO {
	public void getExpenseCategories(List<CategoryBean> categories);
	public boolean saveExpenses(ExpenseBeanList expenses);
	public void getExpensesDetails(List<ExpenseBeanList> expensesDetails,int userID,Map<String,String> dates);
	public boolean deleteExpense(ExpenseBean expense);
	public void getExpenseDetails(ExpenseBean expense);
	public boolean updateExpense(ExpenseBean expense);
}

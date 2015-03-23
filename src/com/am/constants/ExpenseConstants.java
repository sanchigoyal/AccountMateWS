package com.am.constants;

public class ExpenseConstants {
	/*-----General Constants ----*/
	
	/*-----Table Columns -------*/
	public static final String CATEGORY_ID = "category_id";
	public static final String CATEGORY = "category";
	public static final String EXPENSE_ID = "expense_id";
	public static final String DESCRIPTION = "description";
	public static final String AMOUNT = "amount";
	public static final String MODE_OF_PAYMENT_ID = "mop_id";
	public static final String MODE_OF_PAYMENT = "mop";
	public static final String BANK_ID = "bank_id";
	public static final String BANK_NAME = "bank_name";
	public static final String CHEQUE_NUMBER = "cheque_number";
	public static final String START_DATE = "startdate";
	public static final String END_DATE = "enddate";
	public static final String EXPENSE_DATE ="expense_date";
	
	/*---- Stored Procedures -----*/
	public static final String GET_EXPENSE_CATEGORY = "{call getExpenseCategories()}"; 
	public static final String SAVE_EXPENSE = "{call saveExpense(?,?,?,?,?,?,?,?)}";
	public static final String GET_EXPENSES_DETAILS = "{call getExpensesDetails(?,?,?)}";
	public static final String DELETE_EXPENSE = "{call deleteExpense(?,?)}";
	public static final String GET_EXPENSE_DETAILS = "{call getExpenseDetails(?,?)}";
	public static final String UPDATE_EXPENSE = "{call updateExpense(?,?,?,?,?,?,?,?,?)}";
}

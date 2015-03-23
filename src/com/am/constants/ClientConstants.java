package com.am.constants;

public class ClientConstants {
	/*-----General Constants ----*/
	public static final String PREVIOUS_BALANCE = "Previous Balance";
	/*-----Table Columns -------*/
	public static final String CLIENT_ID = "client_id";
	public static final String ACCOUNT_NAME = "account_name";
	public static final String FIRST_NAME = "first_name";
	public static final String LAST_NAME = "last_name";
	public static final String EMAIL = "email";
	public static final String CLIENT_CATEGORY = "client_category";
	public static final String PHONE_NUMBER = "phone_number";
	public static final String ADDRESS = "address";
	public static final String COUNTRY = "country";
	public static final String STATE = "state";
	public static final String CUSTOM_DAYS_TO_PAY = "custom_days_pay";
	public static final String OPENING_BALANCE = "opening_balance";
	public static final String TIN_NUMBER = "tin_number";
	
	public static final String DEBIT = "debit";
	public static final String CREDIT = "credit";
	public static final String START_DATE = "startdate";
	public static final String END_DATE = "enddate";
	public static final String TRANSACTION_ID = "transaction_id";
	public static final String TRANSACTION_DETAILS = "detail";
	public static final String TRANSACTION_TYPE_ID = "transaction_type_id";
	public static final String TRANSACTION_DATE = "transaction_date";
	public static final String DEBIT_VALUE = "debit_value";
	public static final String CREDIT_VALUE = "credit_value";
	public static final String REFERENCE_ID = "reference_id";
	public static final String REFERENCE_NUMBER = "reference_number";
	public static final String REFERENCE_TYPE = "reference_type";
	
	/*---- Stored Procedures -----*/
	public static final String GET_CLIENT_TRANSACTION = "{call getClientTransactions(?,?,?,?)}"; 
	public static final String DELETE_CLIENT = "{call deleteClient(?,?)}";
	public static final String GET_CLIENT_NAME ="{call getClientName(?,?)}";
	public static final String GET_CLIENT_DETAILS = "{call getClientDetails(?,?)}";
	public static final String GET_CLIENTS_DETAILS = "{call getClientsDetails(?,?)}";
	public static final String ADD_NEW_CLIENT = "{call AddNewClient(?,?,?,?,?,?,?,?,?,?,?,?,?)}";
	public static final String UPDATE_CLIENT = "{call updateClient(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
	public static final String GET_CLIENT_CATEGORY = "{call getClientCategories()}";
}

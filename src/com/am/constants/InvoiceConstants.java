package com.am.constants;

public class InvoiceConstants {
	/*-----General Constants ----*/
	public static final int RETAIL_INVOICE = 2;
	public static final int TAX_INVOICE = 3;
	/*-----Table Columns -------*/
	public static final String INVOICE_ID = "INVOICE_ID";
	public static final String INVOICE_DATE = "invoice_date";
	public static final String INVOICE_NUMBER = "invoice_number";
	public static final String INVOICE_TYPE = "invoice_type";
	public static final String INVOICE_TYPE_ID = "invoice_type_id";
	public static final String REFERENCE = "reference";
	public static final String SHIPPED_METHOD = "shipped_method";
	public static final String SHIPPED_TO = "shipped_to";
	public static final String SUB_TOTAL = "sub_total";
	public static final String VAT_TOTAL = "vat_total";
	public static final String TOTAL = "total";
	public static final String OUTSTANDING_AMT = "outstanding_amt";
	public static final String QUANTITY = "quantity";
	public static final String PRICE_WITHOUT_VAT = "price_without_vat";
	public static final String VAT_PERCENT = "vat_percent";
	public static final String PRICE_WITH_VAT = "price_with_vat";
	public static final String ITEM_TOTAL = "total";
	public static final String ACTIVE ="ACTIVE";
	public static final String INVOICE_STATUS="INVOICE_STATUS";
	public static final String PAYMENT_STATUS="PAYMENT_STATUS";
	public static final String CUSTOM_DAYS_TO_PAY ="CUSTOM_DAYS_TO_PAY";
	public static final String DATE_DIFF = "DATE_DIFF";
	
	public static final String START_DATE = "startdate";
	public static final String END_DATE = "enddate";
	
	/*---- Stored Procedures -----*/
	public static final String SAVE_PURCHASE_INVOICE = "{call savePurchaseInvoice(?,?,?,?,?,?,?,?,?,?,?,?)}";
	public static final String SAVE_PURCHASE_ITEM_DETAILS = "{call savePurchaseItemDetails(?,?,?,?,?,?,?,?,?,?)}";
	public static final String SAVE_SALES_INVOICE = "{call saveSalesInvoice(?,?,?,?,?,?,?,?,?,?,?,?)}";
	public static final String SAVE_SALES_ITEM_DETAILS = "{call saveSalesItemDetails(?,?,?,?,?,?,?,?,?)}";
	public static final String GET_INVOICE_DETAILS = "{call getInvoiceDetails(?,?)}";
	public static final String GET_INVOICE_ITEM = "{call getInvoiceItems(?,?)}";
	public static final String GET_UNPAID_INVOICE_LIST = "{call getUnpaidInvoiceList(?,?,?)}";
	public static final String GET_INVOICES_DETAILS = "{call getInvoicesDetails(?,?,?,?)}";
	public static final String GET_LATEST_BILLING_DATE = "{call getLatestBillingDate(?)}";
	public static final String DELETE_INVOICE = "{call deleteInvoice(?,?)}";
}

package com.am.model.dao;

import java.util.List;
import java.util.Map;

import com.am.model.bean.ClientBean;
import com.am.model.bean.InvoiceBean;

public interface InvoiceDAO {
		public boolean savePurchaseInvoice(InvoiceBean invoice);
		public boolean saveSalesInvoice(InvoiceBean invoice);	
		public void getInvoiceDetails(InvoiceBean invoice);
		public List<InvoiceBean> getUnpaidInvoiceList(ClientBean client,int invoiceType);
		public void getInvoicesDetails(List<InvoiceBean> invoicesPaid,List<InvoiceBean> invoicesUnPaid,List<InvoiceBean> deletedInvoices, 
				Map<String, String> dates,int userid,int invoiceTypeID);
		public void getLatestBillingDates(Map<Integer, String> dates,int userid);
		public boolean deleteInvoice(InvoiceBean invoice);
}

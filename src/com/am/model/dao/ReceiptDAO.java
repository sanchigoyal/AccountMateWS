package com.am.model.dao;

import java.util.List;

import com.am.model.bean.PaymentBean;
import com.am.model.bean.InvoiceBean;
import com.am.model.bean.ReceiptBean;

public interface ReceiptDAO {
	//public double getCashBalance(int userID);
	public boolean saveReceipt(ReceiptBean receipt);
	public boolean saveBillWiseReceipt(ReceiptBean receipt);
	public void getReceiptDetails(ReceiptBean receipt,List<InvoiceBean> invoices);
}


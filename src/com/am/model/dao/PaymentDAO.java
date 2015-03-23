package com.am.model.dao;

import java.util.List;

import com.am.model.bean.PaymentBean;
import com.am.model.bean.InvoiceBean;

public interface PaymentDAO {
	public double getCashBalance(int userID);
	public boolean savePayment(PaymentBean payment);
	public boolean saveBillWisePayment(PaymentBean payment);
	public void getPaymentDetails(PaymentBean payment,List<InvoiceBean> invoices);
}

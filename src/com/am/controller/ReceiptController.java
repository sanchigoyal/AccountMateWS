package com.am.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.am.model.bean.ClientBean;
import com.am.model.bean.InvoiceBean;
import com.am.model.bean.ReceiptBean;
import com.am.model.dao.ClientDAO;
import com.am.model.dao.ClientDAOImpl;
import com.am.model.dao.InvoiceDAO;
import com.am.model.dao.InvoiceDAOImpl;
import com.am.model.dao.ReceiptDAO;
import com.am.model.dao.ReceiptDAOImpl;


@Controller
public class ReceiptController {
	private double total =0;
	private double totalOutstanding =0;
	private double subTotal =0;
	private double vatTotal =0;
	ClientDAO clientDAO = new ClientDAOImpl();	
	InvoiceDAO invoiceDAO = new InvoiceDAOImpl();
	ReceiptDAO receiptDAO = new ReceiptDAOImpl();
	
	static Logger LOGGER = Logger.getLogger(ReceiptController.class.getName());
	
	@RequestMapping(value = "/getInvoiceReceiptDetails", method = RequestMethod.GET)
	public ModelAndView getInvoiceReceiptDetails(@RequestParam("invoiceid") String invoiceid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		InvoiceBean invoice = new InvoiceBean();
		invoice.setInvoiceID(Integer.parseInt(invoiceid));
		invoice.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to get Invoice Receipt Detail :: Invoice ID - "+invoice.getInvoiceID()+" :: User - "+invoice.getUserID());
		invoiceDAO.getInvoiceDetails(invoice);
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		List<ClientBean> clients = new ArrayList<ClientBean>();
		ClientBean client = new ClientBean();
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		client.setClientID(invoice.getClientID());
		clientDAO.getClientDetails(client);
		invoices.add(invoice);
		clients.add(client);
		getTotalOutstanding(invoices);
		model.addAttribute("invoices",invoices);
		model.addAttribute("invoicesList",invoices);
		model.addAttribute("clients",clients);
		model.addAttribute("subTotal",subTotal);
		model.addAttribute("vatTotal",vatTotal);
		model.addAttribute("total",total);
		model.addAttribute("outstandingAmount",totalOutstanding);
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(client.getUserID(),banks,4);
	    model.addAttribute("banks",banks);
		ModelAndView mav = new ModelAndView();
		String viewName = "receipt/receiptgateway";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping(value = "/viewReceipt", method = RequestMethod.GET)
	public ModelAndView viewReceipt(@RequestParam("receiptid") String receiptid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		ReceiptBean receipt = new ReceiptBean();
		receipt.setReceiptID(Integer.parseInt(receiptid));
		receipt.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to view receipt :: Receipt ID - "+receipt.getReceiptID()+" :: User - "+receipt.getUserID());
		List<InvoiceBean> invoices = new ArrayList<InvoiceBean>();
		receiptDAO.getReceiptDetails(receipt,invoices);
		model.addAttribute("receipt",receipt);
		model.addAttribute("invoices",invoices);
		ModelAndView mav = new ModelAndView();
		String viewName = "receipt/receipt";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping(value = "/getInvoicesReceiptDetails", method = RequestMethod.GET)
	public ModelAndView getInvoicesReceiptDetails(@RequestParam("invoicelist") String invoicelist,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		List<String> invoiceList = Arrays.asList(invoicelist.split(","));
		int userid = Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to get Invoices Receipt Details :: Invoices - "+invoicelist+" :: User - "+userid);
		InvoiceBean invoice = null;
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		for(String invoiceid : invoiceList){
			if(invoiceid != null && !invoiceid.isEmpty()){	
				invoice = new InvoiceBean();
				invoice.setInvoiceID(Integer.parseInt(invoiceid));
				invoice.setUserID(userid);
				invoiceDAO.getInvoiceDetails(invoice);
				invoices.add(invoice);
			}
		}
		getTotalOutstanding(invoices);
		model.addAttribute("invoicesList",invoices);
		model.addAttribute("subTotal",subTotal);
		model.addAttribute("vatTotal",vatTotal);
		model.addAttribute("total",total);
		model.addAttribute("outstandingAmount",totalOutstanding);
		ModelAndView mav = new ModelAndView();
		String viewName = "layout/gatewaytables";
		mav.setViewName(viewName);
		return mav;
	}
	
	/*@RequestMapping(value = "/checkCashBalanceAvailability", method = RequestMethod.GET)
	public @ResponseBody String checkCashBalanceAvailability(@RequestParam("amount") String amount,HttpServletRequest request) {
		HttpSession session = request.getSession();
		double balance =0;
		LOGGER.info("Request to check cash balance availability :: User - "+session.getAttribute("userid"));
		balance = paymentDAO.getCashBalance(Integer.parseInt((String)session.getAttribute("userid")));
		if(balance > Double.parseDouble(amount)){
			return "yes";
		}
		return "no";
	}*/
	
	@RequestMapping("/recordReceipt")
	 public String recordReceipt(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to Receipt Gateway :: User - "+userid);
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<InvoiceBean> invoices = new ArrayList<InvoiceBean>();
		clientDAO.getClientsDetails(userid,clients,1);
		if(clients.size()>0){
			invoices = invoiceDAO.getUnpaidInvoiceList(clients.get(0),2);
		}
		model.addAttribute("clients",clients);
		model.addAttribute("invoices",invoices);
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(userid,banks,4);
	    model.addAttribute("banks",banks);
		return "receipt/recordreceipt";
	}
	@RequestMapping("/saveReceiptDetails")
	public String saveReceiptDetails(ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Map<String,String> dates = new HashMap<String,String>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to save receipt details :: User - "+session.getAttribute("userid"));
		ReceiptBean receipt = null;
		try{
			if(request.getParameter("billWiseReceipt") != null){
				//bill wise payment
				receipt=extractBillWiseReceiptDetails(request);
				processBillWiseReceiptDetails(receipt);
				receipt.setReceiptDate(formatter.parse(request.getParameter("reptdate")));
				flag=receiptDAO.saveBillWiseReceipt(receipt);
			}
			else{
				receipt=extractReceiptDetails(request);
				receipt.setReceiptDate(formatter.parse(request.getParameter("reptdate")));
				flag=receiptDAO.saveReceipt(receipt);
			}
		}
		catch (ParseException pe) {
			LOGGER.error(pe.getMessage(),pe);
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to save receipt. Please check with support team for assistance.");
		}
		String requestFrom =request.getParameter("requestfrom");
		if(flag){
			model.addAttribute("success","true");
			model.addAttribute("message","Receipt saved Successfull.");
			LOGGER.info("Receipt Successfull :: User - "+receipt.getUserID());
		}else{
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to save receipt.");
			LOGGER.error("Failed to save receipt  :: User - "+receipt.getUserID());
		}
		
		if(requestFrom != null && !requestFrom.equals("") && !requestFrom.isEmpty() &&requestFrom.equals("modal")){
			dates.put("startdate",request.getParameter("requestdatefrom"));
			dates.put("enddate", request.getParameter("requestdateto"));
			List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
			List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
			List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
			invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,receipt.getUserID(),2);
			model.addAttribute("invoicesP",invoicesPaid);
			model.addAttribute("invoicesUP",invoicesUnPaid);
			model.addAttribute("deletedinvoices",deletedInvoices);
			model.addAttribute("startdate",dates.get("startdate"));
			model.addAttribute("enddate",dates.get("enddate"));
			model.addAttribute("unpaidBills",invoicesUnPaid.size());
			model.addAttribute("paidBills",invoicesPaid.size());
			model.addAttribute("deletedBills",deletedInvoices.size());
			//Get total outstanding amount
			getTotalOutstanding(invoicesPaid);
			model.addAttribute("paidTotal",total);
			getTotalOutstanding(invoicesUnPaid);
			model.addAttribute("unpaidOutstanding",totalOutstanding);
			model.addAttribute("unpaidTotal",total);
			return "invoice/salesbook";
		}
		
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<InvoiceBean> invoices = new ArrayList<InvoiceBean>();
		clientDAO.getClientsDetails(receipt.getUserID(),clients,1);
		invoices = invoiceDAO.getUnpaidInvoiceList(clients.get(0),2);
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(receipt.getUserID(),banks,4);
	    model.addAttribute("banks",banks);
		model.addAttribute("clients",clients);
		model.addAttribute("invoices",invoices);
		return "receipt/recordreceipt";
	}
	
	private void getTotalOutstanding(List<InvoiceBean> invoices){
		total = 0;
		totalOutstanding =0;
		vatTotal =0;
		subTotal =0;
		for(InvoiceBean invoice : invoices){
			subTotal +=invoice.getSubTotal();
			vatTotal +=invoice.getVatTotal();
			total += invoice.getTotal();
			totalOutstanding +=invoice.getOutstandingAmount();
		}
	}
	private void processBillWiseReceiptDetails(ReceiptBean receipt){
		//Logic for processing payment
		Map<Integer,Double> invoicesOutstanding = new HashMap<Integer,Double>();
		Map<Integer,Double> invoiceList = receipt.getInvoiceList();
		InvoiceBean invoice = null;
		for(int invoiceID : invoiceList.keySet()){
			invoice = new InvoiceBean();
			invoice.setInvoiceID(invoiceID);
			invoice.setUserID(receipt.getUserID());
			invoiceDAO.getInvoiceDetails(invoice);
			invoicesOutstanding.put(invoiceID,invoice.getOutstandingAmount());
		}
		 invoicesOutstanding = sortByValue(invoicesOutstanding);
		 double tempPaidAmount = receipt.getPaidAmount();
		 for(int invoiceid: invoiceList.keySet()){
			 if(tempPaidAmount != 0){
				 if(invoicesOutstanding.get(invoiceid) <= tempPaidAmount){
					 invoiceList.put(invoiceid,0.0);
					 tempPaidAmount -= invoicesOutstanding.get(invoiceid);
				 }
				 else{
					 invoiceList.put(invoiceid, invoicesOutstanding.get(invoiceid)-tempPaidAmount);
					 tempPaidAmount = 0;
				 }
			 }
			 else{
				 invoiceList.put(invoiceid, invoicesOutstanding.get(invoiceid));
			 }
		 }
		 receipt.setInvoiceList(invoiceList);
	}
	
	public static <K, V extends Comparable<? super V>> Map<K, V> sortByValue( Map<K, V> map )
	{
	    List<Map.Entry<K, V>> list =
	        new LinkedList<>( map.entrySet() );
	    Collections.sort( list, new Comparator<Map.Entry<K, V>>()
	    {
	        @Override
	        public int compare( Map.Entry<K, V> o1, Map.Entry<K, V> o2 )
	        {
	            return (o1.getValue()).compareTo( o2.getValue() );
	        }
	    } );
	
	    Map<K, V> result = new LinkedHashMap<>();
	    for (Map.Entry<K, V> entry : list)
	    {
	        result.put( entry.getKey(), entry.getValue() );
	    }
	    return result;
	}
	private ReceiptBean extractBillWiseReceiptDetails(HttpServletRequest request){
		ReceiptBean receipt = new ReceiptBean();
		HttpSession session = request.getSession();
		Map<Integer,Double> invoiceList = new HashMap<Integer,Double>();
		receipt.setClientID(Integer.parseInt(request.getParameter("clientname")));
		for(String invoiceid : Arrays.asList(request.getParameterValues("billnumber"))){
			invoiceList.put(Integer.parseInt(invoiceid),0.0);
		}
		receipt.setInvoiceList(invoiceList);
		receipt.setPaidAmount(Double.parseDouble(request.getParameter("pay")));
		receipt.setModeOfPaymentID(Integer.parseInt(request.getParameter("mop")));
		receipt.setCashDetails(request.getParameter("cashdetails"));
		receipt.setBankID(Integer.parseInt(request.getParameter("bank")));
		receipt.setChequeNumber(request.getParameter("chequeNumber"));
		receipt.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		return receipt;
	}
	
	private ReceiptBean extractReceiptDetails(HttpServletRequest request){
		ReceiptBean receipt = new ReceiptBean();
		HttpSession session = request.getSession();
		receipt.setClientID(Integer.parseInt(request.getParameter("clientname")));
		receipt.setPaidAmount(Double.parseDouble(request.getParameter("pay")));
		receipt.setModeOfPaymentID(Integer.parseInt(request.getParameter("mop")));
		receipt.setCashDetails(request.getParameter("cashdetails"));
		receipt.setBankID(Integer.parseInt(request.getParameter("bank")));
		receipt.setChequeNumber(request.getParameter("chequeNumber"));
		receipt.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		return receipt;
	}
}

package com.am.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.am.constants.InvoiceConstants;
import com.am.helper.Helper;
import com.am.model.bean.ClientBean;
import com.am.model.bean.InvoiceBean;
import com.am.model.bean.ItemBean;
import com.am.model.bean.ProductBean;
import com.am.model.dao.ClientDAO;
import com.am.model.dao.ClientDAOImpl;
import com.am.model.dao.InvoiceDAO;
import com.am.model.dao.InvoiceDAOImpl;
import com.am.model.dao.ProductDAO;
import com.am.model.dao.ProductDAOImpl;

@Controller
public class InvoiceController {
	private double total =0;
	private double totalOutstanding =0;
	static Logger LOGGER = Logger.getLogger(InvoiceController.class.getName());
	ProductDAO productDAO = new ProductDAOImpl();
	ClientDAO clientDAO = new ClientDAOImpl();
	InvoiceDAO invoiceDAO = new InvoiceDAOImpl();
	
	@RequestMapping("/createPurchaseInvoice")
	 public String createPurchaseInvoice(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to create purchase invoice :: User - "+userid);
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		clientDAO.getClientsDetails(userid,clients,2);
		productDAO.getProductsDetails(userid, products,-1);
		model.addAttribute("clients", clients);
		model.addAttribute("products",products);
		model.addAttribute("command", new InvoiceBean());
		return "purchaseinvoice";
	}
	
	@RequestMapping(value = "/getInvoiceList", method = RequestMethod.GET)
	public ModelAndView getClientsInvoicePaymentDetails(@RequestParam("clientid") String clientid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		ClientBean client = new ClientBean();
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.info("Request to get client's invoice list :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID() );
		invoices = invoiceDAO.getUnpaidInvoiceList(client,1);
		model.addAttribute("invoices",invoices);
		ModelAndView mav = new ModelAndView();
		String viewName = "paymentgatewayinvoicedropdown";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping(value = "/getReceiptInvoiceList", method = RequestMethod.GET)
	public ModelAndView getClientsInvoiceReceiptDetails(@RequestParam("clientid") String clientid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		ClientBean client = new ClientBean();
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.info("Request to get client's invoice list :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID() );
		invoices = invoiceDAO.getUnpaidInvoiceList(client,2);
		model.addAttribute("invoices",invoices);
		ModelAndView mav = new ModelAndView();
		String viewName = "receiptgatewayinvoicedropdown";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping("/createSalesInvoice")
	 public String createSalesInvoice(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		Map<Integer,String> dates = new HashMap<Integer,String>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		invoiceDAO.getLatestBillingDates(dates, userid);
		LOGGER.info("Request to create sales invoice :: User - "+userid);
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		clientDAO.getClientsDetails(userid,clients,1);
		productDAO.getProductsDetails(userid, products,-1);
		model.addAttribute("clients", clients);
		model.addAttribute("products",products);
		model.addAttribute("latestretaildate",dates.get(InvoiceConstants.RETAIL_INVOICE));
		model.addAttribute("latesttaxdate",dates.get(InvoiceConstants.TAX_INVOICE));
		model.addAttribute("command", new InvoiceBean());
		return "salesinvoice";
	}
	
	@RequestMapping(value = "/viewInvoice", method = RequestMethod.GET)
	public ModelAndView viewInvoice(@RequestParam("invoiceid") String invoiceid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		InvoiceBean invoice = new InvoiceBean();
		invoice.setInvoiceID(Integer.parseInt(invoiceid));
		invoice.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to view invoice :: Invoice ID - "+invoice.getInvoiceID()+" :: User - "+invoice.getUserID());
		invoiceDAO.getInvoiceDetails(invoice);
		model.addAttribute("invoice",invoice);
		ModelAndView mav = new ModelAndView();
		String viewName = "invoice";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping("/savePurchaseInvoice")
	public String savePurchaseInvoice(@ModelAttribute("AccountmateWS")InvoiceBean iBean, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag = false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to save purchase invoice :: User - "+userid);
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		InvoiceBean invoice = getInvoiceDetails(iBean);
		invoice.setUserID(userid);
		try {
			Date date = formatter.parse(request.getParameter("invoicedate"));
			invoice.setDate(date);
			LOGGER.debug("Request Details Client ID -"+invoice.getClientID()+" :: Date - "+invoice.getDate()
					+" :: Client TIN - "+invoice.getClientTIN()+" :: Invoice Number - "+invoice.getBillNumber()
					+" :: Shipped To - "+invoice.getShippedTo()+" :: Shipping Method - "+invoice.getShippedMethod()
					+" :: Reference - "+invoice.getReference()+" :: Sub Total - "+invoice.getSubTotal()
					+" :: VAT total - "+invoice.getVatTotal()+" :: Total - "+invoice.getTotal()+" :: User - "+invoice.getUserID());
			flag=invoiceDAO.savePurchaseInvoice(invoice);
			if(flag){
				model.addAttribute("success","true");
				model.addAttribute("message","Order Saved Successfully.");
				LOGGER.info("Order Saved Successfully :: User - "+invoice.getUserID());
			}
			else{
				model.addAttribute("success","false");
				model.addAttribute("message","Failed to save order. Please check with support team for assistance.");
				LOGGER.error("Failed to save order :: User - "+invoice.getUserID());
			}
		} catch (ParseException pe) {
			LOGGER.error(pe.getMessage(),pe);
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to save order. Please check with support team for assistance.");
		}
		finally{
			clientDAO.getClientsDetails(userid,clients,2);
			productDAO.getProductsDetails(userid, products,-1);
			model.addAttribute("clients", clients);
			model.addAttribute("products",products);
			model.addAttribute("command", new InvoiceBean());
		}
		return "purchaseinvoice";
	}
	
	@RequestMapping("/saveSalesInvoice")
	public String saveSalesInvoice(@ModelAttribute("AccountmateWS")InvoiceBean iBean, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Map<Integer,String> dates = new HashMap<Integer,String>();
		boolean flag = false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to save sales invoice :: User - "+userid);
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		InvoiceBean invoice = getInvoiceDetails(iBean);
		invoice.setUserID(userid);
		try {
			Date date = null;
			if(invoice.getInvoiceTypeID() == InvoiceConstants.TAX_INVOICE){
				date= formatter.parse(request.getParameter("taxinvoicedate"));
			}
			else{
				date= formatter.parse(request.getParameter("retailinvoicedate"));
			}
			invoice.setDate(date);
			LOGGER.debug("Request Details Client ID -"+invoice.getClientID()+" :: Date - "+invoice.getDate()
					+" :: Invoice Type ID - "+invoice.getInvoiceTypeID()
					+" :: Client TIN - "+invoice.getClientTIN()+" :: Invoice Number - "+invoice.getBillNumber()
					+" :: Shipped To - "+invoice.getShippedTo()+" :: Shipping Method - "+invoice.getShippedMethod()
					+" :: Reference - "+invoice.getReference()+" :: Sub Total - "+invoice.getSubTotal()
					+" :: VAT total - "+invoice.getVatTotal()+" :: Total - "+invoice.getTotal()+" :: User - "+invoice.getUserID());
			flag=invoiceDAO.saveSalesInvoice(invoice);
			if(flag){
				model.addAttribute("success","true");
				model.addAttribute("message","Invoice Saved Successfully. Invoice No. : "+invoice.getBillNumber());
				LOGGER.info("Invoice Saved Successfully :: User - "+invoice.getUserID());
			}
			else{
				model.addAttribute("success","false");
				model.addAttribute("message","Failed to save invoice. Please check with support team for assistance.");
				LOGGER.error("Failed to save invoice :: User - "+invoice.getUserID());
			}
		} catch (ParseException pe) {
			LOGGER.error(pe.getMessage(),pe);
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to save invoice. Please check with support team for assistance.");
		}
		finally{
			invoiceDAO.getLatestBillingDates(dates, userid);
			clientDAO.getClientsDetails(userid,clients,1);
			productDAO.getProductsDetails(userid, products,-1);
			model.addAttribute("clients", clients);
			model.addAttribute("products",products);
			model.addAttribute("latestretaildate",dates.get(InvoiceConstants.RETAIL_INVOICE));
			model.addAttribute("latesttaxdate",dates.get(InvoiceConstants.TAX_INVOICE));
			model.addAttribute("command", new InvoiceBean());
		}
		return "salesinvoice";
	}
	
	@RequestMapping("/showPurchaseBook")
	public String showPurchaseBook(ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to show purchase book :: User - "+userid);
		Map<String,String> dates = new HashMap<String,String>();
		if(request.getParameter("datefrom")!= null && !request.getParameter("datefrom").equals("")){
			dates.put("startdate",request.getParameter("datefrom"));
			dates.put("enddate", request.getParameter("dateto"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+userid);
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+userid);
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,userid,1);
		model.addAttribute("invoicesP",invoicesPaid);
		model.addAttribute("invoicesUP",invoicesUnPaid);
		model.addAttribute("deletedinvoices",deletedInvoices);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		model.addAttribute("unpaidBills",invoicesUnPaid.size());
		model.addAttribute("paidBills",invoicesPaid.size());
		model.addAttribute("deletedBills",deletedInvoices.size());
		getTotalOutstanding(invoicesPaid);
		model.addAttribute("paidTotal",total);
		getTotalOutstanding(invoicesUnPaid);
		model.addAttribute("unpaidOutstanding",totalOutstanding);
		model.addAttribute("unpaidTotal",total);
		return "purchasebook";
	}
	
	@RequestMapping("/showSalesBook")
	public String showSalesBook(ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to show sales book :: User - "+userid);
		Map<String,String> dates = new HashMap<String,String>();
		if(request.getParameter("datefrom")!= null && !request.getParameter("datefrom").equals("")){
			dates.put("startdate",request.getParameter("datefrom"));
			dates.put("enddate", request.getParameter("dateto"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+userid);
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+userid);
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,userid,2);
		model.addAttribute("invoicesP",invoicesPaid);
		model.addAttribute("invoicesUP",invoicesUnPaid);
		model.addAttribute("deletedinvoices",deletedInvoices);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		model.addAttribute("unpaidBills",invoicesUnPaid.size());
		model.addAttribute("paidBills",invoicesPaid.size());
		model.addAttribute("deletedBills",deletedInvoices.size());
		getTotalOutstanding(invoicesPaid);
		model.addAttribute("paidTotal",total);
		getTotalOutstanding(invoicesUnPaid);
		model.addAttribute("unpaidOutstanding",totalOutstanding);
		model.addAttribute("unpaidTotal",total);
		return "salesbook";
	}
	
	@RequestMapping("/deleteInvoice")
	public String deleteInvoice(@ModelAttribute("AccountmateWS")InvoiceBean invoice,ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		boolean flag =false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		invoice.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to delete a invoice :: Invoice ID - "+invoice.getInvoiceID()+" :: User - "+invoice.getUserID());
		Map<String,String> dates = new HashMap<String,String>();
		dates.put("startdate",request.getParameter("redirectstartdate"));
		dates.put("enddate", request.getParameter("redirectenddate"));
		String redirectPage = request.getParameter("redirectpage");
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+invoice.getUserID());
		flag=invoiceDAO.deleteInvoice(invoice);
		if(flag){
			LOGGER.info("Invoice deleted successfully :: User - "+invoice.getUserID());
			model.addAttribute("success","true");
			model.addAttribute("message","Invoice Deleted Successfully.");
		}
		else{
			LOGGER.info("Failed to delete invoice :: User - "+invoice.getUserID());
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to delete invoice. Please check with support team for assistance.");
		}
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		if(redirectPage.equals("purchasebook")){
			invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,invoice.getUserID(),1);
		}else{
			invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,invoice.getUserID(),2);
		}
		model.addAttribute("invoicesP",invoicesPaid);
		model.addAttribute("invoicesUP",invoicesUnPaid);
		model.addAttribute("deletedinvoices",deletedInvoices);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		model.addAttribute("unpaidBills",invoicesUnPaid.size());
		model.addAttribute("paidBills",invoicesPaid.size());
		model.addAttribute("deletedBills",deletedInvoices.size());
		getTotalOutstanding(invoicesPaid);
		model.addAttribute("paidTotal",total);
		getTotalOutstanding(invoicesUnPaid);
		model.addAttribute("unpaidOutstanding",totalOutstanding);
		model.addAttribute("unpaidTotal",total);
		return redirectPage;
	}
	
	private void getTotalOutstanding(List<InvoiceBean> invoices){
		total = 0;
		totalOutstanding =0;
		for(InvoiceBean invoice : invoices){
			total += invoice.getTotal();
			totalOutstanding +=invoice.getOutstandingAmount();
		}
	}
	
	private InvoiceBean getInvoiceDetails(InvoiceBean iBean){
		InvoiceBean invoice = new InvoiceBean();
		List<ItemBean> invoiceItem = new ArrayList<ItemBean>();
		//Copy valid details from request to invoice.
		invoice.setClientID(iBean.getClientID());
		invoice.setClientTIN(iBean.getClientTIN());
		invoice.setBillNumber(iBean.getBillNumber());
		invoice.setInvoiceTypeID(iBean.getInvoiceTypeID());
		invoice.setShippedTo(iBean.getShippedTo());
		invoice.setShippedMethod(iBean.getShippedMethod());
		invoice.setReference(iBean.getReference());
		for(ItemBean item :iBean.getItems()){
			if(item.getProductID()!=0){
				if(!item.getApplyVat()){
					item.setVatPercent(0.0); //Making vat percent to zero if not applied.
				}
				invoiceItem.add(item);
			}
		}
		invoice.setItems(invoiceItem);
		invoice.setSubTotal(iBean.getSubTotal());
		invoice.setVatTotal(iBean.getVatTotal());
		invoice.setTotal(iBean.getTotal());
		return invoice;
	}
}


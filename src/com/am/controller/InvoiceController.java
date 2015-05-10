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

import com.am.constants.AccountConstants;
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
	
	/**
	 * Method to create new purchase invoice
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/createPurchaseInvoice")
	 public String createPurchaseInvoice(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		
		int userid=Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME));
		LOGGER.info("Request to create purchase invoice :: User - "+userid);
		clientDAO.getClientsDetails(userid,clients,2);
		productDAO.getProductsDetails(userid, products,-1);
		model.addAttribute("clients", clients);
		model.addAttribute("products",products);
		model.addAttribute("command", new InvoiceBean());
		return "invoice/purchaseinvoice";
	}
	
	/**
	 * Method to get list of invoices for a client
	 * @param clientid
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/getInvoiceList", method = RequestMethod.GET)
	public ModelAndView getClientsInvoicePaymentDetails(@RequestParam("clientid") String clientid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		ClientBean client = new ClientBean();
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.info("Request to get client's invoice list :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID() );
		invoices = invoiceDAO.getUnpaidInvoiceList(client,1);
		model.addAttribute("invoices",invoices);
		ModelAndView mav = new ModelAndView();
		String viewName = "layout/gatewayinvoicedropdown";
		mav.setViewName(viewName);
		return mav;
	}
	
	/**
	 * Method to get receipts of client
	 * @param clientid
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/getReceiptInvoiceList", method = RequestMethod.GET)
	public ModelAndView getClientsInvoiceReceiptDetails(@RequestParam("clientid") String clientid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		List<InvoiceBean> invoices= new ArrayList<InvoiceBean>();
		ClientBean client = new ClientBean();
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.info("Request to get client's invoice list :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID() );
		invoices = invoiceDAO.getUnpaidInvoiceList(client,2);
		model.addAttribute("invoices",invoices);
		ModelAndView mav = new ModelAndView();
		String viewName = "layout/gatewayinvoicedropdown";
		mav.setViewName(viewName);
		return mav;
	}
	
	/**
	 * Method to create sales invoice
	 * @param cBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/createSalesInvoice")
	 public String createSalesInvoice(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		Map<Integer,String> dates = new HashMap<Integer,String>();
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		
		int userid=Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME));
		invoiceDAO.getLatestBillingDates(dates, userid);
		LOGGER.info("Request to create sales invoice :: User - "+userid);
		clientDAO.getClientsDetails(userid,clients,1);
		productDAO.getProductsDetails(userid, products,-1);
		model.addAttribute("clients", clients);
		model.addAttribute("products",products);
		model.addAttribute("latestretaildate",dates.get(InvoiceConstants.RETAIL_INVOICE));
		model.addAttribute("latesttaxdate",dates.get(InvoiceConstants.TAX_INVOICE));
		model.addAttribute("command", new InvoiceBean());
		return "invoice/salesinvoice";
	}
	
	/**
	 * Method to view invoice details
	 * @param invoiceid
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/viewInvoice", method = RequestMethod.GET)
	public ModelAndView viewInvoice(@RequestParam("invoiceid") String invoiceid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		InvoiceBean invoice = new InvoiceBean();
		invoice.setInvoiceID(Integer.parseInt(invoiceid));
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to view invoice :: Invoice ID - "+invoice.getInvoiceID()+" :: User - "+invoice.getUserID());
		invoiceDAO.getInvoiceDetails(invoice);
		model.addAttribute("invoice",invoice);
		ModelAndView mav = new ModelAndView();
		String viewName = "invoice/invoice";
		mav.setViewName(viewName);
		return mav;
	}
	
	
	
	/**
	 * Method to save purchase invoice
	 * @param iBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/savePurchaseInvoice")
	public String savePurchaseInvoice(@ModelAttribute("AccountmateWS")InvoiceBean iBean, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag = false;
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		
		InvoiceBean invoice = getInvoiceDetails(iBean);
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to save purchase invoice :: User - "+invoice.getUserID());
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
			clientDAO.getClientsDetails(invoice.getUserID(),clients,2);
			productDAO.getProductsDetails(invoice.getUserID(), products,-1);
			model.addAttribute("clients", clients);
			model.addAttribute("products",products);
			model.addAttribute("command", new InvoiceBean());
		}
		return "invoice/purchaseinvoice";
	}
	
	/**
	 * Method to save sales invoice
	 * @param iBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/saveSalesInvoice")
	public String saveSalesInvoice(@ModelAttribute("AccountmateWS")InvoiceBean iBean, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		Map<Integer,String> dates = new HashMap<Integer,String>();
		boolean flag = false;
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		InvoiceBean invoice = getInvoiceDetails(iBean);
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to save sales invoice :: User - "+invoice.getUserID());
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
			invoiceDAO.getLatestBillingDates(dates, invoice.getUserID());
			clientDAO.getClientsDetails(invoice.getUserID(),clients,1);
			productDAO.getProductsDetails(invoice.getUserID(), products,-1);
			model.addAttribute("clients", clients);
			model.addAttribute("products",products);
			model.addAttribute("latestretaildate",dates.get(InvoiceConstants.RETAIL_INVOICE));
			model.addAttribute("latesttaxdate",dates.get(InvoiceConstants.TAX_INVOICE));
			model.addAttribute("command", new InvoiceBean());
		}
		return "invoice/salesinvoice";
	}
	
	/**
	 * Method to show purchase book
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/showPurchaseBook")
	public String showPurchaseBook(ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		InvoiceBean invoice = new InvoiceBean();
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		Map<String,String> dates = new HashMap<String,String>();
		
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to show purchase book :: User - "+invoice.getUserID());
		if(request.getParameter("datefrom")!= null && !request.getParameter("datefrom").equals("")){
			dates.put("startdate",request.getParameter("datefrom"));
			dates.put("enddate", request.getParameter("dateto"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+invoice.getUserID());
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+invoice.getUserID());
		invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,invoice.getUserID(),1);
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
		return "invoice/purchasebook";
	}
	
	/**
	 * Method to show sales book
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/showSalesBook")
	public String showSalesBook(ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		InvoiceBean invoice = new InvoiceBean();
		Map<String,String> dates = new HashMap<String,String>();
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to show sales book :: User - "+invoice.getUserID());
		if(request.getParameter("datefrom")!= null && !request.getParameter("datefrom").equals("")){
			dates.put("startdate",request.getParameter("datefrom"));
			dates.put("enddate", request.getParameter("dateto"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+invoice.getUserID());
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+invoice.getUserID());
		invoiceDAO.getInvoicesDetails(invoicesPaid,invoicesUnPaid,deletedInvoices,dates,invoice.getUserID(),2);
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
		return "invoice/salesbook";
	}
	
	/**
	 * Method to delete a invoice
	 * @param invoice
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/deleteInvoice")
	public String deleteInvoice(@ModelAttribute("AccountmateWS")InvoiceBean invoice,ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		boolean flag =false;
		Map<String,String> dates = new HashMap<String,String>();
		String redirectPage = null;
		List<InvoiceBean> invoicesPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> invoicesUnPaid = new ArrayList<InvoiceBean>();
		List<InvoiceBean> deletedInvoices = new ArrayList<InvoiceBean>();
		
		invoice.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to delete a invoice :: Invoice ID - "+invoice.getInvoiceID()+" :: User - "+invoice.getUserID());
		dates.put("startdate",request.getParameter("redirectstartdate"));
		dates.put("enddate", request.getParameter("redirectenddate"));
		redirectPage = request.getParameter("redirectpage");
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
		if(redirectPage.equals("invoice/purchasebook")){
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
	
	/**
	 * Method to get total outstanding
	 * @param invoices
	 */
	private void getTotalOutstanding(List<InvoiceBean> invoices){
		total = 0;
		totalOutstanding =0;
		for(InvoiceBean invoice : invoices){
			total += invoice.getTotal();
			totalOutstanding +=invoice.getOutstandingAmount();
		}
	}
	
	/**
	 * Method to filter invoice details
	 * @param iBean
	 * @return
	 */
			
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
		invoice.setCustomDaysToPay(iBean.getCustomDaysToPay());
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


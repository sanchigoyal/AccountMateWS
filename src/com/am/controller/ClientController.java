package com.am.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.am.constants.AccountConstants;
import com.am.helper.Helper;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ClientBean;
import com.am.model.bean.TransactionBean;
import com.am.model.dao.ClientDAO;
import com.am.model.dao.ClientDAOImpl;



@Controller
public class ClientController {
	ClientDAO clientDAO = new ClientDAOImpl();
	static Logger LOGGER = Logger.getLogger(ClientController.class.getName());
	
	/**
	 * Redirect method to new client page
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/newClient")
	   public String newClient(ModelMap model,HttpServletRequest request) {
		 List<CategoryBean> categories = new ArrayList<CategoryBean>();
		 clientDAO.getCategoryDetails(categories);
	     model.addAttribute("categories",categories);
	     model.addAttribute("command",new ClientBean());
	     return "client/newclient";
	   }
	
	/**
	 * Method to get client list
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/clientList")
	 public String getClientList(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		int category =0;
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		ClientBean client = new ClientBean();
		double totalBalance = 0;
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request for client list :: User - "+client.getUserID());
		if(request.getParameter("option")!=null && request.getParameter("option") !=""){
				category=Integer.parseInt(request.getParameter("option"));
				LOGGER.debug("Requested Client Category - "+category+" :: User - "+client.getUserID());
				totalBalance=clientDAO.getClientsDetails(client.getUserID(), clients, category);
				model.addAttribute("category",category);
		}
		else{
			LOGGER.debug("Requested Client Category - All(-1) :: User - "+client.getUserID());
			totalBalance=clientDAO.getClientsDetails(client.getUserID(), clients, -1);
			model.addAttribute("category",-1);
		}
		model.addAttribute("clients",clients);
		model.addAttribute("numberofclients",clients.size());
		model.addAttribute("totalBalance",totalBalance);
		clientDAO.getCategoryDetails(categories);
	    model.addAttribute("categories",categories);
	    model.addAttribute("command",new ClientBean());
		return "client/clientlist";
	}
	
	/**
	 * Method to delete a client
	 * @param client
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/deleteClient")
	public String deleteClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		boolean flag=false;
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalBalance = 0;
		
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to delete a client :: Client ID - "+client.getClientID()
				+" :: User - "+client.getUserID());
		flag=clientDAO.deleteClient(client);
		if(flag== true){
			LOGGER.info("Client Deleted Successfully :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
			model.addAttribute("success","true");
			model.addAttribute("message","Client Deleted Successfully");
		}
		else{
			LOGGER.info("Failed to delete client :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to delete client. Please check with support team for assistance.");
		}
		LOGGER.debug("Client Category - "+client.getClientCategory()+" :: User - "+client.getUserID());
		totalBalance=clientDAO.getClientsDetails(client.getUserID(), clients,client.getClientCategory());
		model.addAttribute("category",client.getClientCategory());
		model.addAttribute("clients",clients);
		model.addAttribute("totalBalance",totalBalance);
		model.addAttribute("numberofclients",clients.size());
		model.addAttribute("command",new ClientBean());
		clientDAO.getCategoryDetails(categories);
        model.addAttribute("categories",categories);
		return "client/clientlist";
	}
	
	/**
	 * Method to get client TIN
	 * @param clientid
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getClientTIN", method = RequestMethod.GET)
	public @ResponseBody String processAJAXRequest(@RequestParam("clientid") String clientid,HttpServletRequest request) {
		HttpSession session = request.getSession();
		ClientBean client = new ClientBean();
	
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to get Client TIN :: User - "+client.getUserID());
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
		clientDAO.getClientDetails(client);
		LOGGER.debug("User - "+client.getUserID()+" :: Client ID - "+client.getClientID()
				+" :: Client TIN - "+client.getClientTIN());
		return client.getClientTIN();
	}
	
	/**
	 * Method to get client ledger for current month
	 * @param cBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/clientLedger")
	 public String getClientLedger(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ClientBean client = new ClientBean();
		Map<String,String> dates = new HashMap<String,String>();
		
		if(request.getParameter("clientid")== null || request.getParameter("clientid")==""){
			return "home";
		}
		client.setClientID(Integer.parseInt(request.getParameter("clientid")));
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to get client legder :: User - "+client.getUserID());
		dates = Helper.getDateRange();
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+client.getUserID());
		clientDAO.getClientLedger(client,transactions,dates);
		model.addAttribute("client",client);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "client/clientledger";
	}
	
	/**
	 * Method to get client ledger between two dates
	 * @param cBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/getClientTransactionByDates")
	public String getClientTransactionByDates(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ClientBean client = new ClientBean();
		Map<String,String> dates = new HashMap<String,String>();
		
		if(request.getParameter("clientid")== null || request.getParameter("clientid")==""){
			return "home";
		}
		client.setClientID(Integer.parseInt(request.getParameter("clientid")));
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to get client legder :: User - "+client.getUserID());
		dates.put("startdate",request.getParameter("datefrom"));
		dates.put("enddate", request.getParameter("dateto"));
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+client.getUserID());
		clientDAO.getClientLedger(client,transactions,dates);
		model.addAttribute("client",client);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "client/clientledger";	
	}
	
	/**
	 * Method to get client edit details
	 * @param clientid
	 * @param model
	 * @param request
	 * @return
	 */
	
	@RequestMapping(value = "/editClient", method = RequestMethod.GET)
	public ModelAndView editClient(@RequestParam("clientid") String clientid,ModelMap model, HttpServletRequest request){
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		ClientBean client = new ClientBean();
		client.setClientID(Integer.parseInt(clientid));
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to edit client :: User - "+client.getUserID());
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
		clientDAO.getClientDetails(client);
		model.addAttribute("client",client);
		model.addAttribute("command",new ClientBean());
		clientDAO.getCategoryDetails(categories);
        model.addAttribute("categories",categories);
		ModelAndView mav = new ModelAndView();
		String viewName = "client/editclient";
		mav.setViewName(viewName);
		return mav;		
	}
	
	/**
	 * Method to add new client
	 * @param client
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/addClient")
	public String addClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model, HttpServletRequest request){
		boolean flag = false;
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		HttpSession session =request.getSession();
		
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to add a new client :: User - "+client.getUserID());
		LOGGER.debug("Request Details - Client Category - "+client.getClientCategory()+" :: Client Name - "+client.getClientName()
				+" :: Opening Balance - "+client.getOpeningBalance()+" :: First Name - "+client.getContactFirstName()
				+" :: Last Name - "+client.getContactLastName()+" :: Email - "+client.getClientEmail()
				+" :: Address - "+client.getClientAddress()+" :: Country - "+client.getClientCountry()+" :: State - "+client.getClientState()
				+" :: Phone Number - "+client.getClientPhoneNumber()+" :: Client TIN - "+client.getClientTIN()
				+" :: Custom Days to Pay - "+client.getCustomDaysToPay()+" :: User - "+client.getUserID());
		flag=clientDAO.addClient(client);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("New Product Added Successfully :: User - "+client.getUserID());
		}else{
			model.addAttribute("success","false");
			LOGGER.info("Failed to add new client :: User - "+client.getUserID());
		}
		clientDAO.getCategoryDetails(categories);
	    model.addAttribute("categories",categories);
	    model.addAttribute("command",new ClientBean());
		return "client/newclient";
	}
	
	/**
	 * Method to update client details
	 * @param client
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/updateClient")
	public String updateClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session =request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		
		client.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to update client :: User - "+client.getUserID()+" :: Client ID - "+client.getClientID());
		LOGGER.debug("Request Details - Client Category - "+client.getClientCategory()+" :: Client Name - "+client.getClientName()
				+" :: Opening Balance - "+client.getOpeningBalance()+" :: First Name - "+client.getContactFirstName()
				+" :: Last Name - "+client.getContactLastName()+" :: Email - "+client.getClientEmail()
				+" :: Address - "+client.getClientAddress()+" :: Country - "+client.getClientCountry()+" :: State - "+client.getClientState()
				+" :: Phone Number - "+client.getClientPhoneNumber()+" :: Client TIN - "+client.getClientTIN()
				+" :: Custom Days to Pay - "+client.getCustomDaysToPay()+" :: Client ID - "+client.getClientID()
				+" :: User - "+client.getUserID());
		flag=clientDAO.updateClient(client);
		if(flag){
			model.addAttribute("success","true");
			model.addAttribute("message","Client Update Successfully.");
			LOGGER.info("Client Updated Successfully :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
		}else{
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to update client. Please check with support team for assistance.");
			LOGGER.error("Failed to update client :: Client ID - "+client.getClientID()+" :: User - "+client.getUserID());
		}
		
		List<ClientBean> clients = new ArrayList<ClientBean>();
		int category=Integer.parseInt(request.getParameter("redirectcategoryedit"));
		double totalBalance = 0;
		LOGGER.debug("Client Category - "+category+" :: User - "+client.getUserID());
		totalBalance=clientDAO.getClientsDetails(client.getUserID(), clients,category);
		model.addAttribute("category",category);
		model.addAttribute("clients",clients);
		model.addAttribute("totalBalance",totalBalance);
		model.addAttribute("numberofclients",clients.size());
		model.addAttribute("command",new ClientBean());
		clientDAO.getCategoryDetails(categories);
        model.addAttribute("categories",categories);
		return "client/clientlist";
	}
}

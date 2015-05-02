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

	@RequestMapping("/newClient")
	   public String newClient(ModelMap model,HttpServletRequest request) {
		 List<CategoryBean> categories = new ArrayList<CategoryBean>();
		 HttpSession session = request.getSession();
		 if(session.getAttribute("userid")== null){
		 	return "home";
		 }
		 clientDAO.getCategoryDetails(categories);
	     model.addAttribute("categories",categories);
	     model.addAttribute("command",new ClientBean());
	     return "client/newclient";
	   }
	
	@RequestMapping("/clientList")
	 public String getClientList(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request for client list :: User - "+userid);
		int category =0;
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalBalance = 0;
		if(request.getParameter("option")!=null && request.getParameter("option") !=""){
				category=Integer.parseInt(request.getParameter("option"));
				LOGGER.debug("Requested Client Category - "+category+" :: User - "+userid);
				totalBalance=clientDAO.getClientsDetails(userid, clients, category);
				model.addAttribute("category",category);
		}
		else{
			LOGGER.debug("Requested Client Category - All(-1) :: User - "+userid);
			totalBalance=clientDAO.getClientsDetails(userid, clients, -1);
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
	@RequestMapping("/deleteClient")
	public String deleteClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to delete a client :: Client ID - "+client.getClientID()
				+" :: User - "+session.getAttribute("userid"));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		boolean flag=false;
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
		List<ClientBean> clients = new ArrayList<ClientBean>();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalBalance = 0;
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
	
	@RequestMapping(value = "/getClientTIN", method = RequestMethod.GET)
	public @ResponseBody String processAJAXRequest(@RequestParam("clientid") String clientid,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to get Client TIN :: User - "+session.getAttribute("userid"));
		ClientBean client = new ClientBean();
		client.setClientID(Integer.parseInt(clientid));
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: User - "+session.getAttribute("userid"));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		clientDAO.getClientDetails(client);
		LOGGER.debug("User - "+session.getAttribute("userid")+" :: Client ID - "+client.getClientID()
				+" :: Client TIN - "+client.getClientTIN());
		return client.getClientTIN();
	}
	
	@RequestMapping("/clientLedger")
	 public String getClientLedger(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		if(request.getParameter("clientid")== null || request.getParameter("clientid")==""){
			return "home";
		}
		LOGGER.info("Request to get client legder :: User - "+session.getAttribute("userid"));
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ClientBean client = new ClientBean();
		Map<String,String> dates = new HashMap<String,String>();
		client.setClientID(Integer.parseInt(request.getParameter("clientid")));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
	
	@RequestMapping("/getClientTransactionByDates")
	public String getClientTransactionByDates(@ModelAttribute("AccountmateWS")ClientBean cBean, 
			   ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		if(request.getParameter("clientid")== null || request.getParameter("clientid")==""){
			return "home";
		}
		LOGGER.info("Request to get client legder :: User - "+session.getAttribute("userid"));
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ClientBean client = new ClientBean();
		Map<String,String> dates = new HashMap<String,String>();
		client.setClientID(Integer.parseInt(request.getParameter("clientid")));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
	
	@RequestMapping(value = "/editClient", method = RequestMethod.GET)
	public ModelAndView editClient(@RequestParam("clientid") String clientid,ModelMap model, HttpServletRequest request){
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		LOGGER.info("Request to edit client :: User - "+session.getAttribute("userid"));
		ClientBean client = new ClientBean();
		client.setClientID(Integer.parseInt(clientid));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.debug("Requested Client ID - "+client.getClientID()+" :: User - "+session.getAttribute("userid"));
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
	
	@RequestMapping("/addClient")
	public String addClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model, HttpServletRequest request){
		boolean flag = false;
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		HttpSession session =request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to add a new client :: User - "+session.getAttribute("userid"));
		LOGGER.debug("Request Details - Client Category - "+client.getClientCategory()+" :: Client Name - "+client.getClientName()
				+" :: Opening Balance - "+client.getOpeningBalance()+" :: First Name - "+client.getContactFirstName()
				+" :: Last Name - "+client.getContactLastName()+" :: Email - "+client.getClientEmail()
				+" :: Address - "+client.getClientAddress()+" :: Country - "+client.getClientCountry()+" :: State - "+client.getClientState()
				+" :: Phone Number - "+client.getClientPhoneNumber()+" :: Client TIN - "+client.getClientTIN()
				+" :: Custom Days to Pay - "+client.getCustomDaysToPay()+" :: User - "+session.getAttribute("userid"));
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
	
	@RequestMapping("/updateClient")
	public String updateClient(@ModelAttribute("AccountmateWS")ClientBean client,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session =request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to update client :: User - "+session.getAttribute("userid")+" :: Client ID - "+client.getClientID());
		LOGGER.debug("Request Details - Client Category - "+client.getClientCategory()+" :: Client Name - "+client.getClientName()
				+" :: Opening Balance - "+client.getOpeningBalance()+" :: First Name - "+client.getContactFirstName()
				+" :: Last Name - "+client.getContactLastName()+" :: Email - "+client.getClientEmail()
				+" :: Address - "+client.getClientAddress()+" :: Country - "+client.getClientCountry()+" :: State - "+client.getClientState()
				+" :: Phone Number - "+client.getClientPhoneNumber()+" :: Client TIN - "+client.getClientTIN()
				+" :: Custom Days to Pay - "+client.getCustomDaysToPay()+" :: Client ID - "+client.getClientID()
				+" :: User - "+session.getAttribute("userid"));
		client.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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

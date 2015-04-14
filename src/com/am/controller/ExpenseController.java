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

import com.am.helper.Helper;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ClientBean;
import com.am.model.bean.ExpenseBean;
import com.am.model.bean.ExpenseBeanList;
import com.am.model.dao.ClientDAO;
import com.am.model.dao.ClientDAOImpl;
import com.am.model.dao.ExpenseDAO;
import com.am.model.dao.ExpenseDAOImpl;

@Controller
public class ExpenseController {
	static Logger LOGGER = Logger.getLogger(ExpenseController.class.getName());
	ExpenseDAO expenseDAO = new ExpenseDAOImpl();
	ClientDAO clientDAO = new ClientDAOImpl();
	@RequestMapping("/recordExpenses")
	   public String getExpensePage(ModelMap model,HttpServletRequest request){
	    List<CategoryBean> categories = new ArrayList<CategoryBean>();
	    List<ExpenseBeanList> expensesDetails = new ArrayList<ExpenseBeanList>();
	    List<ClientBean> banks = new ArrayList<ClientBean>();
	    HttpSession session = request.getSession();
		 if(session.getAttribute("userid")== null){
		 	return "home";
		 }
	    expenseDAO.getExpenseCategories(categories);
	    int userid=Integer.parseInt((String)session.getAttribute("userid"));
	    model.addAttribute("categories",categories);
	    model.addAttribute("command", new ExpenseBeanList());
	    clientDAO.getClientsDetails(userid,banks,4);
	    model.addAttribute("banks",banks);
	    Map<String,String> dates = new HashMap<String,String>();
	    if(request.getParameter("startdate")!= null && !request.getParameter("startdate").equals("")){
			dates.put("startdate",request.getParameter("startdate"));
			dates.put("enddate", request.getParameter("enddate"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+userid);
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+userid);

		expenseDAO.getExpensesDetails(expensesDetails, userid, dates);
		model.addAttribute("expensesdetails", expensesDetails);
		model.addAttribute("startdate", dates.get("startdate"));
		model.addAttribute("enddate", dates.get("enddate"));
		return "expenses";
	   }

	
	@RequestMapping("/saveExpenses")
	public String saveExpenses(@ModelAttribute("AccountmateWS")ExpenseBeanList expensesIn, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag = false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to save expenses :: User - "+userid);
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		List<ExpenseBeanList> expensesDetails = new ArrayList<ExpenseBeanList>();
		ExpenseBeanList expenses = filterExpenses(expensesIn);
		expenses.setUserID(userid);
		try {
			Date date = formatter.parse(request.getParameter("expdate"));
			expenses.setDate(date);
			flag=expenseDAO.saveExpenses(expenses);
			if(flag){
				model.addAttribute("success","true");
				model.addAttribute("message","Expenses Saved Successfully.");
				LOGGER.info("Expenses Saved Successfully :: User - "+expenses.getUserID());
			}
			else{
				model.addAttribute("success","false");
				model.addAttribute("message","Failed to save expenses. Please check with support team for assistance.");
				LOGGER.error("Failed to save expenses :: User - "+expenses.getUserID());
			}
		} catch (ParseException pe) {
			LOGGER.error(pe.getMessage(),pe);
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to save expenses. Please check with support team for assistance.");
		}
		finally{
			expenseDAO.getExpenseCategories(categories);
		    model.addAttribute("categories",categories);
		    model.addAttribute("command", new ExpenseBeanList());
		}
		
		Map<String,String> dates = new HashMap<String,String>();
		if(request.getParameter("redirectsavestartdate")!= null && !request.getParameter("redirectsavestartdate").equals("")){
			dates.put("startdate",request.getParameter("redirectsavestartdate"));
			dates.put("enddate", request.getParameter("redirectsaveenddate"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+userid);
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+userid);
		expenseDAO.getExpensesDetails(expensesDetails, userid, dates);
		model.addAttribute("expensesdetails", expensesDetails);
		model.addAttribute("startdate", dates.get("startdate"));
		model.addAttribute("enddate", dates.get("enddate"));
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(userid,banks,4);
	    model.addAttribute("banks",banks);
		return "expenses";
	}
	
	@RequestMapping(value = "/viewExpense", method = RequestMethod.GET)
	public ModelAndView viewExpense(@RequestParam("expenseid") String expenseid,HttpServletRequest request, ModelMap model) {
		HttpSession session = request.getSession();
		ExpenseBean expense = new ExpenseBean();
		expense.setExpenseID(Integer.parseInt(expenseid));
		expense.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to view expense :: Expense ID - "+expense.getExpenseID()+" :: User - "+expense.getUserID());
		expenseDAO.getExpenseDetails(expense);
		model.addAttribute("expense",expense);
		ModelAndView mav = new ModelAndView();
		String viewName = "expense";
		mav.setViewName(viewName);
		return mav;
	}
	
	@RequestMapping("/updateExpense")
	public String updateExpense(@ModelAttribute("AccountmateWS")ExpenseBean expense, ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		boolean flag = false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request to save expenses :: User - "+userid);
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		List<ExpenseBeanList> expensesDetails = new ArrayList<ExpenseBeanList>();
		expense.setUserID(userid);
		try {
			Date date = formatter.parse(request.getParameter("expmodaldate"));
			expense.setExpenseDate(date);
			flag=expenseDAO.updateExpense(expense);
			if(flag){
				model.addAttribute("success","true");
				model.addAttribute("message","Expense Updated Successfully.");
				LOGGER.info("Expense Updated Successfully :: User - "+expense.getUserID());
			}
			else{
				model.addAttribute("success","false");
				model.addAttribute("message","Failed to update expense. Please check with support team for assistance.");
				LOGGER.error("Failed to update expense :: User - "+expense.getUserID());
			}
		} catch (ParseException pe) {
			LOGGER.error(pe.getMessage(),pe);
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to update expense. Please check with support team for assistance.");
		}
		finally{
			expenseDAO.getExpenseCategories(categories);
		    model.addAttribute("categories",categories);
		    model.addAttribute("command", new ExpenseBeanList());
		}
		
		Map<String,String> dates = new HashMap<String,String>();
		if(request.getParameter("redirecteditstartdate")!= null && !request.getParameter("redirecteditstartdate").equals("")){
			dates.put("startdate",request.getParameter("redirecteditstartdate"));
			dates.put("enddate", request.getParameter("redirecteditenddate"));
		}
		else{
			dates = Helper.getDateRange();
			LOGGER.debug("Requested Date Range - Current Month :: User - "+userid);
		}
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+userid);
		expenseDAO.getExpensesDetails(expensesDetails, userid, dates);
		model.addAttribute("expensesdetails", expensesDetails);
		model.addAttribute("startdate", dates.get("startdate"));
		model.addAttribute("enddate", dates.get("enddate"));
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(userid,banks,4);
	    model.addAttribute("banks",banks);
		return "expenses";
	}
	
	@RequestMapping("/deleteExpense")
	public String deleteExpense(@ModelAttribute("AccountmateWS")ExpenseBean expense,ModelMap model,HttpServletRequest request){
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
	    List<ExpenseBeanList> expensesDetails = new ArrayList<ExpenseBeanList>();
		HttpSession session = request.getSession();
		boolean flag =false;
		if(session.getAttribute("userid")== null){
			return "home";
		}
		expense.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.info("Request to delete a expense :: Expense ID - "+expense.getExpenseID()+" :: User - "+expense.getUserID());
		Map<String,String> dates = new HashMap<String,String>();
		dates.put("startdate",request.getParameter("redirectstartdate"));
		dates.put("enddate", request.getParameter("redirectenddate"));
		LOGGER.debug("Requested Date Range - "+dates.get("startdate")+" to "+dates.get("enddate")+" :: User - "+expense.getUserID());
		flag=expenseDAO.deleteExpense(expense);
		if(flag){
			LOGGER.info("Expense deleted successfully :: User - "+expense.getUserID());
			model.addAttribute("success","true");
			model.addAttribute("message","Expense Deleted Successfully.");
		}
		else{
			LOGGER.info("Failed to delete expense :: User - "+expense.getUserID());
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to delete expense. Please check with support team for assistance.");
		}
		expenseDAO.getExpenseCategories(categories);
		model.addAttribute("categories",categories);
	    model.addAttribute("command", new ExpenseBeanList());
		expenseDAO.getExpensesDetails(expensesDetails, expense.getUserID(), dates);
		model.addAttribute("expensesdetails", expensesDetails);
		model.addAttribute("startdate", dates.get("startdate"));
		model.addAttribute("enddate", dates.get("enddate"));
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(expense.getUserID(),banks,4);
	    model.addAttribute("banks",banks);
		return "expenses";
	}
	
	@RequestMapping(value = "/editExpense", method = RequestMethod.GET)
	public ModelAndView editExpense(@RequestParam("expenseid") String expenseid,ModelMap model, HttpServletRequest request){
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		LOGGER.info("Request to edit expense :: User - "+session.getAttribute("userid"));
		ExpenseBean expense = new ExpenseBean();
		expense.setExpenseID(Integer.parseInt(expenseid));
		expense.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.debug("Requested Expense ID - "+expense.getExpenseID()+" :: User - "+session.getAttribute("userid"));
		expenseDAO.getExpenseDetails(expense);
		model.addAttribute("expense",expense);
		model.addAttribute("command",new ExpenseBean());
		expenseDAO.getExpenseCategories(categories);
		model.addAttribute("categories",categories);
		List<ClientBean> banks = new ArrayList<ClientBean>();
		clientDAO.getClientsDetails(expense.getUserID(),banks,4);
	    model.addAttribute("banks",banks);
		ModelAndView mav = new ModelAndView();
		String viewName = "editexpense";
		mav.setViewName(viewName);
		return mav;		
	}
	
	private ExpenseBeanList filterExpenses(ExpenseBeanList expenses){
		ExpenseBeanList filteredExpenses = new ExpenseBeanList();
		List<ExpenseBean> expenseList = new ArrayList<ExpenseBean>();
		//Copy valid details from request to invoice.
		filteredExpenses.setTotal(expenses.getTotal());
		filteredExpenses.setTotalCash(expenses.getTotalCash());
		filteredExpenses.setTotalCheque(expenses.getTotalCheque());
		for(ExpenseBean expense :expenses.getExpenses()){
			if(expense.getExpenseCategoryID()!=0){
				expenseList.add(expense);
			}
		}
		filteredExpenses.setExpenses(expenseList);	
		return filteredExpenses;
	}
}



	
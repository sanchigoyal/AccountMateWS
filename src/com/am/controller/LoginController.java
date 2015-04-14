package com.am.controller;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.am.model.bean.UserBean;
import com.am.model.dao.UserDao;

@Controller

public class LoginController{
 
	@RequestMapping("/start")
	   public ModelAndView start() {
	      return new ModelAndView("home");
	   }
	
	@RequestMapping("/contact")
	   public ModelAndView contact() {
	      return new ModelAndView("contact", "command","unknown");//add contactbean
	   }
	
	@RequestMapping("/login")
	 public String login(ModelMap model,HttpServletRequest request) {
			      int flag =0;
			      UserBean user = new UserBean();
			      user.setUserEmail(request.getParameter("username"));
			      user.setUserPassword(request.getParameter("password"));
			      flag = UserDao.validate(user);
			      if(flag ==1){
			    	  HttpSession session = request.getSession();
			    	  session.setAttribute("userid",String.valueOf(user.getUserID()));
			    	  session.setAttribute("account",user.getAccountName());
			    	  session.setAttribute("login","success");
			    	  session.setMaxInactiveInterval(10*60);
			    	  System.out.println("User -"+String.valueOf(user.getUserID())+" has logged in.");
			    	  return "home";  
			      }
			      return "home";
			   }
	
	@RequestMapping("/logout")
	public String logout(ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession(false);
		System.out.println("User -"+session.getAttribute("userid")+" has logged out.");
        if(session != null){
            session.invalidate();
        }
		return "home";
	}
}
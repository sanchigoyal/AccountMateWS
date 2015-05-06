package com.am.interceptors;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 

import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.am.constants.AccountConstants;

public class LoginInterceptor implements HandlerInterceptor {
	@Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception {	
		HttpSession session = request.getSession(); 
		List<String> nonBlackList = new ArrayList<String>();
		nonBlackList.add("/AccountmateWS/start");
		nonBlackList.add("/AccountmateWS/login");
		nonBlackList.add("/AccountmateWS/contact");
		nonBlackList.add("/AccountmateWS/login");
		nonBlackList.add("/AccountmateWS/registerpage");
		nonBlackList.add("/AccountmateWS/checkemail");
		nonBlackList.add("/AccountmateWS/register");
		//Authentication logic here
         if(!nonBlackList.contains(request.getRequestURI()) && !request.getRequestURI().startsWith("/AccountmateWS/resources/")){
     		if(session.getAttribute(AccountConstants.USER_NAME)== null){
     			response.sendRedirect("/AccountmateWS/start");
     			return false;
     		}
         }
        return true;
    }
    //override postHandle() and afterCompletion() 

	@Override
	public void afterCompletion(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, Exception arg3)
			throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1,
			Object arg2, ModelAndView arg3) throws Exception {
		// TODO Auto-generated method stub
	}

}

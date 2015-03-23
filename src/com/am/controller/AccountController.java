package com.am.controller;


import java.io.File;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.am.model.bean.UserBean;
import com.am.model.dao.AccountDao;


@Controller
public class AccountController {
	   private boolean isMultipart;
	   private String filePath;
	   private final int maxFileSize = 50 * 1024;
	   private final int maxMemSize = 4 * 1024;
	
	@RequestMapping("/registerpage")
	   public String registerPage() {
	      return "register";
	   }
	
	@RequestMapping(value = "/checkemail", method = RequestMethod.GET)
	public @ResponseBody String processAJAXRequest(
				@RequestParam("email") String email	) {
			//Check with DB if email is available
			return AccountDao.checkEmailAvailibility(email);
		}
	
	@RequestMapping("/register")
	 public String register(ModelMap model,HttpServletRequest request) {
				int flag=0;
				UserBean user = new UserBean();
				File file = null;
				Boolean isValidProfilePic = false;
				FileItem fileUpload = null;
				filePath = request.getServletContext().getInitParameter("file-upload");
				isMultipart = ServletFileUpload.isMultipartContent(request);
				if(!isMultipart){
					 System.out.println("Not a multipart request");
				}
				DiskFileItemFactory factory = new DiskFileItemFactory();
			   	factory.setSizeThreshold(maxMemSize);
			    factory.setRepository(new File("c:\\temp"));
			    
			    ServletFileUpload upload = new ServletFileUpload(factory);
			    upload.setSizeMax( maxFileSize );  
			    try{ 
			         List<FileItem> fileItems = upload.parseRequest(request);
			    	 Iterator i = fileItems.iterator();
			         while ( i.hasNext() ) 
			          {
			             FileItem fi = (FileItem)i.next();
			             if (fi.isFormField())
		                    {	
			            	 	handleFormField(fi.getFieldName(),fi.getString(),user);
		                    }
			             if (!fi.isFormField())	
			             {
			                if(fi.getFieldName().equals("uploadimage") && fi.getSize()!=0)
			                {
			                	fileUpload = fi;
			                	isValidProfilePic = true;
			                }
			             }
			          }   
			          
			          flag=AccountDao.register(user,isValidProfilePic);
			          if(flag == 1 && isValidProfilePic){
			               file = new File( filePath+user.getFileName());
			               fileUpload.write(file) ;
			           }
			       }catch(Exception ex) {
			           System.out.println(ex);
			       }
				
				/*String msg="Hi, "+user.getContactFirstName()+" . Your User ID is "
						+user.getUserID()+" and Password is "+user.getUserPassword()+" .";*/
				
				if(flag==1){
					//EmailService.sendEmail(user.getUserEmail(), msg);
					model.addAttribute("success","true");
					System.out.println("New user registered");
				}else{
					model.addAttribute("success","false");
					System.out.println("Registration failed");
				}
				return "register";
	 }
	
	@RequestMapping("/myProfile")
	public String getProfile(ModelMap model,HttpServletRequest request) {
		return "myprofile";
	}
	private void handleFormField(String fieldName,String fieldValue, UserBean user){
		if(fieldName.equals("contactFirstName")){
			user.setContactFirstName(fieldValue);
		}
		else if(fieldName.equals("contactLastName")){
			user.setContactLastName(fieldValue);
		}
		else if(fieldName.equals("userEmail")){
			user.setUserEmail(fieldValue);
		}
		else if(fieldName.equals("userPassword")){
			user.setUserPassword(fieldValue);
		}
		else if(fieldName.equals("accountName")){
			user.setAccountName(fieldValue);
		}
		else if(fieldName.equals("userPhoneNumber")){
			user.setUserPhoneNumber(fieldValue);
		}
		else if(fieldName.equals("userAddress")){
			user.setUserAddress(fieldValue);
		}
		else if(fieldName.equals("userCountry")){
			user.setUserCountry(fieldValue);
		}
		else if(fieldName.equals("userState")){
			user.setUserState(fieldValue);
		}
		else{
			
		}
		
	}
}

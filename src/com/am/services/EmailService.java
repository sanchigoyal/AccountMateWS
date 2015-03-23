package com.am.services;

import java.io.InputStream;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailService {
	
	@SuppressWarnings("finally")
	public static int sendEmail(String recipient, String msg ){
		
		
		String username=null;
		String password=null;
		String smtphost=null;
		String smtpport=null;
		String sender=null;
		int flag=0;
		try{
			ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
			InputStream is = classLoader.getResourceAsStream("/config.properties");
			Properties properties = new Properties();	
			properties.load(is);
				username=properties.getProperty("emailusername").trim();
				password=properties.getProperty("emailpassword").trim();
				smtphost=properties.getProperty("smtphost").trim();
				smtpport=properties.getProperty("smtpport").trim();
				sender=properties.getProperty("sender").trim();
				
				//System.out.println("Username :"+username+" , password -"+password+" , smtphost-"+smtphost+" , smtpport-"+smtpport+" , sender- "+sender);
				
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		Properties props = new Properties();
		props.put("mail.smtp.auth","true");
		props.put("mail.smtp.starttls.enable","true");
		props.put("mail.smtp.host",smtphost);
		props.put("mail.smtp.port",smtpport);
		final String eusername=username;
		final String epassword=password;
		
		Session session =Session.getInstance(props,
				new javax.mail.Authenticator() {
					protected PasswordAuthentication getPasswordAuthentication(){
						return new PasswordAuthentication(eusername,epassword);
					}
		});
		
		try{
			
			Message message = new  MimeMessage(session);
			message.setFrom(new InternetAddress(sender));
			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
			message.setSubject("Accountmate User ID and Password");
			message.setText(msg);
			Transport.send(message);
			flag=1;
			
			
		}catch(MessagingException me){
			throw new RuntimeException(me);
			
		}
		finally{
			return flag;
		}
		
	}

}

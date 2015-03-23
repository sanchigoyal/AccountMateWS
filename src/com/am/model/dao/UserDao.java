package com.am.model.dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


import com.am.connection.Connect;
import com.am.model.bean.UserBean;


public class UserDao {
	
	
	public static int validate(UserBean user){
		Connection con=null;
		int flag=0;
		String query="select * from user where email='"+user.getUserEmail()+"' and user_password='"+user.getUserPassword()+"'";
		try{
			con=Connect.doConnection();
			if(con==null){
				//Use logger instead
				System.out.println("Connection to database failed.");
			}
				
			Statement st=con.createStatement();
			ResultSet rs=st.executeQuery(query);
			if (!rs.next() ) {
			    flag=0;
			} else {
				flag=1;
				user.setUserID(rs.getInt("user_id"));
				user.setAccountName(rs.getString("account_name"));
			}
			
		}
		catch (SQLException e) {
            e.printStackTrace();
		}
		finally{
			Connect.dropConnection(con);
		}
		return flag;
	}

}

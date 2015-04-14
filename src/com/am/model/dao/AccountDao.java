package com.am.model.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.am.connection.Connect;
import com.am.model.bean.UserBean;

public class AccountDao {
	
	public static String checkEmailAvailibility(String email){
		Connection con=null;
		String available="true";
		String query="select * from user where email='"+email+"';";
		try{
			con=Connect.doConnection();
			if(con==null){
				System.out.println("Connection to database failed.");
			}
			Statement st=con.createStatement();
			ResultSet rs=st.executeQuery(query);
			if (rs.next()) {
			    available="false";
			} 
		}
		catch (SQLException e) {
            e.printStackTrace();
		}
		return available;
	}
	
	public static int register(UserBean user,Boolean isValidProfilePic){
		Connection con = null;
		CallableStatement cs = null;
		ResultSet rs =null;
		int flag = 0;
		try{
			con=Connect.doConnection();
			cs = con.prepareCall("{call registerUser(?,?,?,?,?,?,?,?,?,?)}");
			cs.setString(1,user.getContactFirstName());
			cs.setString(2,user.getContactLastName());
			cs.setString(3,user.getUserEmail());
			cs.setString(4, user.getUserPassword());
			cs.setString(5,user.getAccountName());
			cs.setString(6, user.getUserPhoneNumber());
			cs.setString(7,user.getUserAddress());
			cs.setString(8, user.getUserState());
			cs.setString(9,user.getUserCountry());
			if(isValidProfilePic)
				cs.setInt(10,1);
			else
				cs.setInt(10,0);
	        rs = cs.executeQuery();
	        while(rs.next()){
	        	user.setFileName(rs.getString("file_name"));
	        	flag = 1;
	        }
	        
		}
		catch(SQLException se){
			se.printStackTrace();
		}finally {
	        if (cs != null) {
	            try {
	                cs.close();
	            } catch (SQLException e) {
	                System.err.println("SQLException: " + e.getMessage());
	            }
	        }
	        if (con != null) {
	            try {
	                con.close();
	            } catch (SQLException e) {
	                System.err.println("SQLException: " + e.getMessage());
	            }
	        }
	    }
		return flag;
}
	

}

package com.am.connection;

import java.io.InputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class Connect {
	
	public static Connection con=null;
		
	public static Connection doConnection() {
        try {
        		ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        		InputStream is = classLoader.getResourceAsStream("/config.properties");
        		Properties properties = new Properties();
        		properties.load(is);

        		String driver = properties.getProperty("driver").trim();
        		String url = properties.getProperty("url").trim();
        		String id = properties.getProperty("id").trim();
        		String password = properties.getProperty("password");
        		
        		Class.forName(driver).newInstance();
        		con = DriverManager.getConnection(url, id, password);
        } catch (Exception e) {
          e.printStackTrace();
        }
        return con;	
    }

    public static void dropConnection(Connection con) {
        try {
            	con.close();
        	} catch (Exception e) {
            e.printStackTrace(System.out);

        	}
    }

    public static void dropCallableObject(CallableStatement cs){
    	try {
        	cs.close();
    	} catch (Exception e) {
        e.printStackTrace(System.out);

    	}
    }

}

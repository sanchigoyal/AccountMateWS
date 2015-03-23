package com.am.model.dao;

import java.util.List;
import java.util.Map;

import com.am.model.bean.CategoryBean;
import com.am.model.bean.ClientBean;
import com.am.model.bean.TransactionBean;

public interface ClientDAO {
	public boolean deleteClient(ClientBean client);
	public void getClientLedger(ClientBean client,List<TransactionBean> transactions,Map<String,String> dates);
	public void getClientDetails(ClientBean client);
	public double getClientsDetails(int userid,List<ClientBean> clients, int category);
	public boolean addClient(ClientBean client);	
	public boolean updateClient(ClientBean client);
	public void getCategoryDetails(List<CategoryBean> categories);
}

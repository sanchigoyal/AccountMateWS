package com.am.model.bean;

public class ClientBean {
	
	
	private int clientID;
	private int userID;
	private String clientTIN;
	
	public String getClientTIN() {
		return clientTIN;
	}
	public void setClientTIN(String clientTIN) {
		this.clientTIN = clientTIN;
	}
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public int getClientID() {
		return clientID;
	}
	public void setClientID(int clientID) {
		this.clientID = clientID;
	}
	public String getClientName() {
		return clientName;
	}
	public void setClientName(String clientName) {
		this.clientName = clientName;
	}
	public String getContactFirstName() {
		return contactFirstName;
	}
	public void setContactFirstName(String contactFirstName) {
		this.contactFirstName = contactFirstName;
	}
	public String getContactLastName() {
		return contactLastName;
	}
	public void setContactLastName(String contactLastName) {
		this.contactLastName = contactLastName;
	}
	public String getClientAddress() {
		return clientAddress;
	}
	public void setClientAddress(String clientAddress) {
		this.clientAddress = clientAddress;
	}
	public String getClientPhoneNumber() {
		return clientPhoneNumber;
	}
	public void setClientPhoneNumber(String clientPhoneNumber) {
		this.clientPhoneNumber = clientPhoneNumber;
	}
	public String getClientCountry() {
		return clientCountry;
	}
	public void setClientCountry(String clientCountry) {
		this.clientCountry = clientCountry;
	}
	public String getClientState() {
		return clientState;
	}
	public void setClientState(String clientState) {
		this.clientState = clientState;
	}
	public String getClientEmail() {
		return clientEmail;
	}
	public void setClientEmail(String clientEmail) {
		this.clientEmail = clientEmail;
	}
	public double getOpeningBalance() {
		return OpeningBalance;
	}
	public void setOpeningBalance(double openingBalance) {
		OpeningBalance = openingBalance;
	}
	public int getCustomDaysToPay() {
		return customDaysToPay;
	}
	public void setCustomDaysToPay(int customDaysToPay) {
		this.customDaysToPay = customDaysToPay;
	}
	public int getClientCategory() {
		return clientCategory;
	}
	public void setClientCategory(int clientCategory) {
		this.clientCategory = clientCategory;
	}
	private String clientName;
	private String contactFirstName;
	private String contactLastName;
	private String clientAddress;
	private String clientPhoneNumber;
	private String clientCountry;
	private String clientState;
	private String clientEmail;
	private double OpeningBalance;
	private int customDaysToPay;
	private int clientCategory;
	private String clientCategoryName;
	private double clientDebit;
	private double clientCredit;
	private double clientBalance;
	
	public String getClientCategoryName() {
		return clientCategoryName;
	}
	public void setClientCategoryName(String clientCategoryName) {
		this.clientCategoryName = clientCategoryName;
	}
	public double getClientDebit() {
		return clientDebit;
	}
	public void setClientDebit(double clientDebit) {
		this.clientDebit = clientDebit;
	}
	public double getClientCredit() {
		return clientCredit;
	}
	public void setClientCredit(double clientCredit) {
		this.clientCredit = clientCredit;
	}
	public double getClientBalance() {
		return clientBalance;
	}
	public void setClientBalance(double clientBalance) {
		this.clientBalance = clientBalance;
	}
	
}

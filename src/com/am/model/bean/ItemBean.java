package com.am.model.bean;

public class ItemBean {
	private int itemID;
	private int productID;
	private String productName;
	private int quantity;
	private double priceWithoutVat;
	private boolean applyVat;
	private double vatPercent;
	private double priceWithVat;
	private double subTotal;
	private double total;
	private boolean updateCP;
	
	public boolean isUpdateCP() {
		return updateCP;
	}
	public void setUpdateCP(boolean updateCP) {
		this.updateCP = updateCP;
	}
	public double getSubTotal() {
		return subTotal;
	}
	public void setSubTotal(double subTotal) {
		this.subTotal = subTotal;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public int getItemID() {
		return itemID;
	}
	public void setItemID(int itemID) {
		this.itemID = itemID;
	}
	public int getProductID() {
		return productID;
	}
	public void setProductID(int productID) {
		this.productID = productID;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public double getPriceWithoutVat() {
		return priceWithoutVat;
	}
	public void setPriceWithoutVat(double priceWithoutVat) {
		this.priceWithoutVat = priceWithoutVat;
	}
	public boolean getApplyVat() {
		return applyVat;
	}
	public void setApplyVat(boolean applyVat) {
		this.applyVat = applyVat;
	}
	public double getVatPercent() {
		return vatPercent;
	}
	public void setVatPercent(double vatPercent) {
		this.vatPercent = vatPercent;
	}
	public double getPriceWithVat() {
		return priceWithVat;
	}
	public void setPriceWithVat(double priceWithVat) {
		this.priceWithVat = priceWithVat;
	}
	public double getTotal() {
		return total;
	}
	public void setTotal(double total) {
		this.total = total;
	}
	
}

package com.am.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.am.helper.Helper;
import com.am.model.bean.CategoryBean;
import com.am.model.bean.ProductBean;
import com.am.model.bean.ProductsBean;
import com.am.model.bean.TransactionBean;
import com.am.model.dao.ProductDAO;
import com.am.model.dao.ProductDAOImpl;
import com.am.constants.AccountConstants;

@Controller
public class ProductController {
	
	static Logger LOGGER = Logger.getLogger(ProductController.class.getName());
	ProductDAO productDAO = new ProductDAOImpl();
	
	/**
	 * Method to redirect to create product page
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/newProduct")
	   public String createNewProduct(ModelMap model,HttpServletRequest request) {
		  List<CategoryBean> categories = new ArrayList<CategoryBean>();
		  HttpSession session = request.getSession();
			if(session.getAttribute(AccountConstants.USER_NAME)== null){
				return "home";
			}
		  int userid=Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME));
		  productDAO.getCategoryDetails(userid, categories);
	      model.addAttribute("categories",categories);
	      model.addAttribute("command",new ProductBean());
	      return "product/newproduct";
	   }
	
	/**
	 * Method to return list of products based on the requested category
	 * @param pBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/productList")
	 public String getProductList(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		int category =0;
		double totalStockValue = 0;
		// Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		pBean.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request for Product List :: User - "+pBean.getUserID());
		//Check for the requested category
		if(request.getParameter("option")!=null && request.getParameter("option") !="")
			{
				category=Integer.parseInt(request.getParameter("option"));
				LOGGER.debug("Requested Product Category - "+category+" :: User - "+pBean.getUserID());
				totalStockValue=productDAO.getProductsDetails(pBean.getUserID(),products,category);
				model.addAttribute("category",category);
			}
		else{
			LOGGER.debug("Requested Product Category - All(-1) :: User - "+pBean.getUserID());
			model.addAttribute("category",-1);
			totalStockValue=productDAO.getProductsDetails(pBean.getUserID(),products,-1);
		}
		productDAO.getCategoryDetails(pBean.getUserID(), categories);
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "product/productlist";
	}
	
	/**
	 * Method to return price list based on the requested category
	 * @param pBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/productPriceList")
	 public String getProductPriceList(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		int category =0;
		// Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		pBean.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request for Product Price List :: User - "+pBean.getUserID());
		//Check for the requested category
		if(request.getParameter("option")!=null && request.getParameter("option") !="")
			{
				category=Integer.parseInt(request.getParameter("option"));
				LOGGER.debug("Requested Product Category - "+category+" :: User - "+pBean.getUserID());
				productDAO.getProductsDetails(pBean.getUserID(),products,category);
				model.addAttribute("category",category);
			}
		else{
			LOGGER.debug("Requested Product Category - All(-1) :: User - "+pBean.getUserID());
			model.addAttribute("category",-1);
			productDAO.getProductsDetails(pBean.getUserID(),products,-1);
		}
		productDAO.getCategoryDetails(pBean.getUserID(), categories);
		model.addAttribute("products",products);
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "productpricelist";
	}
	
	/**
	 * Method to add a new product
	 * @param product
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/addProduct")
	public String addProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		HttpSession session = request.getSession();
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to add a new product :: User - "+product.getUserID());
		LOGGER.debug("Request Details - Product Category - "+product.getProductCategory()+" :: Product - "+product.getProductName()
				+" :: Opening Balance - "+product.getOpeningBalance()+" :: Cost Price - "+product.getCostPrice()
				+" :: Dealer Price - "+product.getDealerPrice()+" :: Market Price - "+product.getMarketPrice()
				+" :: User - "+product.getUserID());
		
		flag=productDAO.addProduct(product);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("New Product Added Successfully :: User - "+product.getUserID());
		}else{
			model.addAttribute("success","false");
			LOGGER.error("Failed to add a product ::User -"+product.getUserID());
		}
		productDAO.getCategoryDetails(product.getUserID(), categories);
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "product/newproduct";
	}
	
	/**
	 * Method to get product quantity
	 * @param productid
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getProductQuantity", method = RequestMethod.GET)
	public @ResponseBody String getProductQuantity(
				@RequestParam("productid") String productid,HttpServletRequest request) {
			HttpSession session = request.getSession();
			ProductBean product = new ProductBean();
			//Check if session exists
			if(session.getAttribute(AccountConstants.USER_NAME)== null){
				return "home";
			}
			product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
			LOGGER.info("Request to get product quantity :: User - "+product.getUserID());
			product.setProductID(Integer.parseInt(productid));
			LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
			productDAO.getProductBalance(product);
			LOGGER.debug("User - "+product.getUserID()+" :: Product ID - "+product.getProductID()
					+" :: Product Balance - "+product.getProductBalance());
			return String.valueOf(product.getProductBalance());
		}
	
	/**
	 * Method to get product DLP
	 * @param productid
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getProductDLP", method = RequestMethod.GET)
	public @ResponseBody String getProductDLP(
				@RequestParam("productid") String productid,HttpServletRequest request) {
			HttpSession session = request.getSession();
			ProductBean product = new ProductBean();
			//Check if session exists
			if(session.getAttribute(AccountConstants.USER_NAME)== null){
				return "home";
			}
			product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
			LOGGER.info("Request to get product DLP :: User - "+product.getUserID());
			product.setProductID(Integer.parseInt(productid));
			LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
			productDAO.getProductDetails(product);
			LOGGER.debug("User - "+product.getUserID()+" :: Product ID - "+product.getProductID()
					+" :: Product DLP - "+product.getDealerPrice());
			return String.valueOf(product.getDealerPrice());
		}
	
	/**
	 * Method to get product stock transaction details for current month
	 * @param pBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/stockRegister")
	 public String getProductTransactions(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ProductBean product = new ProductBean();
		Map<String,String> dates = new HashMap<String,String>();
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		if(request.getParameter("productid")== null || request.getParameter("productid")==""){
			return "home";
		}
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to get product transaction :: User - "+product.getUserID());
		product.setProductID(Integer.parseInt(request.getParameter("productid")));
		//Get current month's start and end date
		dates = Helper.getDateRange();
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+product.getUserID());
		productDAO.getProductTransactions(product,transactions,dates);
		model.addAttribute("product",product);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "product/stockregister";

	}
	
	/**
	 * Method to get product stock transaction details between two dates 
	 * @param pBean
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/getProductTransactionByDates")
	public String getProductTransactionByDates(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ProductBean product = new ProductBean();
		Map<String,String> dates = new HashMap<String,String>();
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		if(request.getParameter("productid")== null || request.getParameter("productid")==""){
			return "home";
		}
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to get product transaction :: User - "+product.getUserID());
		product.setProductID(Integer.parseInt(request.getParameter("productid")));
		dates.put("startdate",request.getParameter("datefrom"));
		dates.put("enddate", request.getParameter("dateto"));
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+product.getUserID());
		productDAO.getProductTransactions(product,transactions,dates);
		model.addAttribute("product",product);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "product/stockregister";	
	}
	
	/**
	 * Method to edit a product
	 * @param productid
	 * @param model
	 * @param request
	 * @return
	 */
	
	@RequestMapping(value = "/editProduct", method = RequestMethod.GET)
	public ModelAndView editProduct(@RequestParam("productid") String productid,ModelMap model, HttpServletRequest request){
		HttpSession session = request.getSession();
		ProductBean product = new ProductBean();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to edit product :: User - "+product.getUserID());
		product.setProductID(Integer.parseInt(productid));
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
		productDAO.getProductDetails(product);
		productDAO.getCategoryDetails(product.getUserID(), categories);
		
		model.addAttribute("product",product);
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		ModelAndView mav = new ModelAndView();
		String viewName = "product/editproduct";
		mav.setViewName(viewName);
		return mav;		
	}
	
	/**
	 * Method to update a product
	 * @param product
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/updateProduct")
	public String updateProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session =request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		int category = 0;
		double totalStockValue = 0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to update product :: User - "+product.getUserID()+" :: Product ID - "+product.getProductID());
		LOGGER.debug("Request Details - Product ID - "+product.getProductID()+" :: Product Category - "+product.getProductCategory()
				+" :: Product - "+product.getProductName()
				+" :: Opening Balance - "+product.getOpeningBalance()+" :: Cost Price - "+product.getCostPrice()
				+" :: Dealer Price - "+product.getDealerPrice()+" :: Market Price - "+product.getMarketPrice()
				+" :: User - "+product.getUserID());
		flag=productDAO.updateProduct(product);
		if(flag){
			model.addAttribute("success","true");
			model.addAttribute("message","Product Update Successfully.");
			LOGGER.info("Product Updated Successfully :: Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
		}else{
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to update product. Please check with support team for assistance.");
			LOGGER.error("Failed to update product :: Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
		}
		
		List<ProductBean> products = new ArrayList<ProductBean>();
		category=Integer.parseInt(request.getParameter("redirectcategoryedit"));
		LOGGER.debug("Product Category - "+category+" :: User - "+product.getUserID());
		totalStockValue=productDAO.getProductsDetails(product.getUserID(),products,category);
		productDAO.getCategoryDetails(product.getUserID(), categories);
		model.addAttribute("category",category);
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "product/productlist";
	}
	
	/**
	 * Method to delete a product
	 * @param product
	 * @param model
	 * @param request
	 * @return
	 */
	
	@RequestMapping("/deleteProduct")
	public String deleteProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		boolean flag=false;
		List<ProductBean> products = new ArrayList<ProductBean>();
		double totalStockValue = 0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		product.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to delete a product :: Product ID - "+product.getProductID()
				+" :: User - "+product.getUserID());
		flag=productDAO.deleteProduct(product);
		if(flag== true){
			LOGGER.info("Product Deleted Successfully :: Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
			model.addAttribute("success","true");
			model.addAttribute("message","Product Deleted Successfully.");
		}
		else{
			LOGGER.info("Failed to delete product :: Product ID - "+product.getProductID()+" :: User - "+product.getUserID());
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to delete product. Please check with support team for assistance.");
		}
		
		LOGGER.debug("Product Category - "+product.getProductCategory()+" :: User - "+product.getUserID());
		totalStockValue=productDAO.getProductsDetails(product.getUserID(),products,product.getProductCategory());
		productDAO.getCategoryDetails(product.getUserID(), categories);
		model.addAttribute("category",product.getProductCategory());
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "product/productlist";
		
	}
	
	/**
	 * Method to redirect to product categories page
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/productCategories")
	 public String getProductCategories(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME));
		LOGGER.info("Request for Product Category List :: User - "+userid);
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		totalStockValue=productDAO.getCategoryDetails(userid,categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	/**
	 * Method to add a category
	 * @param category
	 * @param model
	 * @param request
	 * @return
	 */
			
	@RequestMapping("/addCategory")
	public String addCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		category.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to add a new category :: User - "+category.getUserID());
		LOGGER.debug("Request Details - Category - "+category.getCategory()+" :: User - "+category.getUserID());
		flag=productDAO.addCategory(category);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("New Category Added Successfully :: User - "+category.getUserID());
			model.addAttribute("message","Category Added Succesfully.");
		}else{
			model.addAttribute("success","false");
			LOGGER.error("Failed to add a category ::User -"+category.getUserID());
			model.addAttribute("message","Failed to add category. Please check with support team for assistance.");
		}
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	/**
	 * Method to update category details
	 * @param category
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/updateCategory")
	public String updateCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		category.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to update category :: User - "+category.getUserID());
		LOGGER.debug("Request Details - Category ID - "+category.getCategoryID()+" :: Category - "+category.getCategory()
				+" :: User - "+category.getUserID());
		
		flag=productDAO.updateCategory(category);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("Category Update Successfully :: User - "+category.getUserID());
			model.addAttribute("message","Category Update Succesfully.");
		}else{
			model.addAttribute("success","false");
			LOGGER.error("Failed to update category ::User -"+category.getUserID());
			model.addAttribute("message","Failed to update category. Please check with support team for assistance.");
		}
		
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	/**
	 * Method to delete a category
	 * @param category
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/deleteCategory")
	public String deleteCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		category.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to delete category :: User - "+category.getUserID());
		LOGGER.debug("Request Details - Category ID - "+category.getCategoryID()+" :: User - "+category.getUserID());
		
		flag=productDAO.deleteCategory(category);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("Category Deleted Successfully :: User - "+category.getUserID());
			model.addAttribute("message","Category Deleted Succesfully.");
		}else{
			model.addAttribute("success","false");
			LOGGER.error("Failed to delete category ::User -"+category.getUserID());
			model.addAttribute("message","Failed to delete category. Please check with support team for assistance.");
		}
		
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	/**
	 * Method to update product price list
	 * @param productList
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("/updateProductPrice")
	public String updateProductPrice(@ModelAttribute("AccountmateWS")ProductsBean productList,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session =request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		List<ProductBean> products = new ArrayList<ProductBean>();
		int category =0;
		//Check if session exists
		if(session.getAttribute(AccountConstants.USER_NAME)== null){
			return "home";
		}
		productList.setUserID(Integer.parseInt((String)session.getAttribute(AccountConstants.USER_NAME)));
		LOGGER.info("Request to update product list :: User - "+productList.getUserID());
		filterProductList(productList);
		flag=productDAO.updateProductPrice(productList);
		if(flag){
			model.addAttribute("success","true");
			model.addAttribute("message","Product Price Update Successfully.");
			LOGGER.info("Product Price Updated Successfully :: User - "+productList.getUserID());
		}else{
			model.addAttribute("success","false");
			model.addAttribute("message","Failed to update product price. Please check with support team for assistance.");
			LOGGER.error("Failed to update product price :: User - "+productList.getUserID());
		}
		
		category = productList.getProductsCategory();
		LOGGER.debug("Requested Product Category - "+category+" :: User - "+productList.getUserID());
		productDAO.getProductsDetails(productList.getUserID(),products,category);
		model.addAttribute("category",category);
		productDAO.getCategoryDetails(productList.getUserID(), categories);
		model.addAttribute("products",products);
		model.addAttribute("command",new ProductBean());
        model.addAttribute("categories",categories);
		return "productpricelist";
	}
	
	/**
	 * Method to filter unwanted data in the request list
	 * @param products
	 */
	private void filterProductList(ProductsBean products){
		List<ProductBean> filteredProducts = new ArrayList<ProductBean>();
		for(ProductBean product : products.getProducts()){
			if(product.getProductID() != 0){
				filteredProducts.add(product);
			}	
		}
		products.setProducts(filteredProducts);
	}
}

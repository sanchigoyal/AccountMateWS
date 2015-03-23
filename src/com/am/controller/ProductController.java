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
import com.am.model.bean.TransactionBean;
import com.am.model.dao.ProductDAO;
import com.am.model.dao.ProductDAOImpl;

@Controller
public class ProductController {
	
	static Logger LOGGER = Logger.getLogger(ProductController.class.getName());
	ProductDAO productDAO = new ProductDAOImpl();
	
	@RequestMapping("/newProduct")
	   public String createNewProduct(ModelMap model,HttpServletRequest request) {
		  List<CategoryBean> categories = new ArrayList<CategoryBean>();
		  HttpSession session = request.getSession();
			if(session.getAttribute("userid")== null){
				return "home";
			}
		  int userid=Integer.parseInt((String)session.getAttribute("userid"));
		  productDAO.getCategoryDetails(userid, categories);
	      model.addAttribute("categories",categories);
	      model.addAttribute("command",new ProductBean());
	      return "newproduct";
	   }
	
	@RequestMapping("/productList")
	 public String getProductList(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		int category =0;
		List<ProductBean> products = new ArrayList<ProductBean>();
		double totalStockValue = 0;
		LOGGER.info("Request for Product List :: User - "+userid);
		if(request.getParameter("option")!=null && request.getParameter("option") !="")
			{
				category=Integer.parseInt(request.getParameter("option"));
				LOGGER.debug("Requested Product Category - "+category+" :: User - "+userid);
				totalStockValue=productDAO.getProductsDetails(userid,products,category);
				model.addAttribute("category",category);
			}
		else{
			LOGGER.debug("Requested Product Category - All(-1) :: User - "+userid);
			model.addAttribute("category",-1);
			totalStockValue=productDAO.getProductsDetails(userid,products,-1);
		}
		
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
	    productDAO.getCategoryDetails(userid, categories);
        model.addAttribute("categories",categories);
		return "productlist";
	}
	
	@RequestMapping("/addProduct")
	public String addProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to add a new product :: User - "+session.getAttribute("userid"));
		LOGGER.debug("Request Details - Product Category - "+product.getProductCategory()+" :: Product - "+product.getProductName()
				+" :: Opening Balance - "+product.getOpeningBalance()+" :: Cost Price - "+product.getCostPrice()
				+" :: Dealer Price - "+product.getDealerPrice()+" :: Market Price - "+product.getMarketPrice()
				+" :: User - "+session.getAttribute("userid"));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		flag=productDAO.addProduct(product);
		if(flag){
			model.addAttribute("success","true");
			LOGGER.info("New Product Added Successfully :: User - "+product.getUserID());
		}else{
			model.addAttribute("success","false");
			LOGGER.error("Failed to add a product ::User -"+product.getUserID());
		}
		model.addAttribute("command",new ProductBean());
	    productDAO.getCategoryDetails(product.getUserID(), categories);
        model.addAttribute("categories",categories);
        model.addAttribute("command",new ProductBean());
		return "newproduct";
	}
	
	@RequestMapping(value = "/getProductQuantity", method = RequestMethod.GET)
	public @ResponseBody String getProductQuantity(
				@RequestParam("productid") String productid,HttpServletRequest request) {
			HttpSession session = request.getSession();
			if(session.getAttribute("userid")== null){
				return "home";
			}
			LOGGER.info("Request to get product quantity :: User - "+session.getAttribute("userid"));
			ProductBean product = new ProductBean();
			product.setProductID(Integer.parseInt(productid));
			LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+session.getAttribute("userid"));
			product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
			productDAO.getProductBalance(product);
			LOGGER.debug("User - "+session.getAttribute("userid")+" :: Product ID - "+product.getProductID()
					+" :: Product Balance - "+product.getProductBalance());
			return String.valueOf(product.getProductBalance());
		}
	
	@RequestMapping(value = "/getProductDLP", method = RequestMethod.GET)
	public @ResponseBody String getProductDLP(
				@RequestParam("productid") String productid,HttpServletRequest request) {
			HttpSession session = request.getSession();
			if(session.getAttribute("userid")== null){
				return "home";
			}
			LOGGER.info("Request to get product DLP :: User - "+session.getAttribute("userid"));
			ProductBean product = new ProductBean();
			product.setProductID(Integer.parseInt(productid));
			LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+session.getAttribute("userid"));
			product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
			productDAO.getProductDetails(product);
			LOGGER.debug("User - "+session.getAttribute("userid")+" :: Product ID - "+product.getProductID()
					+" :: Product DLP - "+product.getDealerPrice());
			return String.valueOf(product.getDealerPrice());
		}
	
	@RequestMapping("/stockRegister")
	 public String getProductTransactions(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		if(request.getParameter("productid")== null || request.getParameter("productid")==""){
			return "home";
		}
		LOGGER.info("Request to get product transaction :: User - "+session.getAttribute("userid"));
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ProductBean product = new ProductBean();
		Map<String,String> dates = new HashMap<String,String>();
		product.setProductID(Integer.parseInt(request.getParameter("productid")));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		dates = Helper.getDateRange();
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+product.getUserID());
		productDAO.getProductTransactions(product,transactions,dates);
		model.addAttribute("product",product);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "stockregister";

	}
	
	@RequestMapping("/getProductTransactionByDates")
	public String getProductTransactionByDates(@ModelAttribute("AccountmateWS")ProductBean pBean, 
			   ModelMap model,HttpServletRequest request){
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		if(request.getParameter("productid")== null || request.getParameter("productid")==""){
			return "home";
		}
		LOGGER.info("Request to get product transaction :: User - "+session.getAttribute("userid"));
		List<TransactionBean> transactions = new ArrayList<TransactionBean>();
		ProductBean product = new ProductBean();
		Map<String,String> dates = new HashMap<String,String>();
		product.setProductID(Integer.parseInt(request.getParameter("productid")));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		dates.put("startdate",request.getParameter("datefrom"));
		dates.put("enddate", request.getParameter("dateto"));
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: Start Date - "+dates.get("startdate")
				+" :: End Date - "+dates.get("enddate")+" :: User - "+product.getUserID());
		productDAO.getProductTransactions(product,transactions,dates);
		model.addAttribute("product",product);
		model.addAttribute("transactions",transactions);
		model.addAttribute("startdate",dates.get("startdate"));
		model.addAttribute("enddate",dates.get("enddate"));
		return "stockregister";	
	}
	
	@RequestMapping(value = "/editProduct", method = RequestMethod.GET)
	public ModelAndView editProduct(@RequestParam("productid") String productid,ModelMap model, HttpServletRequest request){
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		LOGGER.info("Request to edit product :: User - "+session.getAttribute("userid"));
		ProductBean product = new ProductBean();
		product.setProductID(Integer.parseInt(productid));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		LOGGER.debug("Requested Product ID - "+product.getProductID()+" :: User - "+session.getAttribute("userid"));
		productDAO.getProductDetails(product);
		model.addAttribute("product",product);
		model.addAttribute("command",new ProductBean());
		productDAO.getCategoryDetails(product.getUserID(), categories);
        model.addAttribute("categories",categories);
		ModelAndView mav = new ModelAndView();
		String viewName = "editproduct";
		mav.setViewName(viewName);
		return mav;		
	}

	@RequestMapping("/updateProduct")
	public String updateProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session =request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to update product :: User - "+session.getAttribute("userid")+" :: Product ID - "+product.getProductID());
		LOGGER.debug("Request Details - Product ID - "+product.getProductID()+" :: Product Category - "+product.getProductCategory()
				+" :: Product - "+product.getProductName()
				+" :: Opening Balance - "+product.getOpeningBalance()+" :: Cost Price - "+product.getCostPrice()
				+" :: Dealer Price - "+product.getDealerPrice()+" :: Market Price - "+product.getMarketPrice()
				+" :: User - "+session.getAttribute("userid"));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
		int category=Integer.parseInt(request.getParameter("redirectcategoryedit"));
		double totalStockValue = 0;
		LOGGER.debug("Product Category - "+category+" :: User - "+product.getUserID());
		totalStockValue=productDAO.getProductsDetails(product.getUserID(),products,category);
		model.addAttribute("category",category);
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
		productDAO.getCategoryDetails(product.getUserID(), categories);
        model.addAttribute("categories",categories);
		return "productlist";
	}
	
	@RequestMapping("/deleteProduct")
	public String deleteProduct(@ModelAttribute("AccountmateWS")ProductBean product,ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to delete a product :: Product ID - "+product.getProductID()
				+" :: User - "+session.getAttribute("userid"));
		product.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
		boolean flag=false;
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
		
		List<ProductBean> products = new ArrayList<ProductBean>();
		double totalStockValue = 0;
		LOGGER.debug("Product Category - "+product.getProductCategory()+" :: User - "+product.getUserID());
		totalStockValue=productDAO.getProductsDetails(product.getUserID(),products,product.getProductCategory());
		model.addAttribute("category",product.getProductCategory());
		model.addAttribute("products",products);
		model.addAttribute("totalStockValue",totalStockValue);
		model.addAttribute("numberofproducts",products.size());
		model.addAttribute("command",new ProductBean());
		productDAO.getCategoryDetails(product.getUserID(), categories);
        model.addAttribute("categories",categories);
		return "productlist";
		
	}
	
	@RequestMapping("/productCategories")
	 public String getProductCategories(ModelMap model,HttpServletRequest request) {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		int userid=Integer.parseInt((String)session.getAttribute("userid"));
		LOGGER.info("Request for Product Category List :: User - "+userid);
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		totalStockValue=productDAO.getCategoryDetails(userid,categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	@RequestMapping("/addCategory")
	public String addCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to add a new category :: User - "+session.getAttribute("userid"));
		LOGGER.debug("Request Details - Category - "+category.getCategory()+" :: User - "+session.getAttribute("userid"));
		category.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	@RequestMapping("/updateCategory")
	public String updateCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to update category :: User - "+session.getAttribute("userid"));
		LOGGER.debug("Request Details - Category ID - "+category.getCategoryID()+" :: Category - "+category.getCategory()
				+" :: User - "+session.getAttribute("userid"));
		category.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
	
	@RequestMapping("/deleteCategory")
	public String deleteCategory(@ModelAttribute("AccountmateWS")CategoryBean category,ModelMap model, HttpServletRequest request){
		boolean flag=false;
		HttpSession session = request.getSession();
		if(session.getAttribute("userid")== null){
			return "home";
		}
		LOGGER.info("Request to delete category :: User - "+session.getAttribute("userid"));
		LOGGER.debug("Request Details - Category ID - "+category.getCategoryID()+" :: User - "+session.getAttribute("userid"));
		category.setUserID(Integer.parseInt((String)session.getAttribute("userid")));
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
		List<CategoryBean> categories = new ArrayList<CategoryBean>();
		double totalStockValue = 0;
		totalStockValue=productDAO.getCategoryDetails(category.getUserID(),categories);
		model.addAttribute("categories",categories);
		model.addAttribute("totalstockvalue",totalStockValue);
		model.addAttribute("command",new CategoryBean());
		return "productcategories";
	}
}

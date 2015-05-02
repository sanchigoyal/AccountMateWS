<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Accountmate v1.2</title>
  </head>

  <body>
	<script>
	   function toggleOptional (obj, id ) {
			if ($("#" + id ).css("display") == 'none' ) {
		    	$("#" + id).show("normal");
				obj.innerHTML = '<i class="fa fa-minus-square extraPaddingRight20"></i>';
			}
			else {
				$("#" + id).hide("normal");
				obj.innerHTML = '<i class="fa fa-plus-square extraPaddingRight20"></i>';
			}
			return true;
		}
		
		function doSearch() {
			var searchText = document.getElementById('searchTerm').value.toLowerCase();
			var targetTable = document.getElementById('productList');
			
			for (var rowIndex = 1; rowIndex < targetTable.rows.length-1; rowIndex=rowIndex+2) {
				var rowData = '';
				var colIndex =1;//Only on client name
				//Process data rows. (rowIndex >= 1)
				rowData += targetTable.rows.item(rowIndex).cells.item(colIndex).textContent.toLowerCase();
				if (rowData.indexOf(searchText) == -1)
					targetTable.rows.item(rowIndex).style.display = 'none';
				else
					targetTable.rows.item(rowIndex).style.display = 'table-row';
				
			}
		}
		
		function updateDeleteModal(productName,productid,balance){
			if(balance!=0 || balance!=0.0 || balance !=0.00){
				$('#deletebutton').hide();
				$('#confirmquestion').hide();
			}
			else{
				$('#deletebutton').show();
				$('#confirmquestion').show();
			}
			$('#deleteproductid').val(productid);
			$('#redirectcategory').val($('#productCategory').val());
			document.getElementById('productName').innerHTML=productName;
		}
		
		function updateEditModal(productid){
			var data = 'productid='
				+ encodeURIComponent(productid);
			$.ajax({
				url : "/AccountmateWS/editProduct",
				data : data,
				type : "GET",

				success : function(data) {
					$('#product-content').html(data);
					$('#redirectcategoryedit').val($('#productCategory').val());
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});	
			
		}
	</script>
    
    <!-- Header -->
    <%@include file="../headernew.jsp" %>
	<!-- -- --- -->
	
	<!--Client list
	==============================================================================================================-->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2 class="text-left col-md-6">Stock Register</h2>
				<h2 class="text-right col-md-6">Total Products(${numberofproducts})</h2><!--Provide the number of product -->
			</div>
			<div class="col-md-12">
				<hr/>
			</div>
			<div class="col-md-12">
				<div id="success" class="hideIt">
		            <div class="alert alert-success" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> ${message}
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> ${message}
		            </div>
		        </div>
		    </div>
			<!-- Search Form
			==============================-->
			<div class="col-md-12">
				<div class="well col-md-12">
					<div class="col-md-6">	
							<input type="text" class="form-control" placeholder="Search :: Enter Product Name .." onkeyup="doSearch()" id="searchTerm"/>
					</div>
					<div class="form-group">
						<label for="name" class="col-md-1 col-md-offset-2">Category</label>
						<div class="col-md-3">
							<select id="productCategory" name="productCategory" class="form-control" onChange="updateProducts(this);">
							<option value="-1">All</option>
							<c:forEach var="category" items="${categories}">
									<option value="${category.categoryID}">${category.category}</option>
							</c:forEach>
							</select>
						</div>
					</div>
				</div>
			</div>
		    
		    <!--Table of client list--
			==================================-->
			<div class="col-md-12">
				<table id="productList" class="table">
					<thead>
						<tr>
							<th class="text-center">#</th>
							<th>Product Name</th>
							<th class="text-right">Available Quantity(Pc.)</th>
							<th class="text-right">Stock Value</th>
							<th class="text-center">Action</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="product" items="${products}">
						<!--Single TR-->
						<tr id="parentrow${product.productID}">
							<td class="text-center">${product.productID}</td>
							<td><a class="pointerCursor" onclick="toggleOptional(this, '${product.productID}');"><i class="fa fa-plus-square extraPaddingRight20"></i></a>${product.productName}</td>
							<td class="text-right">${product.productBalance}</td>
							<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.stockValue}</td>
							<td class="text-center"><p><a href="/AccountmateWS/stockRegister?productid=${product.productID}" class="addLineSeperator" data-toggle="tooltip" data-placement="bottom" title="Stock Register"><i class="fa fa-book fa-lg extraPaddingLeftRight5"></i></a>
							<a data-toggle="modal" href="#editProduct" class="addLineSeperator" onClick="updateEditModal('${product.productID}');" title="Edit"><i class="fa fa-edit fa-lg extraPaddingLeftRight5"></i></a>
							<a data-toggle="modal" href="#productDelete" title="delete" onclick="updateDeleteModal('${product.productName}','${product.productID}','${product.productBalance}');"><i class="fa fa-trash fa-lg extraPaddingLeftRight5"></i></a></p></td>
						</tr>
						<tr id="childrow${product.productID}">
							<td colspan="7" style="padding: 0; border: none;">
								<div id="${product.productID}" class="hideIt"><!--div id is same as client id-->
									<table class="table table-striped">
										<tr>
											<td>
											<table>
												<tr><td><strong>Current <abbr title="Cost Price">CP</abbr></strong></td><td><strong>:</strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.costPrice}</td></tr>
												<tr><td><strong>Current <abbr title="Dealer List Price">DLP</abbr></strong></td><td><strong>:</strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.dealerPrice}</td></tr>
												<tr><td><strong>Current <abbr title="Market Retail Price">MRP</abbr></strong></td><td><strong>:</strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.marketPrice}</td></tr>
											</table>
											</td>
											<td nowrap="nowrap" align="left" >
												<strong>Purchase: </strong>${product.totalPurchase}<br />
												<strong>Sold: </strong>${product.totalSales}<br/>
											</td>
											<td nowrap="nowrap" align="left" >
												<strong>Category: </strong>${product.productCategoryName}<br />
											</td>
											<td align="left" nowrap="nowrap">
												<strong>Sales Amount: </strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>0.00<br />
												<strong>Purchase Amount: </strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>0.00<br />
												<strong>Profit: </strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>0.00<br />
												<strong>Profit %: </strong>0.00%<br />
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
						<!--TR End-->
						</c:forEach>
						<!--Total-->
						<tr class="well">
							<td colspan="3" class="text-right"><strong>Total:</strong></td>
							<td colspan="1"  class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${totalStockValue}</td>
							<td colspan="2"></td>
						</tr>
					</tbody>
				</table>
			</div>	
			
			<!----Delete Product Modal--->
			<div class="modal fade" id="productDelete" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
							<div class="modal-header">
								<h2>Are you sure ?</h2>
							</div>
							<div class="modal-body">
								<p>Deleting the product will not remove its sales/purchase entries as they are used for your records, and any
							product with non-zero availability will not be deleted.</p>
								<p id="confirmquestion">Are you sure you want to delete <label id="productName"></label> ?</p>
							</div>
							<div class="modal-footer">
								<form:form class="form-inline" id="productdeleteform" method="post" action="/AccountmateWS/deleteProduct">
									<input type="hidden" id="deleteproductid" name="productID" value = ""/>
									<input type="hidden" id="redirectcategory" name="productCategory" value = ""/>
									<button id="deletebutton" type="submit" class="btn btn-danger">Delete</button>
									<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
								</form:form>
							</div>
					</div>
				</div>
			</div>
			<!-- Edit Product Modal -->
			<div class="modal fade" id="editProduct" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div id="product-content" class="modal-content">
							<%@include file="editproduct.jsp" %>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Footer -->
    <%@include file="../footernew.jsp" %>
	<!-- -- --- -->
    <script>
		if("${success}" == "true")
		{
			document.getElementById("success").style.display = "block";
			document.getElementById("failure").style.display = "none";
		}
		else if ("${success}" == "false"){
			document.getElementById("success").style.display = "none";
			document.getElementById("failure").style.display = "block";
		}
		else{	
			document.getElementById("success").style.display = "none";	
			document.getElementById("failure").style.display = "none";
		}
	</script>
	<script type="text/javascript">
	var options= document.getElementById('productCategory').options;
	for (var i= 0, n= options.length; i<n; i++) {
	    if (options[i].value==='${category}') {
	        options[i].selected= true;
	        break;
	    }
	}
	$(function () {
		  $('[data-toggle="tooltip"]').tooltip();
		});
    function updateProducts(option){
		document.location.href="/AccountmateWS/productList?option="+option.value;   
	}
	</script>
  </body>
</html>
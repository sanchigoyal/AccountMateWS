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
    <!-- Header -->
    <%@include file="../headernew.jsp" %>
	<!-- -- --- -->
	
	<!--Client list
	==============================================================================================================-->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2 class="text-left">Price List</h2>
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
					<div class="form-group">
						<label class="col-md-1 control-label">Category</label>
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
			
			<!--Table of price list--
			==================================-->	
			<div class="col-md-9">
				<form:form id="changeForm" action="/AccountmateWS/updateProductPrice" method="post">
					<table id="productList" class="table">
						<thead>
							<tr>
								<th class="text-center">#</th>
								<th>Product Name</th>
								<th class="text-right">Cost Price</th>
								<th class="text-right">Dealer List Price</th>
								<th class="text-center">Market Retail Price</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="product" items="${products}" varStatus="loop">
							<!--Single TR-->
							<tr id="row${product.productID}">
								<td class="text-center">
									<span>${product.productID}</span>
									<input type="hidden" name="products[${loop.index}].productID" value="${product.productID}">
								</td>
								<td>${product.productName}</td>
								<td class="text-right col-md-2" data-actual="${product.costPrice}">
									<span class="edit pointerCursor"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.costPrice}</span>
									<div class="form-group">
	    								<input type="text" name="products[${loop.index}].costPrice" class="edit-input form-control text-right cp price" value="${product.costPrice}"/>						
									</div>
								</td>
								<td class="text-right col-md-2" data-actual="${product.dealerPrice}">
									<span class="edit pointerCursor"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.dealerPrice}</span>
									<div class="form-group">
	    								<input type="text" name="products[${loop.index}].dealerPrice" class="edit-input form-control text-right dp price" value="${product.dealerPrice}"/>						
									</div>
								</td>
								<td class="text-right col-md-2" data-actual="${product.marketPrice}">
									<span class="edit pointerCursor"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${product.marketPrice}</span>
	    							<div class="form-group">
	    								<input type="text" name="products[${loop.index}].marketPrice" class="edit-input form-control text-right mrp price" value="${product.marketPrice}"/>						
									</div>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
					<input type="hidden" id="redirectcategory" name="productsCategory" value = "${category}"/>
					<input type="submit" class="btn btn-success pull-right" value="Save Changes">
				</form:form>
			</div>
			<div class="col-md-3">
				<div class="well">
					<table id="changeTable">
						<tr><th>Changes..</th></tr>
					</table>
					<br/>
					
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
    <%@include file="../footernew.jsp" %>
	<!-- -- --- -->

    <script>
	    $(document).ready(function() {
		    $('#productList').dataTable();
		    $('input[type=text].edit-input').css("display","none");
		} );
	    
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
	    if (options[i].value=='${category}') {
	        options[i].selected= true;
	        break;
	    }
	}
    
    function updateProducts(option){
		document.location.href="/AccountmateWS/productPriceList?option="+option.value;   
	}
    
    $(document).ready(function() {
        $('span.edit').click(function () {
        	var dad = $(this).parent();
            dad.find('span').hide();
           	dad.find('div').css("display", "block");
           	dad.find('div').find('input[type="text"]').css("display", "block");
           	dad.find('div').find('input[type="text"]').focus();
        });
        $('input[type=text].edit-input').focusout(function() {
            var dad = $(this).parent().parent();//td
            var productid = dad.parent().children().first().find('span').html();
            var productName = dad.parent().children().first().next().html();
            if($(this).parent().hasClass("has-error")){
            	//do nothing on error.
            }
            else{
            if (dad.attr("data-actual") != parseFloat($(this).val())){
            	//Update Span Value
            	dad.css('background', 'yellow');
            	dad.find('span').html('<i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val());
         
            	//Add a entry in change table
            	//if already exists , remove and add
            	
            	if($('#changeRow'+productid).length){
            		if($(this).hasClass("cp")){
            			//if already exist remove and add
            			//or else add
            			if($('#cp'+productid).length){
            				$('#cp'+productid).html('CP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span>');
            			}
            			else{
            				$('#changeRow'+productid+' td ul').append('<li id="cp'+productid+'">CP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li>');
            			}
                	}
                	else if($(this).hasClass("dp")){
                		//if already exist remove and add
                		//or else add
                		if($('#dp'+productid).length){
            				$('#dp'+productid).html('DP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span>');
            			}
            			else{
            				$('#changeRow'+productid+' td ul').append('<li id="dp'+productid+'">DP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li>');
            			}
                	}
                	else{
                		//if already exist remove and add
                		//or else add
                		if($('#mrp'+productid).length){
            				$('#mrp'+productid).html('MRP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span>');
            			}
            			else{
            				$('#changeRow'+productid+' td ul').append('<li id="mrp'+productid+'">MRP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li>');
            			}
                	}	
            	}
            	else{
            		
            		//if no entry exists . Create a fresh one.
            		var rowHTML="";

            		if($(this).hasClass("cp")){
            			rowHTML = '<tr id="changeRow'+productid+'"><td><h5><strong>'+productName+'</strong></h5><p><ul><li id="cp'+productid+'">CP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li></ul></p></td></tr>';
                	}
                	else if($(this).hasClass("dp")){
                		rowHTML = '<tr id="changeRow'+productid+'"><td><h5><strong>'+productName+'</strong></h5><p><ul><li id="dp'+productid+'">DP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li></ul></p></td></tr>';
                	}
                	else{
                		rowHTML = '<tr id="changeRow'+productid+'"><td><h5><strong>'+productName+'</strong></h5><p><ul><li id="mrp'+productid+'">MRP: <s class="text-danger"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+dad.attr("data-actual")+'</s> <span class="text-success"><i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val()+'</span></li></ul></p></td></tr>';
                	}
                	$('#changeTable').append(rowHTML);
                	$('#submitChanges').prop("disabled",false);
            	}	
            }
            else{
            	dad.find('span').html('<i class="fa fa-rupee extraPaddingLeftRight5"></i>'+$(this).val());
                dad.css('background', 'white');
                //delete any entry in the table
                if($('#changeRow'+productid).length){
                	//Can't remove every thing.
                	if($(this).hasClass("cp")){
                		if($('#cp'+productid).length){
            				$('#cp'+productid).remove();
            			}
                	}
                	else if($(this).hasClass("dp")){
                		if($('#dp'+productid).length){
            				$('#dp'+productid).remove();
            			}
                	}
                	else{
                		if($('#mrp'+productid).length){
            				$('#mrp'+productid).remove();
            			}
                	}
                	//Remove everything
                	if(!$('#cp'+productid).length && !$('#dp'+productid).length && !$('#mrp'+productid).length){
                		$('#changeRow'+productid).remove();
                	}
                	
                }
            }
            $(this).parent().hide();
            dad.find('span').show();
           }
        });
    });
	</script>
	<script>
	$(document).ready(function() {
	    $('#changeForm').bootstrapValidator({
	        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
	        feedbackIcons: {
	            valid: 'glyphicon glyphicon-ok',
	            invalid: 'glyphicon glyphicon-remove',
	            validating: 'glyphicon glyphicon-refresh'
	        },
	        fields: {
	            price: {
	            	selector: '.price',
	                message: 'The price is not valid',
	                validators: {
	                    notEmpty: {
	                        message: 'The price is required'
	                    },
	                    numeric: {
	                        message: 'The price must be a number'
	                    }
	                }
	            }
	        }
	    });
	});
	</script>
  </body>
</html>
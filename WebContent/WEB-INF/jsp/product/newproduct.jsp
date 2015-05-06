<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
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
    <%@include file="../layout/headernew.jsp" %>
	<!-- -- --- -->
	
	<div class="container">
		<div class="row">
			<div class="col-md-8">
				<h2>Add product</h2><hr/>
				<div id="success" class="hideIt">
		            <div class="alert alert-success">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> Product Added Successfully.
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> Failed to add product. Please check with support team for assistance.
		            </div>
		        </div>
				<form:form class="form-horizontal" id="productForm" action="/AccountmateWS/addProduct" method="post">
					<div class="form-group">
						<label class="col-md-3 control-label">Product Category</label>
						<div class="col-md-4">
							<select id="productcategory" name="productCategory" class="form-control">
							<c:forEach var="category" items="${categories}">
								<option value="${category.categoryID}">${category.category}</option>
							</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Product Name</label>
						<div class="col-md-8">
							<input id="productname" name="productName" type="text" class="form-control" placeholder="Enter Product Name..."/>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Opening Balance (units)</label>
						<div class="col-md-8">
							<input id="openingbalance" name="openingBalance" type="text" class="form-control" placeholder="Enter Opening Balance... ">
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Curr. Cost Price</label>
						<div class="col-md-8">
							<div class="input-group">
				                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
				                <input id="costprice" name="costPrice" type="text" class="form-control" placeholder="Enter Curr. Cost Price... ">
				            </div>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Curr. DLP</label>
						<div class="col-md-8">
							<div class="input-group">
				                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
				                <input id="dealerprice" name="dealerPrice" type="text" class="form-control" placeholder="Enter Curr. DLP... ">
				            </div>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Curr. MRP (<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</label>
						<div class="col-md-8">
							<div class="input-group">
				                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
				                <input id="marketprice" name="marketPrice" type="text" class="form-control" placeholder="Enter Curr. MRP... ">
				            </div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-8 col-md-offset-3">
							<button type="submit" class="btn btn-primary">Save</button>
							<button type="reset" class="btn btn-default">Clear</button>
						</div>
					</div>
				</form:form>
			</div>
			<div class="col-md-4">
				<br/><br/><br/>
				<div class="well">
					<h4><strong>Upload CSV file</strong></h4>
					<div>
						<p>Use this to upload multiple products from a .csv file. </p>
						  <form  class="form-horizontal" id="formcsv" name="formcsv" method="post" action="import_clients.php" enctype="multipart/form-data">
						  	<div class="form-group">
								<div class="col-md-4">
									<input name="csv" type="file" id="csv"/>
								</div>
							</div>
							<div class="form-group">
								<div class="col-md-4">
									<button type="submit" class="btn btn-success">Upload</button>
								</div>
							</div>
						  	<p><strong>The format MUST be:</strong></p>
						  	<p>product category, product name, opening balance, cost price, dealer list price, market retail price</p>
						  	<p>Please <a href="sample-clients.zip">click here</a> to download a sample .csv file. </p>
						  	<p><strong>Troubleshooting:</strong></p>
							  <ul>
							    <li>If you have any problems uploading a .csv file, it will be due to the data columns not being as listed above. </li>
							    <li>Data columns need to be in the above order.</li>
							    <li>If some columns are missing information, just leave them blank &mdash; but they still need to exist in the file. </li>
							    <li>You'll need to remove any additional data columns not included in the above list. </li>
							  </ul>
						  </form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
    <%@include file="../layout/footernew.jsp" %>
	
	<!--Block of code to display success or failure message --- -->
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
	
	<!-- Bootstrap Validation Logic -->
	<script>
	$(document).ready(function() {
    $('#productForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	productName: {
                message: 'The product name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The product name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 30,
                        message: 'The product name must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9_]+$/,
                        message: 'The product name can consist of alphabetical, number and underscore'
                    }
                }
            },
            openingBalance: {
                message: 'The opening balance is not valid',
                validators: {
                	notEmpty: {
                        message: 'The opening balance is required'
                    },
                    regexp: {
                    	regexp: /^[0-9]+$/,
                        message: 'The opening balance can only consist of numbers'
                    }
                }
            },
            costPrice: {
                message: 'The cost price is not valid',
                validators: {
                    notEmpty: {
                        message: 'The cost price is required'
                    },
                    numeric: {
                        message: 'The cost price must be a number'
                    }
                }
            },
            marketPrice: {
                message: 'The MRP is not valid',
                validators: {
                    notEmpty: {
                        message: 'The market price is required'
                    },
                    numeric: {
                        message: 'The market price must be a number'
                    }
                }
            },
            dealerPrice: {
                message: 'The DLP is not valid',
                validators: {
                    notEmpty: {
                        message: 'The dealer price is required'
                    },
                    numeric: {
                        message: 'The dealer price must be a number'
                    }
                }
            }
            
        }
    });
});
</script>
</body>
</html>
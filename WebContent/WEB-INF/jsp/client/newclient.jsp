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
	
	<div class="container">
		<div class="row">
			<div class="col-md-8">
				<h2>Add client</h2><hr/>
				<div id="success" class="hideIt">
		            <div class="alert alert-success">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> Client added successfully.
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> Failed to add client. Please check with support team for assistance.
		            </div>
		        </div>
				<form:form class="form-horizontal" id="clientForm" action="/AccountmateWS/addClient" method="post">
					<div class="form-group">
						<label class="col-md-3 control-label">Client Category</label>
						<div class="col-md-4">
							<select name="clientCategory" id="clientcategory" class="form-control">
								<c:forEach var="category" items="${categories}">
									  <c:if test="${category.category ne 'CASH'}">
									   	<option value="${category.categoryID}">${category.category}</option>
									  </c:if>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Contact Name</label>
						<div class="col-md-4">
							<input id="firstname" name="contactFirstName" type="text" class="form-control" placeholder="Enter First Name..."/>
						</div>
						<div class="col-md-4">
							<input  id="lastname" name="contactLastName" type="text" class="form-control" placeholder="Enter Last Name...">
						</div>
					</div>
 					<div class="form-group">
						<label class="col-md-3 control-label">TIN</label>
						<div class="col-md-4">
							<input type="text" id="tin" name="clientTIN" class="form-control" placeholder="Enter TIN #... ">
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-3 control-label">Email Address</label>
						<div class="col-md-8">
							<input type="email" id="email" name="clientEmail" class="form-control" placeholder="Enter Email... ">
							<p class="help-block">Example: yourname@domain.com</p>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Account/Business Name</label>
						<div class="col-md-8">
							<input type="text" id="accountname" name="clientName" class="form-control" placeholder="Enter Account/Business Name... ">
						</div>
					</div>
					<hr/>
					<div class="form-group">
						<label class="col-md-3 control-label">Phone Number</label>
						<div class="col-md-8">
							<div class="input-group">
				                <div class="input-group-addon">+91</div>
				                <input type="text" id="phonenumber" name="clientPhoneNumber" class="form-control" placeholder="Enter Phone Number... ">
				            </div>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Billing/Shipping Address</label>
						<div class="col-md-8">
							<input type="text" id="address" name="clientAddress" class="form-control" placeholder="Enter Address... ">
						</div>
					</div>
					<div class="form-group">
					  <div class="col-sm-offset-3">
						<div class="col-md-4">
							<select id="country" name="clientCountry" class="bfh-selectbox bfh-countries form-control"  data-country="IN" data-flags="true" data-blank="false">
							</select>
						</div>
						<div class="col-md-5">
							<select id="state" name="clientState" class="form-control bfh-states" data-country="country"></select>
						</div>
					  </div>
					</div>
					<hr/>
					<div class="form-group">
						<div class="col-md-3 control-label">
							<label>Custom Days to Pay</label>
							<p class="help-block text-justify">All invoices to this client will use this number of days from the invoice date to be due.</p>
						</div>
						<div class="col-md-3">
							<select id="customdaystopay" name="customDaysToPay" class="form-control">
							  <option value="10">10</option>
							  <option value="15">15</option>
							  <option value="20">20</option>
							  <option value="25">25</option>
							  <option value="30">30</option>
							  <option value="45">45</option>
							</select>
						</div>
					</div>
					<div class="form-group required">
						<label class="col-md-3 control-label">Opening Balance</label>
						<div class="col-md-8">
							<div class="input-group">
								 <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
								 <input type="text" id="openingbalance" name="OpeningBalance" class="form-control" placeholder="Enter Opening Balance... ">
							</div>
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-10 col-md-offset-3">
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
	<%@include file="../footernew.jsp" %>
	<!--  -- -- -->
	
   
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
	
	<script>
	$(document).ready(function() {
    $('#clientForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	contactFirstName: {
                message: 'The firstname is not valid',
                row: '.col-md-4',
                validators: {
                    notEmpty: {
                        message: 'The firstname is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 30,
                        message: 'The firstname must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z]+$/,
                        message: 'The firstname can only consist of alphabets'
                    }
                }
            },
            contactLastName: {
                message: 'The lastname is not valid',
                row: '.col-md-4',
                validators: {
                    notEmpty: {
                        message: 'The lastname is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 30,
                        message: 'The lastname must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z]+$/,
                        message: 'The lastname can only consist of alphabets'
                    }
                }
            },
            clientTIN: {
                message: 'The TIN number is not valid',
                validators: {
                    regexp: {
                        regexp: /^[a-zA-Z0-9]+$/,
                        message: 'The TIN can consist of alphabets and digts(0-9)'
                    }
                }
            },
            clientEmail: {
                validators: {
                    emailAddress: {
                        message: 'The email address is not valid'
                    }
                }
            },
            
            clientName: {
                message: 'The Account/Business name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The Account/Business name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 50,
                        message: 'The Account/Business name must be more than 3 and less than 50 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z]+$/,
                        message: 'The Account/Business name can only consist of alphabets'
                    }
                }
            },
            clientPhoneNumber: {
                message: 'The phone number is not valid',
                validators: {
                    stringLength: {
                        min: 10,
                        max: 10,
                        message: 'The phone number must be of 10 digits'
                    },
                    regexp: {
                        regexp: /^[0-9]+$/,
                        message: 'The phone number can only consist of digit[0-9]'
                    }
                }
            },
            clientAddress: {
                message: 'The address is not valid',
                validators: {
                    notEmpty: {
                        message: 'The address is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 50,
                        message: 'The address must be more than 3 and less than 50 characters long'
                    },
                    regexp: {
                    	regexp: /^[a-z 0-9A-Z,]+$/,
                        message: 'The Account/Business name can only consist of alphabets,numbers and comma(,)'
                    }
                }
            },
            clientState: {
                validators: {
                    notEmpty: {
                        message: 'The state is required'
                    }
                }
            },
            OpeningBalance: {
                message: 'The opening balance is not valid',
                validators: {
                	notEmpty: {
                        message: 'The opening balance is required'
                    },
                    numeric: {
                        message: 'The opening balance must be a number'
                    }
                }
            }
            
              
        }
    });
});
</script>
</body>
</html>
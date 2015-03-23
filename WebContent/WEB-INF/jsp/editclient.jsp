<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<div class="modal-header">
	<h2>Edit</h2>
</div>
<div class="modal-body">
	<form:form class="form-horizontal"  id="clientForm" action="/AccountmateWS/updateClient" method="post">
		<input type="hidden" name="clientID" id="clientid" value="${client.clientID}">
		<input type="hidden" name="redirectcategoryedit" id="redirectcategoryedit" value ="">
		<div class="form-group">
			<label for="name" class="col-md-2">Client Category</label>
			<div class="col-md-3">
				<select name="clientCategory" id="clientcategorymodal" class="form-control">
				<c:forEach var="category" items="${categories}">
					<option value="${category.categoryID}">${category.category}</option>
				</c:forEach>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="name" class="col-md-2">Contact Name</label>
			<div class="col-md-5">
				<input id="firstname" name="contactFirstName" type="text" class="form-control" value="${client.contactFirstName}" placeholder="Enter First Name..."/>
			</div>
			<div class="col-md-5">
				<input  id="lastname" name="contactLastName" type="text" class="form-control" value="${client.contactLastName}" placeholder="Enter Last Name...">
			</div>
		</div>
			<div class="form-group">
			<label for="tinnumber" class="col-md-2">TIN</label>
			<div class="col-md-5">
				<input type="text" id="tin" name="clientTIN" value="${client.clientTIN}" class="form-control" placeholder="Enter TIN #... ">
			</div>
		</div>
		<div class="form-group">
			<label for="emailaddress" class="col-md-2">Email Address</label>
			<div class="col-md-5">
				<input type="email" id="email" name="clientEmail" class="form-control" value="${client.clientEmail}" placeholder="Enter Email... ">
				<p class="help-block">Example: yourname@domain.com</p>
			</div>
		</div>
		<div class="form-group">
			<label for="accountname" class="col-md-2">Account/Business Name</label>
			<div class="col-md-5">
				<input type="text" id="accountname" name="clientName" class="form-control"  value = "${client.clientName}" placeholder="Enter Account/Business Name... ">
			</div>
		</div>
		
		<hr/>
		
		
		<div class="form-group">
			<label for="phonenumber" class="col-md-2">Phone Number</label>
			<div class="col-md-5">
				<input type="text" id="phonenumber" name="clientPhoneNumber" class="form-control" value="${client.clientPhoneNumber}" placeholder="Enter Phone Number... ">
			</div>
		</div>
		<div class="form-group">
			<label for="address" class="col-md-2">Billing/Shipping Address</label>
			<div class="col-md-10">
				<input type="text" id="address" name="clientAddress" class="form-control" value="${client.clientAddress}" placeholder="Enter Address... ">
			</div>
		</div>
		<div class="form-group">
		  <div class="col-sm-offset-2">
			<div class="col-md-4">
				<select id="country" name="clientCountry" class="bfh-selectbox bfh-countries form-control"  data-country="${client.clientCountry}" data-flags="true" data-blank="false">
				</select>
			</div>
			<div class="col-md-4">
				<select id="state" name="clientState" class="form-control bfh-states" data-country="${client.clientCountry}" data-state="${client.clientState}"></select>
			</div>
		  </div>
		</div>
		<hr/>
		<div class="form-group">
			<div class="col-md-2">
				<label for="customdaystopay" >Custom Days to Pay</label>
				<p class="help-block">All invoices to this client will use this number of days from the invoice date to be due.</p>
			</div>
			<div class="col-md-2">
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
		<div class="form-group">
			<label for="openingbalance" class="col-md-2">Opening Balance (<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</label>
			<div class="col-md-4">
				<input onblur="convertDecimal();" type="text" id="openingbalance" value="${client.openingBalance}" name="OpeningBalance" class="form-control" placeholder="Enter Opening Balance... ">
			</div>
		</div>
		<div class="form-group">
			<div class="col-md-10 col-md-offset-2">
				<button type="submit" class="btn btn-primary">Update</button>
			</div>
		</div>
	</form:form>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
</div>
<script src="resources/js/bootstrap-formhelpers.min.js"></script>
<script>
$('[name=customDaysToPay]').val("${client.customDaysToPay}");
$('#clientcategorymodal').val("${client.clientCategory}");	
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
                        message: 'The TIN can consist of alphabets and digits(0-9)'
                    }
                }
            },
            clientEmail: {
                validators: {
                    notEmpty: {
                        message: 'The email address is required and cannot be empty'
                    },
                    emailAddress: {
                        message: 'The email address is not a valid'
                    }/*,
                    callback: {
                        message: 'The email is not available',
                        callback: function(value, validator) {
                            return checkEmailAvailability()
                        }
                    }*/
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
                    notEmpty: {
                        message: 'The phone number is required and cannot be empty'
                    },
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
                    regexp: {
                    	regexp: /^[0-9.]+$/,
                        message: 'The opening balance can only consist of numbers and point(.)'
                    }
                }
            }
            
              
        }
    });
});
</script>
<script>
function number_format(num)
{
	num="" + Math.floor(num*100.0 + 0.5)/100.0;
	var i=num.indexOf(".");
	if(num=="NaN"){
		num="00.00";
	}
	else if (i<0 ) {
		num+=".00";}
	else {
	num=num.substring(0,i) + "." + num.substring(i + 1);
	var nDec=(num.length - i) - 1;
	if ( nDec==0 ) num+="00";
	else if ( nDec==1 ) num+="0";
	else if ( nDec>2 ) num=num.substring(0,i + 3);
	}
	return num;
}
	function convertDecimal(){
		var openingbalance = $('#openingbalance').val();
		var temp=parseFloat(openingbalance);
		$('#openingbalance').val(number_format(temp));
	}
</script>
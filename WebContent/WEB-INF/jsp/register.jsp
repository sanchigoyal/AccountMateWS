<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Accountmate</title>

    <!-- Bootstrap core CSS -->
    <link href="resources/css/bootstrap.min.css" rel="stylesheet">
	<link href="resources/css/font-awesome.min.css" rel="stylesheet">
	<link href="resources/css/style.css" rel="stylesheet">
	<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
	<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">

  </head>

  <body>

    <!-- Fixed navbar 
	===============================================================================================================-->
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Accountmate</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="/AccountmateWS/start">Home</a></li>
            <li><a href="/AccountmateWS/contact">Contact</a></li>
          </ul>
       </div><!--/.nav-collapse -->
      </div>
    </div>
	
	<!-- Registration Form 
	==============================================================================================================-->
	</br></br></br></br>
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2><i class="fa fa-rocket"></i><label class="extraPadding20">Sign Up</label></h2><hr/>
				<div id="success">
		            <div class="alert alert-success">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Thank you!</strong>Please login to avail our services.
		            </div>
		        </div>
		        <div id="failure">
		            <div class="alert alert-danger">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> Failed to register. Please check with support team for assistance.
		            </div>
		        </div>
				<form class="form-horizontal" action="/AccountmateWS/register" id="registrationForm" method="post" enctype="multipart/form-data" onsubmit="return validateAll();">
					<div class="form-group">
						<label for="name" class="col-md-2 control-label">Contact Name</label>
						<div class="col-md-5">
							<input type="text" id="firstname" name="contactFirstName" class="form-control" placeholder="Enter First Name..."/>
						</div>
						<div class="col-md-5">
							<input type="text" id="lastname" name="contactLastName" class="form-control" placeholder="Enter Last Name..."/>
						</div>
					</div>
 
					<div class="form-group">
						<label for="emailaddress" class="col-md-2 control-label">Email Address</label>
						<div class="col-md-10">
							<input onblur="checkEmailAvailability();" id ="email" type="email" class="form-control" name="userEmail" placeholder="Enter Email... "/>
							<input type="hidden" id="emailchecksuccess" value="false"/>
							<p id="emailcheck" style="display:none;"></p>
						</div>
					</div>
 
					<div class="form-group">
						<label for="password" class="col-md-2 control-label">Password</label>
						<div class="col-md-5">
							<input type="password" class="form-control" id="password" name="userPassword" placeholder="Enter Password..."/>
						</div>
						<div class="col-md-5">
							<input type="password" class="form-control"  name="repassword" placeholder="Re-Enter Password...">
						</div>
					</div>
					<hr/>
					
					<div class="form-group">
						<label for="accountname" class="col-md-2 control-label">Account/Business Name</label>
						<div class="col-md-10">
							<input type="text" class="form-control" id="accountname" name="accountName" placeholder="Enter Account/Business Name... "/>
						</div>
					</div>
					<div class="form-group">
						<label for="phonenumber" class="col-md-2 control-label">Phone Number</label>
						<div class="col-md-10">
							<input type="text" class="form-control" id="phonenumber" name="userPhoneNumber" placeholder="Enter Phone Number... "/>
						</div>
					</div>
					<div class="form-group">
						<label for="address" class="col-md-2 control-label">Address</label>
						<div class="col-md-10">
							<input type="text" class="form-control"  id="address" name="userAddress" placeholder="Enter Address... "/>
						</div>
					</div>
					
					<div class="form-group">
					  <div class="col-sm-offset-2">
						<div class="col-md-3">
							<select id="country" name="userCountry" class="bfh-selectbox bfh-countries form-control"  data-country="IN" data-flags="true" data-blank="false">
							</select>
						</div>
						<div class="col-md-3">
							<select id="state" name="userState" class="form-control bfh-states" data-country="country"></select>
						</div>
					  </div>
					</div>
					<hr/>
					<div class="form-group">
						<label for="uploadimage" class="col-md-2">Upload Image</label>
						<div class="col-md-10">
							<input type="file" name="uploadimage"/>
							<p class="help-block">Allowed formats: png ; Max size: 50kB</p>
						</div>
					</div>
					
					<div class="form-group">
						<div class="col-md-10 col-md-offset-2">
							<input name="termandcondition" type="checkbox"/>Terms and Conditions
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-10 col-md-offset-2">
							<button type="submit" class="btn btn-primary">Register</button>
							<button type="reset" class="btn btn-default">Clear</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	

	<!--Footer
	==========================================================================================-->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<hr/>
				<p>Copyright &copy; Accountmate Inc.
				<a data-toggle="modal" href="#myModal">Terms and Conditions</a></p>
				
				<!----Modal--->
				<div class="modal fade" id="myModal" tabinex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h2>Terms and Conditions</h2>
							</div>
							<div class="modal-body">
								<p>All copyright, trade marks, design rights, patents and other intellectual property rights (registered and unregistered) 
								in and on Accountmate v1.2 belong to the Accountmate Inc. and/or third parties (which may include you or other users). 
								The Accountmate Inc. reserves all of its rights in Accountmate v1.2. Nothing in the Terms grants you a right or licence
								to use any trade mark, design right or copyright owned or controlled by the Accountmate Inc. or any other third party 
								except as expressly provided in the Terms.</p>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <!-- <script src="https://code.jquery.com/jquery.js"></script>-->
	<script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/bootstrapValidator.js"></script>
    <script src="resources/js/bootstrap-formhelpers.min.js"></script>
    
    <script>
	if("${success}" == "true")
	{
		document.getElementById("success").style.display = "block";
		document.getElementById("failure").style.display = "none";
	}
	else if("${success}" == "false"){
		document.getElementById("success").style.display = "none";
		document.getElementById("failure").style.display = "block";
	}
	else{
		document.getElementById("failure").style.display = "none";	
		document.getElementById("success").style.display = "none";	
	}
</script>
<script>
function validateAll(){
	var emailcheckstatus=document.getElementById("emailchecksuccess").value;
	if(emailcheckstatus=="false"){
		return false;
	}	
}
$(document).ready(function() {
    $('#registrationForm').bootstrapValidator({
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
            userEmail: {
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
            userPassword: {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    stringLength: {
                        min: 8,
                        message: 'The password must have at least 8 characters'
                    }
                }
            },
            repassword: {
                validators: {
                    notEmpty: {
                        message: 'Re-enter your password'
                    },
                    identical: {
                        field: 'userPassword',
                        message: 'The password is not matching'
                    }
                }
            },
            accountName: {
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
            userPhoneNumber: {
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
            userAddress: {
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
            userState: {
                validators: {
                    notEmpty: {
                        message: 'The state is required'
                    }
                }
            },
            termandcondition: {
                validators: {
                    notEmpty: {
                        message: 'Accept terms and conditions'
                    }
                }
            },
            uploadimage: {
            	validators: {
                    file: {
                        extension: 'png',
                        type: 'image/png',
                        maxSize: 51200,   // 2048 * 1024
                        message: 'The selected file is not valid'
                    }
                }
            }    
        }
    });
});
</script>
<script>

	function checkEmailAvailability(){
		//......Ajax for email check goes here .....
		var email=document.getElementById('email').value;
		var data = 'email='
			+ encodeURIComponent(email);
		
		$.ajax({
			url : "/AccountmateWS/checkemail",
			data : data,
			type : "GET",

			success : function(response) {
				//alert( response );
				if(response=="false"){
					document.getElementById("emailcheck").innerHTML='<i class="fa fa-times-circle extraPaddingLeftRight5"></i>Not available';
					document.getElementById("emailcheck").style.display="block";
					document.getElementById("emailcheck").style.color="#FF0000";
					document.getElementById("emailchecksuccess").value="false";
					
				}
				else{
					document.getElementById("emailcheck").innerHTML='<i class="fa fa-check-circle extraPaddingLeftRight5"></i>Available';
					document.getElementById("emailcheck").style.display="block";
					document.getElementById("emailcheck").style.color="#00CC00";
					document.getElementById("emailchecksuccess").value="true";
				}
				
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});
	}
	
	
</script>
  </body>
</html>
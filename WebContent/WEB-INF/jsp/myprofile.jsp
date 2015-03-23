<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Accountmate v1.2</title>

    <!-- Bootstrap core CSS -->
    <link href="resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="resources/css/font-awesome.min.css" rel="stylesheet">
	<link href="resources/css/style.css" rel="stylesheet">
	<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
	<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">
  </head>

  <body>

    <%
		//allow access only if session exists
		String userid = null;
		String login = null;
		if(session.getAttribute("userid") == null){
		    response.sendRedirect("/AccountmateWS/start");
		}else {
				userid = (String) session.getAttribute("userid");
				login = (String) session.getAttribute("login");
		}
	%>
	
    <!-- Header -->
    <%@include file="header.jsp" %>
	<!-- -- --- -->
	
	<div class="container">
		<div class="row">
			<div class="col-md-3">
				<img src="resources/images/profile-picture/default3.png" alt="No Profile Image" class="img-circle" height="180" width="180">
			</div>
			<div class="col-md-4">
				</br></br></br></br>
				<h1> Account Name</h1>
				<h4> Welcome , John Joseph</h4>
			</div>
		</div>
	</div>
	</br>
	<div class="container">
		<div class="row">
			<!-- Tab Navigation -->
			<ul class="nav nav-pills nav-stacked col-md-2">
				<li class="active"><a href="#tab1" data-toggle="tab">Personal</a></li>
				<li><a href="#tab2" data-toggle="tab">Business</a></li>
				<li><a href="#tab3" data-toggle="tab">Settings</a></li>
			</ul>
			
			<!-- Tab Section -->
			<div class="tab-content col-md-10">
				<div class="tab-pane active" id="tab1">
					</br>
					<form class="form-horizontal" action="/AccountmateWS/register" id="registrationForm" method="post">
						<div class=form-group>
							<div class="col-md-8 ">
								<a class="pointerCursor pull-right" onClick="toggleForm('personal')"><i class="fa fa-edit fa-2x extraPaddingLeftRight5"></i></a>
								<a data-toggle="modal" href="#changePassword" class="pointerCursor pull-right" title="Change Password"><i class="fa fa-lock fa-2x extraPaddingLeftRight5"></i></a>
							</div>
						</div>
						<div class="form-group">
							<label for="name" class="col-md-2 control-label">Contact Name</label>
							<div class="col-md-3">
								<input type="text" id="firstname" disabled name="contactFirstName" value="John" class="form-control" placeholder="Enter First Name..."/>
							</div>
							<div class="col-md-3">
								<input type="text" id="lastname"  disabled name="contactLastName" value="Joseph" class="form-control" placeholder="Enter Last Name..."/>
							</div>
						</div>
	 
						<div class="form-group">
							<label for="emailaddress" class="col-md-2 control-label">Email Address</label>
							<div class="col-md-3">
								<input disabled value="john@joseph.com" id ="email" type="email" class="form-control" name="userEmail" placeholder="Enter Email... "/>
							</div>
						</div>
						<div class="form-group">
							<div class="col-md-10 col-md-offset-2">
								<button id="personalsubmit" type="submit" class="btn btn-success">Save</button>
							</div>
						</div>
					</form>
					<!----Change Password Modal--->
					<div class="modal fade" id="changePassword" tabinex="-1" role="dialog" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h2>Change your password</h2>
								</div>
								<div class="modal-body">
									</br>
									<form class="form-horizontal">
										<div class="form-group">
											<label for="password" class="col-md-3 control-label">Old Password</label>
											<div class="col-md-4">
												<input type="password" class="form-control" id="password" name="userPassword" placeholder="Enter Password..."/>
											</div>
										</div>
										<div class="form-group">
											<label for="password" class="col-md-3 control-label">New Password</label>
											<div class="col-md-4">
												<input type="password" class="form-control" id="password" name="userPassword" placeholder="Enter New Password..."/>
											</div>
											<div class="col-md-4">
												<input type="password" class="form-control"  name="repassword" placeholder="Re-Enter Password...">
											</div>
										</div>
										<div class="form-group">
											<div class="col-md-offset-3 col-md-4">
												<button type="submit" class="btn btn-success">Change</button>
											</div>
										</div>
									</form>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
								</div>
							</div>
						</div>
					</div>
					</br></br></br></br></br></br></br>
				</div>
				<div class="tab-pane" id="tab2">
				</br>
					<form class="form-horizontal" action="/AccountmateWS/editProfilePersonal" id="editProfileForm" method="post">
						<div class=form-group>
							<div class="col-md-8 ">
							<a class="pointerCursor pull-right" onclick="toggleForm('business')"><i class="fa fa-edit fa-2x"></i></a> 
							</div>
						</div>
						<div class="form-group">
							<label for="accountname" class="col-md-2 control-label">Account/Business</label>
							<div class="col-md-6">
								<input type="text" class="form-control" disabled id="accountname" name="accountName" placeholder="Enter Account/Business Name... "/>
							</div>
							</div>
							<div class="form-group">
								<label for="phonenumber" class="col-md-2 control-label">Phone Number</label>
								<div class="col-md-6">
									<input type="text" class="form-control" disabled id="phonenumber" name="userPhoneNumber" placeholder="Enter Phone Number... "/>
								</div>
							</div>
							<div class="form-group">
								<label for="address" class="col-md-2 control-label">Address</label>
								<div class="col-md-6">
									<input type="text" class="form-control" disabled id="address" name="userAddress" placeholder="Enter Address... "/>
								</div>
							</div>
							
							<div class="form-group">
							  <div class="col-sm-offset-2">
								<div class="col-md-3">
									<select id="country" name="userCountry" disabled class="bfh-selectbox bfh-countries form-control"  data-country="IN" data-flags="true" data-blank="false">
									</select>
								</div>
								<div class="col-md-3">
									<select id="state" name="userState" disabled class="form-control bfh-states" data-country="country"></select>
								</div>
						 	 </div>
							</div>
							
						<div class="form-group">
							<div class="col-md-10 col-md-offset-2">
								<button id="businesssubmit" type="submit" class="btn btn-success">Save</button>
							</div>
						</div>
					</form>
				</div>
				<div class="tab-pane" id="tab3">
					</br></br></br></br></br></br></br></br>
					<p class="text-center">Page Comming Soon....</p>
					</br></br></br></br></br></br>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer -->
    <%@include file="footer.jsp" %>
	<!-- -- --- -->
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/bootstrapValidator.js"></script>
    <script src="resources/js/bootstrap-formhelpers.min.js"></script>
    <script>
    	$("#personalsubmit").hide();
    	$("#businesssubmit").hide();
    	function toggleForm(form){
    		if(form = 'personal'){
    			if($('#firstname').is(':disabled')){
    				$("#firstname").prop('disabled', false);
    				$("#lastname").prop('disabled', false);
    				$("#personalsubmit").show();
    			}
    			else{
    				$("#firstname").prop('disabled',true);
    				$("#lastname").prop('disabled', true);
    				$("#personalsubmit").hide();
    			}
    		}
    		if(form = 'business'){
    			if($('#accountname').is(':disabled')){
    				$("#accountname").prop('disabled', false);
    				$("#phonenumber").prop('disabled', false);
    				$("#address").prop('disabled', false);
    				$("#country").prop('disabled', false);
    				$("#state").prop('disabled', false);
    				$("#businesssubmit").show();
    			}
    			else{
    				$("#accountname").prop('disabled', true);
    				$("#phonenumber").prop('disabled', true);
    				$("#address").prop('disabled', true);
    				$("#country").prop('disabled', true);
    				$("#state").prop('disabled', true);
    				$("#businesssubmit").hide();
    			}
    		}
    	}
    </script>
  </body>
</html>
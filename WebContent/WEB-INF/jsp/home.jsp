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
    <link href="resources/css/bootstrapValidator.css" rel="stylesheet">
    <link href="resources/css/style.css" rel="stylesheet">

  </head>

  <body>
  <%
	//Allow access only if session exists
	String userid = null;
  	String login = null;
	if(session.getAttribute("userid") != null){
		userid = (String) session.getAttribute("userid");
		login = (String) session.getAttribute("login");
	}
	
	%>
	<!-- Header -->
    <%@include file="header.jsp" %>
	<!-- -- --- -->
	
	<!--Carousel
	=============================================================================================-->
    <div class="container">
    <br>
      <div id="myCarousel" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
          <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
          <li data-target="#myCarousel" data-slide-to="1"></li>
          <li data-target="#myCarousel" data-slide-to="2"></li>
		  <li data-target="#myCarousel" data-slide-to="3"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner">
			<div class="item active">
				<img src="resources/images/banner/banner1.jpg">
				<div class="carousel-caption">
				  <h1>Accountmate v1.2</h1>
				  <p>We help you manage.</p>
				  <p id="startup-buttons1"><a class="btn btn-lg btn-primary"  data-toggle="modal" href="#loginModal">Login</a> 
					<a class="btn btn-lg btn-primary" href="/AccountmateWS/registerpage">Sign Up</a></p>
				</div>
			</div>
			<div class="item">
				<img src="resources/images/banner/banner2.jpg">
				<div class="carousel-caption">
					<h1>Accountmate v1.2</h1>
					<p>We help you manage.</p>
					<p id="startup-buttons2"><a class="btn btn-lg btn-primary"  data-toggle="modal" href="#loginModal">Login</a> 
					<a class="btn btn-lg btn-primary" href="/AccountmateWS/registerpage">Sign Up</a></p>
				</div>
			</div>
			<div class="item">
				<img src="resources/images/banner/banner3.jpg">
				<div class="carousel-caption">
					<h1>Accountmate v1.2</h1>
					<p>We help you manage.</p>
					<p id="startup-buttons3"><a class="btn btn-lg btn-primary"  data-toggle="modal" href="#loginModal">Login</a> 
					<a class="btn btn-lg btn-primary" href="/AccountmateWS/registerpage">Sign Up</a></p>
					
				</div>
			</div>
			<div class="item">
				<img src="resources/images/banner/banner4.jpg">
				<div class="carousel-caption">
					<h1>Accountmate v1.2</h1>
					<p>We help you manage.</p>
					<p id="startup-buttons4"><a class="btn btn-lg btn-primary"  data-toggle="modal" href="#loginModal">Login</a> 
					<a class="btn btn-lg btn-primary" href="/AccountmateWS/registerpage">Sign Up</a></p>
				</div>
			</div>
		</div>
		<!--login Modal---->
		
		<div class="modal fade" id="loginModal" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h2>Please login...</h2>
					</div>
					<div class="modal-body">
						<div class="container">
							<form id="loginForm" class="form-horizontal" action="/AccountmateWS/login" method="post">
								<div class="form-group">
									<div class="col-sm-4">
										<input type="email" class="form-control" id="username" name="username" placeholder="Username/Email address">
									</div>
								</div>
								<div class="form-group">
									<div class="col-sm-4">
										<input type="password" class="form-control" id="password" name="password" placeholder="Password">
									</div>
								</div>
								<div class="form-group">
									<div class="col-sm-4">
										<label class="checkbox-inline">
											<input disabled type="checkbox" value="remember-me"/> Remember me
										</label>
									</div>
								</div> 
								<div class="form-group">
									<div class="col-sm-4">
										<p><a>Forgot your password?</a></p>
									</div>
								</div>
								<div id="loginFailed" class="form-group" style="display:none;">
									<div class="col-sm-4">
									<p style="color:#FF0000;">Invalid Credentials. Please try again !!</p>
									</div>	
								</div>
								<div class="form-group">
									<div class="col-sm-4">
										<button type="submit" class="btn btn-success btn-lg"> Login !</button>
								</div>
						    </div>
							</form>
							
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
		
		
        <!-- Controls -->
        <a class="left carousel-control" href="#myCarousel" data-slide="prev">
          <span class="glyphicon glyphicon-chevron-left"></span>
        </a>
        <a class="right carousel-control" href="#myCarousel" data-slide="next">
          <span class="glyphicon glyphicon-chevron-right"></span>
        </a>
      </div>
    </div>
	<!--End of Carousel ------->

	<!-- Footer -->
    <%@include file="footer.jsp" %>
	<!-- -- --- -->
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <!-- <script src="https://code.jquery.com/jquery.js"></script>-->
	<script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/bootstrapValidator.js"></script>
	<script type="text/javascript">
    $(window).load(function(){
    	if('<%=login%>' == "success")
    	{
    		document.getElementById("leftnav").style.display= "block";
    		document.getElementById("startup-buttons1").style.display="none";
    		document.getElementById("startup-buttons2").style.display="none";
    		document.getElementById("startup-buttons3").style.display="none";
    		document.getElementById("startup-buttons4").style.display="none";
    		document.getElementById("logoutnav").style.display="block";
    	}
    	else{
    		document.getElementById("leftnav").style.display= "none";
    		document.getElementById("startup-buttons1").style.display="block";
    		document.getElementById("startup-buttons2").style.display="block";
    		document.getElementById("startup-buttons3").style.display="block";
    		document.getElementById("startup-buttons4").style.display="block";
    		document.getElementById("logoutnav").style.display="none";
    		$('#loginModal').modal('show');
    	}
        
    });	
	</script>
	<script>
$(document).ready(function() {
    $('#loginForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            username: {
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
            password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required and cannot be empty'
                    },
                    stringLength: {
                        min: 8,
                        message: 'The password must have at least 8 characters'
                    }
                }
            }
              
        }
    });
});
</script>
  </body>
</html>
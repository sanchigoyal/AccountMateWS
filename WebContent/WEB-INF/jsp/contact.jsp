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
	<style>
		#map-container {height:300px;}
	</style>
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
	
	<div class="container">
		<div class="well" rows="2">
			<i class="fa fa-lg fa-map-marker"></i><label class="largeIcon">Location</label>
		</div>
		<div id="map-container">
		</div>
	</div>
	<!--Form and Address
	===============================================================================================================-->
	<div class="container">
		<hr/>
		<div class="row">
			<div class="col-md-4">
				<div class="row">
					<div class="well">
						<i class="fa fa-lg fa-suitcase"></i><label class="largeIcon">Our office</label>
					</div>
					<div class="form">
						<address>
						  <strong>Accountmate, Inc.</strong><br>
						  Kundanhalli Gate<br>
						  Bangalore - 37, India<br>
						  <i class="fa fa-mobile-phone"></i> (+91) 90021-72084
						</address>

						<address>
						  <strong>Sanchi Goyal</strong><br>
						  <a href="mailto:sanchi_goyal@yahoo.in">sanchi.goyal.sg@gmail.com</a>
						</address>
					</div>
				</div>
				<div class="row">
					<div class="well">
						<i class="fa fa-lg fa-clock-o"></i><label class="largeIcon">Business hours</label>
					</div>
					<div class="form">
						<strong>9AM - 2PM IST</strong></br>
						<strong>3PM - 7PM IST</strong>
					</div>
				</div>
			</div>
			<div class="col-md-8">
				<div class="well">
						<i class="fa fa-lg fa-envelope-o"></i><label class="largeIcon">Feel free to contact us</label>
				</div>
				<div class="container">
				<form id="contactForm" class="form-horizontal" method="post" action="">
					<div class="form-group">
						<label for="name" class="col-sm-2 control-label">Name</label>
						<div class="col-sm-5">
							<input id="contactname" name="contactname" type="text" class="form-control" placeholder="Enter Name..."/>
						</div>
					</div>
					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">Email</label>
						<div class="col-sm-5">
							<input id="email" name="email" type="email" class="form-control" placeholder="Enter Email..."/>
						</div>
					</div>
					<div class="form-group">
						<label for="message" class="col-sm-2 control-label">Message</label>
						<div class="col-sm-5">
							<textarea id="message" name="message" class="form-control" rows="4" placeholder="Enter Message..."></textarea>
						</div>
					</div>
					<div class="form-group">
						<label for="knowme" class="col-sm-2 control-label">How did you hear about Accountmate ?</label>
						<div class="col-sm-5">
							<select id="knowme" name="knowme" class="form-control">
								<option value="1">Web Search</option>
								<option value="2">Facebook Ad</option>
								<option value="3">Friends</option>
								<option value="4">An Invoice I Received</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-5 col-sm-offset-2">
							<button class="btn btn-primary" type="submit">Submit</button>
							<button class="btn btn-default" type="reset">Reset</button>
						</div>
					</div>
				</form>
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
	<script src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script src="resources/js/bootstrapValidator.js"></script>
	<script>    
 
      function init_map() {
        var var_location = new google.maps.LatLng(12.955954,77.714764);
 
        var var_mapoptions = {
          center: var_location,
          zoom: 14
        };
 
        var var_marker = new google.maps.Marker({
            position: var_location,
            map: var_map,
            title:"Accountmate Inc."});
 
        var var_map = new google.maps.Map(document.getElementById("map-container"),
            var_mapoptions);
 
        var_marker.setMap(var_map);    
 
      }
 
      google.maps.event.addDomListener(window, 'load', init_map);
 
    </script>
	<script type="text/javascript">
    $(window).load(function(){
    	if('<%=login%>' == "success")
    	{
    		document.getElementById("leftnav").style.display= "block";
    		document.getElementById("logoutnav").style.display="block";
    	}
    	else{
    		document.getElementById("leftnav").style.display= "none";
    		document.getElementById("logoutnav").style.display="none";
    	}
        
    });	
	</script>
	<script>
	$(document).ready(function() {
    $('#contactForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	contactname: {
                message: 'The contact name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The contact name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 30,
                        message: 'The contact name must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z ]+$/,
                        message: 'The contact name can only consist of alphabets'
                    }
                }
            },
            email: {
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
             message: {
                message: 'The message is not valid',
                validators: {
                    notEmpty: {
                        message: 'The message is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 300,
                        message: 'The message must be more than 3 and less than 300 characters long'
                    }
                }
            }
        }
    });
});
</script>
  </body>
</html>
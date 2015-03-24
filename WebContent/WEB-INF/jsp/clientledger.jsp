<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	<link href="resources/css/datepicker.css" rel="stylesheet">
	<link href="resources/css/jquery.dataTables.css" rel="stylesheet">
	<link href="resources/css/dataTables.bootstrap.css" rel="stylesheet">


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
			<div class="col-md-12">
				<h2>${client.clientName}</h2><hr/>	
			</div>
		</div>
		<form class="form-inline" action="/AccountmateWS/getClientTransactionByDates" method="post">
			<input type="hidden" id="clientid" name="clientid" value="${client.clientID}">
			<div class="bfh-datepicker col-md-offset-1 col-md-2" id="datefrom" data-name="datefrom" data-format="y-m-d" data-date="2014-04-04" >
			</div>
			<div class="bfh-datepicker col-md-offset-1 col-md-2" id="dateto" data-name="dateto" data-format="y-m-d" data-date="today" >
			</div>
			<button type="submit" class="btn btn-primary">Search</button>
		</form>
	</div>
	
	<div class="container">
	<hr/>
		<table id="transaction" class="table">
			<thead>
				<tr class="well">
					<td class="col-md-2 text-center">Date</td>
					<td class="col-md-2 text-center">Description</td>
					<td class="col-md-2 text-center">Reference #</td>
					<td class="col-md-2 text-right">Debit</td>
					<td class="col-md-2 text-right">Credit</td>
					<td class="col-md-2 text-right">Balance</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="transaction" items="${transactions}">
				<tr>
					<td class="text-center">${transaction.transaction_date }</td>
					<td class="text-center">${transaction.description}</td>
					<td class="text-center">
						<a data-toggle="modal" href="#viewReference" onclick="updateReferenceModal('${transaction.reference}','${transaction.referenceType}');">${transaction.invoice_number}</a>
					</td>
					<td class="text-right"><i class="fa fa-rupee"></i> ${transaction.debit_value}</td>
					<td class="text-right"><i class="fa fa-rupee"></i> ${transaction.credit_value}</td>
					<td class="text-right"><i class="fa fa-rupee"></i> ${transaction.balance}</td>
				</tr>
			    </c:forEach>
			</tbody>
		</table>
		<table class="table">
			<tr class="well">
					<td class="col-md-3"><strong>Total</strong></td>
					<td class="col-md-2"></td>
					<td class="col-md-1 text-center"></td>
					<td class="col-md-2 text-right"><strong><i class="fa fa-rupee"></i> ${client.clientDebit}</strong></td>
					<td class="col-md-2 text-right"><strong><i class="fa fa-rupee"></i> ${client.clientCredit}</strong></td>
					<td class="col-md-2 text-right"><strong><i class="fa fa-rupee"></i> ${client.clientBalance}</strong></td>
				</tr>
		</table>
		<!----Reference Modal--->
		<div class="modal fade" id="viewReference" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog large">
				<div id="reference-content" class="modal-content">
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
    <script src="resources/js/bootstrap-datepicker.js"></script>
    <script src="resources/js/jquery.dataTables.min.js"></script>
    <script src="resources/js/dataTables.bootstrap.js"></script>
	<script>
	$(document).ready(function() {
	    $('#transaction').dataTable();
	} );
		$(function(){
			$('.datepicker').datepicker();
		});
		
	function updateReferenceModal(referenceid,referencetype){
		if(referencetype == 'INVOICE'){
			//Check Invoice List
			var data = 'invoiceid='
				+ encodeURIComponent(referenceid);
			$.ajax({
				url : "/AccountmateWS/viewInvoice",
				data : data,
				type : "GET",

				success : function(data) {
					$('#reference-content').html(data);
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});
		}
		else if(referencetype == 'PAYMENT'){
			var data = 'paymentid='
				+ encodeURIComponent(referenceid);
			$.ajax({
				url : "/AccountmateWS/viewPayment",
				data : data,
				type : "GET",

				success : function(data) {
					$('#reference-content').html(data);
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});
		}
		else if(referencetype == 'EXPENSE'){
			var data = 'expenseid='
				+ encodeURIComponent(referenceid);
			$.ajax({
				url : "/AccountmateWS/viewExpense",
				data : data,
				type : "GET",

				success : function(data) {
					$('#reference-content').html(data);
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});
		}
		else if(referencetype == 'RECEIPT'){
			var data = 'receiptid='
				+ encodeURIComponent(referenceid);
			$.ajax({
				url : "/AccountmateWS/viewReceipt",
				data : data,
				type : "GET",

				success : function(data) {
					$('#reference-content').html(data);
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});

		}
		else{
			alert('Invalid Data !!!!');
		}
	}	
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
	var datefrom = document.getElementById('datefrom');
	datefrom.setAttribute('data-date','${startdate}');
	var dateto = document.getElementById('dateto');
	dateto.setAttribute('data-date','${enddate}');
	</script>
  </body>
</html>
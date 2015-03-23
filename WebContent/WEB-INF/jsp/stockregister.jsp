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
				<h2>${product.productName}</h2><hr/>	
			</div>
		</div>
		<form class="form-inline" action="/AccountmateWS/getProductTransactionByDates" method="post">
			<input type="hidden" id="productid" name="productid" value="${product.productID}">
			<div class="bfh-datepicker col-md-offset-1 col-md-2" id="datefrom" data-name="datefrom" data-format="y-m-d" data-date="2014-04-04" >
			</div>
			<div class="bfh-datepicker col-md-offset-1 col-md-2" id="dateto" data-name="dateto" data-format="y-m-d" data-date="today" >
			</div>
			<button type="submit" class="btn btn-primary">Search</button>
		</form>
	</div>
	
	<div class="container">
	<hr/>
		<table id="transaction" class="table table-striped">
			<thead>
				<tr class="well">
					<td class="col-md-2 text-center">Date</td>
					<td class="col-md-3 text-center">Description</td>
					<td class="col-md-1 text-center">Reference</td>
					<td class="col-md-2 text-right">IN<i class="fa fa-arrow-down extraPaddingLeftRight5 text-red"></i></td>
					<td class="col-md-2 text-right">OUT<i class="fa fa-arrow-up extraPaddingLeftRight5 text-green"></i></td>
					<td class="col-md-2 text-right">Balance</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="transaction" items="${transactions}">
				<tr>
					<td class="text-center">${transaction.transaction_date }</td>
					<td class="text-center">${transaction.description}</td>
					<td class="text-center">
						<a data-toggle="modal" href="#viewInvoice" onclick="updateInvoiceModal('${transaction.reference}');">${transaction.invoice_number}</a>
					</td>
					<td class="text-right"> ${transaction.debit_value}</td>
					<td class="text-right"> ${transaction.credit_value}</td>
					<td class="text-right"> ${transaction.balance}</td>
				</tr>
			    </c:forEach>
			</tbody>
		</table>
		<table class="table">
			<tr class="well">
					<td class="col-md-3"><strong>Total</strong></td>
					<td class="col-md-2"></td>
					<td class="col-md-1 text-center"></td>
					<td class="col-md-2 text-right"><strong> ${product.productIn}</strong></td>
					<td class="col-md-2 text-right"><strong> ${product.productOut}</strong></td>
					<td class="col-md-2 text-right"><strong> ${product.productBalance}</strong></td>
				</tr>
		</table>
		
		<!----Invoice Modal--->
		<div class="modal fade" id="viewInvoice" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog large">
				<div id="invoice-content" class="modal-content">
						<%@include file="invoice.jsp" %>
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
    
    function updateInvoiceModal(invoiceid){
		var data = 'invoiceid='
			+ encodeURIComponent(invoiceid);
		$.ajax({
			url : "/AccountmateWS/viewInvoice",
			data : data,
			type : "GET",

			success : function(data) {
				$('#invoice-content').html(data);
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});	
		
	}
	</script>
	<script>
	var datefrom = document.getElementById('datefrom');
	datefrom.setAttribute('data-date','${startdate}');
	var dateto = document.getElementById('dateto');
	dateto.setAttribute('data-date','${enddate}');
	</script>
  </body>
</html>
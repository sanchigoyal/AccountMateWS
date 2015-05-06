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
  </head>
  <body>
    <!-- Header -->
    <%@include file="../layout/headernew.jsp" %>
	<!-- -- --- -->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2>${client.clientName}</h2><hr/>	
			</div>
			<div class="col-md-4 col-md-offset-8">
				<div id="daterange" class="form-control" style="cursor: pointer;margin-bottom:10px;">
	                <i class="fa fa-calendar"></i>
	                <span></span>
	                <form id="dateChange" method="post" action="/AccountmateWS/getClientTransactionByDates">
	                	<input type="hidden" id="clientid" name="clientid" value="${client.clientID}">
	                	<input type="hidden" id="datefrom" name="datefrom" value=""/>
	                	<input type="hidden" id="dateto" name="dateto" value=""/> 
	                </form>
	          	</div>
			</div>
			<div class="col-md-12">
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
			</div>
			<!----Reference Modal--->
			<div class="modal fade" id="viewReference" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog large">
					<div id="reference-content" class="modal-content">
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Footer -->
    <%@include file="../layout/footernew.jsp" %>
	<!-- -- --- -->
	<script>
	$(document).ready(function() {
	    $('#transaction').dataTable();
	} );
		
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
	<script>
		$(document).ready(function() {
	        var cb = function(start, end, label) {
	          $('#daterange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
	          $('#datefrom').val(start.format('YYYY-MM-DD'));
	          $('#dateto').val(end.format('YYYY-MM-DD'));
	        };
	    
	     var optionSet = {
	       startDate: moment().subtract(29, 'days'),
	       endDate: moment(),
	       showDropdowns: true,
	       showWeekNumbers: true,
	       timePicker: false,
	       timePickerIncrement: 1,
	       timePicker12Hour: true,
	       ranges: {
	          'Today': [moment(), moment()],
	          'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
	          'Last 7 Days': [moment().subtract(6, 'days'), moment()],
	          'Last 30 Days': [moment().subtract(29, 'days'), moment()],
	          'This Month': [moment().startOf('month'), moment().endOf('month')],
	          'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
	       },
	       opens: 'left',
	       buttonClasses: ['btn btn-default'],
	       applyClass: 'btn-small btn-primary',
	       cancelClass: 'btn-small',
	       format: 'MM/DD/YYYY',
	       separator: ' to ',
	       locale: {
	           applyLabel: 'Search',
	           cancelLabel: 'Clear',
	           fromLabel: 'From',
	           toLabel: 'To',
	           customRangeLabel: 'Custom',
	           daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
	           monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
	           firstDay: 1
	       }
	     };
	     $('#daterange span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
	     $('#daterange').daterangepicker(optionSet, cb);
	     $('#daterange span').html(moment("${startdate}").format('MMMM D, YYYY') + ' - ' + moment("${enddate}").format('MMMM D, YYYY'));//MM-DD-YYYY
	     $('#daterange').data('daterangepicker').setStartDate(moment("${startdate}"));
	     $('#daterange').data('daterangepicker').setEndDate(moment("${enddate}"));
	     $('#datefrom').val(moment("${startdate}").format('YYYY-MM-DD'));
	     $('#dateto').val(moment("${enddate}").format('YYYY-MM-DD'));
		});
	//Date Change form submit
	$('#daterange').on('apply.daterangepicker', function(ev, picker) {
   		 $( "#dateChange" ).submit();		
   	});
	</script>
  </body>
</html>
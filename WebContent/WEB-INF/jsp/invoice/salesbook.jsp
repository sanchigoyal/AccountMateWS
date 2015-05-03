<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
			<div class="col-md-12">
				<h2>Sales Invoice Book</h2><hr/>	
			</div>
			<div class="col-md-12">
				<div id="success" class="hideIt">
		            <div class="alert alert-success" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> ${message}
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> ${message}
		            </div>
		        </div>
			</div>
			<div class="col-md-4 col-md-offset-8">
				<div id="daterange" class="form-control" style="cursor: pointer;margin-bottom:10px;">
	                <i class="fa fa-calendar"></i>
	                <span></span>
	                <form id="dateChange" method="post" action="/AccountmateWS/showSalesBook">
	                	<input type="hidden" id="datefrom" name="datefrom" value=""/>
	                	<input type="hidden" id="dateto" name="dateto" value=""/> 
	                </form>
	          	</div>
			</div>
			<div class="col-md-12">
				<!-- Tab Navigation -->
				<ul class="nav nav-tabs">
					<li class="active"><a href="#tab1" data-toggle="tab">Unpaid <span class="badge">${unpaidBills}</span></a></li>
					<li><a href="#tab2" data-toggle="tab">Paid <span class="badge">${paidBills}</span></a></li>
					<li><a href="#tab3" data-toggle="tab">Deleted <span class="badge">${deletedBills}</span></a></li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="tab1">
						<br/>
							<table class="table table-striped">
								<thead>
									<tr class="well">
										<td class="col-md-2 text-center">Date</td>
										<td class="col-md-3 text-center">Description</td>
										<td class="col-md-1 text-center">Reference</td>
										<td class="col-md-2 text-right">Bill Amount</td>
										<td class="col-md-2 text-right">Outstanding Amount</td>
										<td class="col-md-2 text-center">Options</td>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="invoiceup" items="${invoicesUP}">
									<tr>
										<td class="text-center">${invoiceup.date}</td>
										<td class="text-center">${invoiceup.clientName }</td>
										<td class="text-center">
											<a data-toggle="modal" href="#viewInvoice" onclick="updateInvoiceModal('${invoiceup.invoiceID}');">${invoiceup.billNumber}</a>
										</td>
										<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoiceup.total}</td>
										<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoiceup.outstandingAmount}</td>
										<td class="text-center">
											<p><a href="#receiptModel" class="addLineSeperator"  data-toggle ="modal" title="Receipt" onclick="updateReceiptModal('${invoiceup.invoiceID}');"><i class="fa fa-inr fa-lg extraPaddingLeftRight5"></i></a>
											   <a data-toggle="modal" href="#invoiceDelete" onclick="updateDeleteModal('${invoiceup.billNumber}','${invoiceup.invoiceID}');"><i class="fa fa-trash fa-lg extraPaddingLeftRight5"></i></a></p>
										</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
							<table class="table">
								<tr class="well">
										<td class="col-md-3"><strong>Total</strong></td>
										<td class="col-md-2"></td>
										<td class="col-md-1 text-center"></td>
										<td class="col-md-2 text-right"><strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${unpaidTotal}</strong></td>
										<td class="col-md-2 text-right"><strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${unpaidOutstanding}</strong></td>
										<td class="col-md-2 text-right"></td>
									</tr>
							</table>
					</div>
					<div class="tab-pane" id="tab2">
							<br/>
							<table class="table table-striped">
								<thead>
									<tr class="well">
										<td class="col-md-2 text-center">Date</td>
										<td class="col-md-3 text-center">Description</td>
										<td class="col-md-1 text-center">Reference</td>
										<td class="col-md-2 text-right">Amount</td>
										<td class="col-md-4 text-center">Receipt Details</td>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="invoicep" items="${invoicesP}">
									<tr>
										<td class="text-center">${invoicep.date}</td>
										<td class="text-center">${invoicep.clientName }</td>
										<td class="text-center">
											<a data-toggle="modal" href="#viewInvoice" onclick="updateInvoiceModal('${invoicep.invoiceID}');">${invoicep.billNumber}</a>
										</td>
										<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoicep.total}</td>
										<td class="text-center"></td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
							<table class="table">
								<tr class="well">
										<td class="col-md-3"><strong>Total</strong></td>
										<td class="col-md-2"></td>
										<td class="col-md-1 text-center"></td>
										<td class="col-md-2 text-right"><strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${paidTotal}</strong></td>
										<td class="col-md-2 text-right"><strong> </strong></td>
										<td class="col-md-2 text-right"><strong> </strong></td>
									</tr>
							</table>
					</div>
					<div class="tab-pane" id="tab3">
							<br/>
							<table class="table table-striped">
								<thead>
									<tr class="well">
										<td class="col-md-2 text-center">Date</td>
										<td class="col-md-3 text-center">Description</td>
										<td class="col-md-1 text-center">Reference</td>
										<td class="col-md-2 text-right">Amount</td>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="deletedinvoice" items="${deletedinvoices}">
									<tr>
										<td class="text-center">${deletedinvoice.date}</td>
										<td class="text-center">${deletedinvoice.clientName }</td>
										<td class="text-center">
											<a data-toggle="modal" href="#viewInvoice" onclick="updateInvoiceModal('${deletedinvoice.invoiceID}');">${deletedinvoice.billNumber}</a>
										</td>
										<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${deletedinvoice.total}</td>
									</tr>
									</c:forEach>
								</tbody>
							</table>
					</div>
				</div>
			</div>
			<!----Invoice Modal--->
			<div class="modal fade" id="viewInvoice" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog large">
					<div id="invoice-content" class="modal-content">
							<%@include file="../invoice.jsp" %>
					</div>
				</div>
			</div>
		
			<!----Payment Modal--->
			<div class="modal fade" id="receiptModel" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog large">
					<div id="invoice-content" class="modal-content">
						<div class="modal-header">
							<h2>Receipt</h2>
						</div>
						<div id="receipt-content" class="modal-body">
							<%@include file="../receiptgateway.jsp" %>
					    </div>
						<div class="modal-footer">
							<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>
		
			<!----Delete Invoice Modal--->
			<div class="modal fade" id="invoiceDelete" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
							<div class="modal-header">
								<h2>Are you sure ?</h2>
							</div>
							<div class="modal-body">
								<p>Deleting the invoice will remove its sales/purchase entries as well.</p>
								<p id="confirmquestion">Are you sure you want to delete <label id="invoiceNumber"></label> ?</p>
							</div>
							<div class="modal-footer">
								<form:form class="form-inline" id="invoicedeleteform" method="post" action="/AccountmateWS/deleteInvoice">
									<input type="hidden" id="deleteinvoiceid" name="invoiceID" value = ""/>
									<input type="hidden" id="redirectstartdate" name="redirectstartdate" value = ""/>
									<input type="hidden" id="redirectenddate" name="redirectenddate" value =""/>
									<input type="hidden" id="redirectpage" name="redirectpage" value="invoice/salesbook"/>
									<button id="deletebutton" type="submit" class="btn btn-danger">Delete</button>
									<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
								</form:form>
							</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
    <%@include file="../footernew.jsp" %>
	<!-- -- --- -->
	<script type="text/javascript">
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
    
    function updateDeleteModal(invoiceNumber,invoiceid){
    	$('#deletebutton').show();
		$('#confirmquestion').show();

		$('#deleteinvoiceid').val(invoiceid);
		$('#redirectstartdate').val('${startdate}');
		$('#redirectenddate').val('${enddate}');
		//$('#redirectcategory').val($('#productCategory').val());
		document.getElementById('invoiceNumber').innerHTML=invoiceNumber;
	}
    
    function updateReceiptModal(invoiceid){
		var data = 'invoiceid='
			+ encodeURIComponent(invoiceid);
		$.ajax({
			url : "/AccountmateWS/getInvoiceReceiptDetails",
			data : data,
			type : "GET",

			success : function(data) {
				$('#receipt-content').html(data);
				//$('#cashpayment').hide();
				$('#chequepayment').hide();
				$("#clientname").select2();
				$("#billnumber").select2();
				$("#billWiseCheckBox").hide();
				$("#billWiseReceipt").prop('checked', true);
				$("#pay").prop("readonly",true);
				$('#cashfailure').hide();
				//$('#receiptbutton').hide();
				$('#requestfrom').val('modal');
				$('#requestdatefrom').val('${startdate}');
				$('#requestdateto').val('${enddate}');
				$(document).ready(function() {
			          var cb2 = function(start, end, label) {
			              $('#receiptdate span').html(start.format('MMMM D, YYYY'));
			              $('#receiptdate input').val(start.format('YYYY-MM-DD'));
			            };

			       var optionSet2 = {
			    	         //startDate: moment().subtract(29, 'days'),
			    	         //endDate: moment(),

			    	         //dateLimit: { days: 60 },
			    	         showDropdowns: true,
			    	         showWeekNumbers: false,
			    	         timePicker: false,
			    	         timePickerIncrement: 1,
			    	         timePicker12Hour: true,
			    	         ranges: {
			    	            'Today': [moment(), moment()],
			    	            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')]//,
			    	            //'Last 7 Days': [moment().subtract(6, 'days'), moment()],
			    	            //'Last 30 Days': [moment().subtract(29, 'days'), moment()],
			    	            //'This Month': [moment().startOf('month'), moment().endOf('month')],
			    	            //'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
			    	         },
			    	         opens: 'left',
			    	         buttonClasses: ['btn btn-default'],
			    	         applyClass: 'btn-small btn-primary',
			    	         cancelClass: 'btn-small',
			    	         singleDatePicker: true,
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
			       $('#receiptdate span').html(moment().format('MMMM D, YYYY'));
			       $('#receiptdate input').val(moment().format('YYYY-MM-DD'));
			       $('#receiptdate').daterangepicker(optionSet2, cb2);
				});
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});	
		
	}
	</script>
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
		function togglePaymentOption(){
			if($('#mop').val() == 1){
				//Make a ajax request and get the available cash balance
				//If balance available show cash details div or else show error div.
				var data = 'amount='+ encodeURIComponent($('#pay').val());
				$.ajax({
					url : "/AccountmateWS/checkCashBalanceAvailability",
					data : data,
					type : "GET",
		
					success : function(available) {
						if(available == 'yes'){
							$('#cashpayment').show();
							$('#chequepayment').hide();
							$('#cashfailure').hide();
							$('#paymentbutton').show();
						}
						else{
							$('#cashpayment').hide();
							$('#chequepayment').hide();
							$('#cashfailure').show();
							$('#paymentbutton').hide();
						}
					},
					error : function(xhr, status, error) {
						alert(xhr.responseText);
					}
				});	
				
			}
			else if($('#mop').val() == 2){
				$('#chequepayment').show();
				$('#cashpayment').hide();
				$('#cashfailure').hide();
			}
			else{
				$('#cashpayment').hide();
				$('#chequepayment').hide();
				$('#cashfailure').hide();
				$('#paymentbutton').hide();
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
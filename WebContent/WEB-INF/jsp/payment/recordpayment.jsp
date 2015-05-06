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
				<h2>Payment</h2><hr/>
			</div>
			<div class="col-md-12">
				<div id="success" class="hideIt">
		            <div class="alert alert-success">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> Payment successful.
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger">
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> Failed to make the payment. Please check with support team for assistance.
		            </div>
		        </div>
			</div>
			<div class="col-md-12">
				<%@include file="../payment/paymentgateway.jsp" %>
			</div>
		</div>
	</div>
	
	
	<!-- Footer -->
	<%@include file="../layout/footernew.jsp" %>
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
		$("#clientname").select2();
		$("#billnumber").attr("multiple","multiple");
		$("#billnumber").select2();
		$("#invoice-dropdown").hide();
		$('#invoice-tables').hide();
		$('#invoice-tables').hide();
		//$("#mop").prop('disabled', true);
		$('#cashfailure').hide();
		$('#paymentbutton').hide();
		$('#cashpayment').hide();
		$('#chequepayment').hide();
		togglePaymentOption();
		function updateInvoiceList()
		{
			if($('#billWisePayment').is(':checked')){
				var clientid = $('#clientname').val();
				var data = 'clientid='
					+ encodeURIComponent(clientid);
				$.ajax({
					url : "/AccountmateWS/getInvoiceList",
					data : data,
					type : "GET",

					success : function(data) {
						$('#invoice-dropdown').html(data);
						$("#billnumber").attr("multiple","multiple");
						$("#billnumber").select2();
						$("#invoice-dropdown").show();
						$('#invoice-tables').hide();
						//$("#mop").prop('disabled', true);
						$('#cashfailure').hide();
						$('#paymentbutton').hide();
						$('#cashpayment').hide();
						$('#chequepayment').hide();
						
						//get the pre selected value 
						//Query database and get the invoice details
						//Show in the tables
						updateInvoiceTable();
					},
					error : function(xhr, status, error) {
						alert(xhr.responseText);
					}
				});	
			}
			else{
				$("#invoice-dropdown").hide();
				$('#invoice-tables').hide();
			}
		}
		function updateInvoiceTable()
		{
			var invoices = new Array();
			$("#billnumber option:selected").each(function(){
                invoices.push($(this).val());
            });
			var invoicelist = invoices.join(",");
			if( invoicelist == ""){
				$('#invoice-tables').hide();
				//$("#mop").prop('disabled', true);
				$('#cashfailure').hide();
				$('#paymentbutton').hide();
				$('#cashpayment').hide();
				$('#chequepayment').hide();
			}
			else{
				var data = 'invoicelist='
					+ encodeURIComponent(invoicelist);
				$.ajax({
					url : "/AccountmateWS/getInvoicesPaymentDetails",
					data : data,
					type : "GET",

					success : function(data) {
						$('#invoice-tables').html(data);
						$('#invoice-tables').show();
						//$("#mop").prop('disabled', false);
						togglePaymentOption();
						
					},
					error : function(xhr, status, error) {
						alert(xhr.responseText);
					}
				});
			}
		}
		
		function togglePaymentOption(){
			if($('#mop').val() == 1){
				$('#cashpayment').show();
				$('#chequepayment').hide();
				$('#cashfailure').hide();
				$('#paymentbutton').show();
			}
			else{
				$('#chequepayment').show();
				$('#cashpayment').hide();
				$('#cashfailure').hide();
			}
		}
	</script>
	<script>
		$(document).ready(function() {
	          var cb2 = function(start, end, label) {
	              $('#paymentdate span').html(start.format('MMMM D, YYYY'));
	              $('#paymentdate input').val(start.format('YYYY-MM-DD'));
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
	       $('#paymentdate span').html(moment().format('MMMM D, YYYY'));
	       $('#paymentdate input').val(moment().format('YYYY-MM-DD'));
	       $('#paymentdate').daterangepicker(optionSet2, cb2);
		});
 	</script>
  </body>
</html>
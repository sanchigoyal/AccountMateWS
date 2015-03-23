<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <!-- Bootstrap core CSS -->
    <link href="resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="resources/css/font-awesome.min.css" rel="stylesheet">
	<link href="resources/css/style.css" rel="stylesheet">
	<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
	<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" media="all" href="resources/css/daterangepicker-bs3.css" />
      
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
	
	<input type="hidden" name="counter" id="counter" value="0" /> 
	<script>
		function addRow()
		{	
			var currentCounter =$('#counter').val();
			var randomnumber=parseInt(currentCounter)+1;
			var rowHtml = '<tr id="row'+randomnumber+'"><td align="right"><a href="javascript:" onclick="$(\'#row'+randomnumber+'\').remove();calcTotal();" title="Delete this row"><strong>X</strong></a><input type="hidden" class="rowid" value="'+randomnumber+'"/></td><td><select id="expenseCategory'+randomnumber+'"  name="expenses['+randomnumber+'].expenseCategoryID" class="form-control"><c:forEach var="category" items="${categories}"><option value="${category.categoryID}">${category.category}</option></c:forEach></select></td><td><input id="description'+randomnumber+'" name="expenses['+randomnumber+'].description" type="text" class="form-control" value=""/></td><td><input  id="amount'+randomnumber+'" name="expenses['+randomnumber+'].amount" type="text" class="form-control text-right" value="0.00" onkeyup="calcTotal();"/></td><td><select id="by'+randomnumber+'" name="expenses['+randomnumber+'].transactionBy" class="form-control" onChange="toggleChequeDetails('+randomnumber+');calcTotal();"><option value="1">Cash</option><option value="2">Cheque</option></select></td><td><select disabled id="bank'+randomnumber+'" name="expenses['+randomnumber+'].bankID" class="form-control" style="height: 20px;padding-bottom: 0px;padding-top: 0px;"><option value="1">Bank1</option><option value="2">Bank2</option></select><input  disabled id="chequenumber'+randomnumber+'" name="expenses['+randomnumber+'].chequeNumber" type="text" value="" class="form-control" style="height: 20px;" placeholder="Cheque Number.."/></td></tr>';
			$('#counter').val(randomnumber);
			$('#expense-table').append(rowHtml);
		}
	</script>
	
    <!-- Header -->
    <%@include file="header.jsp" %>
	<!-- -- --- -->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2>Expenses</h2>
			</div>
		</div>
	</div>
	<div id="expense-input" class="container">
		<hr/>
		<form:form id="invoiceForm" class="form-horizontal" method="post" action="/AccountmateWS/saveExpenses" onSubmit="updateStartEndDate();">
			<input type="hidden" name="redirectsavestartdate" id="redirectsavestartdate" value=""/>
			<input type="hidden" name="redirectsaveenddate" id="redirectsaveenddate" value=""/>
			<div class="row">
				<div class="col-md-9">
					<a onClick="addRow();"><i class="fa fa-plus-square extraPaddingLeftRight5"></i>Add rows</a>	
				</div>
				<div class="col-md-3">
					<div>
						<div id="expensedate" class="form-control" style="cursor: pointer;margin-bottom:10px;">
		                  <i class="fa fa-calendar"></i>
		                  <span></span> <b class="caret"></b>
		                  <input type="hidden" name="expdate" value=""/>
		            	</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-9">
							<table id="expense-table" class="table">
								<thead>
									<tr class="well">
										<th></th>
										<th class="text-center col-md-3">Expense Category</th>
										<th class="text-center">Description</th>
										<th class="text-center">Amount</th>
										<th class="text-center">By</th>
										<th class="text-center">Misc</th>
									</tr>
								</thead>
								<tbody>
									<tr id="row0">
										<td align="right" style="color:#FFFFFF">X
										<input type="hidden" class="rowid" value="0"/>
										</td>
										<td>
											<select id="expenseCategory0" class="form-control"  name="expenses[0].expenseCategoryID">
												<c:forEach var="category" items="${categories}">
													<option value="${category.categoryID}">${category.category}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input id="description0"  name="expenses[0].description" type="text" class="form-control" value=""/>
										</td>
										<td>
											<input  id="amount0" type="text"  name="expenses[0].amount" class="form-control text-right" value="0.00" onkeyup="calcTotal();"/>
										</td>
										<td>
											<select id="by0" class="form-control"  name="expenses[0].transactionBy" onChange="toggleChequeDetails('0');calcTotal();">
												<option value="1">Cash</option>
												<option value="2">Cheque</option>
											</select>
										</td>
										<td>
											<select disabled id="bank0" class="form-control"  name="expenses[0].bankID" style="height: 20px;padding-bottom: 0px;padding-top: 0px;">
												<c:forEach var="bank" items="${banks}">
													<option value="${bank.clientID}">${bank.clientName}</option>
												</c:forEach>
											</select>
											<input  disabled id="chequenumber0"   name="expenses[0].chequeNumber" type="text" value="" class="form-control" style="height: 20px;" placeholder="Cheque Number.."/>
										</td>
									</tr>
								</tbody>
						</table>
						<input type="submit" class="btn btn-primary pull-right" value="Save">
				</div>
				<div class="col-md-3">
					<div class="panel panel-success">
							<div class="panel-heading">Total</div>
							  <div class="panel-body">
							    <p>By Cash: <i class="fa fa-rupee extraPaddingLeftRight5 "></i><span id="cashTotal">0.00</span></p>
							    <p>By Cheque : <i class="fa fa-rupee extraPaddingLeftRight5 "></i><span id="chequeTotal">0.00</span></p>
							 </div>
						</div>
				</div>
			</div>	
		</form:form>
	</div>		
	<div class="container">
		<div class="row">
			<hr/>
			<div class="col-md-12" id="success">
	            <div class="alert alert-success" >
	              <button type="button" class="close" data-dismiss="alert">&times;</button>
	              <strong>Well done!</strong> ${message}
	            </div>
	        </div>
	        <div class="col-md-12" id="failure">
	            <div class="alert alert-danger" >
	              <button type="button" class="close" data-dismiss="alert">&times;</button>
	              <strong>Oh snap!</strong> ${message}
	            </div>
	        </div>
			<div>
				<div class="col-md-4">
					<a id="addExpense" onClick="enableExpenseInput();"><i class="fa fa-plus-square extraPaddingLeftRight5"></i>Add Expenses</a>
				</div>
				<div class="col-md-4 pull-right">
					<div id="reportrange" class="form-control" style="cursor: pointer;margin-bottom:10px;">
	                  <i class="fa fa-calendar"></i>
	                  <span></span>
	                  <form id="dateChange" method="post" action="/AccountmateWS/recordExpenses">
	                  	<input type="hidden" id="startdate" name="startdate" value=""/>
	                  	<input type="hidden" id="enddate" name="enddate" value=""/> 
	                  </form>
	            	</div>
				</div>				
			</div>

	        <div class="col-md-12">
				<div class="panel-group" id="accordion">
					<c:forEach var="expensedetails" items="${expensesdetails}" varStatus="loop">
		    			<div class="panel panel-default" id="panel${loop.index}">
		        			<div class="panel-heading">
		             			<h4 class="panel-title">
		        				<a data-toggle="collapse" data-target="#collapse${loop.index}" href="#collapse${loop.index}">
		          				<strong>${expensedetails.expenses[0].expenseCategory} (<i class="fa fa-rupee extraPaddingLeftRight5"></i>${expensedetails.total})</strong>
		        				</a>
		      					</h4>
							</div>
		        			<div id="collapse${loop.index}" class="panel-collapse collapse <c:if test="${loop.index == 0}">
   								in
							</c:if>">
			            		<div class="panel-body">
			            			<table class="table table-striped">
										<thead>
											<tr class="well">
												<th class="col-md-2 text-center">Date</th>
												<th class="col-md-3 text-center">Description</th>
												<th class="col-md-1 text-center">Amount</th>
												<th class="col-md-3 text-center">Details</th>
												<th class="col-md-3 text-center">Options</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="expense" items="${expensedetails.expenses}">
											<tr>
												<td class="text-center">${expense.expenseDate}</td>
												<td class="text-center">${expense.description}</td>
												<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${expense.amount}</td>
												<td class="text-center">
													<c:choose>
													      <c:when test="${expense.modeOfPayment eq 'Cash'}">
													      CASH
													      </c:when>
													      <c:otherwise>
													      ${expense.bankName}/${expense.chequeNumber}
													      </c:otherwise>
													</c:choose>
												</td>
												<td class="text-center">
													<p><a href="#editExpense" class="addLineSeperator"  data-toggle ="modal" title="edit" onclick="updateEditModal('${expense.expenseID}');"><i class="fa fa-edit fa-lg extraPaddingLeftRight5"></i></a>
													   <a data-toggle="modal" href="#expenseDelete" onclick="updateDeleteModal('${expense.description}','${expense.expenseID}');"><i class="fa fa-trash fa-lg extraPaddingLeftRight5"></i></a></p>
												</td>
											</tr>
											</c:forEach>
										</tbody>
									</table>
			            		</div>
		        			</div>
		    			</div>
		    		</c:forEach>
				</div>
			</div>
		</div>
		<!----Delete Expense Modal--->
		<div class="modal fade" id="expenseDelete" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
						<div class="modal-header">
							<h2>Are you sure ?</h2>
						</div>
						<div class="modal-body">
							<p>Deleting the expense will remove its cash/cheque transaction entries as well.</p>
							<p id="confirmquestion">Are you sure you want to delete <label id="expenseDescription"></label> ?</p>
						</div>
						<div class="modal-footer">
							<form:form class="form-inline" id="expensedeleteform" method="post" action="/AccountmateWS/deleteExpense">
								<input type="hidden" id="deleteexpenseid" name="expenseID" value = ""/>
								<input type="hidden" id="redirectstartdate" name="redirectstartdate" value = ""/>
								<input type="hidden" id="redirectenddate" name="redirectenddate" value =""/>
								<button id="deletebutton" type="submit" class="btn btn-danger">Delete</button>
								<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
							</form:form>
						</div>
				</div>
			</div>
		</div>
		<!-- Edit Product Modal -->
		<div class="modal fade" id="editExpense" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div id="expense-content" class="modal-content">
						<%@include file="editexpense.jsp" %>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Footer -->
	<%@include file="footer.jsp" %>
	<!--  -- -- -->
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/bootstrapValidator.js"></script>
    <script src="resources/js/bootstrap-formhelpers.min.js"></script>
    <script type="text/javascript" src="resources/js/moment.js"></script>
    <script type="text/javascript" src="resources/js/daterangepicker.js"></script>
    <script type="text/javascript">
       $(document).ready(function() {
          var cb = function(start, end, label) {
            $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
            $('#startdate').val(start.format('YYYY-MM-DD'));
            $('#enddate').val(end.format('YYYY-MM-DD'));
          };
          
          var cb2 = function(start, end, label) {
              $('#expensedate span').html(start.format('MMMM D, YYYY'));
              $('#expensedate input').val(start.format('YYYY-MM-DD'));
            };

       var optionSet = {
         startDate: moment().subtract(29, 'days'),
         endDate: moment(),

         dateLimit: { days: 60 },
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
       $('#reportrange span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
       $('#reportrange').daterangepicker(optionSet, cb);
       $('#reportrange span').html(moment("${startdate}").format('MMMM D, YYYY') + ' - ' + moment("${enddate}").format('MMMM D, YYYY'));//MM-DD-YYYY
       $('#reportrange').data('daterangepicker').setStartDate(moment("${startdate}"));
       $('#reportrange').data('daterangepicker').setEndDate(moment("${enddate}"));
       $('#startdate').val(moment("${startdate}").format('YYYY-MM-DD'));
       $('#enddate').val(moment("${enddate}").format('YYYY-MM-DD'));
       
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
       $('#expensedate span').html(moment().format('MMMM D, YYYY'));
       $('#expensedate input').val(moment().format('YYYY-MM-DD'));
       $('#expensedate').daterangepicker(optionSet2, cb2);
	});
       
   
    </script>
    <script>
    	$('#expense-input').hide();
    	function enableExpenseInput(){
    		$('#expense-input').show();
    		$('#addExpense').hide();
    	}
    	function toggleChequeDetails(rowid){
    		if($('#by'+rowid).val() == 2){
    			$('#bank'+rowid).prop('disabled', false);
    			$('#chequenumber'+rowid).prop('disabled', false);
    		}
    		else{
    			$('#bank'+rowid).prop('disabled', true);
    			$('#chequenumber'+rowid).prop('disabled', true);
    		}
    		
    	}
    	
    	function number_format(num)
    	{
    		num="" + Math.floor(num*100.0 + 0.5)/100.0;
    		var i=num.indexOf(".");
    		if (i<0 ) num+=".00";
    		else {
    		num=num.substring(0,i) + "." + num.substring(i + 1);
    		var nDec=(num.length - i) - 1;
    		if ( nDec==0 ) num+="00";
    		else if ( nDec==1 ) num+="0";
    		else if ( nDec>2 ) num=num.substring(0,i + 3);
    		}
    		return num;
    	}
    	
    	function calcTotal(){
    		var cashTotal = 0;
    		var chequeTotal =0;
    		$('.rowid').each(function(index, element) {
    			if($('#by'+$(element).val()).val() == 2){
    				chequeTotal = chequeTotal + parseFloat($('#amount'+$(element).val()).val());
    			}
    			else{
    				cashTotal = cashTotal + parseFloat($('#amount'+$(element).val()).val());
    			}
    		});
    		document.getElementById('cashTotal').innerHTML=number_format(cashTotal);
    		document.getElementById('chequeTotal').innerHTML=number_format(chequeTotal);
    	}
    	
    	 function updateDeleteModal(expenseDescription,expenseid){
    	    	$('#deletebutton').show();
    			$('#confirmquestion').show();

    			$('#deleteexpenseid').val(expenseid);
    			$('#redirectstartdate').val($('#startdate').val());
    			$('#redirectenddate').val($('#enddate').val());
    			document.getElementById('expenseDescription').innerHTML=expenseDescription;
    		}
    	
    	 function updateEditModal(expenseid){
 			var data = 'expenseid='
 				+ encodeURIComponent(expenseid);
 			$.ajax({
 				url : "/AccountmateWS/editExpense",
 				data : data,
 				type : "GET",

 				success : function(data) {
 					$('#expense-content').html(data);
 					$('#redirecteditstartdate').val($('#startdate').val());
 	    			$('#redirecteditenddate').val($('#enddate').val());
 					//$('#redirectcategoryedit').val($('#productCategory').val());
 				},
 				error : function(xhr, status, error) {
 					alert(xhr.responseText);
 				}
 			});	
 			
 		}
    	function updateStartEndDate(){
    		$('#redirectsavestartdate').val($('#startdate').val());
    		$('#redirectsaveenddate').val($('#enddate').val());
    	}
    	 
    	$('#reportrange').on('apply.daterangepicker', function(ev, picker) {
    		 $( "#dateChange" ).submit();		
    	});
    	 
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
	
  </body>
</html>
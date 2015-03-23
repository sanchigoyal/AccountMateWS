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
	<script>
		function toggleOptional (obj, id ) {
			if ($("#" + id ).css("display") == 'none' ) {
		    	$("#" + id).show("normal");
				obj.innerHTML = '<i class="fa fa-minus-square extraPaddingRight20"></i>';
			}
			else {
				$("#" + id).hide("normal");
				obj.innerHTML = '<i class="fa fa-plus-square extraPaddingRight20"></i>';
			}
			return true;
		}
		
		function doSearch() {
			var searchText = document.getElementById('searchTerm').value.toLowerCase();
			var targetTable = document.getElementById('clientList');
			for (var rowIndex = 1; rowIndex < targetTable.rows.length-1; rowIndex=rowIndex+2) {
				var rowData = '';
				var colIndex =1;//Only on client name
				//Process data rows. (rowIndex >= 1)
				rowData += targetTable.rows.item(rowIndex).cells.item(colIndex).textContent.toLowerCase();
				if (rowData.indexOf(searchText) == -1)
					targetTable.rows.item(rowIndex).style.display = 'none';
				else
					targetTable.rows.item(rowIndex).style.display = 'table-row';
				
			}
		}
		
		function updateDeleteModal(clientName,clientid,balance){
			if(balance!=0 || balance!=0.0 || balance !=0.00){
				$('#deletebutton').hide();
				$('#confirmquestion').hide();
			}
			else{
				$('#deletebutton').show();
				$('#confirmquestion').show();
			}
			$('#deleteclientid').val(clientid);
			$('#redirectcategory').val($('#clientCategory').val());
			document.getElementById('clientName').innerHTML=clientName;
		}
		
		function updateClients(option){
			document.location.href="/AccountmateWS/clientList?option="+option.value;   
		}
		
		function updateEditModal(clientid){
			var data = 'clientid='
				+ encodeURIComponent(clientid);
			$.ajax({
				url : "/AccountmateWS/editClient",
				data : data,
				type : "GET",

				success : function(data) {
					$('#client-content').html(data);
					$('#redirectcategoryedit').val($('#clientCategory').val());
				},
				error : function(xhr, status, error) {
					alert(xhr.responseText);
				}
			});	
			
		}
	</script>
    
    <!-- Header -->
    <%@include file="header.jsp" %>
	<!-- -- --- -->
    
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2 class="text-left col-md-6">My Clients</h2>
				<h2 class="text-right col-md-6">Total Clients(${numberofclients})</h2><!--Provide the number of product -->
			</div>
		</div>
	</div>
	<!-- Search Form
	==============================-->
	<div class="container">
		<hr/>
		<div class="well">
			<div class="row">
				<div class="col-md-6">	
						<input type="text" class="form-control" placeholder="Search :: Enter Client Name .." onkeyup="doSearch()" id="searchTerm"/>
				</div>
				<div class="form-group">
					<label for="name" class="col-md-1 col-md-offset-2">Category</label>
					<div class="col-md-3">
						<select id="clientCategory" name="clientCategory" class="form-control" onChange="updateClients(this);">
						<option value="-1">All</option>
						<c:forEach var="category" items="${categories}">
								<option value="${category.categoryID}">${category.category}</option>
						</c:forEach>
						</select>
					</div>
				</div>
			</div>
		</div>
		<div id="success">
            <div class="alert alert-success" >
              <button type="button" class="close" data-dismiss="alert">&times;</button>
              <strong>Well done!</strong> ${message}
            </div>
        </div>
        <div id="failure">
            <div class="alert alert-danger" >
              <button type="button" class="close" data-dismiss="alert">&times;</button>
              <strong>Oh snap!</strong> ${message}
            </div>
        </div>
	</div>
	
	<!--Table of client list--
	==================================-->
	<div class="container">
		<hr/>
		<table id="clientList" class="table">
			<thead>
				<tr>
					<th class="text-center">#</th>
					<th>Client Name</th>
					<th class="text-right">Owes</th>
					<th class="text-center">Action</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="client" items="${clients}">
				<!--Single TR-->
				<tr id="parentrow${client.clientID}">
					<td class="text-center">${client.clientID}</td>
					<td><a class="pointerCursor" onclick="toggleOptional(this, '${client.clientID}');"><i class="fa fa-plus-square extraPaddingRight20"></i></a>${client.clientName}</td>
					<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${client.clientBalance}</td>
					<td class="text-center"><p><a href="/AccountmateWS/clientLedger?clientid=${client.clientID}" class="addLineSeperator" data-toggle="tooltip" data-placement="bottom" title="Ledger"><i class="fa fa-book fa-lg extraPaddingLeftRight5"></i></a>
					<a data-toggle ="modal" href="#editClient" class="addLineSeperator" onClick="updateEditModal('${client.clientID}');" title="Edit"><i class="fa fa-edit fa-lg extraPaddingLeftRight5"></i></a>
					<a data-toggle="modal" href="#clientDelete" onclick="updateDeleteModal('${client.clientName}','${client.clientID}','${client.clientBalance}');" data-toggle="tooltip" data-placement="bottom" title="Delete"><i class="fa fa-trash fa-lg extraPaddingLeftRight5"></i></a></p></td>
				</tr>
				<tr id="childrow${client.clientID}">
					<td colspan="6" style="padding: 0; border: none;">
						<div id="${client.clientID}" class="hideIt"><!--div id is same as client id-->
							<table class="table table-striped">
								<tr>
									<td><strong>Primary contact: </strong>${client.contactLastName},${client.contactFirstName}<br/>
										<strong>Phone: </strong>${client.clientPhoneNumber}<br />
										<strong>Email: </strong>${client.clientEmail}<br/>
									</td>
									<td nowrap="nowrap" align="left" >
										<strong>Billing/Shipping Address: </strong>${client.clientAddress},${client.clientState}(${client.clientCountry})<br />
										<strong>TIN: </strong>${client.clientTIN}
									</td>
									<td nowrap="nowrap" align="left" >
										<strong>Category: </strong>${client.clientCategoryName}<br />
									</td>
									<td align="left" nowrap="nowrap">
										<strong>Total Credit: </strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${client.clientCredit}<br />
										<strong>Total Debit: </strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${client.clientDebit}<br />
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<!--TR End-->
				</c:forEach>
				<!--Total-->
				<tr class="well">
					<td colspan="2" class="text-right"><strong>Total:</strong></td>
					<td colspan="1"  class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${totalBalance}</td>
					<td colspan="2"></td>
				</tr>
			</tbody>
		</table>
		<!----Delete Client Modal--->
		<div class="modal fade" id="clientDelete" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
						<div class="modal-header">
							<h2>Are you sure ?</h2>
						</div>
						<div class="modal-body">
							<p>Deleting the client will not remove their invoices as they are used for your records. Also any
							clients with unpaid invoices or recurring invoices will not be deleted.</p>
							<p id="confirmquestion">Are you sure you want to delete <label id="clientName"></label> ?</p>
						</div>
						<div class="modal-footer">
							<form:form class="form-inline" id="clientdeleteform" method="post" action="/AccountmateWS/deleteClient">
								<input type="hidden" id="deleteclientid" name="clientID" value = ""/>
								<input type="hidden" id="redirectcategory" name="clientCategory" value = ""/>
								<button id="deletebutton" type="submit" class="btn btn-danger">Delete</button>
								<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
							</form:form>
					</div>
				</div>
			</div>
		</div>
		<!-- Edit Product Modal -->
		<div class="modal fade" id="editClient" tabinex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog large">
				<div id="client-content" class="modal-content">
						<%@include file="editclient.jsp" %>
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
	var options= document.getElementById('clientCategory').options;
	for (var i= 0, n= options.length; i<n; i++) {
	    if (options[i].value==='${category}') {
	        options[i].selected= true;
	        break;
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
    		$('#loginModal').modal('show');
    	}
        
    });	
	</script>
  </body>
</html>
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
	<link href="resources/css/datepicker.css" rel="stylesheet">
	<link href="resources/css/font-awesome.min.css" rel="stylesheet">
	<link href="resources/css/style.css" rel="stylesheet">
	<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">
	<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
	<link href="resources/css/select2.css" rel="stylesheet"/>
	<link href="resources/css/select2-bootstrap.css" rel="stylesheet"/>
  </head>

  <body>
  <input type="hidden" name="counter" id="counter" value="0" /> 
  <script>
	function addRow()
	{	
		var currentCounter =$('#counter').val();
		//alert(currentCounter);
		var randomnumber=parseInt(currentCounter)+1;
		var rowHtml = '<tr id="row'+randomnumber+'"><td align="right"><a href="javascript:" onclick="$(\'#row'+randomnumber+'\').remove();totalAmount();" title="Delete this row"><strong>X</strong></a></td><td><select id="p'+randomnumber+'" name="items['+randomnumber+'].productID" class="form-control" onChange="updateQuantity('+randomnumber+');"><c:forEach var="product" items="${products}"><option value="${product.productID}">${product.productName}</option></c:forEach></select></td><td><input id="qty'+randomnumber+'" type="text" name="items['+randomnumber+'].quantity"  data-toggle="tooltip" data-placement="left" title="Quantity Available = ${products[0].productBalance}" class="form-control text-right" value="0" onkeyup="rowCalc('+randomnumber+');"/></td><td><input id="pc'+randomnumber+'" type="text" class="form-control text-right" value="0.00" onkeyup="rowCalc('+randomnumber+');" name="items['+randomnumber+'].priceWithoutVat"/></td><td style="text-align: center; vertical-align: middle;"><input type="checkbox" id="vatcheck'+randomnumber+'" name="items['+randomnumber+'].applyVat"  class="text-center" onclick="toggleVatBox('+randomnumber+');rowCalc('+randomnumber+');"/></td><td><input id="vat'+randomnumber+'" type="text" class="form-control text-right" value="0.00" disabled onkeyup="rowCalc('+randomnumber+');" name="items['+randomnumber+'].vatPercent"/></td><td><input id="pcV'+randomnumber+'" type="text" class="form-control text-right" value="0.00" onkeyup="rowCalc2('+randomnumber+');" name="items['+randomnumber+'].priceWithVat"/></td><td class="text-right input-group"><span class="input-group-addon"><i class="fa fa-rupee"></i></span><input type="text" readOnly="readOnly" name="items['+randomnumber+'].total" class="form-control text-right rowTotal" id="total'+randomnumber+'" value="0.00"/><input type="hidden" id="rowSubTotal'+randomnumber+'" value="0.00" class="rowSubTotal"></td></tr>';
		$('#counter').val(randomnumber);
		$('#invoice-table').append(rowHtml);
      	$('[data-toggle="tooltip"]').tooltip();
		//suggest(randomnumber);
	}

	function toggleVatBox(id){
		if(document.getElementById('vat'+id).disabled == true){
			document.getElementById('vat'+id).disabled= false;
		}
		else{
			document.getElementById('vat'+id).disabled = true;
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
	function rowCalc(rowID)
	{ 
		var qty = $('#qty'+rowID).val();
		var priceperitem = $('#pc'+rowID).val();
		var vatper = $('#vat'+rowID).val();
		
		var priceperitemwithvat= 0;
		if($('#vatcheck'+rowID).is(':checked')){
			priceperitemwithvat=parseFloat(priceperitem) + (parseFloat(vatper)/100)*parseFloat(priceperitem);}
		else{
			priceperitemwithvat=parseFloat(priceperitem);
		}
		$('#pcV'+rowID).val(number_format(priceperitemwithvat));
		$('#rowSubTotal'+rowID).val(number_format(parseFloat(priceperitem) * parseFloat(qty)));
		$('#total'+rowID).val(number_format(priceperitemwithvat * parseFloat(qty)));
		totalAmount();
	}
	
	function rowCalc2(rowID)
	{ 
	var priceperitemwithvat = $('#pcV'+rowID).val();
	var vatper = $('#vat'+rowID).val();
	var qty = $('#qty'+rowID).val();
	var priceperitem=0;
	if($('#vatcheck'+rowID).is(':checked')){
			priceperitem=parseFloat(priceperitemwithvat)/(parseFloat(1)+ parseFloat(vatper)/100);}
		else{
			priceperitem=parseFloat(priceperitemwithvat);
		}
	$('#pc'+rowID).val(number_format(priceperitem));
	$('#rowSubTotal'+rowID).val(number_format(priceperitem * parseFloat(qty)));
	$('#total'+rowID).val(number_format(priceperitemwithvat * parseFloat(qty)));
	totalAmount();
	}
	
	function totalAmount()
	{
		var total = 0;
		var subtotal =0;
		$('.rowSubTotal').each(function(index, element) {
		subtotal = subtotal + parseFloat($(element).val());
		});
		
		$('.rowTotal').each(function(index, element) {
		total = total + parseFloat($(element).val());
		});
		
		$('#subtotal').val(number_format(subtotal));
		$('#vattotal').val(number_format(total-subtotal));
		$('#total').val(number_format(total));
	}
	
	function updateTIN(){
		var clientid =document.getElementById("suppliername").value;
		var data = 'clientid='
			+ encodeURIComponent(clientid);
		$.ajax({
			url : "/AccountmateWS/getClientTIN",
			data : data,
			type : "GET",

			success : function(response) {
				document.getElementById("tinnumber").value = response;
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});	
	}
	
	function updateQuantity(index){
		var productid =document.getElementById("p"+index).value;
		var data = 'productid='
			+ encodeURIComponent(productid);
		$.ajax({
			url : "/AccountmateWS/getProductQuantity",
			data : data,
			type : "GET",
			success : function(response) {
				$('#qty'+index).attr("data-original-title","Quantity Available = "+response);
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
	
	<!-- Purchase Invoice 
	==============================================================================================================-->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2>Purchase Order</h2>
			</div>
		</div>
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
			<form:form id="invoiceForm" class="form-horizontal" action="/AccountmateWS/savePurchaseInvoice">
				<div class="form-group">
					<label for="suppliername" class="col-md-2">Supplier Name</label>
					<div class="col-md-4">
						<select id="suppliername" name="clientID" class="form-control " onChange="updateTIN();">
							<c:forEach var="client" items="${clients}">
								<option value="${client.clientID}">${client.clientName}</option>
							</c:forEach>
						</select>
					</div>
					<label for="date" class="col-md-2 text-right">Date</label>
					<div class="bfh-datepicker col-md-offset-1 col-md-2" id="invoicedate" data-name="invoicedate" data-format="y-m-d" data-date="2014-04-04" >
					</div>
				</div>
				<div class="form-group">
					<label for="tinnumber" class="col-md-2">TIN #</label>
					<div class="col-md-4">
						<input id="tinnumber" name ="clientTIN" type="text" class="form-control" value="${clients[0].clientTIN}" readOnly="readOnly"/>
					</div>
				</div>
				<div class="form-group">
					<label for="invoicenumber" class="col-md-2">Invoice #</label>
					<div class="col-md-4">
						<input type="text" name="billNumber" class="form-control" placeholder="Enter invoice number.."/>
					</div>
				</div>
				<hr/>
				<div class="form-group">
					<label for="detail text-left" class="col-md-2">Other Details</label>
				</div>
				<div class="form-group">
					<div class="col-md-4">
						<textarea name="shippedTo" class="form-control" placeholder="Shipped to... " rows="3"></textarea>
					</div>
					<div class="col-md-4">
						<textarea name="shippedMethod" class="form-control" placeholder="Shipping Method... " rows="3"></textarea>
					</div>
					<div class="col-md-4">
						<textarea name="reference" class="form-control" placeholder="Reference... " rows="3"></textarea>
					</div>
				</div>
				<hr/>
				<table id="invoice-table" class="table">
					<thead>
						<tr class="well">
						<th></th>
							<th class="col-md-3 text-center">Product Details</th>
							<th class="col-md-1 text-center">QTY</th>
							<th class="col-md-2 text-center">Price(<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</th>
							<th class="col-md-1 text-center">VAT</th>
							<th class="col-md-1 text-center">VAT %</th>
							<th class="col-md-2 text-center">Price(<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</th>
							<th class="col-md-2 text-center">Total</th>
							
						</tr>
					</thead>
					<tbody>
						<tr id="row0">
							<td align="right" style="color:#FFFFFF">X</td>
							<td><select id="p0" name="items[0].productID" class="form-control" onChange="updateQuantity(0);">
								<c:forEach var="product" items="${products}">
									<option value="${product.productID}">${product.productName}</option>
								</c:forEach>
								</select>
							</td>
							<td><input id="qty0" type="text" name="items[0].quantity"  data-toggle="tooltip" data-placement="left" title="Quantity Available = ${products[0].productBalance}" class="form-control text-right" value="0" onkeyup="rowCalc(0);"/>
							</td>
							<td><input id="pc0" type="text" class="form-control text-right" value="0.00" onkeyup="rowCalc(0);" name="items[0].priceWithoutVat"/>
							</td>
							<td style="text-align: center; vertical-align: middle;"><input type="checkbox" id="vatcheck0"  class="text-center" onclick="toggleVatBox(0);rowCalc(0);" name="items[0].applyVat"/>
							</td>
							<td><input id="vat0" type="text" class="form-control text-right" value="0.00" disabled onkeyup="rowCalc(0);" name="items[0].vatPercent"/>
							</td>
							<td>
								<input id="pcV0" type="text" class="form-control text-right" value="0.00" onkeyup="rowCalc2(0);" name="items[0].priceWithVat"/>
							</td>
							<td class="text-right input-group">
								<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
								<input  type="text" readOnly="readOnly" name="items[0].total" class="form-control text-right rowTotal" id="total0" value="0.00"/>
								<input type="hidden" id="rowSubTotal0" value="0.00" class="rowSubTotal">
							</td>
							
						</tr>
					</tbody>
				</table>
				<div class="well">
					<div class="row">
						<div class="col-md-5">
							<a onclick="addRow();"><i class="fa fa-plus extraPaddingLeftRight5 pointerCursor"></i>Add row</a>
						</div>
						<div class="col-md-5 text-right">
							<strong>Subtotal (ex VAT) </strong>
						</div>
						<div class="col-md-2 text-right input-group">
							<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
							<form:input readOnly="readOnly" type="text" class="form-control text-right extraPadding" id="subtotal" value="0.00" path="subTotal"/>
						</div>
					</div>
					<div class="row">
						<div class="col-md-10 text-right">
							<strong>VAT </strong>
						</div>
						<div class="col-md-2 text-right input-group">
							<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
							<form:input type="text" class="form-control text-right" id="vattotal" value="0.00" readOnly="readOnly" path="vatTotal"/>
						</div>
					</div>
					<div class="row">
						<div class="col-md-10 text-right">
							<strong>Total</strong>
						</div>
						<div class="col-md-2 text-right input-group">
							<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
							<form:input type="text" class="form-control text-right" id="total" value="0.00" readOnly="readOnly" path="total"/>
						</div>
					</div>
				</div>
				<hr/>
				<div>
					<div class="form-group">
						<div class="pull-right">
							<button type="submit" class="btn btn-primary btn-lg">Save</button>
							<button type="reset" class="btn btn-default btn-lg">Clear</button>
						</div>
					</div>
				</div>
			</form:form>
		</div>
	</div>
	
	<!-- Footer -->
    <%@include file="footer.jsp" %>
	<!-- -- --- -->	

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
	<script src="resources/js/bootstrap-datepicker.js"></script>
	<script src="resources/js/bootstrap-formhelpers.min.js"></script>
	<script src="resources/js/bootstrapValidator.js"></script>
	<script src="resources/js/select2.js"></script>
    <script>
        $(document).ready(function() { $("#suppliername").select2(); });
        $(function () {
        	  $('[data-toggle="tooltip"]').tooltip();
        	});
    </script>
	<script>
		$(function(){
			$('.datepicker').datepicker();
		});
	</script>
	<script>
		function getCurrentDate(){
			var today = new Date();
		    var dd = today.getDate();
		    var mm = today.getMonth()+1; //January is 0!

		    var yyyy = today.getFullYear();
		    if(dd<10){
		        dd='0'+dd;
		    } 
		    if(mm<10){
		        mm='0'+mm;
		    } 
		    var today = yyyy+'-'+mm+'-'+dd;
		    return today;
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
		var date = document.getElementById('invoicedate');
		date.setAttribute('data-date',getCurrentDate());
		document.getElementById("leftnav").style.display= "block";
	</script>
	<script>
	$(document).ready(function() {
    $('#invoiceForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	billNumber: {
                message: 'The invoice number is not valid',
                validators: {
                    notEmpty: {
                        message: 'The invoice number is required and cannot be empty'
                    },
                    stringLength: {
                        max: 50,
                        message: 'The invoice number must be less than 50 characters'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9]+$/,
                        message: 'The invoice number can consist of alphabets and digits(0-9)'
                    }
                }
            },
            shippedTo: {
                message: 'Please enter a valid shipping address',
                validators: {
                    stringLength: {
                        max: 99,
                        message: 'Shipping address must be less than 100 characters'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9]+$/,
                        message: 'Shipping address can consist of alphabets and digits.'
                    }
                }
            },
            shippedMethod: {
                message: 'Please enter a valid shipping method',
                validators: {
                    stringLength: {
                        max: 99,
                        message: 'Shipping method must be less than 100 characters'
                    },
                    regexp: {
                        regexp: /^[0-9a-z A-Z]+$/,
                        message: 'Shipping method can consist of alphabets and digits.'
                    }
                }
            },
            reference: {
                message: 'The reference is not valid',
                validators: {
                    stringLength: {
                        max: 99,
                        message: 'Reference must be less than 100 characters'
                    },
                    regexp: {
                    	regexp: /^[a-z 0-9A-Z,]+$/,
                        message: 'Reference can consist of alphabets and digits.'
                    }
                }
            }
            
        }
    });
});
</script>
</body>
</html>
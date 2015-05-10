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
  </head>
  <body>  
  	<input type="hidden" name="counter" id="counter" value="0" /> 
  <script>
	function addRow()
	{	
		var currentCounter =$('#counter').val();
		var randomnumber=parseInt(currentCounter)+1;
		var rowHtml = '<tr id="row'+randomnumber+'"><td align="center"><a href="javascript:" onclick="$(\'#row'+randomnumber+'\').remove();" title="Delete this row"><strong>X</strong></a></td><td><select id="p'+randomnumber+'" name="items['+randomnumber+'].productID" class="form-control productname" onChange="updateQuantity('+randomnumber+');"><c:forEach var="product" items="${products}"><option value="${product.productID}">${product.productName}</option></c:forEach></select></td><td><input id="qty'+randomnumber+'" type="text" name="items['+randomnumber+'].quantity"  data-toggle="tooltip" data-placement="left" title="Quantity Available = ${products[0].productBalance}" class="form-control text-right quantity" value="0" onkeyup="rowCalc('+randomnumber+');"/></td><td><input id="pc'+randomnumber+'" type="text" class="form-control text-right price" value="0.00" onkeyup="rowCalc('+randomnumber+');" name="items['+randomnumber+'].priceWithoutVat"/></td><td style="text-align: center; vertical-align: middle;"><input type="checkbox" id="vatcheck'+randomnumber+'" name="items['+randomnumber+'].applyVat"  class="text-center" onclick="toggleVatBox('+randomnumber+');rowCalc('+randomnumber+');"/></td><td><input id="vat'+randomnumber+'" type="text" class="form-control text-right percent" value="0.00" disabled onkeyup="rowCalc('+randomnumber+');" name="items['+randomnumber+'].vatPercent"/></td><td><input id="pcV'+randomnumber+'" type="text" class="form-control text-right price" value="0.00" onkeyup="rowCalc2('+randomnumber+');" name="items['+randomnumber+'].priceWithVat"/></td><td></span><input type="text" readOnly="readOnly" name="items['+randomnumber+'].total" class="form-control text-right rowTotal" id="total'+randomnumber+'" value="0.00"/><input type="hidden" id="rowSubTotal'+randomnumber+'" value="0.00" class="rowSubTotal" name="items['+randomnumber+'].subTotal"></td></tr>';
		$('#counter').val(randomnumber);
		$('#invoice-table').append(rowHtml);
      	$('[data-toggle="tooltip"]').tooltip();
      	$('select.productname').select2();
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
		if(qty==''){
			qty=0;
		}
		if(priceperitem==''){
			priceperitem=0;
		}
		if(vatper==''){
			vatper=0;
		}
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
				checkTIN();
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
				$('#qty'+index).attr("onkeyup","checkLimit(this,'"+response+"');rowCalc("+index+");");
				$('#qty'+index).val(0);
				rowCalc(index);
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});	
	}
	
	function updateDLP(index){
		var productid =document.getElementById("p"+index).value;
		var data = 'productid='
			+ encodeURIComponent(productid);
		$.ajax({
			url : "/AccountmateWS/getProductDLP",
			data : data,
			type : "GET",

			success : function(response) {
				$('#pcV'+index).attr("data-original-title","Current DLP = Rs. "+response);
			},
			error : function(xhr, status, error) {
				alert(xhr.responseText);
			}
		});	
	}
  </script>
	<!-- Header -->
    <%@include file="../layout/headernew.jsp" %>
	<!-- -- --- -->
	
	<!-- Sales Invoice 
	==============================================================================================================-->
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2>Sales Invoice</h2><hr/>
			</div>
			<div class="col-md-12">
				<div class="hideIt" id="success">
		            <div class="alert alert-success" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> ${message}
		            </div>
		        </div>
		        <div class="hideIt" id="failure">
		            <div class="alert alert-danger" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> ${message}
		            </div>
		        </div>
			</div>
			<div class="col-md-12">
				<form:form id="invoiceForm" class="form-horizontal" method="post" action="/AccountmateWS/saveSalesInvoice">
					<div class="form-group required">
						<label class="col-md-2 control-label">Client Name</label>
						<div class="col-md-4">
							<select id="suppliername" name="clientID" class="form-control " onChange="updateTIN();">
								<c:forEach var="client" items="${clients}">
									<option value="${client.clientID}">${client.clientName}</option>
								</c:forEach>
							</select>
						</div>
						<div class="col-md-3 pull-right">
							<div>
								<div id="taxinvoicedate" class="form-control" style="cursor: pointer;">
				                  <i class="fa fa-calendar"></i>
				                  <span></span> <b class="caret"></b>
				                  <input type="hidden" name="taxinvoicedate" value=""/>
				            	</div>
							</div>
							<div>
								<div id="retailinvoicedate" class="form-control" style="cursor: pointer;">
				                  <i class="fa fa-calendar"></i>
				                  <span></span> <b class="caret"></b>
				                  <input type="hidden" name="retailinvoicedate" value=""/>
				            	</div>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">TIN #</label>
						<div class="col-md-4">
							<input id="tinnumber" name ="clientTIN" type="text" class="form-control" value="${clients[0].clientTIN}" readOnly="readOnly"/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label">Custom Days to Pay</label>
						<div class="col-md-4">
							<select id="customdaystopay" name="customDaysToPay" class="form-control">
							  <option value="0">Client's Custom Days to Pay</option>
							  <option value="10">10</option>
							  <option value="15">15</option>
							  <option value="20">20</option>
							  <option value="25">25</option>
							  <option value="30">30</option>
							  <option value="45">45</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-offset-2 col-md-4">
							<label class="radio-inline"><input type="radio" name="invoiceTypeID" value="3" checked="checked" onClick="checkTIN();">Tax Invoice</label>
							<label class="radio-inline"><input type="radio" name="invoiceTypeID" value="2" onClick="checkTIN();">Retail Invoice</label>
						</div>
					</div>
					<div id="warning" class="hideIt">
		            	<div class="alert alert-warning">
		              		<button type="button" class="close" data-dismiss="alert">&times;</button>
		              		<strong>Warning !</strong> TIN number is required for Tax Invoices.
		            	</div>
		        	</div>
		        	<hr/>
		        	<div class="table-responsive">
		        		<table class="table table-bordered table-striped" id="invoice-table">
		        			<thead>
		        				<tr class="well">
		        					<th class="text-center"><i class="fa fa-trash fa-lg"></i></th>
									<th class="text-center col-md-3">Product Details</th>
									<th class="text-center">QTY</th>
									<th class="text-center">Price [<i class="fa fa-rupee extraPaddingLeftRight5"></i>]</th>
									<th class="text-center">VAT</th>
									<th class="text-center">VAT %</th>
									<th class="text-center">Price [<i class="fa fa-rupee extraPaddingLeftRight5"></i>]</th>
									<th class="text-center">Total [<i class="fa fa-rupee extraPaddingLeftRight5"></i>]</th>
		        				</tr>
		        			</thead>
		        			<tbody>
		        				<tr id="row0">
									<td style="color:#FFFFFF">X</td>
									<td>
										<select id="p0" name="items[0].productID" class="form-control productname" onChange="updateQuantity(0);updateDLP(0);">
											<c:forEach var="product" items="${products}">
												<option value="${product.productID}">${product.productName}</option>
											</c:forEach>
										</select>
									</td>
									<td>
										<input id="qty0" type="text" name="items[0].quantity"  data-toggle="tooltip" data-placement="left" title="Quantity Available = ${products[0].productBalance}" class="form-control text-right quantity" value="0" onkeyup="checkLimit(this,'${products[0].productBalance}');rowCalc(0);"/>
									</td>
									<td>
										<input id="pc0" type="text" class="form-control text-right price" value="0.00" onkeyup="rowCalc(0);" name="items[0].priceWithoutVat"/>
									</td>
									<td style="text-align: center; vertical-align: middle;">
										<input type="checkbox" id="vatcheck0"  class="text-center" onclick="toggleVatBox(0);rowCalc(0);" name="items[0].applyVat"/>
									</td>
									<td>
										<input id="vat0" type="text" class="form-control text-right percent" value="0.00" disabled onkeyup="rowCalc(0);" name="items[0].vatPercent"/>
									</td>
									<td>
										<input id="pcV0" type="text" class="form-control text-right price" value="0.00" data-toggle="tooltip" data-placement="left" onkeyup="rowCalc2(0);" name="items[0].priceWithVat" title="Current DLP = Rs. ${products[0].dealerPrice}"/>
									</td>
									<td>
										<input  type="text" readOnly="readOnly" name="items[0].total" class="form-control text-right rowTotal" id="total0" value="0.00"/>
										<input type="hidden" id="rowSubTotal0" value="0.00" class="rowSubTotal" name="items[0].subTotal">
									</td>
								</tr>
		        			</tbody>
		        		</table>
		        	</div>
		        	<div class="col-md-12 well" style="
													    margin-bottom: 10px;
													    padding-top: 10px;
													    padding-bottom: 10px;
													    padding-right: 10px;
													    padding-left: 10px;
													">
		        		<div class="col-md-6">
		        			<a onclick="addRow();"><i class="fa fa-plus extraPaddingLeftRight5 pointerCursor"></i>Add row</a>
		        		</div>
		        		<div class="col-md-6">
		        			<div class="form-group" style="margin-bottom: 5px;">
								<label class="control-label col-md-4 col-md-offset-3">Subtotal (ex VAT) </label>
								<div class="col-md-5">
									<div class="input-group">
						                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
						                <input type="text" class="form-control text-right" readOnly="readOnly" id="subtotal" value="0.00" name="subTotal"/>
						            </div>	
								</div>
							</div>
							<div class="form-group" style="margin-bottom: 5px;">
								<label class="control-label col-md-4 col-md-offset-3">VAT</label>
								<div class="col-md-5">
									<div class="input-group">
						                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
						                <input type="text" class="form-control text-right" id="vattotal" value="0.00" readOnly="readOnly" name="vatTotal"/>
						            </div>
								</div>
							</div>
							<div class="form-group" style="margin-bottom: 5px;">
								<label class="control-label col-md-4 col-md-offset-3">Total</label>
								<div class="col-md-5">
									<div class="input-group">
						                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
						                <input type="text" class="form-control text-right" id="total" value="0.00" readOnly="readOnly" name="total"/>
						            </div>
								</div>
							</div>
		        		</div>
		        	</div>
		        	<div class="col-md-12" style="
					    padding-left: 0px;
					    padding-right: 0px;
					">
						<hr/>
					</div>
		        	<div class="col-md-12">
						<div class="form-group">
							<label for="detail text-left" class="col-md-2">Other Details</label>
						</div>
						<div class="form-group">
							<div class="col-md-4">
								<textarea style="resize: none;" name="shippedTo" class="form-control" placeholder="Shipped to... " rows="3"></textarea>
							</div>
							<div class="col-md-4">
								<textarea  style="resize: none;" name="shippedMethod" class="form-control" placeholder="Shipping Method... " rows="3"></textarea>
							</div>
							<div class="col-md-4">
								<textarea style="resize: none;" name="reference" class="form-control" placeholder="Reference... " rows="3"></textarea>
							</div>
						</div>
					</div>
					<div class="col-md-12">
						<div class="form-group">
							<div class="col-md-offset-10 col-md-2">
								<button type="submit" class="btn btn-primary btn-lg">Save</button>
								<button type="reset" class="btn btn-default btn-lg">Clear</button>
							</div>
						</div>
					</div>
				</form:form>
			</div>
		</div>
	</div>
	<!-- Footer -->
    <%@include file="../layout/footernew.jsp" %>
	<!-- -- --- -->	
    <script>
    	$('#warning').hide();
        $(document).ready(function() { 
        	$("#suppliername").select2(); 
        	$('select.productname').select2();
        });
        $(function () {
        	  $('[data-toggle="tooltip"]').tooltip();
        });
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
	$(document).ready(function() {         
	     var cbTax = function(start, end, label) {
	         $('#taxinvoicedate span').html(start.format('MMMM D, YYYY'));
	         $('#taxinvoicedate input').val(start.format('YYYY-MM-DD'));
	       };
       	 var cbRetail = function(start, end, label) {
	         $('#retailinvoicedate span').html(start.format('MMMM D, YYYY'));
	         $('#retailinvoicedate input').val(start.format('YYYY-MM-DD'));
	       };
	     var optionSetTax = {
	   	         showDropdowns: true,
	   	         minDate:moment("${latesttaxdate}"),
	   	         showWeekNumbers: false,
	   	         timePicker: false,
	   	         timePickerIncrement: 1,
	   	         timePicker12Hour: true,
	   	         ranges: {
	   	            'Today': [moment(), moment()],
	   	            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')]
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
	     var optionSetRetail = {
	   	         showDropdowns: true,
	   	         minDate:moment("${latestretaildate}"),
	   	         showWeekNumbers: false,
	   	         timePicker: false,
	   	         timePickerIncrement: 1,
	   	         timePicker12Hour: true,
	   	         ranges: {
	   	            'Today': [moment(), moment()],
	   	            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')]
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
	      $('#taxinvoicedate span').html(moment().format('MMMM D, YYYY'));
	      $('#retailinvoicedate span').html(moment().format('MMMM D, YYYY'));
	      
	      $('#taxinvoicedate input').val(moment().format('YYYY-MM-DD'));
	      $('#retailinvoicedate input').val(moment().format('YYYY-MM-DD'));
	      
	      $('#taxinvoicedate').daterangepicker(optionSetTax, cbTax);
	      $('#retailinvoicedate').daterangepicker(optionSetRetail, cbRetail);
	});
	</script>
	<script>
		function checkLimit(ele,maxVal){
			if($(ele).val()> parseInt(maxVal)){
				$(ele).val(maxVal);
				$(ele).trigger('mouseover');
			}
		}
		function checkTIN(){
			if($("input[type='radio'][name='invoiceTypeID']:checked").val() == 3){
				$('#taxinvoicedate').show();
				$('#retailinvoicedate').hide();
			}
			else{
				$('#taxinvoicedate').hide();
				$('#retailinvoicedate').show();
			}
			if($("input[type='radio'][name='invoiceTypeID']:checked").val() == 3 && $('#tinnumber').val() == ''){
				$('#warning').show();
				$('#savebutton').hide();
			}
			else{
				$('#warning').hide();
				$('#savebutton').show();
				
			}
		}
		checkTIN();
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
            shippedTo: {
                message: 'Please enter a valid shipping address',
                validators: {
                    stringLength: {
                        max: 99,
                        message: 'Shipping address must be less than 100 characters'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9,.]+$/,
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
                        regexp: /^[0-9a-z A-Z,.]+$/,
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
                    	regexp: /^[a-z 0-9A-Z,.]+$/,
                        message: 'Reference can consist of alphabets and digits.'
                    }
                }
            }
            
        }
    });
});
	
	$('input[type=text].price').keypress(function (e) {
	    var regex = new RegExp("^[0-9.]+$");
	    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
	    if (regex.test(str)) {
	        return true;
	    }

	    e.preventDefault();
	    return false;
	});

	$('input[type=text].quantity').keypress(function (e) {
	    var regex = new RegExp("^[0-9]+$");
	    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
	    if (regex.test(str)) {
	        return true;
	    }

	    e.preventDefault();
	    return false;
	});

	$('input[type=text].percent').keypress(function (e) {
	    var regex = new RegExp("^[0-9.]+$");
	    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
		if (regex.test(str)) {
	        return true;
	    }
	    e.preventDefault();
	    return false;
	});
</script>
</body>
</html>
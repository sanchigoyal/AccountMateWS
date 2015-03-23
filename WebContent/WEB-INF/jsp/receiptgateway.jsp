<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <form class="form-horizontal" id="clientForm" action="/AccountmateWS/saveReceiptDetails" method="post">
					<input type="hidden" id="requestfrom" name="requestfrom" value=""/>
					<input type="hidden" id="requestdatefrom" name ="requestdatefrom" value=""/>
					<input type="hidden" id="requestdateto" name="requestdateto" value=""/>
					<div class="form-group">
						<label for="name" class="col-md-2">Date of Receipt </label>
						<div class="col-md-4">
							<div>
								<div id="receiptdate" class="form-control" style="cursor: pointer;margin-bottom:10px;">
				                  <i class="fa fa-calendar"></i>
				                  <span></span> <b class="caret"></b>
				                  <input type="hidden" name="reptdate" value=""/>
				            	</div>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label for="name" class="col-md-2">Client </label>
						<div class="col-md-4">
							<select name="clientname" id="clientname" class="form-control" onChange="updateInvoiceList();">
								<c:forEach var="client" items="${clients}">
									<option value="${client.clientID}">${client.clientName}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group" id="billWiseCheckBox">
						<div class="col-md-offset-2 col-md-4">
							<input type="checkbox" id="billWiseReceipt" onclick="updateInvoiceList();" name="billWiseReceipt"/> Bill Wise Receipt
						</div>
					</div>
					<div id="invoice-dropdown">
						<%@include file="receiptgatewayinvoicedropdown.jsp" %>
 					</div>
 					<hr/>
 					<div id="invoice-tables">
 						<%@include file="receiptgatewaytables.jsp" %>
					</div>
					<div class="form-group">
						<label for="pay" class="col-md-2">Received</label>
						<div class="col-md-4">
							<input type="text" id="pay" name="pay" class="form-control" onkeyup="togglePaymentOption();" placeholder="Enter Amount to be paid... " value="${outstandingAmount}">
						</div>
					</div>
					<div class="form-group">
						<label for="mop" class="col-md-2">Mode of Payment</label>
						<div class="col-md-4">
							<select name="mop" id="mop" class="form-control" onChange="togglePaymentOption();">
							<option value="1">Cash</option>
							<option value="2">Cheque</option>
							</select>
						</div>
						<div id="cashfailure" class="col-md-6">
				            <div class="alert alert-danger">
				              <strong>Oh snap!</strong> You do not have sufficient cash to make this transaction.
				            </div>
				        </div>
					</div>
					<div id="cashpayment">
						<div class="form-group">
							<div class="col-md-4 col-md-offset-2">
								<textarea name="cashdetails" id="cashdetails" class="form-control" rows="3" placeholder="Enter Cash Details.... "></textarea>
							</div>
					    </div>
					</div>
					<div id="chequepayment">
						<div class="form-group">
							<label for="bank" class="col-md-2">Bank</label>
							<div class="col-md-4">
								<select name="bank" id="bank" class="form-control">
									<c:forEach var="bank" items="${banks}">
										<option value="${bank.clientID}">${bank.clientName}</option>
									</c:forEach>
								</select>
							</div>
							<div class="col-md-4">
								<input type="text" name="chequeNumber" id="chequenumber" class="form-control" placeholder="Enter Cheque Number.. ">
							</div>
						</div>
					</div>
					<div id="receiptbutton" class="form-group">
						<div class="col-md-10 col-md-offset-2">
							<button type="submit" class="btn btn-success">Save</button>
						</div>
					</div>
	</form>
	
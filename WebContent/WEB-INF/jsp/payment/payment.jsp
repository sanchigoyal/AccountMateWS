<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="modal-header">
	<span class="col-md-12 text-center"><strong>PAYMENT</strong></span>
	<div id="left" class="col-md-6" >
		<h2>${payment.clientName}</h2>
	</div>
	<div id="right">
		</br></br>
		<table class="pull-right">
			<tr><td><strong>Payment #</strong></td><td> ${payment.paymentID}</td></tr>
			<tr><td><strong>Date</strong></td><td> ${payment.paymentDate}</td></tr>
		</table>
	</div>
	<br/><br/>
</div>
<div class="modal-body">
	<c:if test="${payment.billWise == 'Y'}">
		<div>
			<table class="table">
				<tr class="well">
					<th class="col-md-3 text-center">Invoice</th>
					<th class="col-md-2 text-center">Sub Total</th>
					<th class="col-md-2 text-center">Total Vat</th>
					<th class="col-md-2 text-center">Total</th>
					<th class="col-md-2 text-center">Amount Paid</th>
				</tr>
				<c:forEach var="invoice" items="${invoices}">
					<tr>
						<td class="text-center">${invoice.billNumber}</td>
						<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.subTotal}</span></td>
						<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.vatTotal}</span></td>
						<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.total}</span></td>
						<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.outstandingAmount}</span></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</c:if>
	<c:choose>
		<c:when test="${payment.billWise == 'Y'}">
			<div class="well col-md-3">
				<strong>Total Paid</strong><i class="fa fa-rupee extraPaddingLeftRight5"></i>${payment.paidAmount}<br/>
				<strong>Mode of Payment</strong> ${payment.mop}<br/>
				<c:choose>
					<c:when test="${payment.mop == 'Cash'}">
						<strong>Cash Detail</strong> ${payment.cashDetails}<br/>
					</c:when>
					<c:otherwise>
						<strong>Bank</strong> ${payment.bankName}<br/>
						<strong>Cheque Number</strong> ${payment.chequeNumber}<br/>
					</c:otherwise>
				</c:choose>
			</div>
		</c:when>
		<c:otherwise>
			<table class="table">
				<tr class="well">
					<th class="text-center">Total Paid</th>
					<th class="text-center">Mode Of Payment</th>
					<c:choose>
						<c:when test="${payment.mop == 'Cash'}">
							<th class="text-center">Cash Details</th>
						</c:when>
						<c:otherwise>
							<th class="text-center">Bank</th>
							<th class="text-center">Cheque Number</th>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td class="text-center"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${payment.paidAmount}</td>
					<td class="text-center">${payment.mop}</td>
					<c:choose>
						<c:when test="${payment.mop == 'Cash'}">
							<td class="text-center">${payment.cashDetails}</td>
						</c:when>
						<c:otherwise>
							<td class="text-center">${payment.bankName}</td>
							<td class="text-center">${payment.chequeNumber}</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</table>
		</c:otherwise>
	</c:choose>
</div>
<div class="modal-footer" style="margin-top: 140px;">
	<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
</div>
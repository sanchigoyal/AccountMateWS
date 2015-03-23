<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<table class="table">
	<tr class="well">
		<th class="col-md-3 text-center">Invoice</th>
		<th class="col-md-2 text-center">Sub Total</th>
		<th class="col-md-2 text-center">Total Vat</th>
		<th class="col-md-2 text-center">Total</th>
		<th class="col-md-2 text-center">Outstanding Amount</th>
	</tr>
	<c:forEach var="invoice" items="${invoicesList}">
		<tr>
			<td class="text-center">${invoice.billNumber}</td>
			<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.subTotal}</span></td>
			<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.vatTotal}</span></td>
			<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.total}</span></td>
			<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${invoice.outstandingAmount}</span></td>
		</tr>
	</c:forEach>
	<tr>
		<td class="text-center"><strong>Total</strong></td>
		<td class="text-right"><strong><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${subTotal}</span></strong></td>
		<td class="text-right"><strong><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${vatTotal}</span></strong></td>
		<td class="text-right"><strong><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${total}</span></strong></td>
		<td class="text-right"><strong><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${outstandingAmount}</span></strong></td>
	</tr>
</table>
<hr/>

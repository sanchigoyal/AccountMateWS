<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="form-group">
	<label class="col-md-2 control-label">Invoice</label>
	<div class="col-md-4">
		<select name="billnumber" id="billnumber" class="form-control" onChange="updateInvoiceTable();">
			<c:forEach var="invoice" items="${invoices}">
				<option value="${invoice.invoiceID}">${invoice.billNumber}</option>
			</c:forEach>
		</select>
	</div>
</div>
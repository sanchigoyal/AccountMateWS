<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
		<div class="modal-header" style="height: 131.11111116409302px;">
			<span class="col-md-12 text-center"><strong>${invoice.invoice_type} INVOICE</strong></span>
			<div id="left" class="col-md-6" >
				<h2 style="margin-top: 10px;">${invoice.clientName}</h2>
				<p>TIN : ${invoice.clientTIN }<br/>
				<strong>Custom Days to Pay : ${invoice.customDaysToPay}</strong></p>
			</div>
			<div id="right" class="col-md-3 col-md-offset-3" style="margin-top: 10px;">
				<table class="">
					<tr><td style="padding-right: 10px;"><strong>Invoice #</strong></td><td> ${invoice.billNumber}</td></tr>
					<tr><td style="padding-right: 10px;"><strong>Date</strong></td><td> ${invoice.date}</td></tr>
				</table>
				<p>
				<c:if test="${invoice.invoiceStatus eq 'ACTIVE'}">
					<span class="text-primary"><strong>${invoice.invoiceStatus}</strong></span>
				</c:if>
				<c:if test="${invoice.invoiceStatus eq 'DELETED'}">
					<span class="text-danger"><strong>${invoice.invoiceStatus}</strong></span>
				</c:if>
				<c:if test="${invoice.invoiceStatus eq 'ACTIVE'}">
					<c:if test="${invoice.paymentStatus eq 'PAID'}">
						<span class="text-success"><strong>${invoice.paymentStatus}</strong></span>
					</c:if>
					<c:if test="${invoice.paymentStatus eq 'DUE/PARTIALLY PAID'}">
						<span class="text-danger"><strong>${invoice.paymentStatus}</strong></span>
					</c:if>
					<c:if test="${invoice.paymentStatus eq 'DUE/UNPAID'}">
						<span class="text-danger"><strong>${invoice.paymentStatus}</strong></span>
					</c:if>
					<c:if test="${invoice.paymentStatus eq 'PARTIALLY PAID'}">
						<span class="text-warning"><strong>${invoice.paymentStatus}</strong></span>
					</c:if>
					<c:if test="${invoice.paymentStatus eq 'UNPAID'}">
						<span class="text-primary"><strong>${invoice.paymentStatus}</strong></span>
					</c:if>
				</c:if>
				</p>
			</div>
			<br/><br/><br/><br/>
		</div>
		<div class="modal-body">
			<table id="invoice-table" class="table">
						<thead>
							<tr class="well">
								<th class="text-center col-md-4">Product Details</th>
								<th class="text-center col-md-1">QTY</th>
								<th class="text-center col-md-2">Price</th>
								<th class="text-center col-md-1">VAT</th>
								<th class="text-center col-md-2">Price</th>
								<th class="text-center col-md-2">Total</th>
								
							</tr>
						</thead>
						<tbody>
							<c:forEach var="item" items="${invoice.items}">
							<tr>
								<td><span class="extraPadding20">${item.productName}</span></td>
								<td class="text-center">${item.quantity}</td>
								<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${item.priceWithoutVat}</span></td>
								<td class="text-right">${item.vatPercent}%</td>
								<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${item.priceWithVat}</span></td>
								<td class="text-right"><span class="extraPaddingRight20"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${item.total}</span></td>
								
							</tr>
							</c:forEach>
						</tbody>
			</table>
			<div class="well">
						<div class="row">
							<div class="col-md-10 text-right">
								<strong>Subtotal (ex VAT) </strong>
							</div>
							<div class="col-md-2 text-right input-group">
								<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
								<input readOnly="readOnly" type="text" class="form-control text-right extraPaddingRight20" id="subtotal" value="${invoice.subTotal}"/>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10 text-right">
								<strong>VAT </strong>
							</div>
							<div class="col-md-2 text-right input-group">
								<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
								<input type="text" class="form-control text-right extraPaddingRight20" id="vattotal" value="${invoice.vatTotal}" readOnly="readOnly"/>
							</div>
						</div>
						<div class="row">
							<div class="col-md-10 text-right">
								<strong>Total</strong>
							</div>
							<div class="col-md-2 text-right input-group">
								<span class="input-group-addon"><i class="fa fa-rupee"></i></span>
								<input type="text" class="form-control text-right extraPaddingRight20" id="total" value="${invoice.total}" readOnly="readOnly"/>
							</div>
						</div>
			</div>
			<hr/>
						<div class="col-md-4">
							<textarea name="shippedTo" class="form-control" rows="3" readOnly="readOnly">Shipped To..${invoice.shippedTo}</textarea>
						</div>
						<div class="col-md-4">
							<textarea name="shippedMethod" class="form-control" rows="3" readOnly="readOnly">Shipping Method..${invoice.shippedMethod}</textarea>
						</div>
						<div class="col-md-4">
							<textarea name="reference" class="form-control" rows="3" readOnly="readOnly">Reference..${invoice.reference}</textarea>
						</div>
						<br/><br/><br/><br/>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
		</div>
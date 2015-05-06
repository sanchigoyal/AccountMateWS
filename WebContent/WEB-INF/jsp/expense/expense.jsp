<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div class="modal-header">
	<span class="col-md-12 text-center"><strong>EXPENSE</strong></span>
	<div id="right">
		</br></br>
		<table class="pull-right">
			<tr><td><strong>Payment #</strong></td><td> ${expense.expenseID}</td></tr>
			<tr><td><strong>Date</strong></td><td> ${expense.expenseDate}</td></tr>
		</table>
	</div>
	<br/><br/>
</div>
<div class="modal-body">
		<table class="table text-center table-striped">
			<tbody>
				<tr><td>Expense Category</td><td>${expense.expenseCategory}</td></tr>
				<tr><td>Description</td><td>${expense.description}</td></tr>
				<tr><td>Amount</td><td>${expense.amount}</td></tr>
				<tr><td>Mode of Payment</td><td>${expense.modeOfPayment}</td></tr>
				<tr><td>Bank</td><td>${expense.bankName}</td></tr>
				<tr><td>Cheque Number</td><td>${expense.chequeNumber}</td></tr>
			</tbody>
		</table>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
</div>
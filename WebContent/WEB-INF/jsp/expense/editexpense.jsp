<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<div class="modal-header">
	<h2>Edit</h2>
</div>
<div class="modal-body">
	<form:form class="form-horizontal"  id="expenseForm" action="/AccountmateWS/updateExpense" method="post">
		<input type="hidden" name="expenseID" id="expenseid" value="${expense.expenseID}">
		<input type="hidden" id="redirecteditstartdate" name="redirecteditstartdate" value = ""/>
		<input type="hidden" id="redirecteditenddate" name="redirecteditenddate" value =""/>
		<div class="form-group">
			<div class="col-md-offset-4 col-md-8">
				<div>
					<div id="expensemodaldate" class="form-control" style="cursor: pointer;margin-bottom:10px;">
	                  <i class="fa fa-calendar"></i>
	                  <span></span> <b class="caret"></b>
	                  <input type="hidden" name="expmodaldate" value=""/>
	            	</div>
				</div>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Expense Category</label>
			<div class="col-md-8">
				<select id="expensecategorymodal" name="expenseCategoryID" class="form-control">
				<c:forEach var="category" items="${categories}">
					<option value="${category.categoryID}">${category.category}</option>
				</c:forEach>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-md-4 control-label">Description</label>
			<div class="col-md-8">
				<input id="description" name="description" type="text" class="form-control" value="${expense.description}" placeholder="Enter Description..."/>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Amount</label>
			<div class="col-md-8">
				<input id="amount" name="amount" type="text" class="form-control" value="${expense.amount}" placeholder="Enter Amount... ">
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Mode of Payment</label>
			<div class="col-md-8">
				<select id="by" class="form-control"  name="transactionBy" onChange="toggleBank();">
					<option value="1">Cash</option>
					<option value="2">Cheque</option>
				</select>
			</div>
		</div>
		<div id="bankdetails">
			<div class="form-group required">
				<label class="col-md-4 control-label">Bank</label>
				<div class="col-md-8">
					<select disabled id="bank" class="form-control"  name="bankID">
						<c:forEach var="bank" items="${banks}">
							<option value="${bank.clientID}">${bank.clientName}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col-md-4 control-label">Cheque Number</label>
				<div class="col-md-8">
					<input disabled id="chequeNumber" name="chequeNumber" type="text" class="form-control" value="${expense.chequeNumber}" placeholder="Enter Cheque #... ">
				</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-md-8 col-md-offset-4">
				<button type="submit" class="btn btn-success">Update</button>
			</div>
		</div>
	</form:form>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
</div>

<script>
$('#expensecategorymodal').val("${expense.expenseCategoryID}");
$('#by').val("${expense.transactionBy}");
function toggleBank(){
	if($("#by").val() == 1){
		$('#bankdetails').hide();
		$("#bank").prop('disabled', true);
		$("#chequeNumber").prop('disabled', true);
	}
	else{
		$('#bankdetails').show();
		$("#bank").prop('disabled', false);
		$("#chequeNumber").prop('disabled', false);
	}
}
toggleBank();
</script>
<script type="text/javascript">
       $(document).ready(function() {
          var cb2 = function(start, end, label) {
              $('#expensemodaldate span').html(start.format('MMMM D, YYYY'));
              $('#expensemodaldate input').val(start.format('YYYY-MM-DD'));
            };

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
       $('#expensemodaldate span').html(moment("${expense.expenseDate}").format('MMMM D, YYYY'));
       $('#expensemodaldate input').val(moment("${expense.expenseDate}").format('YYYY-MM-DD'));
       $('#expensemodaldate').daterangepicker(optionSet2, cb2);
	});
</script>
<script>
	$(document).ready(function() {
    $('#expenseForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	description: {
                message: 'The description is not valid',
                validators: {
                    stringLength: {
                        min: 0,
                        max: 30,
                        message: 'The description must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9_]+$/,
                        message: 'The description can consist of alphabetical, number and underscore'
                    }
                }
            },
            amount: {
                message: 'The amount is not valid',
                validators: {
                    notEmpty: {
                        message: 'The amount is required'
                    },
                    numeric: {
                        message: 'The amount must be a number'
                    }
                }
            },
            chequeNumber: {
                message: 'The cheque number is not valid',
                validators: {
                    regexp: {
                        regexp: /^[a-z A-Z0-9_]+$/,
                        message: 'The cheque number can consist of alphabetical, number and underscore'
                    }
                }
            }
        }
    });
});
</script>	

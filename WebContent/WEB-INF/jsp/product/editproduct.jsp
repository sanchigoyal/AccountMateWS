<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<div class="modal-header">
	<h2>Edit</h2>
</div>
<div class="modal-body">
	<form:form class="form-horizontal"  id="productForm" action="/AccountmateWS/updateProduct" method="post">
		<input type="hidden" name="productID" id="productid" value="${product.productID}">
		<input type="hidden" name="redirectcategoryedit" id="redirectcategoryedit" value ="">
		<div class="form-group">
			<label class="col-md-4 control-label">Product Category</label>
			<div class="col-md-8">
				<select id="productcategorymodal" name="productCategory" class="form-control">
				<c:forEach var="category" items="${categories}">
					<option value="${category.categoryID}">${category.category}</option>
				</c:forEach>
				</select>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Product Name</label>
			<div class="col-md-8">
				<input id="productname" name="productName" type="text" class="form-control" value="${product.productName}" placeholder="Enter Product Name..."/>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Opening Balance (units)</label>
			<div class="col-md-8">
				<input id="openingbalance" name="openingBalance" type="text" class="form-control" value="${product.openingBalance}" placeholder="Enter Opening Balance... ">
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Curr. Cost Price</label>
			<div class="col-md-8">
				<div class="input-group">
	                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
	                <input id="costprice" name="costPrice" type="text" class="form-control" value="${product.costPrice}" placeholder="Enter Curr. Cost Price... ">
	            </div>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Curr. DLP</label>
			<div class="col-md-8">
				<div class="input-group">
	                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
	                <input id="dealerprice" name="dealerPrice" type="text" class="form-control" value="${product.dealerPrice}" placeholder="Enter Curr. DLP... ">
	            </div>
			</div>
		</div>
		<div class="form-group required">
			<label class="col-md-4 control-label">Curr. MRP</label>
			<div class="col-md-8">
				<div class="input-group">
	                <div class="input-group-addon"><i class="fa fa-rupee extraPaddingLeftRight5"></i></div>
	                <input id="marketprice" name="marketPrice" type="text" class="form-control" value="${product.marketPrice}" placeholder="Enter Curr. MRP... ">
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
$('#productcategorymodal').val("${product.productCategory}");	
</script>
<script>
	$(document).ready(function() {
    $('#productForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	productName: {
                message: 'The product name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The product name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 3,
                        max: 30,
                        message: 'The product name must be more than 3 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9]+$/,
                        message: 'The product name can consist of alphabets and numbers'
                    }
                }
            },
            openingBalance: {
                message: 'The opening balance is not valid',
                validators: {
                	notEmpty: {
                        message: 'The opening balance is required and cannot be empty'
                    },
                    regexp: {
                    	regexp: /^[0-9]+$/,
                        message: 'The opening balance can only consist of numbers'
                    }
                }
            },
            costPrice: {
                message: 'The cost price is not valid',
                validators: {
                	 notEmpty: {
                         message: 'The cost price is required'
                     },
                     numeric: {
                         message: 'The cost price must be a number'
                     }
                }
            },
            marketPrice: {
                message: 'The MRP is not valid',
                validators: {
                	 notEmpty: {
                         message: 'The market price is required'
                     },
                     numeric: {
                         message: 'The market price must be a number'
                     }
                }
            },
            dealerPrice: {
                message: 'The DLP is not valid',
                validators: {
                	 notEmpty: {
                         message: 'The dealer price is required'
                     },
                     numeric: {
                         message: 'The dealer price must be a number'
                     }
                }
            }
            
        }
    });
});
</script>
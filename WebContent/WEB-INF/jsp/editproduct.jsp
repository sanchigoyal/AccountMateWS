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
			<label for="name" class="col-md-4">Product Category</label>
			<div class="col-md-8">
				<select id="productcategorymodal" name="productCategory" class="form-control">
				<c:forEach var="category" items="${categories}">
					<option value="${category.categoryID}">${category.category}</option>
				</c:forEach>
				</select>
			</div>
		</div>
		<div class="form-group">
			<label for="productname" class="col-md-4">Product Name</label>
			<div class="col-md-8">
				<input id="productname" name="productName" type="text" class="form-control" value="${product.productName}" placeholder="Enter Product Name..."/>
			</div>
		</div>
		<div class="form-group">
			<label for="openingbalance" class="col-md-4">Opening Balance (units)</label>
			<div class="col-md-8">
				<input id="openingbalance" name="openingBalance" type="text" class="form-control" value="${product.openingBalance}" placeholder="Enter Opening Balance... ">
			</div>
		</div>
		<div class="form-group">
			<label for="costprice" class="col-md-4">Curr. Cost Price (<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</label>
			<div class="col-md-8">
				<input onblur="convertDecimal('costprice');" id="costprice" name="costPrice" type="text" class="form-control" value="${product.costPrice}" placeholder="Enter Curr. Cost Price... ">
			</div>
		</div>
		<div class="form-group">
			<label for="dealerprice" class="col-md-4">Curr. DLP (<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</label>
			<div class="col-md-8">
				<input onblur="convertDecimal('dealerprice');" id="dealerprice" name="dealerPrice" type="text" class="form-control" value="${product.dealerPrice}" placeholder="Enter Curr. DLP... ">
			</div>
		</div>
		<div class="form-group">
			<label for="marketprice" class="col-md-4">Curr. MRP (<i class="fa fa-rupee extraPaddingLeftRight5"></i>)</label>
			<div class="col-md-8">
				<input onblur="convertDecimal('marketprice');" id="marketprice" name="marketPrice" type="text" class="form-control" value="${product.marketPrice}" placeholder="Enter Curr. MRP... ">
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
                    regexp: {
                    	regexp: /^[0-9]+$/,
                        message: 'The opening balance can only consist of numbers'
                    }
                }
            },
            costPrice: {
                message: 'The cost price is not valid',
                validators: {
                    regexp: {
                    	regexp: /^[0-9.]+$/,
                        message: 'The cost price can consist of numbers and point(.)'
                    }
                }
            },
            marketPrice: {
                message: 'The MRP is not valid',
                validators: {
                    regexp: {
                    	regexp: /^[0-9.]+$/,
                        message: 'The MRP can consist of numbers and point(.)'
                    }
                }
            },
            dealerPrice: {
                message: 'The DLP is not valid',
                validators: {
                    regexp: {
                    	regexp: /^[0-9.]+$/,
                        message: 'The DLP can consist of numbers and point(.)'
                    }
                }
            }
            
        }
    });
});
</script>
<script>
function number_format(num)
{
	num="" + Math.floor(num*100.0 + 0.5)/100.0;
	var i=num.indexOf(".");
	if(num=="NaN"){
		num="00.00";
	}
	else if (i<0 ) 
		num+=".00";
	else {
		num=num.substring(0,i) + "." + num.substring(i + 1);
		var nDec=(num.length - i) - 1;
		if ( nDec==0 ) num+="00";
		else if ( nDec==1 ) num+="0";
		else if ( nDec>2 ) num=num.substring(0,i + 3);
		}
	return num;
}
	function convertDecimal(ele){
		var price = $('#'+ele).val();
		var temp=parseFloat(price);
		$('#'+ele).val(number_format(temp));
	}
</script>
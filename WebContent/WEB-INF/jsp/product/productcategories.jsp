<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
     <script>
    	function updateEditModal(categoryid,categoryname){
			$('#editcategoryID').val(categoryid);
			$('#editcategoryname').val(categoryname);
    	}
    	
    	function updateDeleteModal(categoryid,categoryname,noofproducts){
			if(noofproducts!=0 || noofproducts!=0.0 || noofproducts !=0.00){
				$('#deletebutton').hide();
				$('#confirmquestion').hide();
			}
			else{
				$('#deletebutton').show();
				$('#confirmquestion').show();
			}
			//deletebutton.setAttribute('onClick','deleteproduct('+productid+');');
			$('#deletecategoryid').val(categoryid);
			document.getElementById('deleteCategoryName').innerHTML=categoryname;
		}
    </script>
    <!-- Header -->
    <%@include file="../layout/headernew.jsp" %>
	<!-- -- --- -->
	
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<h2> Product Categories</h2><hr/>
			</div>
			<div class="col-md-12">
				<div id="success" class="hideIt">
		            <div class="alert alert-success" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Well done!</strong> ${message}
		            </div>
		        </div>
		        <div id="failure" class="hideIt">
		            <div class="alert alert-danger" >
		              <button type="button" class="close" data-dismiss="alert">&times;</button>
		              <strong>Oh snap!</strong> ${message}
		            </div>
		        </div>
		    </div>
		    <div class="col-md-12">
	        	<a data-toggle="modal" href="#newcategory"><i class="fa fa-plus-square extraPaddingLeftRight5"></i>Add Category</a>
	        	<br/><br/>
				<table id="categoryList" class="table">
					<thead>
						<tr class="well">
							<th class="text-center">Category Name</th>
							<th class="text-right">Number of Products</th>
							<th class="text-right">Stock Value</th>
							<th class="text-center">Action</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="category" items="${categories}">
						<!--Single TR-->
						<tr>
							<td class="text-center">${category.category}</td>
							<td class="text-right">${category.noOfProducts}</td>
							<td class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${category.stockValue}</td>
							<td class="text-center"><p><a data-toggle="modal" href="#editcategory" class="addLineSeperator" onClick="updateEditModal('${category.categoryID}','${category.category}');" title="Edit"><i class="fa fa-edit fa-lg extraPaddingLeftRight5"></i></a>
							<a data-toggle="modal" href="#deletecategory" onclick="updateDeleteModal('${category.categoryID}','${category.category}','${category.noOfProducts}');"><i class="fa fa-trash fa-lg extraPaddingLeftRight5"></i></a></p></td>
						</tr>
						<!--TR End-->
						</c:forEach>
						<!--Total-->
						<tr class="well">
							<td colspan="2" class="text-right"><strong>Total:</strong></td>
							<td colspan="1"  class="text-right"><i class="fa fa-rupee extraPaddingLeftRight5"></i>${totalstockvalue}</td>
							<td colspan="2"></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<!-- Add Category Modal -->
			<div class="modal fade" id="newcategory" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
							<%@include file="newcategory.jsp" %>
					</div>
				</div>
			</div>
			<!-- Edit Category Modal -->
			<div class="modal fade" id="editcategory" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
							<%@include file="editcategory.jsp" %>
					</div>
				</div>
			</div>
			<!----Delete Category Modal--->
			<div class="modal fade" id="deletecategory" tabinex="-1" role="dialog" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
							<div class="modal-header">
								<h2>Are you sure ?</h2>
							</div>
							<div class="modal-body">
								<p>Deleting the category will not remove its sales/purchase entries as they are used for your records, and any
							category with non-zero product availibility will not be deleted.</p>
								<p id="confirmquestion">Are you sure you want to delete <label id="deleteCategoryName"></label> ?</p>
							</div>
							<div class="modal-footer">
								<form:form class="form-inline" id="categoryDeleteForm" method="post" action="/AccountmateWS/deleteCategory">
									<input type="hidden" id="deletecategoryid" name="categoryID" value = ""/>
									<button id="deletebutton" type="submit" class="btn btn-danger">Delete</button>
									<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
								</form:form>
							</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Footer -->
    <%@include file="../layout/footernew.jsp" %>
	<!-- -- --- -->    
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
    $('#newCategoryForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	category: {
                message: 'The category name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The category name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 2,
                        max: 30,
                        message: 'The category name must be more than 2 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9_]+$/,
                        message: 'The category name can consist of alphabetical, number and underscore'
                    }
                }
            }
            
        }
    });
});
	
$(document).ready(function() {
    $('#editCategoryForm').bootstrapValidator({
        // To use feedback icons, ensure that you use Bootstrap v3.1.0 or later
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
        	category: {
                message: 'The category name is not valid',
                validators: {
                    notEmpty: {
                        message: 'The category name is required and cannot be empty'
                    },
                    stringLength: {
                        min: 2,
                        max: 30,
                        message: 'The category name must be more than 2 and less than 30 characters long'
                    },
                    regexp: {
                        regexp: /^[a-z A-Z0-9_]+$/,
                        message: 'The category name can consist of alphabetical, number and underscore'
                    }
                }
            }
            
        }
    });
});
</script>
  </body>
</html>
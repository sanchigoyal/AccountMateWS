<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<div class="modal-header">
	<h2>Add Category</h2>
</div>
<div class="modal-body">
	<form:form class="form-horizontal"  id="newCategoryForm" action="/AccountmateWS/addCategory" method="post">
		<div class="form-group required">
			<label class="col-md-3 control-label">Category Name</label>
			<div class="col-md-8">
				<input id="categoryname" name="category" type="text" class="form-control" value="" placeholder="Enter Category Name..."/>
			</div>
		</div>
		<div class="form-group">
			<div class="col-md-8 col-md-offset-3">
				<button type="submit" class="btn btn-success">Add</button>
			</div>
		</div>
	</form:form>
</div>
<div class="modal-footer">
	<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
</div>
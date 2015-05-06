<!-- List of css -->
<link href="resources/css/bootstrap.min.css" rel="stylesheet">
<link href="resources/css/font-awesome.min.css" rel="stylesheet">
<link href="resources/css/style.css" rel="stylesheet">
<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">
<!-- Use date range picker instead of datepicker ------------
<link href="resources/css/datepicker.css" rel="stylesheet">-->
<link href="resources/css/dataTables.bootstrap.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" media="all" href="resources/css/daterangepicker-bs3.css" />
<link href="resources/css/select2.css" rel="stylesheet"/>
<link href="resources/css/select2-bootstrap.css" rel="stylesheet"/>

<!-- Navigation Bar
	===============================================================================================================-->
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Accountmate</a>
        </div>
        <div class="navbar-collapse collapse">
			<ul id="leftnav" class="nav navbar-nav">
			<li><a href="/AccountmateWS/accountBook">Account Book</a></li>
			<li><a class="dropdown-toggle pointerCursor" data-toggle="dropdown">Invoices & Receipts<b class="caret"></b></a>
				<ul class="dropdown-menu extraPaddingTop20 extraPaddingBottom20">
					<li><a href="/AccountmateWS/recordReceipt">Receipts</a></li><hr/>
					<li><a href="/AccountmateWS/createSalesInvoice">Sales invoice</a></li>
					<li><a href="/AccountmateWS/showSalesBook">Sales invoice book</a></li>
				</ul></li>
			<li><a class="dropdown-toggle pointerCursor" data-toggle="dropdown">Expenses<b class="caret"></b></a>
				<ul class="dropdown-menu extraPaddingTop20 extraPaddingBottom20">
					<li><a href="/AccountmateWS/createPurchaseInvoice">Purchase order</a></li>
					<li><a href="/AccountmateWS/showPurchaseBook">Purchase order book</a></li><hr/>
					<li><a href="/AccountmateWS/recordPayment">Record Payment</a></li>
					<li><a href="/AccountmateWS/recordExpenses">Record Expenses</a></li>
				</ul></li>
			<li class="dropdown">
				<a class="dropdown-toggle pointerCursor" data-toggle="dropdown">Client<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="/AccountmateWS/clientList">Client List</a></li>
					<li><a href="/AccountmateWS/newClient">New Client</a></li>
				</ul>
			</li>
			<li class="dropdown">
				<a class="dropdown-toggle pointerCursor" data-toggle="dropdown">Product<b class="caret"></b></a>
				<ul class="dropdown-menu">
					<li><a href="/AccountmateWS/productPriceList">Price List</a></li>
					<li><a href="/AccountmateWS/productList">Product List</a></li>
					<li><a href="/AccountmateWS/newProduct">New Product</a></li>
					<li><a href="/AccountmateWS/productCategories">Product Categories</a></li>
				</ul>
			</li>
			<li><a href="/AccountmateWS/reports">Reports</a></li>
		  </ul>
		  <ul class="nav navbar-nav navbar-right">
            <li><a href="/AccountmateWS/start">Home</a></li>
            <li><a href="/AccountmateWS/contact">Contact</a></li>
            <li><a id ="logoutnav" class="dropdown-toggle pointerCursor" data-toggle="dropdown"><i class="fa fa-user"></i></a>
            	<ul class="dropdown-menu">
					<li><a href="/AccountmateWS/myProfile">My Profile</a></li>
					<li><a href="/AccountmateWS/logout">Logout</a></li>
				</ul>
            </li>
          </ul>
          
       </div><!--/.nav-collapse -->
      </div>
    </div>
	
	</br></br></br></br>
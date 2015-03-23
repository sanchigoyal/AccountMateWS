<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Accountmate v1.2</title>

    <!-- Bootstrap core CSS -->
    <link href="resources/css/bootstrap.min.css" rel="stylesheet">
    <link href="resources/css/font-awesome.min.css" rel="stylesheet">
	<link href="resources/css/style.css" rel="stylesheet">
	<link href="resources/css/bootstrapValidator.css" rel="stylesheet">
	<link href="resources/css/bootstrap-formhelpers.min.css" rel="stylesheet">
  </head>

  <body>

    <%
		//allow access only if session exists
		String userid = null;
		String login = null;
		if(session.getAttribute("userid") == null){
		    response.sendRedirect("/AccountmateWS/start");
		}else {
				userid = (String) session.getAttribute("userid");
				login = (String) session.getAttribute("login");
		}
	%>
	
    <!-- Header -->
    <%@include file="header.jsp" %>
	<!-- -- --- -->
	
	
	<div class="container">
		<div class="row">
			<div class="col-md-1">
				<img src="resources/images/others/stats-logo.png"  height="75" width="75">
			</div>
			<div class="col-md-4">
				</br>
				<h1> Reports</h1>
			</div>
		</div>
	</div>
	</br>
	<div class="container">
		<div class="row">
			<!-- Tab Navigation -->
			<ul class="nav nav-pills nav-stacked col-md-2">
				<li class="active"><a href="#tab1" data-toggle="tab">Overall</a></li>
				<li><a href="#tab2" data-toggle="tab">Products</a></li>
				<li><a href="#tab3" data-toggle="tab">Clients</a></li>
			</ul>
			
			<!-- Tab Section -->
			<div class="tab-content col-md-10">
				<div class="tab-pane active" id="tab1">
					</br></br></br></br></br></br></br></br>
					<p class="text-center">Page Comming Soon....</p>
					</br></br></br></br></br></br>
				</div>
				<div class="tab-pane" id="tab2">
					<div class="col-md-8">
						<div id="graph2" style="height: 400px; margin: 0 auto"></div>
						<table id="datatable2">
							<thead>
								<tr>
									<th></th><th>Fan</th><th>CFL</th><th>Gyser</th><th>Switch gears</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>Jan</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Feb</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Mar</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Apr</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>May</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Jun</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Jul</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Aug</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Sep</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Oct</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Nov</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
								<tr>
									<th>Dec</th><td>30</td><td>40</td><td>30</td><td>40</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div  class="col-md-4">
						<div id="graph1" style="width: 400px; height: 400px; margin: 0 auto"></div>
						<table id="datatable1">
						<thead>
								<tr>
									<th></th>
									<th>Products</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>Fan</th>
									<td>30</td>
								</tr>
								<tr>
									<th>CFL</th>
									<td>40</td>
								</tr>
								<tr>
									<th>Gyser</th>
									<td>20</td>
								</tr>
								<tr>
									<th>Switch gears</th>
									<td>10</td>
								</tr>
							</tbody>
						</table>
						</br></br></br>
					</div>
				</div>
				<div class="tab-pane" id="tab3">
					<div class="col-md-8">
						<div class="col-md-6">
							</br>
							<select class="form-control">
								<option>MBS Trader</option>
							</select>
							</br>
						</div>

						<div id="graph3" style="height: 450px; margin: 0 auto"></div>
						<table id="datatable3">
							<thead>
								<tr>
									<th></th><th>Purchase</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>Jan</th><td>30</td>
								</tr>
								<tr>
									<th>Feb</th><td>40</td>
								</tr>
								<tr>
									<th>Mar</th><td>45</td>
								</tr>
								<tr>
									<th>Apr</th><td>55</td>
								</tr>
								<tr>
									<th>May</th><td>40</td>
								</tr>
								<tr>
									<th>Jun</th><td>45</td>
								</tr>
								<tr>
									<th>Jul</th><td>60</td>
								</tr>
								<tr>
									<th>Aug</th><td>62</td>
								</tr>
								<tr>
									<th>Sep</th><td>70</td>
								</tr>
								<tr>
									<th>Oct</th><td>50</td>
								</tr>
								<tr>
									<th>Nov</th><td>55</td>
								</tr>
								<tr>
									<th>Dec</th><td>60</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div  class="col-md-4">
						<div class="col-md-12">
							<div id="graph4" style="width: 300px; height: 300px; margin: 0 auto"></div>
							<table id="datatable4">
							<thead>
									<tr>
										<th></th>
										<th>Products</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>Fan</th>
										<td>30</td>
									</tr>
									<tr>
										<th>CFL</th>
										<td>40</td>
									</tr>
									<tr>
										<th>Gyser</th>
										<td>20</td>
									</tr>
									<tr>
										<th>Switch gears</th>
										<td>10</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="col-md-12">
							<div id="target" style="width: 300px; height: 200px;"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Footer -->
    <%@include file="footer.jsp" %>
	<!-- -- --- -->
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="resources/js/jquery.js"></script>
    <script src="resources/js/bootstrap.min.js"></script>
    <script src="resources/js/bootstrapValidator.js"></script>
    <script src="resources/js/bootstrap-formhelpers.min.js"></script>
    <script src="resources/js/highcharts.js"></script>
	<script src="resources/js/data.js"></script>
	<script src="resources/js/exporting.js"></script>
	<script src="http://code.highcharts.com/highcharts-more.js"></script>
	<script src="http://code.highcharts.com/modules/solid-gauge.js"></script>
	
    <script>
	    $(function () {
	    $('#graph1').highcharts({
	        data: {
	            table: document.getElementById('datatable1')
	        },
	        chart: {
	            type: 'pie'
	        },
	        title: {
	            text: 'Category Wise Product Sale (Jan,2015)'
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'Units'
	            }
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                dataLabels: {
	                    enabled: true
	                },
	                showInLegend: false
	            }
	        },
	        tooltip: {
	            formatter: function () {
	                return this.point.name+': <b>'+this.point.y+'%</b>'; 
	            }
	        }
	    });
	    
	    $('#graph2').highcharts({
	        data: {
	            table: document.getElementById('datatable2')
	        },
	        chart: {
	            type: 'column'
	        },
	        title: {
	            text: 'Category Wise Product Sale'
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'Units'
	            }
	        },
	        tooltip: {
	        	headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	                '<td style="padding:0"><b>{point.y:.1f} units</b></td></tr>',
	            footerFormat: '</table>',
	            shared: true,
	            useHTML: true
	            /*formatter: function () {
	                return this.point.name+': <b>'+this.point.y+'%</b>'; 
	            }*/
	        }
	    });
	    $('#graph4').highcharts({
	        data: {
	            table: document.getElementById('datatable4')
	        },
	        chart: {
	            type: 'pie'
	        },
	        title: {
	            text: 'Category Wise (Jan-Dec 2014)'
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'Units'
	            }
	        },
	        plotOptions: {
	            pie: {
	                allowPointSelect: true,
	                cursor: 'pointer',
	                dataLabels: {
	                    enabled: true
	                },
	                showInLegend: false
	            }
	        },
	        tooltip: {
	            formatter: function () {
	                return this.point.name+': <b>'+this.point.y+'%</b>'; 
	            }
	        }
	    });
	    
	    $('#graph3').highcharts({
	        data: {
	            table: document.getElementById('datatable3')
	        },
	        chart: {
	            type: 'line'
	        },
	        title: {
	            text: 'Overall Purchase'
	        },
	        yAxis: {
	            allowDecimals: false,
	            title: {
	                text: 'Amount (in Rupees)'
	            }
	        },
	        plotOptions: {
	            line: {
	                dataLabels: {
	                    enabled: true
	                },
	                enableMouseTracking: false
	            }
	        }
	    });
	    var gaugeOptions = {

	            chart: {
	                type: 'solidgauge'
	            },

	            title: null,

	            pane: {
	                center: ['50%', '85%'],
	                size: '130%',
	                startAngle: -90,
	                endAngle: 90,
	                background: {
	                    backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
	                    innerRadius: '60%',
	                    outerRadius: '100%',
	                    shape: 'arc'
	                }
	            },

	            tooltip: {
	                enabled: false
	            },

	            // the value axis
	            yAxis: {
	                stops: [
	                    [0.1, '#DF5353'], // red
	                    [0.5, '#DDDF0D'], // yellow
	                    [0.9, '#55BF3B'] // green
	                ],
	                lineWidth: 0,
	                minorTickInterval: null,
	                tickPixelInterval: 400,
	                tickWidth: 0,
	                title: {
	                    y: -70
	                },
	                labels: {
	                    y: 16
	                }
	            },

	            plotOptions: {
	                solidgauge: {
	                    dataLabels: {
	                        y: 5,
	                        borderWidth: 0,
	                        useHTML: true
	                    }
	                }
	            }
	        };

	        // The speed gauge
	        $('#target').highcharts(Highcharts.merge(gaugeOptions, {
	            yAxis: {
	                min: 0,
	                max: 100,//set target
	                title: {
	                    text: 'Target'
	                }
	            },

	            credits: {
	                enabled: false
	            },

	            series: [{
	                name: 'Purchase',
	                data: [30],
	                dataLabels: {
	                    format: '<div style="text-align:center"><span style="font-size:20px;color:' +
	                        ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}%</span><br/>' +
	                           '<span style="font-size:12px;color:silver">Jan,2014</span><br/><a href="#">details</a></div>'
	                },
	                tooltip: {
	                    valueSuffix: ' %'
	                }
	            }]

	        }));

	});
	
	document.getElementById("datatable1").style.display="none";
	document.getElementById("datatable2").style.display="none";
	document.getElementById("datatable3").style.display="none";
	document.getElementById("datatable4").style.display="none";
    </script>
  </body>
</html>
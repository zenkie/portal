var shopOverview;
var shopOverviewControl = Class.create();

shopOverviewControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "shopOverviewInteface", this._onsend_message, this);//为回调方法起个名字
	},
	
	shopOverview : function () {
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="shopOverviewInteface";
		evt.param="";
		evt.table="WX_ORDER"
		evt.action="GETORDER"
		evt.permission="r";
		this._executeCommandEvent(evt);
	 },
	 
	 _executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为返回的数据 自己函数构建json
			var result= r.evalJSON();
            if (result.code !=0 ){
				//错误返回
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
		}
	  );
	},
	 
	_onsend_message : function (e) {//成功回调函数
		var data=e.getUserData();
		//console.log(data);
		for(var i in data){
			var jsondata=eval('('+data[i]+')');
			jQuery("#issales").text(jsondata["salecount"]);
			jQuery("#yescount").text(jsondata["yescount"]);
			jQuery("#yestotamt").text(jsondata["yestotamt"]);
			jQuery("#ispaying").text(jsondata["ispaying"]);			
		}
		
	},
};

var shopOrderView;
var shopOrderViewControl = Class.create();
shopOrderViewControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "shopOrderViewInteface", this._onsend_message, this);//为回调方法起个名字
	},
	
	shopOrderView : function () {
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="shopOrderViewInteface";
		evt.param={"days":7};
		evt.table="WX_ORDER"
		evt.action="GETORDERAMT"
		evt.permission="r";
		this._executeCommandEvent(evt);
	 },
	 
	 _executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为返回的数据 自己函数构建json
			var result= r.evalJSON();
            if (result.code !=0 ){
				//错误返回
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
		}
	  );
	},
	 
	_onsend_message : function (e) {//成功回调函数
		var data=e.getUserData();
		for(var i in data){				
			var weekchartdata=eval('('+data[i]+')');
			//console.log(weekchartdata);
			//alert("11");
			jQuery("#order_amt").text(weekchartdata["order_amt"]);
			jQuery("#deal_amt").text(weekchartdata["deal_amt"]);
			jQuery("#backorder_amt").text(weekchartdata["backorder_amt"]);
			jQuery("#TOT_AMT_PRICELIST").text(weekchartdata["TOT_AMT_PRICELIST"]);
			jQuery("#TOT_AMT_ACTUAL").text(weekchartdata["TOT_AMT_ACTUAL"]);
			jQuery("#TOT_AMT_BACK").text(weekchartdata["TOT_AMT_BACK"]);
			//图表的载入			
			var now = new Date(weekchartdata.systime);
			//alert(now);			
			chart=new Highcharts.Chart({
				chart:{
					renderTo:'container'
				},
				title: {
					text: '',
					x: -20 //center
				},
				subtitle: {
					text: '',
					x: -20
				},
				xAxis: {
					type:'datetime',
					labels: {  
					formatter: function() {  
						return  Highcharts.dateFormat('%m月%d日', this.value);  
					   }					 			
                    },
					tickPixelInterval: 100
				},
				credits: {          
					enabled:false
				}, 
				yAxis: {
					title: {
						text: '订单数据 (个)'
					},
					min:0,
					plotLines: [{
						value: 0,
						width: 1,
						color: '#808080'
					}]
				},
				tooltip: {
					valueSuffix: '个',
					xDateFormat: '%Y-%m-%d'//鼠标移动到趋势线上时显示的日期格式 
				},
				legend: {
					layout: 'horizontal',
					align: 'center',
					verticalAlign: 'bottom',
					borderWidth: 0,
					labelFormatter:function(){return"<strong>"+this.name+'</strong><span style="color:#BBB">(点击隐藏)</span>'}
				},
				series: [{
					name: '下单数',
					data: weekchartdata.order_amtlist,
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000 // 间隔1小时
				},{
					name: '成交数',
					data: weekchartdata.deal_amtlist,
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000 // 间隔1小时
				},{
					name: '退单数',
					data: weekchartdata.backorder_amtlist,
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000 // 间隔1小时
				}]
			});
			
			var chart2=new Highcharts.Chart({
				
				chart: {
					renderTo:'container2',
					zoomType: 'xy'
					
				},
				title: {
					text: ''
				},
				credits: {          
					enabled:false
				},
				subtitle: {
					text: ''
				},
				xAxis: [{
					type:'datetime',
					labels: {  
					formatter: function() {  
						return  Highcharts.dateFormat('%m/%d', this.value);  
					   }					 			
                    },
					tickPixelInterval: 70
				}],
				yAxis: [{ // Primary yAxis		
					tickPixelInterval: 50,
					labels: {
						formatter: function() {
							return this.value +' 元';
						},
						style: {
							color: '#89A54E'
						}
					},
					min:0,
					title: {
						text: '成交额',
						style: {
							color: '#89A54E'
						}
					},
					opposite: true
					}, { // Secondary yAxis
						gridLineWidth: 0,
						min:0,
						title: {
							text: '下单数',
							style: {
								color: '#4572A7'
							}
						},
						labels: {
							formatter: function() {
								return this.value +' 个';
							},
							style: {
								color: '#4572A7'
							}
					}

					}, { // Tertiary yAxis
						gridLineWidth: 0,
						min:0,
						title: {
							text: '退款额',
							style: {
								color: '#AA4643'
							}
						},
					labels: {
						formatter: function() {
							return this.value +' 元';
						},
						style: {
							color: '#AA4643'
						}
					},
					opposite: true
				}],
				tooltip: {
					shared: true,
					xDateFormat: '%Y-%m-%d'//鼠标移动到趋势线上时显示的日期格式 
				},
				legend: {
					layout: 'horizontal',
					align: 'center',
					//x: 100,
					verticalAlign: 'bottom',
					//y: 150,
					//floating: false,
					backgroundColor: '#FFFFFF'
				},
				series: [{
					name: '下单数',
					color: '#4572A7',
					type: 'column',
					yAxis: 1,
					data: weekchartdata.order_amtlist,
					//data:[23,54,33,62,22,85],
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000, // 间隔1小时
					tooltip: {
						valueSuffix: '个'
					}

				}, {
					name: '成交额',
					color: '#89A54E',
					type: 'spline',
					data: weekchartdata.TOT_AMT_ACTUALLIST,
					//data:[10,34,45,67,33,77],
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000, // 间隔1小时
					tooltip: {
						valueSuffix: '元'
					}
				}, {
					name: '退款额',
					type: 'spline',
					color: '#AA4643',
					yAxis: 2,
					data: weekchartdata.TOT_AMT_BACKLIST,
					//data:[32,34,53,56,23,66,34],
					pointStart: Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()-7),
					pointInterval: 24*3600 * 1000, // 间隔1小时
					
					tooltip: {
						valueSuffix: '元'
					}

				}]
			});
		}
	},
	
};

shopOrderViewControl.main = function () {
	shopOverview=new shopOverviewControl();	
	shopOverview.shopOverview();
	
	shopOrderView=new shopOrderViewControl();	
	shopOrderView.shopOrderView();
	
};

jQuery(document).ready(shopOrderViewControl.main);

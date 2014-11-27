var minmenu;
var minmenuControl = Class.create();

minmenuControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "minmenuInteface", this._onsend_message, this);//为回调方法起个名字
	},
	
	minmenu : function () {
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="minmenuInteface";
		evt.param="";
		evt.table="WX_ISSUEARTICLE"
		evt.action="GETSUM"
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
			var menusum=eval('('+data[i]+')');	
			jQuery("#articleamt").text(menusum["articleamt"]);
			jQuery("#articlegroyamt").text(menusum["articlegroyamt"]);
			jQuery("#menuappsec").text(menusum["menuappsec"]);
			jQuery("#menucname").text(menusum["menucname"]);
			jQuery("#menu_amt").text(menusum["menu_amt"]);
			jQuery("#book_amt").text(menusum["book_amt"]);
			var menupublictype=menusum["menupublictype"];
			if(menupublictype == '1'){
				jQuery("#menupublictype").text('订阅号');
			}else if(menupublictype == '2'){
				jQuery("#menupublictype").text('服务号');
			}else if(menupublictype == '3'){
				jQuery("#menupublictype").text('认证订阅号');
			}else if(menupublictype == '4'){
				jQuery("#menupublictype").text('认证服务号');
			}
			
			var c='{';
			var hh=menusum.book_clob;
			var d='}';
			var bookres=c+hh+d;
			var jsdata=eval('('+bookres+')');
			var arr=[];
			for (var key in jsdata) {
				arr.push({"key":key,"value":jsdata[key]});
			}
			arr.sort(function compare(a,b){return b.value-a.value});
			var key1=new Array();
			var value1=new Array();
			for(var i=0;i<arr.length;i++){
				key1[i]=arr[i].key;
				value1[i]=arr[i].value;
			}
			if(value1.length == '0' || key1.length == '0'){
				key1[0] = '文章';
				value1[0] = 0;
			}
				var chart1=new Highcharts.Chart({                                           
				chart: {   
					renderTo:'container',		
					type: 'bar'                                                    
				},                                                                 
				title: {                                                           
					text: ''                    
				},                                                                
				xAxis: {                                                           
					categories: key1,
					title: {                                                       
						text: null                                                 
					}                                                              
				},                                                                 
				yAxis: {                                                           
					min: 0,                                                        
					title: {                                                       
					text: '次',                             
					align: 'high'                                              
				},                                                             
				labels: {                                                      
					overflow: 'justify'                                        
					}                                                              
				},                                                                 
				tooltip: {                                                         
					valueSuffix: ' 次'                                       
				},                                                                 
				plotOptions: {                                                     
					bar: {                                                         
						dataLabels: {                                              
							enabled: true                                          
						}                                                          
					}                                                              
				},                                                                 
				legend: {                                                          
					enabled: false                                                 
				},                                                                 
				credits: {                                                         
					enabled: false                                                 
				},                                                                 
				series: [{                                                        
					name: '文章浏览次数',                                             
					data:  value1                               
				}]                                                                 
			});	
			
			var a='{';
			var ss=menusum.result_clob;
			var b='}';
			var res=a+ss+b;
			var jdata=eval('('+res+')');
			var key=new Array();
			var value=new Array();
			var i=0;
			for(var j in jdata){
				key[i]=j;
				value[i]=jdata[j];
				i++;
			}
			if(value.length == '0' || key.length == '0'){
				key[0] = '文章所属分类';
				value[0] = 0;
			}			
			var chart2=new Highcharts.Chart({
				chart: {
					renderTo:'container2',
					plotBackgroundColor: null,
					plotBorderWidth: null,
					plotShadow: false,
					events:{
						load:function(){							
							var series = this.series[0];  
							var temp = [];  
							for(var i=0;i<key.length;i++){
								temp.push([""+key[i]+"",value[i]]); 
							}								
							series.setData(temp);  
						}
					}
				},
				title: {
					text: ''
				},
				credits: {          
					enabled:false
				},
				tooltip: {
					pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
				},
				plotOptions: {
					pie: {
						size:'60%',
						allowPointSelect: true,
						cursor: 'pointer',
						dataLabels: {
							enabled: true,
							color: '#000000',
							distance: 11,
							connectorColor: '#000000',
							//format: '<b>{point.name}</b>: {point.percentage:.1f} %'
						}
					}
				},
				series: [{
					type: 'pie',
					name: '浏览比重',
					data: []
				}]
			});
		}
		
	},
};

minmenuControl.main = function () {
	minmenu=new minmenuControl();	
	minmenu.minmenu();	
};

jQuery(document).ready(minmenuControl.main);
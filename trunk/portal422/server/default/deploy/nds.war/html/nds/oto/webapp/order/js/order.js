/*
*订单操作
*/
(function(window){
	function Order(config){
		/*this.oct = jQuery.extend({
			orderId: 0,//订单ID
			ad_client_id: 37,//公司编号
			orderCode: "",//订单编号
			shipmentFree: 0,//动费
			totalFree: 0,//应付金额=商品金额+动费
			productFree: 0,//商品金额
			orderItem: [],//订单明细
			ip: ""
		},config);*/
		this.oct = config;
		this.init();
	}
	
	Order.prototype = {
		init: function(){
			var that = this;
			//当商品详情多余3个时候隐藏
			jQuery("#page_order .order_detail:gt(2)").hide();
			jQuery("#page_order .order_detail").length>3 && jQuery("#order_more").show();
			
			that.bindEvent();
			that.getOrderAddr();//获取默认地址
		},
		
		bindEvent: function(){
			var that = this,oct = that.oct;
			//当商品详情操作
			jQuery("#order_morea,#order_mpic").unbind().bind("click",function(){
				if(jQuery("#order_mpic img").hasClass("order_picflip")){
					jQuery("#order_mpic img").removeClass("order_picflip");
					$("#order_morea").html("点击加载更多");
					jQuery("#page_order .order_detail:gt(2)").slideUp();
				}else{
					jQuery("#order_mpic img").addClass("order_picflip");
					jQuery("#order_morea").html("点击收起");
					jQuery("#page_order .order_detail:gt(2)").slideDown();
				}
			});
			
			jQuery("#addressDefault").unbind().bind("click",function(){
				location.href = "/html/nds/oto/webapp/address/index.vml?type=pagePay"
			});
			
			//取消订单
			jQuery(".order_cancel").unbind().bind("click",function(){
				dialog.alert({
					content:"是否确定要取消订单？",
					sureFn:function(){
						var _command = "ExecuteWebAction";
						var _params = {
							"webaction": "wx_order_cancel",
							"id": oct.orderId
						}
						that.submitData(_command,_params,function(){
							dialog.tips("取消订单成功！");
							setTimeout(function () {
								location.href = '/html/nds/oto/webapp/order/index_more.vml?vipid='+oct.vipid+'&docno='+oct.orderCode;
							},500);
						});
					}
				});
			});
			
			jQuery("#submit-order").unbind().bind("click",function(){
				if(!that.checkForm()){
					return false;
				}
				dialog.loading(true);
				var _command = "ObjectModify";
				var _params = {
					"ID": oct.orderId,
					"table": "WX_ORDER",
					"unionfk": true,
					"partial_update": true,					
					"LOGISTICS_FREE":oct.shipmentFree,
					"PAYMENT__NAME": jQuery("#select_pay").val(),
					"REMARKS": jQuery("#orderRemarks").val(),
					"WX_ADDRESS_ID__ADDRESS": jQuery("#addressDefault").attr("addId")?jQuery("#addressDefault").attr("addId"):"",
					"WX_COUPONEMPLOY_ID":"",
					"YNCOUPON":"N"
				}
				that.submitData(_command,_params,function(data){
					that.callpay();
				});			
			});
		},
		
		changeLogistics: function(){
			var that = this,oct = that.oct;
			var address =  $("#addressDefault");
			if(address.hasClass("address_null")){
				dialog.tips("请新增收货地址！");
				return false;
			}
			var _command = "ExecuteWebAction";
			var _params = {
				"webaction": "wx_logistics_free",
				"id": 0,
				"query": {
					"addressid": address.attr("addId"),
					"companyid": oct.ad_client_id
				}
			};
			that.submitData(_command,_params,function(data){//计算运费
				var free=parseFloat(data[0].result_data.message);
				oct.shipmentFree = free;
				oct.totalFree = oct.productFree+free;
				jQuery(".order_ship").html("运费：¥"+free);
				jQuery(".order_totprice").html("¥"+oct.totalFree);
				jQuery("input[name=WIDtotal_fee]").val(oct.totalFree)
			});
		},
		
		callpay: function(){
			var that = this,oct = that.oct;
			var paycode = jQuery("#select_pay option:selected").attr("code");//支付代码
			if(paycode && /alipay/.test(paycode)){
				if(oct.totalFree == 0){
					zeropay();
				}else{
					//jQuery("#alipayment").submit();
					document.forms.alipayment.submit();
				}
			}else if(paycode&&/weixin/.test(paycode)){
				try{
					var ua = navigator.userAgent;
					if(/MicroMessenger\/\s*\d+/i.test(ua)){
						var verison = /MicroMessenger\/\s*\d+/i.exec(ua);
						if(verison) verison=verison[0];
						if(!verison){
							dialog.tips("请用微信支付！",1500);
							return;
						}
						verison=verison.replace(/MicroMessenger\/\s*\d+/i,"");
						if(isNaN(verison)){
							dialog.tips("请用微信支付！",1500);
							return;
						}
						verison=parseInt(verison);
						if(verison<5){
							dialog.tips("微信版本大于等于5才支付微支付！",1500);
							return;
						}
					}else{
						dialog.tips("请在微信中支付！",1500);
						return;
					}
				}catch(e){
					dialog.tips("请用微信中支付！",1500);
					return;
				}
				weixinpay(oct);
			}else{
				dialog.tips("暂时只支付支付宝支付！",1500);
				return false;
			}
			
			//当金额为零时，支付方式
			function zeropay(oct){
				var _command = "ExecuteWebAction";
				var _params = {
					"webaction": "wx_order_destocke",
					"id": oct.orderId,
					"query": {
						"orderno": oct.orderCode
					}
				}
				that.submitData(_command,_params,function(){
					dialog.tips("订单支付成功！");
					setTimeout(function () {
						location.reload();
					},1000);
				});
			}
			//微信支付
			function weixinpay(oct){
				//判断IP是否为空
				if(!oct.ip){
					dialog.tips("IP异常！",1500);
					return false;
				}
				var _command = "ExecuteWebAction";
				var _params = {
					"nds.control.ejb.UserTransaction": "N",
					"webaction": "wx_weixinpaysign",
					"id": oct.orderId,
					"query": {
						"ip": oct.ip,
						"ad_client_id": oct.ad_client_id,
						"orderid": oct.orderId
					}
				};
				that.submitData(_command,_params,function(data){
					wxs.orderinfo = data[0].result_data.message;
					wxs.weixinpay();
				})
			}
		},
		
		checkForm: function(){
			var that = this,oct = that.oct;
			var buys=parseInt(oct.buyQty);
			if(!buys||!/^\d+$/.test(buys)){
				dialog.tips("购买数量只能为大于0的整数");
				return false;
			}
			var address =  $("#addressDefault");
			if(address.hasClass("address_null")){
				dialog.tips("请新增收货地址！");
				return false;
			}
			var pay = jQuery("#select_pay").val();
			if(pay == -1 || pay == undefined){
				dialog.tips("请选择支付方式！");
				return false;
			}
			return true;
		},
		
		//获取默认地址
		getOrderAddr: function(){
			var that = this,oct = that.oct;
			dialog.loading(true);
			var _command = "Query";
			var _params = {
				"columns": ["id","province","city","regionId","address","name","phonenum",],
				"params": {
					"column": "id",
					"condition": oct.orderId
				},
				"table": "wx_order"
			};
			that.submitData(_command,_params,function(data){
				var defAddress = data[0].rows[0];
				if(defAddress[1] != null){
					//当订单有地址进行操作					
					showOrderAddress(defAddress);
					that.changeLogistics();
				}else{
					//如果没有地址，获取收货地址的默认值
					that.getDefAddr();
				}
			});
			
			function showOrderAddress(defAddress){
				var address = {
						"id":defAddress[0],
						"province":defAddress[1],
						"city":defAddress[2],
						"regionId":defAddress[3],
						"address":defAddress[4],
						"name":defAddress[5],
						"phonenum":defAddress[6]
					};
				jQuery("#addressDefault").removeClass(".address_null1");
				jQuery("#addressDefault").find(".address").html(address.address);
				jQuery("#addressDefault").find(".userinfo").html("<strong>"+address.name+"</strong> "+address.phonenum);
				jQuery("#addressDefault").find("ul").addClass("icon_hide");
				jQuery("#addressDefault").unbind();
			};
		},
		
		//获取收货地址的默认值
		getDefAddr: function(){
			var that = this,oct = that.oct;
			dialog.loading(true);
			var _command = "Query";
			var _params = {
				"columns": ["id","ad_client_id","province","city","regionId","address","wx_vip_id","name","phonenum","isaddress"],
				"params": {
					"expr1": {
						"expr1": {
							"condition": oct.vipid,
							"column": "wx_vip_id"
						},
						"expr2": {
							"condition": 2,
							"column": "isaddress"
						},
						"combine": "and"
					},
					"expr2": {
						"condition": oct.ad_client_id,
						"column": "ad_client_id"
					},
					"combine": "and"
				},
				"table": "wx_address"
			};
			that.submitData(_command,_params,function(data){
				if(data[0].rows.length != 0){
					var defAddress = data[0].rows[0];
					showDefAddress(defAddress);
					that.changeLogistics();
				}else{
					jQuery("#addressDefault").addClass(".address_null");
				}
			});
			
			function showDefAddress(defAddress){
				var address = {
					"id":defAddress[0],
					"ad_client_id":defAddress[1],
					"province":defAddress[2],
					"city":defAddress[3],
					"regionId":defAddress[4],
					"address":defAddress[5],
					"wx_vip_id":defAddress[6],
					"name":defAddress[7],
					"phonenum":defAddress[8],
					"isaddress":defAddress[9]
				};
				jQuery("#addressDefault").removeClass(".address_null1");
				jQuery("#addressDefault").attr("addId",address.id);
				jQuery("#addressDefault").find(".address").html(address.address);
				jQuery("#addressDefault").find(".userinfo").html("<strong>"+address.name+"</strong> "+address.phonenum);
			}
		},
		
		//数据提交接口
		submitData: function(_command,_params,_success){
			jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				dataType: 'json',
				data:{command:_command,params:JSON.stringify(_params)},//将json对象转换成字符串
				success: function (data) {
					dialog.loading(false);
					if(data[0].code == 0){
						_success && _success(data);
					}else{
						dialog.tips(data[0].message);
					}
				},
				error: function () {
					alert("网络出现问题，请检查网络链接！");
				}
			});
		}
	}
	window.Order = Order;
}(window));


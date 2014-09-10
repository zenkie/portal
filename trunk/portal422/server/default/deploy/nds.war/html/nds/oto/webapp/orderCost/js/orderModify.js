function commitOrder(){
	var buys=parseInt($("#buy_qty").attr("qty"));
	if(!buys||!/^\d+$/.test(buys)){
		showBubble("购买数量只能为大于0的整数");
		return;
	}
	var para=Object;
	para.remarks=$("#orderRemarks").val();
    para.orderid=$("#orderid").val();
	para.integral=$("#all_total-price").html();
	para.addressid = $("#allAddress .default").attr("id").replace("toAddrList_","");
	if(!para.addressid){
		showBubble("请新增收货地址！");
		return false;
	}
	
	//orderModify(para,link_param);
	oct.callpay(para);
}


function orderModify(para,link_param){
	var _params ="{\"table\":15942,\"unionfk\":true,\"partial_update\":true,\"ID\":"+para.orderid+",\"PAYMENT__NAME\":\""+para.pay+"\",\"WX_ADDRESS_ID__ADDRESS\":\""+para.address+"\",\"LOGISTICS_FREE\":"+oct.shipmentFree+""+link_param+"}";
	$.ajax({
        url: '/html/nds/schema/restajax.jsp',
        type: 'post',
		async: false,
        data:{command:"ObjectModify",params:_params},
		success: function (data) {		
			var _data = eval("("+data+")");
            if (_data[0].code == 0) {
				$("#cou1").val("100");
				oct.callpay();
			} else {
				showConfirm({
					describeText:"提交订单失败，请稍候再试",
					sureText: "重试",
					cancelText: "取消",
					sureFn: function () {
						orderModify()
					}
				});	
			}
        }
    });
}

var oct;
var ordercontroll=function(){};
ordercontroll.prototype.initialize=function(){
	this.orderId=0;				//订单ID
	this.cardno=""				//线下会员号
	this.orderCode="";			//订单编号
	this.shipmentFree=0;		//动费
	this.totalFree=0;			//应付金额=商品金额+动费
	this.adjustFree=0;			//调整金额
	this.productFree=0;			//商品金额	
	this.orderItem=[];			//订单明细
	this.adClientId=0;			//公司编号
	this.allIntegral=0;			//会员所有积分
};
ordercontroll.prototype.changeLogistics=function(){
	var addresses=$("#allAddress>li[class*=default]");
	if(!addresses||addresses.size()<=0){
		showBubble("请新增收货地址！");
		return false;
	}
	var addressId=addresses.attr("id").replace("toAddrList_","");
	if(!addressId){
		showBubble("请新增收货地址！");
		return false;
	}	
	if(addressId&&!isNaN(addressId)){addressId=parseInt(addressId);}	
	var _params = "{\"webaction\":\"wx_logistics_free\",\"id\":0,\"query\":{\"addressid\":"+addressId+"}}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		async: true,
		success: function (data) {
			try{
				var mess =eval("("+data+")")[0];
				var free=parseFloat(mess.result_data.message);
				oct.shipmentFree=free;
				oct.totalFree=Math.round((oct.shipmentFree+oct.productFree)*100)/100;
				//优惠劵
				var coupon = $("#couponId");
				if(coupon.length==0 || coupon.val()==-1){
					$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费");
					$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
					$("#WIDtotal_fee").val(oct.totalFree);
				}else{
					$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费"+"&nbsp;-&nbsp;￥"+$(".couponDefault").attr("data-money")+"&nbsp;优惠劵");
					var fee = oct.shipmentFree + oct.productFree;
					if($(".couponDefault").attr("data-money") >= fee){
						$("#all_total-price").html("¥0");
						$("#WIDtotal_fee").val("0");
						oct.totalFree=0;
					}else{
						oct.totalFree-=Math.round(parseFloat($(".couponDefault").attr("data-money"))*100)/100;
						oct.totalFree=Math.round(oct.totalFree*100)/100;
						$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
						$("#WIDtotal_fee").val(oct.totalFree);	
					}	
							
				}								
			}catch(e){
			}
		},
		error:function(data){		
		}
	});
};

ordercontroll.prototype.callpay=function(param){
	//判断积分是否足够
	var productIntegral=parseInt(param.integral);
	if(oct.allIntegral<productIntegral){
		showBubble("积分不够,不能兑换！");
		return;
	}
	//var _params = "{\"webaction\":\"wx_order_payintegral\",\"id\":0,\"query\":{\"orderno\":\""+oct.orderCode+"\",\"integral\":"+param.integral+",\"addressid\":"+param.addressid+"}}";
	var _params = "{\"method\":\"integralExchange\",\"webaction\":\"wx_order_payintegral\",\"id\":0,\"query\":{\"docno\":\""+oct.orderCode+"\",\"cardno\":\""+oct.cardno+"\",\"ad_client_id\":"+oct.adClientId+",\"availableintegral\":"+0+",\"integral\":"+param.integral+",\"remarks\":\""+param.remarks+"\",\"addressid\":"+param.addressid+"}}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		async: true,
		success: function (data) {
			var _data = eval("("+data+")");
            if (_data[0].code == 0) {
				if (_data[0].result_data.code==0){
					showBubble("兑换成功！");
					setTimeout(function () {
						location.reload();
					},1000)
				}else{
					showBubble(_data[0].result_data.message);
				}
			}else{
				showBubble("兑换失败！");
			}
		}
	});
};
ordercontroll.prototype.zeropay=function(){
	var _params = "{\"webaction\":\"wx_order_destocke\",\"id\":"+oct.orderId+",\"query\":{\"orderno\":\""+oct.orderCode+"\"}}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		success: function (data) {		
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				showBubble("订单支付成功！");
				setTimeout(function () {
					location.reload();
				},1000)
			}else if(_data[0].message){
				showBubble(_data[0].message);
			}else{
				showBubble("支付失败");
			}
		}
	});
};

ordercontroll.prototype.formatNumber=function(number){
	var n=number;
	if(number||number==0||number=="0"){
		try{number=parseFloat(n).toFixed(2);}
		catch(e){}
		n=number.toString().replace(/(?=(?:\d{3})+(?!\d))/g,",");
		n=n.replace(/^,|,$/g,"");
	}
	return n;
};	
ordercontroll.main=function(){
	oct=new ordercontroll();
	oct.initialize();
}
$(document).ready(ordercontroll.main);

function canleOrder(orderid) {
	showConfirm({
		describeText:"是否确定要取消订单？",
		sureText: "确定",
		cancelText: "取消",
		sureFn: function () {
			cancleOrder_sure(orderid);
		}
	});	
}

function cancleOrder_sure(orderid){
	var _params = "{\"webaction\":\"wx_order_cancel\",\"id\":"+orderid+"}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		success: function (data) {		
		var _data = eval("("+data+")");
		if (_data[0].code == 0) {
			showBubble("取消订单成功！");
			setTimeout(function () {
				location.href = '/html/nds/oto/webapp/usercenterMall/index.vml';
			},500)
			}
		}
	});
}

function confirmReceipt(evt) {
	var orderid=evt;
	var _params = "{\"webaction\":\"wx_order_accept\",\"id\":"+orderid+"}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		success: function (data) {		
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				showBubble("确认收货成功！");
				setTimeout(function () {
					location.reload();
				},500)
			}else{
				alert(data);
			}
		}
	});
}

function showBubble(a, b) {
        if (a) {
            b = b || 1000;
            var c = $("#bubble");
            c.stop().css("opacity", 1), c.hasClass("qb_none") || c.html(a), c.html(a).removeClass("qb_none"), setTimeout(function () {
                c.animate({
                    opacity: 0
                }, 1000, "swing", function () {
                   $(this).addClass("qb_none").removeAttr("style");
                })
            }, b)
        }
}

function showConfirm(b){
		 var a = {
            sureNode: $("#notice-sure"),
            cancelNode: $("#notice-cancel"),
            contentNode: $("#notice-content"),
            dialogNode: $("#message-notice")
        };
       
		function c() {
			f.sureFn.call(this, arguments), e()
		}
		function d() {
			f.cancelFn.call(this, arguments), e()
		}
		function e() {
			a.contentNode.empty(), a.sureNode.html("确定").off("click", c), a.cancelNode.html("取消").off("click", d), a.dialogNode.addClass("qb_none")
		}
		var f = {
			describeText: "",
			sureText: "确定",
			cancelText: "取消",
			showNum: 2,
			sureFn: function () {
				return !0
			},
			cancelFn: function () {
				return !0
			}
		};
		$.extend(f, b), a.dialogNode.hasClass("qb_none") && (a.dialogNode.removeClass("qb_none"), a.sureNode.on("click", c), a.cancelNode.on("click", d), 1 == f.showNum && a.cancelNode.addClass("qb_none"), a.sureNode.html(f.sureText), a.cancelNode.html(f.cancelText), a.contentNode.html(f.describeText))       
}
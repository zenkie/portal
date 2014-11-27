var wbs=null;
var weixinbesweptjs=Class.create();

weixinbesweptjs.prototype={
	initialize: function() {
		this.count=0;//burgeonnebula1001043618621583921
		this.orderinfo={"key":"6uPRLPtgBX7Pa3T5NNHp2FjHSNkVl4W9","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","out_trade_no":"2324124123421341241werr","attach":"attach","body":"beswept","goods_tag":"goods_tag","total_fee":"1","ip":"172.18.34.88","certificatepath":"D:/NEWBOSoto/act.nea/conf/weixinbesweptapiclient_cert.p12","psd":"10010436","out_refund_no":"refund2324124123421341241werr","refund_fee":1,"op_user_id":"10010436"};
		application.addEventListener("CREATE_WEIXINBESWEPTORDER", this._onCreateWeixinBesweptOrder, this);	
		application.addEventListener("QUERY_WEIXINBESWEPTORDER", this._onQueryWeixinBesweptOrder, this);
		application.addEventListener("REVERSE_WEIXINBESWEPTORDER", this._onReverseWeixinBesweptOrder, this);
		application.addEventListener("REFUND_WEIXINBESWEPTORDER", this._onRefundWeixinBesweptOrder, this);
		application.addEventListener("QUERYREFUND_WEIXINBESWEPTORDER", this._onQueryRefundWeixinBesweptOrder, this);
		application.addEventListener("CREATE_WEIXINNATIVEORDER", this._onCreateWeixinNativeOrder, this);
	},
	
	//参数说明
	/*
	appid 		是	String(32) 	微信分配的公众账号ID
	mch_id 		是	String(32) 	微信支付分配的商户号
	sub_mch_id	是	String(32)	微信支付分配的子商户号
	device_info 否	String(32) 	终端设备号(商户自定义)
	body 		是	String(127) 商品描述
	attach 		否	String(127) 附加数据，原样返回
	out_trade_no 是	String(32) 	商户系统内部的订单号,32 个字符内、可包含字母, 确保在商户系统唯一
	total_fee 	是	Int 		订单总金额，单位为分，只能整数
	ip 			是	String(16) 订单生成的机器IP
	time_start 	否	String(14) 	订单生成时间， 格式为yyyyMMddHHmmss，如2009年12 月25 日9 点10 分10 秒表示为20091225091010。时区为GMT+8 beijing。该时间取自商户服务器
	time_expire 否	String(14) 	订单失效时间，交易结束时间 格式为yyyyMMddHHmmss，如2009年12 月27 日9 点10 分10 秒表示为20091227091010。时区为GMT+8 beijing。该时间取自商户服务器
	goods_tag 	否	String(32) 	商品标记，微信平台配置的商品标记，用于优惠券或者满减使用，使用说明详见第3 节
	*/
	
	createNativeOrder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinNativePayCommand";
		evt.callbackEvent="CREATE_WEIXINNATIVEORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"body":wbs.orderinfo.body,"attach":wbs.orderinfo.attach,"goods_tag":wbs.orderinfo.goods_tag,"total_fee":wbs.orderinfo.total_fee,"spbill_create_ip":wbs.orderinfo.ip,"time_start":wbs.orderinfo.time_start,"time_expire":wbs.orderinfo.time_expire,"product_id":"234214fwfs2rrw3r2wf","trade_type":"NATIVE","notify_url":"demo.syman.cn//servlets/binserv/nds.weixin.wxt.foreign.RestWeixinPayCallback"};
		evt.params=Object.toJSON(param);
		evt.method="createorder";
		
		this._executeCommandEvent(evt);
	},
	
	_onCreateWeixinNativeOrder:function(e){
		
	},
	
	//微信被扫下单
	createweixinbesweptorder:function(){
		var autocode=jQuery("#authorization").val().trim();
		if(!autocode){
			alert("授权码不能为空");
			return;
		}
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="CREATE_WEIXINBESWEPTORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"body":wbs.orderinfo.body,"attach":wbs.orderinfo.attach,"goods_tag":wbs.orderinfo.goods_tag,"total_fee":wbs.orderinfo.total_fee,"ip":wbs.orderinfo.ip,"time_start":wbs.orderinfo.time_start,"time_expire":wbs.orderinfo.time_expire,"auth_code":autocode};
		evt.params=Object.toJSON(param);
		evt.method="createorder";
		
		this._executeCommandEvent(evt);
	},
	_onCreateWeixinBesweptOrder:function(e){
		var data=e.getUserData();
		//5秒后第1次查询订单
		window.setTimeout("wbs.querybesweptorder()",5000);
	},
	
	querybesweptorder:function(){
		wbs.queryweixinbesweptorder();
		//设置撤销订单按钮可用
		jQuery("#reverseorder").removeAttr("disabled");
	},
	
	//参数说明
	/*
	appid 		是	String(32) 	微信分配的公众账号ID
	mch_id 		是	String(32) 	微信支付分配的商户号
	sub_mch_id	是	String(32)	微信支付分配的子商户号
	device_info 否	String(32) 	终端设备号(商户自定义)
	transaction_id 	否	String(32) 微信的订单号，优先使用
	out_trade_no	是	String(32) 	商户系统内部的订单号,transaction_id 、out_trade_no 二选一，如果同时存在优先级：transaction_id>out_trade_no
	*/
	//微信被扫订单查询
	queryweixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="QUERY_WEIXINBESWEPTORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"transaction_id":wbs.orderinfo.transaction_id};
		evt.params=Object.toJSON(param);
		evt.method="queryorder";
		
		this._executeCommandEvent(evt);
	},
	_onQueryWeixinBesweptOrder:function(e){
		var data=e.getUserData();
		if(!data){return;}
        //判断订单是否支付成功，如果订单不成功，则每10秒查询一次，共查询三次，如果三次后还没有支付成功，则撤销订单
		var status=data.trade_state;
		if(!status){
			alert("等待用户支付");
			return;
		}
		status=status.toLowerCase();
		if(status=="success"){
			alert("支付成功");
			return;
		}else if(status=="refund"){
			alert("用户已申请退款");
			return;
		}else if(status=="close"){
			alert("订单已关闭");
			return;
		}else if(status=="revoked"){
			alert("订单已撤销，请重新下单");
			return;
		}else if(status=="nopay"){
			alert("订单已超时，请撤销后重新下单");
			return;
		}else if(status=="userpaying"||status=="notpay"||status=="payerror"){
			if(wbs.count<3){
				window.setTimeout("wbs.queryweixinbesweptorder()",10000);
				alert("请等待用户支付");
				wbs.count+=1;
			}else{
				alert("订单已超时，请撤销后重新下单");
				return;
			}
		}else{
			alert("请撤销订单后重新下单");
		}
	},
	
	//参数说明
	/*
	appid 		是	String(32) 	微信分配的公众账号ID
	mch_id 		是	String(32) 	微信支付分配的商户号
	sub_mch_id	是	String(32)	微信支付分配的子商户号
	transaction_id 	否	String(32) 微信的订单号，优先使用
	out_trade_no	是	String(32) 	商户系统内部的订单号,transaction_id 、out_trade_no 二选一，如果同时存在优先级：transaction_id>out_trade_no
	*/
	//微信被扫订单撤销(支付失败的关单，支付成功的撤销支付。注意：7 天以内的单可撤销)
	reverseWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="REVERSE_WEIXINBESWEPTORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"certificatepath":wbs.orderinfo.certificatepath,"psd":wbs.orderinfo.psd};
		evt.params=Object.toJSON(param);
		evt.method="reverseorder";
		
		this._executeCommandEvent(evt);
	},
	_onReverseWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        if(!data){
			alert("订单撤撤销失败，请重新撤销。");
			//设置撤销订单按钮可用
			jQuery("#reverseorder").removeAttr("disabled");
			return;
		}
		var canrecall=data.recall;
		if(!canrecall){
			alert("订单撤撤销失败，请重新撤销。");
			//设置撤销订单按钮可用
			jQuery("#reverseorder").removeAttr("disabled");
			return;
		}
		canrecall=canrecall.toLowerCase();
		if(canrecall=="y"){
			alert("请重新撤销。");
			return;
		}
		alert(e.message?e.message:"订单撤销失败");
	},
	
	//参数说明
	/*
	appid 		是	String(32) 	微信分配的公众账号ID
	mch_id 		是	String(32) 	微信支付分配的商户号
	sub_mch_id	是	String(32)	微信支付分配的子商户号
	device_info 否	String(32) 	微信支付分配的终端设备号，与下单一致
	transaction_id 	否	String(28) 微信订单号
	out_trade_no	否	String(32) 	商户系统内部的订单号,transaction_id 、out_trade_no 二选一，如果同时存在优先级：transaction_id>out_trade_no
	out_refund_no	是	String(32) 	商户系统内部的退款单号，商户系统内部唯一，同一退款单号多次请求只退一笔
	total_fee 	是	Int 订单总金额，单位为分
	refund_fee	是	Int 退款总金额，单位为分,可以做部分退款
	op_user_id 	是	String(32)	操作员帐号, 默认为商户号
	certificatepath	是	String(1000)	证书地址
	psd				是	证书密码
	*/
	
	//微信被扫订单申请退款
	refundWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="REFUND_WEIXINBESWEPTORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"out_refund_no":wbs.orderinfo.out_refund_no,"total_fee":wbs.orderinfo.total_fee,"refund_fee":wbs.orderinfo.refund_fee,"op_user_id":wbs.orderinfo.op_user_id,"certificatepath":wbs.orderinfo.certificatepath,"psd":wbs.orderinfo.psd};
		evt.params=Object.toJSON(param);
		evt.method="refundorder";
		
		this._executeCommandEvent(evt);
	},
	_onRefundWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        alert(e.message);
	},
	
	//参数说明
	/*
	appid 		是	String(32) 	微信分配的公众账号ID
	mch_id 		是	String(32) 	微信支付分配的商户号
	sub_mch_id	是	String(32)	微信支付分配的子商户号
	device_info 否	String(32) 	微信支付分配的终端设备号
	transaction_id 	否	String(28) 微信订单号
	out_trade_no 	否	String(32) 	商户系统内部的订单号
	out_refund_no 	否	String(32) 	商户退款单号
	refund_id		否	String(28) 	微信退款单号	refund_id、out_refund_no、out_trade_no 、transaction_id 四个参数必填一个，如果同事存在优先级为：refund_id>out_refund_no>transaction_id>out_trade_no
	*/
	//微信被扫退款单查询
	queryRefundWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="QUERYREFUND_WEIXINBESWEPTORDER";
		var param={"key":wbs.orderinfo.key,"appid":wbs.orderinfo.appid,"mch_id":wbs.orderinfo.mch_id,"sub_mch_id":wbs.orderinfo.sub_mch_id,"out_trade_no":wbs.orderinfo.out_trade_no,"out_refund_no":wbs.orderinfo.out_refund_no};
		evt.params=Object.toJSON(param);
		evt.method="queryrefundorder";
		
		this._executeCommandEvent(evt);
	},
	_onQueryRefundWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        alert(data);
	},
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				//art.dialog.tips(result.message);
				alert(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	}
}

weixinbesweptjs.main = function(){ wbs=new weixinbesweptjs();};
jQuery(document).ready(weixinbesweptjs.main);
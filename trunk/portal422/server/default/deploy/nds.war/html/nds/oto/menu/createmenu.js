var cm=null;
var createmenu=Class.create();

createmenu.prototype={
	initialize: function() {
		application.addEventListener("CREATE_MENU", this._onCreateMenu, this);
		application.addEventListener("CREATE_TWODIMENSIONALCODE", this._onCreateTwoDimensionalCode, this);
		application.addEventListener("CREATE_WEIXINBESWEPTORDER", this._onCreateWeixinBesweptOrder, this);	
		application.addEventListener("QUERY_WEIXINBESWEPTORDER", this._onQueryWeixinBesweptOrder, this);
		application.addEventListener("REVERSE_WEIXINBESWEPTORDER", this._onReverseWeixinBesweptOrder, this);
		application.addEventListener("REFUND_WEIXINBESWEPTORDER", this._onRefundWeixinBesweptOrder, this);
		application.addEventListener("QUERYREFUND_WEIXINBESWEPTORDER", this._onQueryRefundWeixinBesweptOrder, this);
		application.addEventListener("GET_OPENID", this._onGetOpenid, this);
		application.addEventListener("GET_OPENIDAU", this._onGetOpenidAu, this);
		this.inittest();
	},
	inittest:function(){
		var ua="Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/226.26 (KHTML, like Gecko) Mobile/10B329 MicroMessenger/13.0.1";
		if(/MicroMessenger/i.test(ua)){
			var reg=new RegExp("micromessenger\/\\d+","igm");
			var verison=reg.exec(ua);
			if(verison){verison=verison[0];}
			if(verison){
				//verison.replace(new RegExp("micromessenger\/","img"),"");
				verison=verison.toLowerCase().replace("micromessenger\/","");
			}
			if(isNaN(verison)){
				
			}
		}
		//alert(Math.ceil(0.01/0.1));
		//alert(Math.round(0.001/0.1*100)/100)
	},
	inite:function(){
		var value=jQuery("#menus").val();//obj.value.replace(/[^\d.]/g,"");
		var reg=/(0|([1-9]\d*))(\.\d{1,2})/;
		
		jQuery("#recharemoney").val(value);
	},
	getOpenid:function(){
		var evt={};
		evt.command="nds.weixin.ext.GetWeixinOpenidCommand";
		evt.callbackEvent="GET_OPENID";
		var param={};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	_onGetOpenid:function(e){
	
	},
	
	getOpenidAu:function(){
		var evt={};
		evt.command="nds.weixin.ext.GetWeixinAuthorizationCommand";
		evt.callbackEvent="GET_OPENIDAU";
		var code=jQuery("#menus").val();
		var param={"code":code};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	_onGetOpenidAu:function(e){
	
	},	
	
	cratemenu:function(){
		this.inite();
		return;
		
		
		var evt={};
		evt.command="nds.weixin.ext.TestCreateMenuCommand";
		evt.callbackEvent="CREATE_MENU";
		var menu=jQuery("#menus").val();
		menu=eval('('+menu+')');
		var param={"domain":jQuery("#domin").val(),"menu":menu};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	_onCreateMenu:function(e){
		var data=e.getUserData();
        alert(data.message);
	},
	createTwoDimensionalCode:function(){
		var evt={};
		evt.command="nds.weixin.ext.TwoDimensionalCodeCommand";
		evt.callbackEvent="CREATE_TWODIMENSIONALCODE";
		var param={"logopath":""};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	_onCreateTwoDimensionalCode:function(e){
		var data=e.getUserData();
        if(data&&data.imgpath){
			jQuery("#codess").attr("src",data.imgpath);
		}
	},
	createweixinbesweptorder:function(){
		var autocode=jQuery("#menus").val().trim();
		if(!autocode){
			alert("autocde is null");
			return;
		}
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="CREATE_WEIXINBESWEPTORDER";
		var param={"key":"burgeonnebula1001043618621583921","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","body":"beswept","out_trade_no":"2324124123421341241werr","total_fee":"1","ip":"172.18.34.88","auth_code":autocode};
		evt.params=Object.toJSON(param);
		evt.method="createorder";
		
		this._executeCommandEvent(evt);
	},
	_onCreateWeixinBesweptOrder:function(e){
		var data=e.getUserData();
		window.setTimeout("cm.queryweixinbesweptorder()",5000);
        alert(data);
	},
	queryweixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="QUERY_WEIXINBESWEPTORDER";
		var param={"key":"burgeonnebula1001043618621583921","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","out_trade_no":"2324124123421341241werr"};
		evt.params=Object.toJSON(param);
		evt.method="queryorder";
		
		this._executeCommandEvent(evt);
	},
	_onQueryWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        alert(data);
	},
	reverseWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="REVERSE_WEIXINBESWEPTORDER";
		var param={"key":"burgeonnebula1001043618621583921","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","out_trade_no":"2324124123421341241werr","certificatepath":"D:/NEWBOSoto/act.nea/conf/weixinbesweptapiclient_cert.p12","psd":"10010436"};
		evt.params=Object.toJSON(param);
		evt.method="reverseorder";
		
		this._executeCommandEvent(evt);
	},
	_onReverseWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        alert(data);
	},
	refundWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="REFUND_WEIXINBESWEPTORDER";
		var param={"key":"burgeonnebula1001043618621583921","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","out_trade_no":"2324124123421341241werr","out_refund_no":"refund2324124123421341241werr","total_fee":1,"refund_fee":1,"op_user_id":"10010436","certificatepath":"D:/NEWBOSoto/act.nea/conf/weixinbesweptapiclient_cert.p12","psd":"10010436"};
		evt.params=Object.toJSON(param);
		evt.method="refundorder";
		
		this._executeCommandEvent(evt);
	},
	_onRefundWeixinBesweptOrder:function(e){
		var data=e.getUserData();
        alert(data);
	},
	queryRefundWeixinbesweptorder:function(){
		var evt={};
		evt.command="nds.weixin.wxt.foreign.WeixinBesweptOrderCommand";
		evt.callbackEvent="QUERYREFUND_WEIXINBESWEPTORDER";
		var param={"key":"burgeonnebula1001043618621583921","appid":"wxa5338bf0ca2d4d5f","mch_id":"10010436","sub_mch_id":"10010843","out_trade_no":"2324124123421341241werr","certificatepath":"D:/NEWBOSoto/act.nea/conf/weixinbesweptapiclient_cert.p12","psd":"10010436"};
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

createmenu.main = function(){ cm=new createmenu();};
jQuery(document).ready(createmenu.main);
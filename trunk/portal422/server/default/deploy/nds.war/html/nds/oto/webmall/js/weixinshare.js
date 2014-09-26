var wxs={
	appId:"",
	MsgImg:"",
	TLImg:"",
	url:"",
	title:"测试分享",
	desc:"测试分享测试分享测试分享",
	fakeid:"",
	weixinno:"",
	orderinfo:{},
	callback:function(res){WeixinJSBridge.log(res.err_msg);}
};
var weixinshareing=new function(){};

wxs.onBridgeReady=function(){
	//WeixinJSBridge.log(wxs.url+","+wxs.appId);
	WeixinJSBridge.on('menu:share:appmessage', function(argv){
		WeixinJSBridge.invoke(
			'sendAppMessage',
			{
				"appid":wxs.appId,
				"img_url":wxs.MsgImg,
				"img_width":"120",
				"img_height":"120",
				"link":wxs.url,
				"desc":wxs.desc,
				"title":wxs.title
			}, 
			function(res){}
		);
	});
	WeixinJSBridge.on('menu:share:timeline', function(argv){
		WeixinJSBridge.invoke(
			'shareTimeline',
			{
				"img_url":wxs.TLImg,
				"img_width":"120",
				"img_height":"120",
				"link":wxs.url,
				"desc":wxs.desc,
				"title":wxs.title
			}, 
			function(res){wxs.callback(res);}
		);
	});
	WeixinJSBridge.on('menu:share:weibo', function(argv){
		WeixinJSBridge.invoke(
			'shareWeibo',
			{
				"content":wxs.title,
				"url":wxs.url
			}, 
			function(res){wxs.callback(res);}
		);
	});
	WeixinJSBridge.on('menu:share:facebook', function(argv){
		WeixinJSBridge.invoke(
			'shareFB',
			{
				"img_url":wxs.TLImg,
				"img_width":"120",
				"img_height":"120",
				"link":wxs.url,
				"desc":wxs.desc,
				"title":wxs.title
			}, 
			function(res){wxs.callback(res);}
		);
	});
};

wxs.attention=function(){
	if(typeof WeixinJSBridge != "undefined" && WeixinJSBridge.invoke){
		/*WeixinJSBridge.invoke(
			"profile", 
			{
				username: wxs.weixinno,
				scene: "57"
			}
		);*/
		WeixinJSBridge.invoke(
			'addContact', 
			{ 
				webtype: '1', 
				username: wxs.weixinno  
			},  
			function(res) {wxs.callback(res);}
		);
	}
};

wxs.weixinpay=function(){
	WeixinJSBridge.invoke(
		'getBrandWCPayRequest',
		wxs.orderinfo,
		function(res){
			if(res.err_msg=="ok"){
				showBubble("支付成功！");
			}else{
				WeixinJSBridge.log(res.err_msg);
				alert(res.err_code+"<=>"+res.err_msg+"<=>"+res.err_desc)
			}
		}
	);
}

wxs.main=function(){
	/*wxs=new weixinshareing();
	wxs.initialize();*/
	
	if (typeof WeixinJSBridge === "undefined"){
		if(document.addEventListener){
			document.addEventListener('WeixinJSBridgeReady', wxs.onBridgeReady, false);
		}else if(document.attachEvent){
			document.attachEvent('WeixinJSBridgeReady'   , wxs.onBridgeReady);
			document.attachEvent('onWeixinJSBridgeReady' , wxs.onBridgeReady);
		}
	}else{
		wxs.onBridgeReady();
	}
};
$(document).ready(wxs.main);

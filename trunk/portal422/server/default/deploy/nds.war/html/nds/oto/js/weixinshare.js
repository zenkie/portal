var wxs={
	appId="";
	MsgImg="";
	TLImg="";
	url="";
	demain="";
	title="测试分享";
	desc="测试分享测试分享测试分享";
	fakeid="";
	callback=function(){};
};
var weixinshareing=new function(){};

wxs.onBridgeReady:function(){
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
			function(res){(wxs.callback)();}
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
			function(res){(wxs.callback)();}
		);
	});
	WeixinJSBridge.on('menu:share:weibo', function(argv){
		WeixinJSBridge.invoke(
			'shareWeibo',
			{
				"content":wxs.title,
				"url":wxs.url
			}, 
			function(res){(wxs.callback)();}
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
			function(res){(wxs.callback)();}
		);
	});
};
wxs.main:function(){
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
$(document).ready(weixinshareing.main);

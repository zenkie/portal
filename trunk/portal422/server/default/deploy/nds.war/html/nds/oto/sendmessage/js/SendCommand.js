var sendCommand;
var SendMessageControl = Class.create();


SendMessageControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "SendMessageInteface", this._onsend_message, this);//为回调方法起个名字
		application.addEventListener( "SendMassMessageInteface", this._onmass_send_message, this);//为回调方法起个名字
	},
	
	send_message : function (memberid) {			
		var evt={};
		evt.command="nds.weixin.ext.MassReplyCommand";//调用的类
		evt.params={"niid":memberid};	//参数
		evt.callbackEvent="SendMessageInteface";//回调方法				
		this._executeCommandEvent(evt);		
	 },
	 
	send_mass_message : function (memberid) {			
		var evt={};
		evt.command="WxBindkey";//调用的类
		evt.params={"memberid":memberid};	//参数
		evt.callbackEvent="SendMassMessageInteface";//回调方法				
		this._executeCommandEvent(evt);		
	 },
	 
	 _executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为返回的数据 自己函数构建json
			var result= r.evalJSON();
            if (result.code !=0 ){
				dialog.close();
				art.dialog.tips(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
		}
	  );
	},
	 
	_onsend_message : function (e) {//回调函数
		dialog.close();
		this._showDialog({content:"发送信息成功"});
		var url = jQuery("#ifr1").attr("src"); //刷新消息
		jQuery("#ifr1").attr("src",url);
	},
	
	_onmass_send_message : function (e) {//群发消息回调函数
		dialog.close();
		this._showDialog({content:"发送信息成功"});
		// var url = jQuery("#ifr1").attr("src"); //刷新消息
		// jQuery("#ifr1").attr("src",url);
	},
	
	_showDialog : function(opt){//显示dialog
		config = {
			time: 1,
			lock:true,
			cancel: false,
			content: ''
		};
		config = jQuery.extend({}, config, opt);//配置
		art.dialog(config);	
	},
};

SendMessageControl.main = function () {
	sendCommand=new SendMessageControl();	
};

jQuery(document).ready(SendMessageControl.main);

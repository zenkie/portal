//实例化dwr上传参数
var reg;
var FindPwdControl = Class.create();
FindPwdControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "FindInteface", this._onFind, this);//为回调方法起个名字
		application.addEventListener( "SMSInteface", this._onSendSMS, this);//为回调方法起个名字
	},
	
	submitData : function () {
		var evt = {};
		var PHONECODE = jQuery("#PHONECODE").val();
		evt.password1 = jQuery("#PASSWORD").val();
		evt.password2 = jQuery("#repswd").val();
		evt.phonenum = jQuery("#PHONE").val();
		evt.command="nds.smslogin.ChangePassword";//调用的类
		evt.params={"verifyCode":PHONECODE};	//参数
		evt.callbackEvent="FindInteface";//回调方法				
		this._executeCommandEvent(evt);		
	 },
	 
	sendSMS : function () {//发送手机验证码
		var phone = jQuery("#PHONE").val();
		if(!window.findpwd.utils.checkPhone(phone,jQuery("#PHONENUMBER").nextAll(".hint")))return false;
		jQuery(".checkCode").attr("disabled",true);
		jQuery(".checkCode").addClass("disabled");
		this.timerOut();
		var evt={};
		evt.command="nds.smslogin.forgetpassword";//调用的类
		evt.params={"phonenum":phone};	//参数
		evt.callbackEvent="SMSInteface";//回调方法				
		this._executeCommandEvent(evt);	
	},
	
	timerOut : function () {
		var count = 59;
		var handler = function(){			
			jQuery(".checkCode").val(count+"秒后重新获取");
			count --;
			if(count == 0){
				clear();
				jQuery(".checkCode").val("获取验证码");
				jQuery(".checkCode").removeClass("disabled");
				jQuery(".checkCode").attr("disabled",false);
			}
		}
		var timer = setInterval( handler , 1000);
		
		var clear = function(){
			clearInterval(timer);
		}
		
	},
	
	 _executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为返回的数据 自己函数构建json
			var result= r.evalJSON();
            if (result.code !=0 ){
				//错误返回
				if(result.data){
					reg._showDialog({content:result.data.message});
				}else{
					reg._showDialog({content:result.message});
				}
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.message);
                application.dispatchEvent(evt);
            }
		}
	  );
	},
	 
	_onFind : function (e) {//成功回调函数
		var message = e.getUserData();
		this._showDialog({content:message,cancel:function(){
			location.href = "/login.jsp";
		}});
	},
	
	_onSendSMS : function (e){
	},
	
	_showDialog:function(opt){//显示dialog
		config = {
			time: 2,
			lock:true,
			cancel: false,
			content: ''
		};
		config = jQuery.extend({}, config, opt);//配置
		art.dialog(config);	
	},
};

FindPwdControl.main = function () {
	reg=new FindPwdControl();
};

jQuery(document).ready(FindPwdControl.main);
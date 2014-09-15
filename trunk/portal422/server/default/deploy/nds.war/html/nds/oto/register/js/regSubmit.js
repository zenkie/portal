//实例化dwr上传参数
var reg;
var RegisterControl = Class.create();
RegisterControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "RegisterInteface", this._onRegister, this);//为回调方法起个名字
		application.addEventListener( "SMSInteface", this._onSendSMS, this);//为回调方法起个名字
	},
	
	submitData : function () {
		var evt={};
		evt.command="RegistrateUser";//调用的类		
		var table = "WX_REGUSER";
		var PASSWORD = jQuery("#PASSWORD").val();
		var WXAPPID = jQuery("#WXAPPID").val();
		var PHONENUMBER = jQuery("#PHONENUMBER").val();
		var PHONECODE = jQuery("#PHONECODE").val();
		var EMAIL = PHONENUMBER+"@syman.cn";
		var USERNAME = PHONENUMBER;
		evt.params={"table":table,"EMAIL":EMAIL,"PASSWORD":PASSWORD,"WXAPPID":WXAPPID,"COMPANY":"","USERNAME":USERNAME,"PHONENUMBER":PHONENUMBER,"ADDRESS":"","verifyCode":PHONECODE};	//参数
		evt.callbackEvent="RegisterInteface";//回调方法				
		this._executeCommandEvent(evt);		
	 },
	 
	sendSMS : function () {//发送手机验证码
		var phone = jQuery("#PHONENUMBER").val();
		if(!window.register.utils.checkPhoneSMS(phone,jQuery("#PHONENUMBER").nextAll(".hint")))return false;
		jQuery(".checkCode").attr("disabled",true);
		jQuery(".checkCode").addClass("disabled");
		this.timerOut();
		var evt={};
		evt.command="nds.smslogin.regvaildcode";//调用的类
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
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
		}
	  );
	},
	 
	_onRegister : function (e) {//成功回调函数
		location.href = "/html/nds/oto/register/bindwx.jsp";//下一步 绑定公众号
	},
	
	_onSendSMS : function (e){
		var data = e.getUserData();
		jQuery("#PHONENUMBER").nextAll(".hint").html(data.message);
	},
	
	_showDialog:function(opt){//显示dialog
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

RegisterControl.main = function () {
	reg=new RegisterControl();
};

jQuery(document).ready(RegisterControl.main);
var edi;
var EditDevIntefaceControl = Class.create();
var user;
var pwd;
var isCode = false;//是否需要验证码 true 必须
var clientId;
var dialog;

EditDevIntefaceControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "EditDevInteface", this._onedit_dev_inter, this);//为回调方法起个名字
	},
	
	edit_dev : function (user,pwd,vcode) {				
			var evt={};
			evt.command="WxBindkey";//调用的类
			evt.params={"user":user,"pwd":pwd,"vcode":vcode,"userid":clientId};	//参数
			evt.callbackEvent="EditDevInteface";//回调方法
			dialog = art.dialog({lock:true,cancel: false,content: '正在绑定，请稍后.....'});
			this._executeCommandEvent(evt);	
	 },
	 
	_onedit_dev_inter : function (e) {//回调函数
			var r=e.getUserData();
			dialog.close();
			switch (r.code) {
				case -8:
					showDialog({content:r.message});
					isCode = true;					
					jQuery("#ImageCode").attr("src", "/servlets/binserv/Wxvcode?user="+clientId);
					jQuery("#wxImageCode").show();//显示验证码
					break;				
				case 0:
					showDialog({
						content:"微信公众账号智能绑定成功",
						cancel:function(){
							location.href = "/html/nds/oto/portal/portal.jsp?ss=88";				
						}});					
					break;
				case -1:
					showDialog({content:r.message});
					break;				
			}			
			
	},	
	
	_executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为返回的数据 自己函数构建json
			var result= r.evalJSON();
			var evt=new BiEvent(result.callbackEvent);
			evt.setUserData(result);
			application.dispatchEvent(evt);
		}
	  );
	},
	
	_showMessage:function(msg, bError){//返回错误信息
			if(msg!=null&&bError){
				showDialog({content:msg});
			}
	},
	
	_isEmpty:function(obj){//判断是否为空 true 为空 false 不为空
		return (!obj || obj.trim() == "" || obj.trim() == undefined);
	}		
	
};

EditDevIntefaceControl.main = function () {
	edi=new EditDevIntefaceControl();	
	jQuery("#wxbind").click(function(){
		user = jQuery("#wxAccount").val();
		pwd = jQuery("#wxPwd").val();
		if(isCode){
			var code = jQuery("#wxImgCode").val();
			if(edi._isEmpty(code)){
				showDialog({content:"验证码不为空"});
				return;
			}
			commit(code);			
		}else{
			commit("");
		}		
		
	});	
	clientId = jQuery("#clientId").val();	
	 jQuery("#ImageCode").click(function () {
		jQuery(this).attr("src", "/servlets/binserv/Wxvcode?user="+clientId);
	});	
};

function commit(code){//提交数据
	if(edi._isEmpty(user) || edi._isEmpty(pwd)){
		showDialog({content:"用户名或者密码不能为空"});			
	}else{
		edi.edit_dev(user,pwd,code);
	}
}

function showDialog(opt){//显示dialog
	config = {
		time: 1,
		lock:true,
		cancel: false,
		content: ''
	};
	config = jQuery.extend({}, config, opt);//配置
	art.dialog(config);	
}

jQuery(document).ready(EditDevIntefaceControl.main);

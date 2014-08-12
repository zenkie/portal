var edi;//EditDevIntefaceControl对象
var user;//用户名
var pwd;//密码
var isCode = false;//是否需要验证码 true 必须
var clientId;//公司ID
var dialog;//artDialog对象
var EditDevIntefaceControl = Class.create();

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
	
	edit_dev : function (user,pwd,vcode) {//user用户 pwd密码 vcode验证码
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
				case -8://-8 微信返回结果 需要验证码
					this._showDialog({content:r.message});
					isCode = true;					
					jQuery("#ImageCode").attr("src", "/servlets/binserv/Wxvcode?user="+clientId);
					jQuery("#wxImageCode").show();//显示验证码
					break;				
				case 0://0 表示操作成功
					this._showDialog({
						content:"微信公众账号智能绑定成功",
						cancel:function(){
							location.href = "/html/nds/oto/portal/portal.jsp?ss=88";				
						}});					
					break;
				case -1://微信返回码 除-8情况 都在这里显示
					this._showDialog({content:r.message});
					break;				
			}			
			
	},	
	
	_executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){//r为后台返回的数据
			var result= r.evalJSON();
			var evt=new BiEvent(result.callbackEvent);
			evt.setUserData(result);
			application.dispatchEvent(evt);
		}
	  );
	},
	
	_isEmpty:function(obj){//判断是否为空 true 为空 false 不为空
		return (!obj || obj.trim() == "" || obj.trim() == undefined);
	},
	
	_commit:function(code){//提交数据
		if(this._isEmpty(user) || this._isEmpty(pwd)){
			this._showDialog({content:"用户名或者密码不能为空"});			
		}else{
			this.edit_dev(user,pwd,code);
		}
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
	}	
};

EditDevIntefaceControl.main = function () {
	edi=new EditDevIntefaceControl();
	clientId = jQuery("#clientId").val();
	
	jQuery("#ImageCode").click(function () {//初始化二维码
		jQuery(this).attr("src", "/servlets/binserv/Wxvcode?user="+clientId);
	});
	
	jQuery("#wxbind").click(function(){//提交按钮绑定事件
		user = jQuery("#wxAccount").val();
		pwd = jQuery("#wxPwd").val();
		if(isCode){
			var code = jQuery("#wxImgCode").val();
			if(edi._isEmpty(code)){
				showDialog({content:"验证码不为空"});
				return;
			}
			edi._commit(code);
		}else{
			edi._commit("");
		}
	});
};

jQuery(document).ready(EditDevIntefaceControl.main);

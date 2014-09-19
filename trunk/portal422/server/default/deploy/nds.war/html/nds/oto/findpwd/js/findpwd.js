(function(root,factory){
	root.findpwd = factory();
}(this,function(){
var utils = {};
utils.isEmpty = function(obj){
	if(obj.trim() == "" || obj.trim() == undefined){
		return true;
	}
	return false;
};
utils.checkEmpty = function(obj,hint){
	if(!this.isEmpty(obj)){
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.checkWxappid = function(obj,hint){
	jQuery("#PHONENUMBER").attr("disabled",true);
	var reg = /^[A-Z0-9-_]*$/i;
	if(!this.isEmpty(obj) && reg.test(obj.trim())){
		if(!this.isExistWxappid(obj)){
			this.displayHint(hint,"该服务号还未绑定");
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		if(this.isEmpty(obj)){
			jQuery("#PHONENUMBER").attr("disabled",false);
			this.hiddenHint(hint);
			return false;
		}
		this.displayHint(hint);
		return false;
	}
};
utils.isExistWxappid = function(obj){
	//判断数据库中是否唯一
	var _params="{table:\"WX_REGUSER\",columns:['PHONENUMBER'],params:{column:\"WXAPPID\",condition:\"="+obj+"\"}}";
	var _data;
	jQuery.ajax({
		url:'/html/nds/schema/restajax.jsp',
		type:'post',
		async: false,
		data:{command:"Query",params:_params},
		success:function(pdata){
			pdata=pdata.replace('error:null','');
			_data = eval("("+pdata+")")[0].rows;
		}
	});
	if(_data.length!=0){
		//"已经被注册！"
		jQuery("#PHONE").val(_data[0][0]);
		return true;
	}
	return false;
};
utils.checkPhone = function(obj,hint){
	jQuery("#WXAPPID").attr("disabled",true);
	var reg=/^((\(\d{2,3}\))|(\d{3}\-))?1[3,4,5,7,8]{1}\d{9}$/;
	if(!this.isEmpty(obj) && reg.test(obj)){		
		if(!this.isExistPhone(obj)){
			this.displayHint(hint,"该手机还未注册");
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		if(this.isEmpty(obj)){
			jQuery("#WXAPPID").attr("disabled",false);
			this.hiddenHint(hint);
			return false;
		}		
		this.displayHint(hint);
		return false;
	}
};
utils.isExistPhone = function(obj){
	//判断数据库中是否唯一
	var _params="{table:\"WX_REGUSER\",columns:['PHONENUMBER'],params:{column:\"PHONENUMBER\",condition:\"="+obj+"\"}}";
	var _data;
	jQuery.ajax({
		url:'/html/nds/schema/restajax.jsp',
		type:'post',
		async: false,
		data:{command:"Query",params:_params},
		success:function(pdata){
			pdata=pdata.replace('error:null','');
			_data = eval("("+pdata+")")[0].rows;
		}
	});
	if(_data.length!=0){
		//"已经被注册！"
		jQuery("#PHONE").val(_data[0][0]);
		return true;
	}
	return false;
};
utils.checkPswd = function(obj,hint){
	var reg = /^[^\u4e00-\u9fa5]{6,16}$/;
	if(!this.isEmpty(obj) && reg.test(obj.trim())){
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.checkPswdSe = function(newObj,hint){
	var oldObj = jQuery("#PASSWORD").val();
	if(oldObj == newObj){
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.checkPhoneCode = function(obj,hint){
	if(!this.isEmpty(obj) && obj.length == 6){
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.displayHint = function(hint,content){
	hint.addClass("red");
	if(!content)hint.html(hint.attr("hintInfo"));//错误提示
	else hint.html(content);
};
utils.hiddenHint = function(hint){
	hint.removeClass("red");
	hint.html(hint.attr("notiInfo"));//关闭，如果有友情提示则显示
};
var engine = {};
engine.onBlurInput = function(){
	jQuery("#PHONENUMBER").blur(function(){
		var _this = jQuery(this);
		var command = _this.attr("verify");
		var obj = _this.val();
		var hint = _this.nextAll(".hint");
		if(utils['check' + command]){
			if(!utils['check' + command].apply(utils,[obj,hint])){
				jQuery("#findButton").attr("disabled",true);
				jQuery("#findButton").addClass("disabled");
				return false;
			}
		}
		jQuery("#findButton").attr("disabled",false);
		jQuery("#findButton").removeClass("disabled");
		return true;
	});
	jQuery("#WXAPPID").blur(function(){
		var _this = jQuery(this);
		var command = _this.attr("verify");
		var obj = _this.val();
		var hint = _this.nextAll(".hint");
		if(utils['check' + command]){
			if(!utils['check' + command].apply(utils,[obj,hint])){
				jQuery("#findButton").attr("disabled",true);
				jQuery("#findButton").addClass("disabled");
				return false;
			}
		}
		jQuery("#findButton").attr("disabled",false);
		jQuery("#findButton").removeClass("disabled");
		return true;
	});
	jQuery("#PHONECODE,#PASSWORD,#repswd").blur(bindFun);
};
engine.bindButton = function(){
	jQuery("#findButton").click(function(){
		jQuery("#findSubmit").hide();
		jQuery("#findPwd").show();
	});
};
var count = {};//计算input正确输入个数
var inputNum;//校验个数
var displayInput;//提交按钮
var bindFun = function(){//绑定函数，根据校验规则调用相应的校验函数
	var _this = jQuery(this);
	var command = _this.attr("verify");
	var obj = _this.val();
	var hint = _this.nextAll(".hint");
	if(utils['check' + command]){
		if(!utils['check' + command].apply(utils,[obj,hint])){
			if(count[_this.attr("id")]){
				delete count[_this.attr("id")];
				jQuery("#"+displayInput).addClass("disabled");
				jQuery("#"+displayInput).attr("disabled",true);
			}
			return false;
		}
	}
	count[_this.attr("id")] = true;
	var countNum = 0;
	for(var i in count){
		countNum ++;
	}
	if(countNum == inputNum){
		jQuery("#"+displayInput).removeClass("disabled");
		jQuery("#"+displayInput).attr("disabled",false);
	}
	return true;
};
var init = function(){
	engine.onBlurInput();
	engine.bindButton();
	inputNum = jQuery("#inputNum").val();
	displayInput = jQuery("#inputName").val();
	jQuery("input[type=text]").val("");
};
var obj = {};
obj.utils = utils;
obj.init = init;
return obj;
}));

jQuery(document).ready(function(){
	window.findpwd.init();//初始化
});
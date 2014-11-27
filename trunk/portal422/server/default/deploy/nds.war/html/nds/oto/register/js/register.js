(function(root,factory){
	root.register = factory();
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
	var reg = /^[A-Z0-9-_]*$/i;
	if(!this.isEmpty(obj) && reg.test(obj.trim())){
		if(this.isExistWxappid(obj,hint,"该服务号已被绑定，<a class='link_blue' href='/html/nds/oto/findpwd/index.html' target='_blank'>忘记星云账号？</a>")){
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.isExistWxappid = function(obj,hint,content){	
	if(this.isExist(obj,"WXAPPID",hint,content))return true;
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
utils.checkPhoneSMS = function(obj,hint){//验证手机唯一，是否已经注册过，注册过不需要发送短信
	var reg=/^((\(\d{2,3}\))|(\d{3}\-))?1[3,4,5,7,8]{1}\d{9}$/;
	if(!this.isEmpty(obj) && reg.test(obj)){
		var _data;
		var existObj = "PHONENUMBER";
		var _params="{table:\"WX_REGUSER\",columns:['"+existObj+"'],params:{column:\""+existObj+"\",condition:\"="+obj+"\"}}";
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
			this.displayHint(hint,"该手机号码已被绑定，请<a class='link_blue' href='/login.jsp' target='_blank'>直接登录</a>或<a class='link_forget'  href='/html/nds/oto/findpwd/index.html' target='_blank'>忘记星云密码？</a>");
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.checkPhone = function(obj,hint){
	var reg=/^((\(\d{2,3}\))|(\d{3}\-))?1[3,4,5,7,8]{1}\d{9}$/;
	if(!this.isEmpty(obj) && reg.test(obj)){
		if(this.isExistPhone(obj,hint,"该手机号码已被绑定，请<a class='link_blue' href='/login.jsp' target='_blank'>直接登录</a>或<a class='link_forget'  href='/html/nds/oto/findpwd/index.html' target='_blank'>忘记星云密码？</a>")){
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.isExistPhone = function(obj,hint,content){
	if(this.isExist(obj,"PHONENUMBER",hint,content))return true;
	return false;
};
utils.checkMail = function(obj,hint){
	var reg=/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]+$/;
	if(!this.isEmpty(obj) && reg.test(obj)){
		if(this.isExistEmail(obj)){
			this.displayHint(hint,"邮箱已被注册！");
			return false;
		}
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.isExistEmail = function(obj){
	if(this.isExist(obj,"EMAIL"))return true;
	return false;
};
utils.isExist = function(obj,existObj,hint,content){
	//判断数据库中是否唯一
	var _params="{table:\"WX_REGUSER\",columns:['"+existObj+"'],params:{column:\""+existObj+"\",condition:\"="+obj+"\"}}";
	var _data;
	jQuery.ajax({
		url:'/html/nds/schema/restajax.jsp',
		type:'post',
		async: true,
		data:{command:"Query",params:_params},
		success:function(pdata){
			pdata=pdata.replace('error:null','');
			_data = eval("("+pdata+")")[0].rows;
			if(_data.length!=0){
				//"已经被注册！"
				if(count[existObj]){
					delete count[existObj];
					jQuery("#"+displayInput).addClass("disabled");
					jQuery("#"+displayInput).attr("disabled",true);
				}
				utils.displayHint(hint,content);
				return true;
			}else{
				utils.hiddenHint(hint);
				count[existObj] = true;
				var countNum = 0;
				for(var i in count){
					countNum ++;
				}
				if(countNum == inputNum){
					jQuery("#"+displayInput).removeClass("disabled");
					jQuery("#"+displayInput).attr("disabled",false);
				}
				return false;
			}
		}
	});	
	return true;
};
utils.checkPhoneCode = function(obj,hint){
	if(!this.isEmpty(obj) && obj.length == 6){
		this.hiddenHint(hint);
		return true;
	}else{
		this.displayHint(hint);
		//位数不够6位
		return false;
	}
};
utils.checkAddress = function(obj,hint){
	if(!this.isEmpty(obj)){
		if(!utils.chkProCitDis())return false;	
		this.hiddenHint(hint);		
		return true;
	}else{
		this.displayHint(hint);
		return false;
	}
};
utils.chkProCitDis = function(){//验证省市区联动
	province = jQuery("#province").children().filter(":selected").val();
	city = jQuery("#city").children().filter(":selected").val();
	regionId = jQuery("#regionId").children().filter(":selected").val();
	province = province == "省份" ? "" : province;		
	regionId = regionId == "城市" ? "" : regionId;
	regionId = regionId == "区县" ? "" : regionId;
	regionId = regionId == "市辖区" ? "" : regionId;
	if (province == "" || regionId == "") {
		utils.displayHint(jQuery("#province").nextAll(".hint"));
		return false;
	}
	utils.hiddenHint(jQuery("#province").nextAll(".hint"));
	return true;
};
utils.checkBusiness = function(){
	var business = jQuery("#BUSINESS").children().filter(":selected").val();
	if(business == -1){
		utils.displayHint(jQuery("#BUSINESS").nextAll(".hint"));
		return false;
	}
	utils.hiddenHint(jQuery("#BUSINESS").nextAll(".hint"));
	return true;
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
utils.ajaxSubmit = function(_command,_params,opt){
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:_command,params:_params},
		success: function (data) {			
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				if(opt.success){
					opt.success();
				}
			} else {
				art.dialog({
					time: 1,
					lock:true,
					cancel: false,
					content: _data[0].message
				});	
			}
		}					
	});
};
var engine = {};
engine.displayFirst = function(){
	var list = jQuery(".payStep").find("li");
	jQuery(".payStep").find("li>span").remove();
	list.removeClass("now");
	jQuery(list[0]).addClass("now");
	jQuery(list[2]).prepend("<span></span>");
	jQuery(list[3]).prepend("<span></span>");
	
	jQuery("#registerUser").show();
	jQuery("#companyInfo").hide();
};
engine.displaySecond = function(){
	var list = jQuery(".payStep").find("li");
	jQuery(".payStep").find("li>span").remove();
	list.removeClass("now");
	jQuery(list[1]).addClass("now");
	jQuery(list[1]).prepend("<span></span>");
	jQuery(list[3]).prepend("<span></span>");
	
	jQuery("#registerUser").hide();
	jQuery("#companyInfo").show();
};
engine.displayThird = function(){
	var list = jQuery(".payStep").find("li");
	jQuery(".payStep").find("li>span").remove();
	list.removeClass("now");
	jQuery(list[2]).addClass("now");
	jQuery(list[1]).prepend("<span></span>");
	jQuery(list[2]).prepend("<span></span>");
	
	jQuery("#companyInfo").hide();
	jQuery("#bindwx").show();
};
engine.displayFourth = function(){
	var list = jQuery(".payStep").find("li");
	jQuery(".payStep").find("li>span").remove();
	list.removeClass("now");
	jQuery(list[3]).addClass("now");
	jQuery(list[1]).prepend("<span></span>");
	jQuery(list[2]).prepend("<span></span>");
	jQuery(list[3]).prepend("<span></span>");
	
	jQuery("#bindwx").hide();
	jQuery("#experience").show();
};
engine.onBlurInput = function(){
	//绑定input text,password类型
	jQuery(":text,:password").blur(bindBlur);
	jQuery("#BUSINESS").blur(bindBlur);
};
engine.firstStep = function(){
	var inputText = jQuery("#registerUser").find(":text,:password");
	for(var i=0,length=inputText.length;i<length;i++){
		if(!bindFun(inputText[i]))return false;
	}
	return true;
};
engine.secondStep = function(){
	var inputText = jQuery("#companyInfo").find(":text,#BUSINESS");
	for(var i=0,length=inputText.length;i<length;i++){
		if(!bindFun(inputText[i]))return false;
	}
	return true;
};
engine.bindButton = function(){
	jQuery("#nextSub").click(function(){
		reg.submitData();		
	});
	
	jQuery("#subRegister").click(function(){
		if(engine.secondStep()){
			var NICKNAME = jQuery("#NICKNAME").val();
			var USERNAME = jQuery("#USERNAME").val();
			var COMPANY = jQuery("#COMPANY").val();
			var BUSINESS = jQuery("#BUSINESS").children().filter(":selected").val();
			var ADDRESS = province+city+regionId+jQuery("#addInfo").val();
			var editId = jQuery("#editId").val();
			var _command = "ObjectModify";		//partial_update 更新必传字段
			var _params = "{\"table\":\"WEB_CLIENT\",\"partial_update\":true,\"id\":"+editId+",\"NICKNAME\":"+NICKNAME+",\"CONTACTNAME\":"+USERNAME+",\"COMPANY\":"+COMPANY+",\"BUSINESS\":"+BUSINESS+",\"ADDRESS\":"+ADDRESS+"}";
			var opt = {
				success:function(){
					engine.displayThird();
				}
			};
			//客户姓名
			jQuery("#welcomeContent").html("客户"+USERNAME+"，恭喜完成账号注册!");
			utils.ajaxSubmit(_command,_params,opt);
		}else{
			return;
		}
	});
};
var count = {};//计算input正确输入个数
var inputNum;//校验个数
var displayInput;//提交按钮
var bindBlur = function(){//绑定函数，根据校验规则调用相应的校验函数
	var	_this = jQuery(this);	
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
var bindFun = function(obj1){//绑定函数，根据校验规则调用相应的校验函数
	var _this;
	if(obj1){
		_this = jQuery(obj1);
	}else{
		_this = jQuery(this);
	}
	var command = _this.attr("verify");
	var obj = _this.val();
	var hint = _this.nextAll(".hint");
	if(utils['check' + command]){
		if(!utils['check' + command].apply(utils,[obj,hint])){
			return false;
		}
	}
	return true;
};
var init = function(){
	engine.onBlurInput();
	engine.bindButton();
	inputNum = jQuery("#inputNum").val();
	displayInput = jQuery("#inputName").val();
	jQuery(":text,:password").val("");
	
	var step = jQuery("#step").val();
	engine["display"+step]&&engine["display"+step]();
	// if(step && step != ""){
		// engine["display"+step]&&engine["display"+step]();
	// }
};
var obj = {};
obj.utils = utils;
obj.engine = engine;
obj.init = init;
return obj;
}));

jQuery(document).ready(function(){
	window.register.init();//初始化
});
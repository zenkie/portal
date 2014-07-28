var reg;
var register = Class.create();
var sum = 0;
register.prototype={
	initialize:function(){},	
	checkCompany:function(){
		var userNameObj=jQuery("#company");
		if(userNameObj.next()!=null) delhelpinline(userNameObj);
		if(!userNameObj.val() || userNameObj.val().trim() == "" || userNameObj.val().trim() == undefined){
			addhelpinline(userNameObj,"企业名称不为空!");
			return;
		}
		
		sum++;
	},
	checkWxappid:function(){
		var userNameObj=jQuery("#wxappid");
		
		if(!userNameObj.val() || userNameObj.val().trim() == "" || userNameObj.val().trim() == undefined){
			delhelpinline(userNameObj);
			addhelpinline(userNameObj,"微信公众号不为空!");
			return;
		}
		var reg = /^[A-Z0-9-_]*$/i;
		if(!reg.test(userNameObj.val().trim())){
			delhelpinline(userNameObj);
			addhelpinline(userNameObj,"公众号输入不合法！");
			//pswd.next()[0].innerHTML="<img src=\"/html/nds/oto/themes/01/images/error_sug.png\" style=\"vertical-align: middle;\">";
			return;
		}
		//判断数据库中是否唯一
		var _params="{table:\"WX_REGUSER\",columns:['WXAPPID'],params:{column:\"WXAPPID\",condition:\"="+userNameObj.val()+"\"}}";
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
			delhelpinline(userNameObj);
			addhelpinline(userNameObj,"公众号已被注册！");
			return;
		}
		userNameObj.next()[0].innerHTML="*";
		delhelpinline(userNameObj.next());
		sum++;
	},
	checkUserName:function(){
		var userNameObj=jQuery("#username");
		if(userNameObj.next()!=null) delhelpinline(userNameObj);
		if(!userNameObj.val() || userNameObj.val().trim() == "" || userNameObj.val().trim() == undefined){
			addhelpinline(userNameObj,"联系人不为空!");
			return;
		}
		sum++;		
	},
	checkPswd:function(){
		var reg = /^[A-Z0-9-_]{6,12}$/i;
		var pswd=jQuery("#pswd");
		if(!reg.test(pswd.val().trim())){
			delhelpinline(pswd);
			addhelpinline(pswd,"输入密码只能由字母、数字、下划线组成！");
			//pswd.next()[0].innerHTML="<img src=\"/html/nds/oto/themes/01/images/error_sug.png\" style=\"vertical-align: middle;\">";
			return;
		}
		
		pswd.next()[0].innerHTML="*";
		delhelpinline(pswd.next());
		sum++;
	},
	//检查2次输入密码是否一致
	checkPswdSe:function(){
		var pswd = jQuery("#pswd");
		var repswd = jQuery("#repswd");
		if(pswd.val().trim()!=repswd.val().trim() || repswd.val().trim()=="" ){
			if(repswd.next().length!=0) return;
			addhelpinline(repswd,"密码不一致!");
			return;
		}
		if(repswd.next()!=null) delhelpinline(repswd);
		sum++;
	},
	checkPhone:function(){
		var phone = jQuery("#phone");
		if(phone.val().length==0 &&  phone.nextAll().length == 0 ){ 
			sum++;
			return;
		}
		if(phone.val().length==0 &&  phone.nextAll().length != 0 ){ 
			delhelpinline(phone);
			sum++;
			return;
		}
		var reg=/[0-9]{8,12}/i;
		if(!reg.test(phone.val()) && phone.nextAll().length == 0){
			addhelpinline(phone,"号码格式不正确!");
			return;
		}
		sum++;
	},
	checkMail:function(){
		var reg=/^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]+$/;
		var mail=jQuery("#input_mail");
		//判断输入是否合法
		if(!reg.test(mail.val().trim())){
			delhelpinline(mail);
			addhelpinline(mail,"邮箱为空或格式不正确!");
			return;
		};
		//判断数据库中是否唯一
		var _params="{table:\"WX_REGUSER\",columns:['EMAIL'],params:{column:\"EMAIL\",condition:\"="+mail.val()+"\"}}";
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
			delhelpinline(mail);
			addhelpinline(mail,"邮箱已被注册！");
			return;
		}
		//判断是否要修改提示信息
		if(mail.nextAll().length==2){
			mail.next()[0].innerHTML="*";
			delhelpinline(mail.next());
		}
		sum++;
	},
	checkPin:function(){
		var input_pin=jQuery("#input_pin");
		if(input_pin.val().trim().length!=4){
			if(input_pin.nextAll().length==2) return;
			delhelpinline(input_pin);
			addhelpinline(input_pin,"输入的验证码位数不对！");
			return;
		}	
		if(input_pin.nextAll().length==2){
			input_pin.next()[0].innerHTML="*";
			delhelpinline(input_pin.next());
		}
		sum++;
	},
	submitButton:function(){
		sum=0;
		this.checkCompany();
		this.checkUserName();
		this.checkPswd();
		this.checkPswdSe();
		this.checkPhone();
		this.checkMail();
		this.checkPin();
		this.checkWxappid();
		/*
		var userObj={
			"username":jQuery("#username").val(),
			"pswd":jQuery("#pswd").val(),
			"address":jQuery("#address").val(),
			"phone":jQuery("#phone").val(),
			"mail":jQuery("#input_mail").val(),
			"pin":jQuery("#input_pin").val(),
			"wxappid":jQuery("#wxappid").val()
		};*/
		//保存数据
		if(sum!=8) return;
		jQuery("#regForm").submit();
	}
};
register.main = function () {
	reg=new register();
};
//添加提示
jQuery(document).ready(register.main);
function addhelpinline(inputObj,message){
	inputObj.parent().append("<span class=\"maroon\"><img src=\"/html/nds/oto/themes/01/images/error_sug.png\" style=\"vertical-align: middle;\"></span><span class=\"\">"+message+"</span>");
}
//删除提示
function delhelpinline(inputObj){
	inputObj.nextAll().remove();
}

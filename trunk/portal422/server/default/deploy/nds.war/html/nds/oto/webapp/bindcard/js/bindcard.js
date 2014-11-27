//验证电话
function check_phone(obj) {
	if (obj.value == "" || obj.value == null) {
		$("#mobile_msg").removeClass("qb_none");
		$("#mobile_msg").text("手机号码不能为空！");
		return false;
	} else if (!checkPhone(obj.value)) {
		$("#mobile_msg").removeClass("qb_none");
		$("#mobile_msg").text("手机号码格式不正确！");
		obj.value = "";
		return false;
	} else {
		return true;
	}
}

function checkPhone(value) {
	return /^((\(\d{2,3}\))|(\d{3}\-))?1[3,8,5]{1}\d{9}$/.test(value.trim());
}

function bindcard(){
	var cardnum=$("#cardnum").val();
	var cardpwd=$("#cardpwd").val();
	var mobile=$("#mobile").val();
	var vipid=$("#vipid").val();
	var clientid=$("#clientid").val();
	var iserp=$("#iserp").val();
	var verifycode="";
	var verifyc=$("#verifycode");
	if(verifyc.length){verifycode=verifyc.val();}

	$("#card_msg").addClass("qb_none");
	$("#pwd_msg").addClass("qb_none");
	$("#mobile_msg").addClass("qb_none");
	$("#captcha_msg").addClass("qb_none");
	
	if (cardnum == "" || cardnum == null) {
		$("#card_msg").removeClass("qb_none");
		$("#card_msg").text("会员卡卡号不能为空！");
		return false;
    }
	
	if (cardpwd == "" || cardpwd == null) {
		$("#pwd_msg").removeClass("qb_none");
		$("#pwd_msg").text("会员卡密码不能为空！");
		return false;
    }
	
	if (!check_phone(document.getElementById("mobile"))) {
            return false;
    }
	
	var issend=$("#issendmessage").val();
	if(verifyc.length){
		if (verifycode == "" || verifycode == null) {
			$("#captcha_msg").removeClass("qb_none");
			$("#captcha_msg").text("验证码不能为空！");
			return false;
		}
	}

	var link="";
	if(iserp=='Y'){
		link=",\"verifycode\":\""+verifycode+"\",\"vipid\":"+vipid+",\"method\":\"bindcard\",\"ad_client_id\":"+clientid;
	}
	var _params = "{\"table\":16038,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"DOCNO\":\""+cardnum+"\",\"VIPPASSWORD\":\""+cardpwd+"\",\"PHONENUM\":\""+mobile+"\""+link+"}";

	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ObjectCreate",params:_params},
		success: function (data) {			
		var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				showConfirm({
				describeText: "绑卡成功！",
				sureText: "确定",
				cancelText: "返回个人中心",
				sureFn: function () {
					location.href = '/html/nds/oto/webapp/usercenter/index.vml'
				},
				cancelFn:function () {
					location.href = '/html/nds/oto/webapp/usercenter/index.vml'
				}
				});
			} else {
				showConfirm({
				describeText:_data[0].message,
				sureText: "重试",
				cancelText: "取消",
				sureFn: function () {
					bindcard()
				}
				});	
			}
		}
    });
}

//发送验证码
function sendopencrdverifycode(o){
	//60秒后重新发送
	var wait = 60;  
	get_code_time = function (o) {  
	   if (wait == 0) {  
			o.removeAttribute("disabled");  
			o.value = "发送验证码";  
			wait = 60;  
		} else {  
			o.setAttribute("disabled",true);  
		    o.value = wait + "秒后重发";  
		    wait--;  
			setTimeout(function() {  
			   get_code_time(o)  
		   }, 1000)  
		}  
	} 
	//获取vipid phone
	var vipid=$("#vipid").val();
	var phone = $("#mobile").val().trim();
	if (!phone){
		$("#mobile_msg").removeClass("qb_none");
		$("#mobile_msg").text("手机号码不能为空！");
		return false;
	}
	//向后台发送处理数据
	var _params = "{\"nds.control.ejb.UserTransaction\":\"N\",\"webaction\":\"wx_sendphonemessage\",\"id\":0,\"query\":{\"method\":\"bindcard\",\"vipid\":"+vipid+",\"phone\":\""+phone+"\"}}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ExecuteWebAction",params:_params},
		success: function (data) {
		var _data = eval("("+data+")");
		   if(_data[0].code == 0){
				showBubble("验证码发送成功！");
				get_code_time(o);
		   }else{					
				showBubble("验证码发送失败！");
		   }
		}
	});
}

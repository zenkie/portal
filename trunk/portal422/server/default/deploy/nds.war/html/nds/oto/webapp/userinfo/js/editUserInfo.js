function Modify() {
	var flag = valite();
	if (flag == false) {
		return;
	}		
	var id = $("#modifyId").val();
	var name = $("#name").val().trim();
	var sex = $("#gender").val();
	var phone = $("#mobile").val().trim();
	var selectYear = $("#selectYear").val();
	var selectMonth = $("#selectMonth").val();
	selectMonth = selectMonth.length == 2? selectMonth:"0"+selectMonth;
	var selectDate = $("#selectDate").val();
	selectDate = selectDate.length == 2? selectDate:"0"+selectDate;
	var birthday = selectYear+""+selectMonth+""+selectDate;
	var selectProvince = $("#province").val();
	var selectCity = $("#city").val();
	var selectArea = $("#regionId").val();
	var address = $("#address").val();
	var isopen=$("#isopen").val();
	var vipid=$("#vipid").val();
	var clientid=$("#clientid").val();
	var link="";
	var verifycode="";
	var verifyc=$("#verifycode");
	if(verifyc.length){verifycode=verifyc.val();}
	var iserp=$("#iserp").val();
	address = selectProvince+selectCity+selectArea+address;
	if(isopen=='1'){
		link=",\"verifycode\":\""+verifycode+"\",\"vipid\":"+vipid+",\"OPENCARD_STATUS\":2,\"method\":\"opencard\",\"ad_client_id\":"+clientid;
	}else{
		link=",\"verifycode\":\""+verifycode+"\",\"vipid\":"+vipid+",\"method\":\"updatecard\",\"ad_client_id\":"+clientid;
	}
	var _params ="{\"table\":15939,\"ID\":"+id+",\"RELNAME\":\""+name+"\",\"GENDER\":\""+sex+"\",\"PHONENUM\":\""+phone+"\",\"PROVINCE\":\""+selectProvince+"\",\"CITY\":\""+selectCity+"\",\"AREA\":\""+selectArea+"\",\"BIRTHDAY\":\""+birthday+"\",\"CONTACTADDRESS\":\""+address+"\",\"partial_update\":true"+link+"}";
	$("#params").text(_params);
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ObjectModify",params:_params},
		success: function (data) {
		var _data = eval("("+data+")");
		   if(_data[0].code == 0){
				showBubble("个人信息修改成功！");
				setTimeout(function () {
				location.href = "/html/nds/oto/webapp/usercenter/index.vml";
				},1000)					
		   }else{					
				showBubble(_data[0].message);
				setTimeout(function () {
				location.reload();
				},1000)
		   }
		}
	});
}

//校验
function valite() {
	$("#name_msg").addClass("qb_none");
	$("#mobile_msg").addClass("qb_none");
	$("#captcha_msg").addClass("qb_none");
	$("#address_msg").addClass("qb_none");
	$("#addressList_msg").addClass("qb_none");
	$("#birthdayList_msg").addClass("qb_none");
	
	if (!$("#name").val() || $("#name").val().trim() == "" || $("#name").val().trim() == undefined) {
		$("#name_msg").removeClass("qb_none");
		$("#name_msg").text("姓名不能为空");
		return false;
	}

	if (!check_phone(document.getElementById("mobile"))) {
		return false;
	}

	var issendmessage=$("#issendmessage").val();
	if(issendmessage=="是"){
		if (!$("#verifycode").val() || !($("#verifycode").val().trim())) {
			$("#captcha_msg").removeClass("qb_none");
			$("#captcha_msg").text("验证码不能为空！");
			return false;
		}
	}

	if ($("#address").length > 0) {
		if ($("#address").val().trim() == "" || $("#address").val().trim() == undefined) {
			$("#address_msg").removeClass("qb_none");
			$("#address_msg").text("详细地址不能为空！");           
			return false;
		}
		if ($("#address").val().length > 64) {
			$("#address_msg").removeClass("qb_none");
			$("#address_msg").text("详细地址过长，请重新输入！");
			return false;
		}
	}
	
	if(chkBirthday()){
		return chkProCitDis();
	}
	return false;
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
	var _params = "{\"nds.control.ejb.UserTransaction\":\"N\",\"webaction\":\"wx_sendphonemessage\",\"id\":0,\"query\":{\"method\":\"opencard\",\"vipid\":"+vipid+",\"phone\":\""+phone+"\"}}";
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

//验证生日
function chkBirthday(){
	var selectYear = $("#selectYear").val();
	var selectMonth = $("#selectMonth").val();
	var selectDate = $("#selectDate").val();
	if((selectYear==-1) || (selectMonth==-1) || (selectDate==-1)){
		$("#birthdayList_msg").removeClass("qb_none");
		$("#birthdayList_msg").text("请选择生日日期！");
		return false;
	}
	return true;
}
	
////验证省市区联动
function chkProCitDis() {
	var province = $("#province").val();
	var city = $("#city").val();
	var regionId = $("#regionId").val();
	province = province == "省" ? "" : province;
	city = city == "市" ? "" : city;
	city = city == "市辖区" ? "" : city;
	city = city == "市" ? "" : city;
	city = city == "县" ? "" : city;
	regionId = regionId == "区" ? "" : regionId;
	regionId = regionId == "市辖区" ? "" : regionId;
	if (province == "" || regionId == "") {
		$("#addressList_msg").removeClass("qb_none");
		$("#addressList_msg").text("请完整通讯地址！");
		return false;
	}
	return true;
}
//验证电话
function check_phone(obj) {
	if (obj.value == "" || obj.value == null) {
		$("#mobile_msg").removeClass("qb_none");
		$("#mobile_msg").text("电话号码不能为空！");
		return false;
	} else if (!checkPhone(obj.value)) {
		$("#mobile_msg").removeClass("qb_none");
		$("#mobile_msg").text("电话号码格式不正确！");
		obj.value = "";
		return false;
	} else {
		return true;
	}
}

function checkPhone(value) {
	return /^((\(\d{2,3}\))|(\d{3}\-))?1[3,8,5]{1}\d{9}$/.test(value.trim());
}
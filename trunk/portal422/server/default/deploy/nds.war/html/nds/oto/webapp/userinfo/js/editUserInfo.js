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
		var iserp=$("#iserp").val();
		address = selectProvince+selectCity+selectArea+address;
		if(isopen=='Y'&&iserp=='Y'){
		link=",\"vipid\":"+vipid+",\"method\":\"opencard\",\"ad_client_id\":"+clientid;
		}else if(iserp=='Y'){
		link=",\"vipid\":"+vipid+",\"method\":\"updatecard\",\"ad_client_id\":"+clientid;
		}
		var _params ="{\"table\":16003,\"ID\":"+id+",\"RELNAME\":\""+name+"\",\"GENDER\":\""+sex+"\",\"PHONENUM\":\""+phone+"\",\"PROVINCE\":\""+selectProvince+"\",\"CITY\":\""+selectCity+"\",\"REGIONID\":\""+selectArea+"\",\"BIRTHDAY\":\""+birthday+"\",\"CONTACTADDRESS\":\""+address+"\",\"partial_update\":true"+link+"}";
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
					showBubble("个人信息修改失败！");
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
		$("#address_msg").addClass("qb_none");
		$("#addressList_msg").addClass("qb_none");
		if (!$("#name").val() || $("#name").val().trim() == "" || $("#name").val().trim() == undefined) {
            $("#name_msg").removeClass("qb_none");
			$("#name_msg").text("联系人不能为空");
            return false;
        }
        else if ($("#name").val().length > 32) {
			$("#name_msg").removeClass("qb_none");
			$("#name_msg").text("联系人信息过长，请重新输入！");
            return false;
        }
        if (!$("#mobile").val() || !$("#mobile").val().trim()) {
            $("#mobile_msg").removeClass("qb_none");
			$("#mobile_msg").text("手机号码不能为空！");
            return false;
        }
        if (!check_phone(document.getElementById("mobile"))) {
            return false;
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
			
		return chkProCitDis();
	}
	
	////验证省市区联动
	function chkProCitDis() {
		var province = $("#province").val();
        var city = $("#city").val();
        var regionId = $("#regionId").val();
        province = province == "请选择省" ? "" : province;
        city = city == "请选择市" ? "" : city;
        city = city == "市辖区" ? "" : city;
        city = city == "市" ? "" : city;
        city = city == "县" ? "" : city;
        regionId = regionId == "请选择区" ? "" : regionId;
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
	
function showBubble(a, b) {
        if (a) {
            b = b || 2500;
            var c = $("#bubble");
            c.css("opacity", 1), c.hasClass("qb_none") || c.html(a), c.html(a).removeClass("qb_none"), setTimeout(function () {
                c.animate({
                    opacity: 0
                }, 1500, "ease", function () {
                   $(this).addClass("qb_none").removeAttr("style")
                })
            }, b)
        }
}

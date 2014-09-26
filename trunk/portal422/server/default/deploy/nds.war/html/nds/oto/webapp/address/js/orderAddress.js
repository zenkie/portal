	function editAddress(_command,_params,_objectid,_cartid,_docno,_status,_cost){
	//校验	
	var flag = valite();
	 if (flag == false) {
        return false;
    }
	jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
			type: 'post',
			data:{command:_command,params:_params},
			success: function (data) {			
			var _data = eval("("+data+")");
				if (_data[0].code == 0) {
					if(_cost == "1"){
						location.href = "/html/nds/oto/webapp/orderCost/index.vml?status="+_status+"&objectid="+_objectid+"&cartid="+_cartid+"&docno="+_docno;
					}else{
						location.href = "/html/nds/oto/webapp/order/index.vml?status="+_status+"&objectid="+_objectid+"&cartid="+_cartid+"&docno="+_docno;
					}					
				} else {
					alert("添加数据失败");
				}
			}					
		});
	}
	
	
	//校验
	function valite() {
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
        var province = $("#province").children().filter(":selected").val();
        var city = $("#city").children().filter(":selected").val();
        var regionId = $("#regionId").children().filter(":selected").val();
        // var more = $("#address").val();
        province = province == "请选择省" ? "" : province;
        city = city == "请选择市" ? "" : city;
        city = city == "市辖区" ? "" : city;
        city = city == "市" ? "" : city;
        city = city == "县" ? "" : city;
        regionId = regionId == "请选择区" ? "" : regionId;
        regionId = regionId == "市辖区" ? "" : regionId;
        if (province == "" || regionId == "") {
			$("#region_msg").removeClass("qb_none");
			$("#region_msg").text("请选择省份或者某个城市下的具体区域！");
            return false;
        }
        var address = province + city + regionId;
        $("#addressDetail").val(address);
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
		return /^((\(\d{2,3}\))|(\d{3}\-))?1[3,8,5]{1}\d{9}$/.test(value);
	}


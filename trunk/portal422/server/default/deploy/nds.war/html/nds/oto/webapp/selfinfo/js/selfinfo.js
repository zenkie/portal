
        function chkSave() {
            if (!$("#RealName").val()) {
                alert("真实姓名未填写！");
                return false;
            }
            if (!$("#Mobile").val()) {
                alert("手机号码未填写！");
                return false;
            }
        }
        //判断手机号码格式
        function chkMobile() {
            if (!chkT($("#Mobile").val())) {
                alert('手机号码格式不正确！');
                $("#Mobile").focus();
                return false;
            }
			return true;
        }

        String.prototype.Trim = function () {
            var m = this.match(/^\s*(\S+(\s+\S+)*)\s*$/);
            return (m == null) ? "" : m[1];
        }

        String.prototype.isMobile = function () {
            return (/^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+\d{8})$/.test($("#Mobile").val().Trim()));
        }
        function chkT(tel) {
            if (tel.isMobile()) {
                return true;
            }
            else {
                return false;
            }
        }

function Modify() {
		var id = $("#vipid").val();
		var name = $("#RealName").val();
		if(!chkMobile())return;
		var phone = $("#Mobile").val();
		//alert(phone);
		var _params ="{\"table\":16003,\"ID\":"+id+",\"NAME\":\""+name+"\",\"PHONENUM\":\""+phone+"\",\"partial_update\":true}";
		$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectModify",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {				
					location.href = "/html/nds/oto/webapp/usercenterMall/index.vml";
                } else {
                    alert("个人信息修改失败");
                }
            }
        });
	
}

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

function bindcard(){
	var cardnum=$("#cardnum").val();
	var cardpwd=$("#cardpwd").val();
	var mobile=$("#mobile").val();
	var vipid=$("#vipid").val();
	var clientid=$("#clientid").val();
	var iserp=$("#iserp").val();
	
	if (cardnum == "" || cardnum == null) {
		$("#card_msg").removeClass("qb_none");
		$("#card_msg").text("会员卡卡号不能为空！");
		return false;
    }
	var link="";
	if(iserp=='Y'){
	link=",\"vipid\":"+vipid+",\"method\":\"bindcard\",\"ad_client_id\":"+clientid;
	}
	var _params = "{\"table\":16038,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"DOCNO\":\""+cardnum+"\",\"VIPPASSWORD\":\""+cardpwd+"\",\"PHONENUM\":\""+mobile+"\""+link+"}";
    
	if (!check_phone(document.getElementById("mobile"))) {
            return false;
    }

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
					describeText:"绑卡失败，请稍候再试",
					//describeText:_data[0].errMessage,
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


function showConfirm(b){
		 var a = {
            sureNode: $("#notice-sure"),
            cancelNode: $("#notice-cancel"),
            contentNode: $("#notice-content"),
            dialogNode: $("#message-notice")
        };
       
            function c() {
                f.sureFn.call(this, arguments), e()
            }
            function d() {
                f.cancelFn.call(this, arguments), e()
            }
            function e() {
                a.contentNode.empty(), a.sureNode.html("确定").off("click", c), a.cancelNode.html("取消").off("click", d), a.dialogNode.addClass("qb_none")
            }
            var f = {
                describeText: "",
                sureText: "确定",
                cancelText: "取消",
                showNum: 2,
                sureFn: function () {
                    return !0
                },
                cancelFn: function () {
                    return !0
                }
            };
            $.extend(f, b), a.dialogNode.hasClass("qb_none") && (a.dialogNode.removeClass("qb_none"), a.sureNode.on("click", c), a.cancelNode.on("click", d), 1 == f.showNum && a.cancelNode.addClass("qb_none"), a.sureNode.html(f.sureText), a.cancelNode.html(f.cancelText), a.contentNode.html(f.describeText))
        
}

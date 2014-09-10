function delAddress(delId) {
		showConfirm({
			describeText: "确定删除收货地址吗？",
			sureText: "确定",
			cancelText: "取消",
			sureFn: function () {
			var _params = "{\"table\":16009,\"id\":"+delId+"}";
			jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectDelete",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					location.href = "/html/nds/oto/webapp/address/addressMangage.vml?wechatid=wechatid";				
                } else {
                    alert("删除数据失败！");
                }
            }			
        });
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
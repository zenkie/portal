function delCart(delId){
	var _params = "{\"table\":16004,\"id\":"+delId+"}";
	$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectDelete",params:_params},
			success: function (data) {			
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					showBubble("删除商品成功！");
					setTimeout(function () {
				    location.reload();
					},1000)
                } else {
					showConfirm({
					describeText: b.msgType ? b.errMsg : "删除商品失败，请稍候再试",
					sureText: "重试",
					cancelText: "取消",
					sureFn: function () {
						delCart(delId);
						location.reload();
					}
					});	
                }
            }
        });
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
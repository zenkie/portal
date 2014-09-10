function toPay(d) {
	if(d.length == 0){
		showBubble("未选择商品，无法结算！");
		setTimeout(function () {
			location.reload();
		},1000);
		return;
	}
	var obj = eval(d);
	var vip=$("#vipid").val();
	var toids=[];
	for(var i=0;i<obj.length;i++){
		var id=obj[i].toId;
		toids[i]=id;

	}
	var json = JSON.stringify(JSON.stringify(toids));
		var _params = "{\"table\":16032,\"WX_VIP_ID\":"+vip+",\"WX_SHOPPING_FILTER\":"+json+"}";
		$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectCreate",params:_params},
			success: function (data) {			
			var _data = eval("("+data+")");
			var objID=_data[0].objectid;
                if (_data[0].code == 0) {
					location.href = '/html/nds/oto/webapp/order/index.vml?cartid='+objID;
                }else{
					showBubble(_data[0].message.replace("行 1:",""),1000);
						setTimeout(function () {
							location.reload();
						},1000);
				}
            }
        });
}

function ModifyNum(n) {
	var obj = eval(n);
	var number = obj.number
	var toId = obj.toId
		var _params = "{\"table\":16004,\"ID\":"+toId+",\"QTY\":"+number+",\"partial_update\":true}";
		$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectModify",params:_params},
			success: function (data) {		
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					//alert("修改成功");
					location.reload();
                }
            }
        });
}

	function showBubble(message, speed) {
        if (message) {
            speed = speed || 1000;
            var bubble = $("#bubble");
            bubble.css("opacity", 1), bubble.hasClass("qb_none") || bubble.html(message), bubble.html(message).removeClass("qb_none"), setTimeout(function () {
                bubble.animate({
                    opacity: 0
                }, 1000, "swing", function () {
                   $(this).addClass("qb_none").removeAttr("style");
                })
            }, speed)
        }
    }
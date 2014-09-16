$(function(){
	init();
});

function init(){
	$(".address").each(function(){
		$(this).click(function(){
		var address = $(this);
		showConfirm({
			describeText: "确定此地址为默认地址吗？",
			sureText: "确定",
			cancelText: "取消",
			sureFn: function () {
				selectAddress(address);
			}
		});  
	});
	});
	var parent = $("i.icon_checkbox_checked").closest("div.fn_address");
	var addressList = $("#addressList");
	addressList.prepend(parent);
}

function selectAddress(address){//修改订单地址  订单表：15942
		var _cost = $("#cost").val();
		var _objectid = $("#objectid").val();//订单id
		var _cartid = $("#cartid").val();
		var _docno = $("#docno").val();
		var _status = $("#status").val();
		var addressList = $("#addressList");
		var parent = address.closest("div.fn_address");
		var _id = address.attr("id");//收货地址id
		_id = _id.replace("address_","");
		var _command = "ObjectModify";			
		var _params = "{\"table\":15942,\"partial_update\":true,\"id\":"+_objectid+",\"WX_ADDRESS_ID__ADDRESS\":"+_id+"}";
		jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:_command,params:_params},
				success: function (data) {			
				var _data = eval("("+data+")");
					if (_data[0].code == 0) {
						jQuery(".icon_checkbox").removeClass("icon_checkbox_checked");
						addressList.prepend(parent);
						parent.find("i.icon_checkbox").addClass("icon_checkbox_checked");
						if(_cost == "1"){
							location.href = "/html/nds/oto/webapp/orderCost/index.vml?status="+_status+"&objectid="+_objectid+"&cartid="+_cartid+"&docno="+_docno;
						}else{
							location.href = "/html/nds/oto/webapp/order/index.vml?status="+_status+"&objectid="+_objectid+"&cartid="+_cartid+"&docno="+_docno;
						}						
					} else {
						alert("默认地址失败");
					}
				}			
				
			});
}
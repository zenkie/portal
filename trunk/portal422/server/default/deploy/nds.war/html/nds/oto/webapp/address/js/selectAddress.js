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

function selectAddress(address){
		var addressList = $("#addressList");			
		var parent = address.closest("div.fn_address");
		var _id = address.attr("id");
		_id = _id.replace("address_","");
		var _command = "ObjectModify";			
		var _params = "{\"table\":16009,\"partial_update\":true,\"id\":"+_id+",\"ISADDRESS\":2}";
		jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:_command,params:_params},
				success: function (data) {			
				var _data = eval("("+data+")");
					if (_data[0].code == 0) {
						$(".icon_checkbox").removeClass("icon_checkbox_checked");
						addressList.prepend(parent);
						parent.find("i.icon_checkbox").addClass("icon_checkbox_checked");							
					} else {
						alert("默认地址失败");
					}
				}			
				
			});
}
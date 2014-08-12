function check(){
	var objectid = jQuery("#hidId").val();
	var _command = "GetObject";//ajax请求 获取手动绑定 是否绑定
	var _params = "{\"table\":15943,\"id\":"+objectid+"}"; //WX_INTERFACESET 微信接口配置
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:_command,params:_params},
		success: function (data) {			
		var _data = eval("("+data+")");//获取返回数据
			if (_data[0].code == 0) {				
				var iscon = _data[0].ISCONNECT;//是否绑定 Y 是 N 否
				if(iscon == 'Y'){
					art.dialog({
						time: 1,
						lock:true,
						cancel: false,
						content: '微信公众账号手动绑定成功',
						cancel:function(){
							location.href = "/html/nds/oto/portal/portal.jsp?ss=88";				
						}
					});
				}else{
					art.dialog({
						time: 1,
						lock:true,
						cancel: false,
						content: '微信公众账号还未手动绑定，赶快去绑定吧。。。',						
					});
				}
			}
		}					
	});
}
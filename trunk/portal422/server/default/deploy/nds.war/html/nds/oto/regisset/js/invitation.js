jQuery(function(){
var str={};
function json2str(stt)
{
	var S = [];
	for(var i in stt){
		stt[i] = typeof stt[i] == 'string'?'"'+stt[i]+'"':(typeof stt[i] == 'object'?json2str(stt[i]):stt[i]);
		S.push(i+':'+stt[i]); 
	}
	return '{'+S.join(',')+'}';
}

$("#regColumn").click(function(){
	jQuery("li input[type=checkbox]:checked").each(function(){
		var json = eval("("+this.value+")");
		str['\"'+json.KEY+'\"']=json;
    });
	var content=json2str(str);
	var attention=$("#mustsee").attr("checked")=="checked"?"Y":"N";
	var template=$("#model").val();
	var confr=$("#txtTarea").val();
	var flag=$("#flag").val();
	var id=$("#ids").val();
	if(confr=="" || confr==null){
		   alert("报名确认为空,不会发送短信！");
		   confr="";
	}
	var _command = "ObjectCreate";
    var _command1="ObjectModify";	
	var _params = "{\"table\":WX_REGISSET,\"unionfk\":true,\"ATTENTION\":\""+attention+"\",\"TEMPLATE\":\""+template+"\",\"CONTROLJSON\":\'"+content+"\',\"CONFIRM\":\""+confr+"\"}";
	var _params1 = "{\"table\":WX_REGISSET,\"partial_update\":true,\"ID\":\""+id+"\",\"ATTENTION\":\""+attention+"\",\"TEMPLATE\":\""+template+"\",\"CONTROLJSON\":\'"+content+"\',\"CONFIRM\":\""+confr+"\"}";
	if(template=="" || template==null){
		   alert("报名模板不能为空");
	}else if(flag == -1){
			jQuery.ajax({
					url: ' /html/nds/schema/restajax.jsp',
					type: 'post',
					data:{command:_command,params:_params},
					success: function (data) {			
						var _data = eval("("+data+")");
						if (_data[0].code == 0) {
							alert("添加成功");
							var w = window.opener;
                            if(w==undefined){
							   w= window.parent;
							   }
							w.pc.navigate('WX_REGISSET','null',this);
						} else {
							//alert("添加失败");
							alert(_data[0].message);
						}
					}					
				});	
		}else{
		    jQuery.ajax({
					url: '/html/nds/schema/restajax.jsp',
					type: 'post',
					data:{command:_command1,params:_params1},
					success: function (data) {			
						var _data = eval("("+data+")");
						if (_data[0].code == 0) {
							alert("修改成功");
							var w = window.opener;
                            if(w==undefined){
							   w= window.parent;
							   }
							w.pc.navigate('WX_REGISSET','null',this);
						} else {
							//alert("修改失败");
							alert(_data[0].message);
						}
					}					
				});	
		}
	});	
	

	jQuery("#del").click(function(){
	    var id=$("#ids").val();
		var _command="ObjectDelete";	
	    var _params = "{\"table\":WX_REGISSET,\"ID\":"+id+"}";
	    jQuery.ajax({
					url: '/html/nds/schema/restajax.jsp',
					type: 'post',
					data:{command:_command,params:_params},
					success: function (data) {			
						var _data = eval("("+data+")");
						if (_data[0].code == 0) {
							alert("删除成功");
							var w = window.opener;
                            if(w==undefined){
							   w= window.parent;
							}
							w.pc.navigate('WX_REGISSET','null',this);
						} else {
							//alert("删除失败");
							alert(_data[0].message);
						}
					}					
				});
	});
	
});

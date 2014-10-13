function editMenu(colid){
	
	jQuery.post("/html/nds/oto/object/editMenu.jsp",
		{"colid":colid},
		function(data){
			//alert(data);
			jQuery("#query-content").html(data);
		}
	);
}
function delMenu(tableid,colid){
	var _param = {command:"ObjectDelete",params:"{\"table\":\""+tableid+"\",\"id\":"+colid+"}"};
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:_param,
		success:function(data){
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					art.dialog({
						time: 2,
						lock:true,
						cancel: false,
						content: '数据删除成功！',
					});
					pc.refreshGrid();
                } else {
					var message = "删除失败！";
					if(_data[0].message && _data[0].message!=""){
						message = _data[0].message;
					}						
					art.dialog.tips(message);
										
                }
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {
				alert("返回错误信息"+textStatus+":::"+errorThrown);
			}
	});
}
function delMenuArt(tableid,colid){
	var _param = {command:"ObjectDelete",params:"{\"table\":\""+tableid+"\",\"id\":"+colid+"}"};
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:_param,
		async: false,
		success:function(data){
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					art.dialog({
						time: 2,
						lock:true,
						cancel: false,
						content: '数据删除成功！',
					});
					//pc.refreshGrid();
                } else {
					art.dialog.tips("删除失败！");
                }
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {
				alert("返回错误信息"+textStatus+":::"+errorThrown);
			}
	});
}
function editTable(_params){
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		async: false,
		data:{command:"ObjectModify",params:_params},
		success: function (data) {
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				flagchange = true;
			} else {
				art.dialog.tips('操作失败！');
			}
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {}
    });
	
}
function queryData(_params){
	
	jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
            type: 'post',
			async: false,
            data:{command:"Query",params:_params},
			success: function (data) {
				var _data = eval("("+data+")")[0].rows;
				alert(_data);
				//specValueList[tabidValueList]=_data;
				tabidValueList=parseInt(tabidValueList);
				if(!specValueList[tabidValueList]){specValueList[tabidValueList]={};}
				for(var i=0;i<_data.length;i++){
					
				}
			}
	});
}
//var _params="{table:16014,columns:['id','NAME','VALUE'],params:{column:\"WX_SPEC_ID\",condition:\"="+tabidValueList+"\"}}";
	

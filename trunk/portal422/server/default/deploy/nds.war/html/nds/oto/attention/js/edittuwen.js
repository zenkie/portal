

//搜索
function changSelection(){
		var tableId=jQuery("#tableID").val();
		var SHOW_DC=jQuery("#SHOW_DC").val();
		var artOrPro=jQuery("#artOrPro").val();
		var sigleid="";
		var chooseUrl=  document.getElementsByName("chooseUrl");
		if(chooseUrl.length>0){
			jQuery("#goodsTable").contents().find("input[name=chooseUrl]:checked").each(function () {
				sigleid = jQuery(this).val();
			});
		}
		jQuery('#listTable').html("正在查询，请耐心等待...");
		jQuery.post("/html/nds/oto/object/addMenu_tbody.jsp",
					{"tableId":tableId,"artOrPro":artOrPro,"SHOW_DC":SHOW_DC,"sid":sigleid,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
					function(data){
						
						jQuery('#listTable').html(data);
				}
			);		
}
//返回保存数据
function submitMessage(){
	//跳转连接文字
	var txtTitle=jQuery("#txtTitle").val().trim();
	
	if(txtTitle==""){
		art.dialog.tips('您未输入链接文字！');
		return false;
	}
	var grouponimage=jQuery("#grouponimage").attr("src");
	if(grouponimage=="/html/nds/oto/themes/01/images/noimage.png"){
		art.dialog.tips('您未上传图片！');
		return false;
	}
	//获得描述
	var description = jQuery("#description").val().trim();
	if(description==""){
		art.dialog.tips('您未输入描述！');
		return false;
	}
	//获得ptype
	var fromid=jQuery("#jumpType").val();
	if(fromid=="" || fromid.length <= 0){
		art.dialog.tips('请选择跳转去向！');
		return false;
	}
	//获得id
	var sigleid="";
	//如果是input type=“text”
	var writeUrl=  document.getElementById("writeUrl");
	if(writeUrl!=null){
		sigleid=writeUrl.value+"";
	}
	var chooseUrl=  document.getElementsByName("chooseUrl");
	if(chooseUrl.length>=0){
		jQuery("#goodsTable").contents().find("input[name=chooseUrl]:checked").each(function () {
			sigleid = jQuery(this).val();
        });
	}
	var obj = {
		title1:txtTitle,
		content1:description,
		url1:grouponimage,
		fromid:Number(fromid),
		objid:sigleid,
		sort:0
	}
	art.dialog.data('obj',obj);// 存储数据
	art.dialog.data('flagFunc',1);
	dialog.close();
}
art.dialog.data('obj','');
art.dialog.data('flagFunc',0);

function cancelMessage(){
	art.dialog.data('flagFunc',0);
	art.dialog.close();
}

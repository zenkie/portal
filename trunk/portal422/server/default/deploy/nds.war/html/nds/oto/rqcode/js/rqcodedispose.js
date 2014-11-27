var rqd=null;
var rqcodedispose=function(){};

rqcodedispose.prototype.initialize=function(){
	this.fromid;
	this.objid;
	this.allDispose={};
	this.currentdisposeid;
};
rqcodedispose.prototype.init=function(){
	if(this.fromid){
		this.currentdisposeid=this.fromid;
		jQuery("#alldispose option[value="+this.fromid+"]").attr("selected","selected");
		this.changeDispose();
	}
};
rqcodedispose.prototype.changeDispose=function(){
	var disposeid=jQuery("#alldispose option:checked").val();
	if(isNaN(disposeid)){
		jQuery("#currentdispose").html("");
		return;
	}
	
	var dispose=this.allDispose[disposeid];
	if(!dispose){
		jQuery("#currentdispose").html("");
		return;
	}
	
	this.currentdisposeid=parseInt(disposeid);
	if(dispose.SHOW_DC==null && dispose.FIFTLE_CONDITION==null){
		jQuery("#currentdispose").html("");
	}else if(dispose.SHOW_DC==null && dispose.FIFTLE_CONDITION!=null){
		jQuery("#currentdispose").html("<label for=\"customurl\">输入连接:</label><input id=\"customurl\" type=\"text\" name=\"customurl\" value=\"http://\">");
	}else{
		var disposestr=JSON.stringify(dispose);
		if(isNaN(this.objid)){this.objid="0";}
		jQuery.ajax(
			{
				type:"post",
				url:"/html/nds/oto/rqcode/rqcodedispose_tbody.jsp",
				data:{"currentdispose":disposestr,"rqcodedisposeid":this.objid},
				success:function(data,testStatus){
					jQuery('#currentdispose').html(data);
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
				
				}
			}
		);
		/* jQuery.post("/html/nds/oto/rqcode/rqcodedispose_tbody.jsp",
			{"currentdispose":disposestr,"objid":this.objid},
			function(data){
				jQuery('#currentdispose').html(data);
			}
		); */
	}
};

rqcodedispose.prototype.searchDisposeRecode=function(){
	var dispose=this.allDispose[this.currentdisposeid];
	if(!dispose){
		jQuery('#listTable').html("");
		return;
	}
	var tableId=dispose.AD_TABLE_ID;
	var showdc=dispose.SHOW_DC;
	if(isNaN(this.objid)){this.objid="0";}
	jQuery('#listTable').html("正在查询，请耐心等待...");
	jQuery.ajax(
		{
			type:"post",
			url:"/html/nds/oto/rqcode/rqcodedispose.jsp",
			data:{"tableId":tableId,"showdc":showdc,"rqcodedisposeid":this.objid,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
			success:function(data,testStatus){
				jQuery('#listTable').html(data);
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
			
			}
		}
	);
	/* jQuery.post("/html/nds/oto/rqcode/rqcodedispose.jsp",
		{"tableId":tableId,"showdc":showdc,"sid":sigleid,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
		function(data){
			jQuery('#listTable').html(data);
		}
	); */	
};

//返回保存数据
rqcodedispose.prototype.submitMessage=function(){
	//获得id
	var objid="";
	//如果是input type=“text”
	var customurl=  document.getElementById("customurl");
	if(customurl){
		objid=customurl.value+"";
	}else{
		objid=jQuery("#listTable td input[type=radio][name=chooseUrl]:checked").val();
	}
	
	var currentdispose=this.allDispose[this.currentdisposeid];
	if(!currentdispose||jQuery.isEmptyObject(currentdispose)){
		art.dialog.data('dispose',{});
		art.dialog.list['load_dialog'].close();
		return;
	}
	var dispose={
		fromid:this.currentdisposeid,
		name:currentdispose.NAME,
		objid:objid
	}
	art.dialog.data('dispose',dispose);// 存储数据
	art.dialog.list['load_dialog'].close()
};

rqcodedispose.prototype.cancelMessage=function(){
	art.dialog.list['load_dialog'].close();
}

rqcodedispose.main=function(){
	rqd=new rqcodedispose();
	rqd.initialize();
}

jQuery(document).ready(rqcodedispose.main);
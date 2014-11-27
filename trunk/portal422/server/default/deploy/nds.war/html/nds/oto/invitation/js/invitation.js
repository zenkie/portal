jQuery(function(){
 	var flag = jQuery("#flag").val();
	var datas_id="";
	var data_id=jQuery("#data_id").val();
	var data_dir=jQuery("#data_dir").val();
	var pass="";
	jQuery("#invicon").append("<input type='hidden' name='p' value='"+data_id+"' />");
	jQuery("#ifr").attr("src","/html/nds/oto/webapp/invitation/"+data_dir+"/index.vml");
	jQuery("#tem").hide();
	if(flag=='-1'){		
		jQuery("#regissets").find("option[data-id="+data_id+"]").attr("selected","true");			
	}
	
	jQuery("#regissets").change(function(){
		var test=jQuery(this).children('option:selected').val();
		var num=jQuery(this).children('option:selected').attr("class");
		jQuery("#ifr").attr("src","/html/nds/oto/webapp/invitation/"+num+"/index.vml");
	});
	if(flag!='-1'){
			jQuery("#tem").hide();
			jQuery("#addinvitation").show();			 		 
			datas_id = jQuery("#dataid").val();
			var datas_dir = jQuery("#datadir").val();	 	
			jQuery("#ifr").attr("src","/html/nds/oto/webapp/invitation/"+datas_dir+"/index.vml");			 	 
	}
	
	
   jQuery("#save").click(function(){
    var photo = jQuery("#photo").attr("src");
	
	var intemlateid =jQuery("#regissets").val();
	//alert(intemlateid);
	var wx_regisset_id= jQuery("#regisset").val();
	
	var theme= jQuery("#theme").val();
	var starttime=jQuery("#starttime").val();
	var location= jQuery("#location").val();
	var organizers= jQuery("#organizers").val();
	var endtime= jQuery("#endtime").val();
	var introduction= jQuery("#introduction").val();
	 
	var d = new Date();
	var nowStr = d.format("yyyy/MM/dd hh:mm:ss"); 
	var _command = "ObjectCreate";		//unionfk 不管是否为显示主键 可以插入原有值 
    var _command1="ObjectModify";	
	var _params = "{\"table\":WX_INVITATION,\"unionfk\":true,\"WX_INVITATIONTEMP_ID__ID\":"+intemlateid+",\"PHOTO\":\""+photo+"\",\"WX_REGISSET_ID__ID\":\""+wx_regisset_id+"\",\"THEME\":\""+theme+"\",\"STARTTIME\":\""+starttime+"\",\"LOCATION\":\""+location+"\",\"ORGANIZERS\":\""+organizers+"\",\"ENDTIME\":\""+endtime+"\",\"INTRODUCTION\":\""+introduction+"\"}";
	var _params1 = "{\"table\":WX_INVITATION,\"partial_update\":true,\"WX_INVITATIONTEMP_ID__ID\":"+intemlateid+",\"id\":"+flag+",\"PHOTO\":\""+photo+"\",\"WX_REGISSET_ID__ID\":\""+wx_regisset_id+"\",\"THEME\":\""+theme+"\",\"STARTTIME\":\""+starttime+"\",\"LOCATION\":\""+location+"\",\"ORGANIZERS\":\""+organizers+"\",\"ENDTIME\":\""+endtime+"\",\"INTRODUCTION\":\""+introduction+"\"}";
	if(wx_regisset_id == 0){
		   alert("请选择报名模板");
		}else if(theme == ''){
		   alert("活动主题不能为空");
		}else if(starttime == ''){
		   alert("活动时间不能为空");
		}else if(location ==''){
		   alert("活动地点不能为空");
		}else if(organizers ==''){
		   alert("主办方不能为空");
		}else if(endtime ==''){
		   alert("报名截止日期不能为空");
		}else if(photo ==''){
		   alert("背景图片不能为空");
		}else if(starttime ==''){
		   alert("开始时间不能为空");
		}else if(introduction ==''){
		   alert("活动描述不能为空");
		}else if(starttime < nowStr){
		   alert("开始时间应不小于当前时间");
		}else if(endtime > starttime){
		   alert("结束时间应小于开始时间");
		}else if(flag == -1){
			jQuery.ajax({
					url: '/html/nds/schema/restajax.jsp',
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
							w.pc.navigate('WX_INVITATION','null',this);													
						} else {
							alert("添加失败");
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
							w.pc.navigate('WX_INVITATION','null',this);
						} else {
							alert("修改失败");
						}
					}					
				});	
		}
	});	
	
	
	
	jQuery("#del").click(function(){
	    var flag = jQuery("#flag").val();
		var _command="ObjectDelete";	
	    var _params = "{\"table\":WX_INVITATION,\"ID\":"+flag+"}";
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
							w.pc.navigate('WX_INVITATION','null',this);
						} else {
							alert("删除失败");
						}
					}					
				});
	});
	
});

Date.prototype.format = function(format){ 
var o = { 
"M+" : this.getMonth()+1, //month 
"d+" : this.getDate(), //day 
"h+" : this.getHours(), //hour 
"m+" : this.getMinutes(), //minute 
"s+" : this.getSeconds(), //second 
"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
"S" : this.getMilliseconds() //millisecond 
}

if(/(y+)/.test(format)) {
	format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
} 

for(var k in o) {
	if(new RegExp("("+ k +")").test(format)) {
		format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
	}
}
return format; 
}

function SyncPreview(){
	var preview = getPrevieDocument();
	var id = this.id;
	switch(id){
		case 'photo':
			preview.find('#'+id).attr("src",this.value);
			break;
		default:
			preview.find('#'+id).html(this.value);
			break;
	}
}

function getPrevieDocument(){
	return jQuery(jQuery("#ifr")[0].contentWindow.document);
}

jQuery(document).ready(function(){
	jQuery("#myForm").on('blur','input,textarea,select',SyncPreview);
});
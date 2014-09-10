$(document).ready(function () {
	var vipid = $("#vip").val();
	var isopen = $("#isopen").val();
	$("#showcard1").click(function () { 
		var btn = $(this);
		var wxname = $("#wxname1").val();
		if (wxname  == '') {
			alert("请输入昵称");
			return;
		}
		var info = $("#info1").val();
		if (info == '') {
			alert("请输入内容");
			return;
		}
		if(info.length >= 250){
			alert("内容不超过250字");
			return;
		}
		var _command = "ObjectCreate";		
		var _params = "{\"table\":22179,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"CONTENT\":"+info+"}";
		submitData(_command,_params,function(){
			alert("留言成功！");
			setTimeout('window.location.href=location.href',1000);
		});
	}); 
	
	$("#showcard2").click(function () { 
		var btn = $(this);
		var wxname = $("#wxname2").val();
		if (wxname  == '') {
			alert("请输入昵称");
			return;
		}
		var info = $("#info2").val();
		if (info == '') {
			alert("请输入内容");
			return;
		}
		if(info.length >= 250){
			alert("内容不超过250字");
			return;
		}
		var _command = "ObjectCreate";		
		var _params = "{\"table\":22179,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"CONTENT\":"+info+"}";
		submitData(_command,_params,function(){
			alert("留言成功！");
			setTimeout('window.location.href=location.href',1000);
		});
	});  
	
	$(".hhsubmit").click(function () { 
		var objid = $(this).attr("date");
		var info = $(".hly"+objid).val();
		if (info == '') {
			alert("请输入内容");
			return;
		}
		if(info.length >= 250){
			alert("内容不超过250字");
			return;
		}
		var _command = "ObjectCreate";		
		var _params = "{\"table\":22179,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"CONTENT\":"+info+",\"COMMENTID\":"+objid+"}";
		submitData(_command,_params,function(){
			alert("留言成功！");
			setTimeout('window.location.href=location.href',1000);
		});		
	});  
	
	$(".hfinfo").click(function () { 
		var objid = $(this).attr("date");
		$(".hhly"+objid).slideToggle();
	}); 
	
	$(".hhbt").click(function () { 
		var objid = $(this).attr("date");
		$(".hhly"+objid).slideToggle();
	});
	
	$("#windowclosebutton").click(function () { 
		$("#windowcenter").slideUp(500);
	});
	
	$("#alertclose").click(function () { 
		$("#windowcenter").slideUp(500);
	});
	$(".first1").click(function(){
		$(".ly1").slideToggle();
	});
	$(".first2").click(function(){
		$(".ly2").slideToggle();
	});
}); 

function alert(title,type,time){
	if(!type){//不需要滚动到顶部
		window.scrollTo(0, -1);
		$("#windowcenter").css("top","");
		$("#windowcenter").css("bottom","70px");
	}else{
		var top = $(window).scrollTop()+200;
		$("#windowcenter").css("bottom","");
		$("#windowcenter").css("top",top+"px");
	}
	if(!time){
		time = 3000;
	}
	$("#windowcenter").slideToggle("slow"); 
	$("#txt").html(title);
	setTimeout(function(){$("#windowcenter").slideUp(500);},time);
}

function submitData(_command,_params,callback){//提交数据 或者查询数据
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:_command,params:_params},
		success: function (data) {			
		var _data = eval("("+data+")");
			if (_data[0].code == 0) {				
				callback(_data);//成功回调函数	
			} else {
				alert(_data[0].message.replace("行 1:",""));
			}
		}					
	});
}

function bindEvent(){
	$(".hhsubmit").unbind("click");
	$(".hfinfo").unbind("click");
	$(".hhbt").unbind("click");
	$(".hhsubmit").click(function () {
		var objid = $(this).attr("date");
		var info = $(".hly"+objid).val();
		if (info == '') {
			alert("请输入内容");
			return;
		}
		if(info.length >= 250){
			alert("内容不超过250字");
			return;
		}
		var _command = "ObjectCreate";		
		var _params = "{\"table\":22179,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"CONTENT\":"+info+",\"COMMENTID\":"+objid+"}";
		submitData(_command,_params,function(){
			alert("留言成功！");
			setTimeout('window.location.href=location.href',1000);
		});		
	});  
	
	$(".hfinfo").click(function () {
		var objid = $(this).attr("date");
		$(".hhly"+objid).slideToggle();
	}); 
	
	$(".hhbt").click(function () {
		var objid = $(this).attr("date");
		$(".hhly"+objid).slideToggle();
	});
}
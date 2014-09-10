$(document).ready(function () {
	$("#showcard1").click(function () { 
		alert("这是手机预览，请关注微信公众服务号进行留言！");
	}); 
	
	$("#showcard2").click(function () { 
		alert("这是手机预览，请关注微信公众服务号进行留言！");
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
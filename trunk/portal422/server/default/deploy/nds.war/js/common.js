// JavaScript Document
// 在线客服
$(document).ready(function(){
	$(window).scroll(function(){
		nowtop = parseInt($(document).scrollTop());	
		$('#service_box').css('top', nowtop + 200 + 'px')
	})
	$('#service_box').hover(function(){
		$(this).css('width','285px');
	},function(){
		$(this).css('width','83px');
	})	
})
//弹出层===========================
$(function(){
	$("#funbox .brandshow li").click(function(){
		var index=$("#funbox .brandshow li").index(this);
		$('.tc_detail').show();
		$('.brandshow').hide();
		//$("#page"+(index+1)).show();
		//$("#magazine div.pagea").eq(index).show().siblings().hide();
		//left=left-(index*len_li);
		//anfade();
        /*$('#magazine').turn({
				display: 'single',
				acceleration: true,
				gradients: !$.isTouch,
				elevation:50,
				page:index+1,
				when: {
					turned: function(e, page) {
						alert(page);
					}
				}
	    });*/
		//$("#magazine").turn({page: index+1, acceleration: true, gradients: true,display: 'single'});
		if (!$("#magazine").turn("is")) {	//如果是第一次加载，初始化；否则设置页码即可
			$("#magazine").turn({page: index+1, acceleration: true, gradients: true,display: 'single',duration:600,elevation:20});
			
		}else{
			$("#magazine").turn("page", index+1);		//设置页码
			}
	})
	$(".tc_detail .slider_next").click(function(){
		$('#magazine').turn('next');
	})
	$(".tc_detail .slider_prev").click(function(){
		$('#magazine').turn('previous');
	})

	//关闭
	$('.tc_detail .btn_close').click(function(){
		//$(".page").parents("div.turn-page").remove();
		//$(".page").removeClass("turn-page");
		$(".tc_detail").hide();
		$('.brandshow').show();
		//$("#magazine").turn("removePage", 1); 
		//$("#magazine").turn("disable", true);
		//$("#magazine").turn("_removeMv");
		//left=0;
	})
});
$(window).bind('keydown', function(e){
	
	if (e.keyCode==37)
		$('#magazine').turn('previous');
	else if (e.keyCode==39)
		$('#magazine').turn('next');
		
});


//锚点带动画跳转特效=================================
jQuery(document).ready(function($) {
   $(".menu ul li a").click(function(event) { 
      var index=this.title
      var id='#'+'index_'+index
     $("html,body").animate({scrollTop: $(id).offset().top}, 800);
   });
   $(".taoba").click(function(event) { 
      var index=this.title
      var id='#'+'index_'+index
     $("html,body").animate({scrollTop: $(id).offset().top}, 800);
   });
});
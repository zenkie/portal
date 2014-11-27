$(function(){
	$(".product_list").each(function(){
			var gsize=$(this).find("#goodssize").val();
			var goodslist=$(this).find(".product_li");
			var goodslistends=goodslist.slice(3,goodslist.length);
			if(gsize>3){
				for(var i=0;i<goodslistends.length;i++){
					var $goodslistends = $(goodslistends[i]);
					$goodslistends.hide();
				}
				$(this).find(".more_orders").show();
			}			
	});
	$(".more_orders").click(function(){
		var goodslist=$(this).closest(".product_list").find(".product_li");
		var goodslistends=goodslist.slice(3,goodslist.length);
		var flag=$(this).find(".click_more").attr("index");
		if(flag=='1'){
			for(var i=0;i<goodslistends.length;i++){
				var $goodslistends = $(goodslistends[i]);
				$goodslistends.slideDown();
			}
			$(this).find(".click_more").html("点击收起");
			$(this).find(".click_more").attr("index","2");
			$(this).find(".order_img").children().addClass("order_picflip");
		}else{
			for(var i=0;i<goodslistends.length;i++){
				var $goodslistends = $(goodslistends[i]);
				$goodslistends.slideUp();
				$(this).find(".click_more").html("点击加载更多");
				$(this).find(".click_more").attr("index","1");
				$(this).find(".order_img").children().removeClass("order_picflip");
			}
		}
	});
})
$(function(){
	var  status = $("#tabstatus").val();
	if(status == "tab1"){
		$("#details_tag a:first").addClass("on");
	}else if(status == "tab2"){
		$("#details_tag a:eq(1)").addClass("on");	
	}else if(status == "tab3"){
		$("#details_tag a:last").addClass("on");
	}
});

$(function(){
	var  status = $("#tabstatus").val();
	if(status == "tab1"){
		$("#details_tag a:first").addClass("on");
		$("#details_tag a:eq(1)").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab2';
		});
		$("#details_tag a:last").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab3';
		});
	}else if(status == "tab2"){
		$("#details_tag a:eq(1)").addClass("on");	
		$("#details_tag a:first").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab1';
		});
		$("#details_tag a:last").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab3';
		})
	}else if(status == "tab3"){
		$("#details_tag a:last").addClass("on");
		$("#details_tag a:first").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab1';
		});
		$("#details_tag a:eq(1)").click(function(){
			window.location.href ='/html/nds/oto/webapp/orderDetail/index.vml?tabstatus=tab2';
		})
	}
});
/*
function showcontent() {
    var tag = document.getElementById("details_tag").childNodes;
	var content=document.getElementById("details_content").childNodes;
	var len= tag.length;
	for(var i=0; i<len; i++)
	{
		tag[i].index=i;
		tag[i].onclick = function(){
			for(var n=0; n<len; n++){
				tag[n].className="";
				//content[n].className="this_none"; 
			}
			tag[this.index].className = "on";
			//content[this.index].className = "this_show";
		}
	}
}
$(function () { showcontent(); });
*/


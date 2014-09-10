$(function(){
	$("#select_coupon").click(function(){
		if($(".coupon-content").css("display") == "none"){
			$(".coupon-content").show();
		}else{
			$(".coupon-content").hide();
		}
		
	});
	$(".resourcesCon").find("li").click(function(){
		$(".coupon-content").hide();
		$(".resourcesCon").find("li").removeClass("couponDefault");
		$(this).addClass("couponDefault");
		$("#couponId").val($(this).attr("data-id"));
		$("#select_coupon span").html($(this).attr("data"));		
		oct.totalFree=Math.round((oct.shipmentFree+oct.productFree)*100)/100;
		//优惠劵
		var coupon = $("#couponId");
		if(coupon.length==0 || coupon.val()==-1){
			$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费");
			$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
			$("#WIDtotal_fee").val(oct.totalFree);
		}else{
			$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费"+"&nbsp;-&nbsp;￥"+$(".couponDefault").attr("data-money")+"&nbsp;优惠劵");
			var fee = oct.shipmentFree+oct.productFree;
			if($(".couponDefault").attr("data-money") >= fee){
				$("#all_total-price").html("¥0");
				$("#WIDtotal_fee").val("0");
				oct.totalFree=0;
			}else{
				oct.totalFree-=Math.round(parseFloat($(".couponDefault").attr("data-money"))*100)/100;
				oct.totalFree=Math.round(oct.totalFree*100)/100;
				$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
				$("#WIDtotal_fee").val(oct.totalFree);	
			}									
		}
	});
});

function init(){
		var _this = $(".resourcesCon").find("li.couponDefault");
		if(_this.length == 0)return;
		$("#couponId").val($(_this).attr("data-id"));
		$("#select_coupon span").html($(_this).attr("data"));		
		oct.totalFree=Math.round((oct.shipmentFree+oct.productFree)*100)/100;
		//优惠劵
		var coupon = $("#couponId");
		if(coupon.length==0 || coupon.val()==-1){
			$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费");
			$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
			$("#WIDtotal_fee").val(oct.totalFree);
		}else{
			$("#all_total-price_detail").html("¥"+oct.formatNumber(oct.productFree)+"&nbsp;+&nbsp;¥"+oct.formatNumber(oct.shipmentFree)+"&nbsp;运费"+"&nbsp;-&nbsp;￥"+$(".couponDefault").attr("data-money")+"&nbsp;优惠劵");
			var fee = oct.shipmentFree+oct.productFree;
			if($(".couponDefault").attr("data-money") >= fee){
				$("#all_total-price").html("¥0");
				$("#WIDtotal_fee").val("0");
				oct.totalFree=0;
			}else{
				oct.totalFree-=Math.round(parseFloat($(".couponDefault").attr("data-money"))*100)/100;
				oct.totalFree=Math.round(oct.totalFree*100)/100;
				$("#all_total-price").html("¥"+oct.formatNumber(oct.totalFree));
				$("#WIDtotal_fee").val(oct.totalFree);	
			}									
		}
}

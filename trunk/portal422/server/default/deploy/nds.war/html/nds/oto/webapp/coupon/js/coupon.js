function getCoupon(tp){
	var id=$(tp).closest('li').find('.thisid').val();
	var vipid=$(tp).closest('li').find('.user').val();
	var couponid=$(tp).closest('li').find('.coupid').val();
	var _params = "{\"table\":15995,\"ID\":"+id+",\"WX_VIP_ID\":"+vipid+",\"WX_COUPON_ID\":"+couponid+",\"ISRECEIVE\":\"Y\",\"partial_update\":true}";
	$.ajax({
		url:'/html/nds/schema/restajax.jsp',
		type:"post",
		data:{command:"ObjectModify",params:_params},
		success: function(data){
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				tp.onclick = function(){};
				tp.parentNode.class="on";
				showBubble("领取成功，请及时使用！");
				setTimeout(function () {
				    location.reload();
					},1000);
			}else{
				tp.onclick = getCoupon(this);
				showBubble("领取失败，请稍后重试！");
				setTimeout(function () {
				    location.reload();
					},1000);
			}
		}
	});
}
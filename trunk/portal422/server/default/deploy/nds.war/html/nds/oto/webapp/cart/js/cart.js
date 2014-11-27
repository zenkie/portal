//全选反选
function SelectAll() { 
	if(jQuery(".goods_sel:checked").length == jQuery(".goods_sel").length){
		jQuery("input[name=selectall]").removeAttr("checked");
		jQuery(".goods_sel").removeAttr("checked");
	}else{
		jQuery("input[name=selectall]").attr("checked","true");
		jQuery(".goods_sel").attr("checked","true");
	}
	var s=0;
	$(".cart_goods").each(function(){
		if($(this).find(".goods_sel").attr("checked")=='checked'){
			s+=parseInt($(this).find('.buyNum').val())*parseFloat($(this).find("span[class=price]").text());
		}
	}); 
	$("#total").html(s.toFixed(2));
}

//购物车数量加减、合计
function numSub(){  
	$(".plus").click(function(){ 
		var t=$(this).prev();
		t.val(parseInt(t.val())+1);
		var id = $(this).parent().parent().parent().find(".goods_sel").attr("id");
		var str = id + "," + t.val();
		ModifyNum(str);
		setTotal();  
	});
	$(".minus").click(function(){  
		var t=$(this).next(); 
		t.val(parseInt(t.val())-1)
		if(parseInt(t.val())<0){ 
			showBubble("商品数量不能小于0！"); 
			$("#bubble").show();
			setTimeout(function () {
				$("#bubble").hide();
			},1000);
			t.val(0); 
			return;
		}
		var id = $(this).parent().parent().parent().find(".goods_sel").attr("id");
		var str = id + "," + t.val();
		ModifyNum(str);		
		setTotal();  
	}); 
	$("body").each(function(){//触发onclick事件
		$(this).find(".goods_sel").bind("click",function(){
			if(jQuery(".goods_sel:checked").length == jQuery(".goods_sel").length){
				jQuery(".input").attr("checked","true");
			}else{
				jQuery(".input").attr("checked",false);
			}
			setTotal();
		})
	}); 
	function setTotal(){ 
		var s=0; 
		var price = 0;
		$(".cart_goods").each(function(){
		/*
			if($(this).find(".goods_sel").attr("checked")=='checked'){
				s+=parseInt($(this).find('.buyNum').val())*parseFloat($(this).find("span[class=price]").text());
			}
		*/
		if($(this).find(".goods_sel").attr("checked")=='checked'){
			price = $(this).find("span[class=price]").text();
			if(!isNaN(price)){
				s+=parseInt($(this).find('.buyNum').val())*parseFloat($(this).find("span[class=price]").text());
			}		
		}
		}); 
		$("#total").html(s.toFixed(2));
	}  
	setTotal();
} 

function ModifyNum(n) {
	var obj = n.split(",");
	var toId = obj[0];
	var number = obj[1];
	var _params = "{\"table\":16004,\"ID\":"+toId+",\"QTY\":"+number+",\"partial_update\":true}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ObjectModify",params:_params},
		success: function (data) {		
		var _data = eval("("+data+")");
			if (_data[0].code == 0) {
				//alert("修改成功");
				//location.reload();
				return;
			}
		}
	});
}

//判断是否删除物品
function ifDelete(){ 
	$(".icon_delete").click(function(){
		$(".cart_goods").each(function(){
			if(jQuery(".goods_sel:checked").length==0){			
				showBubble("未选择商品，无法删除！");
				$("#bubble").show();
				setTimeout(function () {
					$("#bubble").hide();
				},1000);
				return;
			}else if($(this).find(".goods_sel").attr("checked")=='checked'){
				var id = $(this).find(".goods_sel").attr("id");
				if(jQuery(".goods_sel:checked").length == 1){
					showConfirm({
						describeText: "确定要删除该商品吗？",
						sureText: "确定",
						cancelText: "取消",
						sureFn: function () {
							delCart(id);
						}
					});
				}else{
					var obj = [];
					$(".cart_goods").each(function(){
						if($(this).find(".goods_sel").attr("checked")=='checked'){
							obj.push($(this).children().attr("id"));
						}
					});
					var toids=[];
					for(var i=0;i<obj.length;i++){
						var id=obj[i];
						toids[i]=id;
					}
					showConfirm({
						describeText: "确定要删除这些商品吗？",
						sureText: "确定",
						cancelText: "取消",
						sureFn: function () {
							delCart(toids);
						}
					});	
				}
			}
		});
	});
}
//删除物品
function delCart(delId){
	var obj = eval(delId);
	if(obj.length > 1){
		var toids=[];
		for(var i=0;i<obj.length;i++){
			var id=obj[i];
			toids[i]=id;
			var _params = "{\"table\":16004,\"id\":"+toids[i]+"}";
			$.ajax({
					url: '/html/nds/schema/restajax.jsp',
					type: 'post',
					data:{command:"ObjectDelete",params:_params},
					success: function (data) {			
					var _data = eval("("+data+")");
						if (_data[0].code == 0) {
							showBubble("删除商品成功！");
							setTimeout(function () {
							location.reload();
							},1000)
							return;
						} else {
							showConfirm({
							describeText: b.msgType ? b.errMsg : "删除商品失败，请稍候再试",
							sureText: "重试",
							cancelText: "取消",
							sureFn: function () {
								delCart(delId);
								location.reload();
							}
							});	
						}
					}
			});
		}
		
	}else{
		var _params = "{\"table\":16004,\"id\":"+delId+"}";
		$.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:"ObjectDelete",params:_params},
				success: function (data) {			
				var _data = eval("("+data+")");
					if (_data[0].code == 0) {
						showBubble("删除商品成功！");
						setTimeout(function () {
						location.reload();
						},1000)
						return;
					} else {
						showConfirm({
						describeText: b.msgType ? b.errMsg : "删除商品失败，请稍候再试",
						sureText: "重试",
						cancelText: "取消",
						sureFn: function () {
							delCart(delId);
							location.reload();
						}
						});	
					}
				}
		});
	}
}

//结算
$(function(){	
	jQuery(".confirm_order").click(function(){
		var total=jQuery("#total").html();
		if(total=='0.00'){
			showBubble("未选择商品，无法结算！");
			setTimeout(function () {
			$("#bubble").hide();
			},1000);
			return;
		}else{
			var obj = [];
			$(".cart_goods").each(function(){
				if($(this).find(".goods_sel").attr("checked")=='checked'){
					obj.push($(this).children().attr("id"));
				}
			});
			var vip=$("#vipid").val();
			var toids=[];
			for(var i=0;i<obj.length;i++){
				var id=obj[i];
				toids[i]=id;
			}
			var json = JSON.stringify(JSON.stringify(toids));
			var _params = "{\"table\":16032,\"WX_VIP_ID\":"+vip+",\"WX_SHOPPING_FILTER\":"+json+"}";
			$.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:"ObjectCreate",params:_params},
				success: function (data) {			
				var _data = eval("("+data+")");
				var objID=_data[0].objectid;
					if (_data[0].code == 0) {
						location.href = '/html/nds/oto/webapp/order/index.vml?objectid='+objID;
					}else{
						showBubble(_data[0].message.replace("行 1:",""),1000);
							setTimeout(function () {
								location.reload();
							},1000);
					}
				}
			});
		}
	});
})  

function toPay(d) {
	if(d.length == 0){
		showBubble("未选择商品，无法结算！");
		setTimeout(function () {
			location.reload();
		},1000);
		return;
	}
	var obj = eval(d);
	var vip=$("#vipid").val();
	var toids=[];
	for(var i=0;i<obj.length;i++){
		var id=obj[i].toId;
		toids[i]=id;
	}
	var json = JSON.stringify(JSON.stringify(toids));
	var _params = "{\"table\":16032,\"WX_VIP_ID\":"+vip+",\"WX_SHOPPING_FILTER\":"+json+"}";
	$.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:"ObjectCreate",params:_params},
		success: function (data) {			
		var _data = eval("("+data+")");
		var objID=_data[0].objectid;
			if (_data[0].code == 0) {
				location.href = '/html/nds/oto/webapp/order/index.vml?cartid='+objID;
			}else{
				showBubble(_data[0].message.replace("行 1:",""),1000);
					setTimeout(function () {
						location.reload();
					},1000);
			}
		}
	});
}




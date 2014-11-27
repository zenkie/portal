$(function(){
		$(".oc-comm").find("li").each(function(){//好评 中评 差评 选中时的样式切换
		var _this = $(this);
		var _ul = _this.closest("ul");
		_this.bind("click",function(){
			_ul.find("li").removeClass("selected");
			_this.addClass("selected");
			_ul.next("input").val(_this.attr("val"));
		});
		});
		
		$(".fl").find("a").each(function(){
			var _this = jQuery(this);
			var _span = _this.closest("span");
			var _input = _span.closest("div").next("input");	
			_this.bind("click",function(){
				switch(_this.index()){
				 case 0: 
					 _this.addClass("active");//一颗星的样式
					 _this.next().removeClass("active");
					 _this.next().next().removeClass("active");
					 _this.next().next().next().removeClass("active");
					 _this.next().next().next().next().removeClass("active");
					 _input.val("1");//插入后台的值
				 break;
				 case 1: 
					 _this.addClass("active");//二颗星的样式
					 _this.next().removeClass("active");
					 _this.next().next().removeClass("active");
					 _this.next().next().next().removeClass("active");
					 _input.val("2");
				 break;
				 case 2: 
					 _this.addClass("active");//三颗星的样式
					 _this.next().removeClass("active");
					 _this.next().next().removeClass("active");
					 _input.val("3");
				 break;
				 case 3: 
					 _this.addClass("active");//四颗星的样式
					 _this.next().removeClass("active");
					 _input.val("4");
				 break;
				 case 4: 
					_this.addClass("active");//五颗星的样式
					 _input.val("5");
				 break;
				}
			})
		})
		
		 /*$(".oc-star-n").find("li").each(function(){//描述相符  服务态度 发货速度 样式切换 并且赋值
		 var _this = jQuery(this);
		 var _ul = _this.closest("ul");
		 var _input = _ul.closest("div").next("input");	 
		 
		 _this.bind("click",function(){
			switch(_this.index()){
			case 0: 
					 _ul.css("background-position","-80px 0px");//一颗星的样式
					 _input.val("1");//插入后台的值
				 break;
				 case 1: 
					 _ul.css("background-position","-60px -0px");//二颗星的样式
					 _input.val("2");
				 break;
				 case 2: 
					 _ul.css("background-position","-40px -0px");//三颗星的样式
					 _input.val("3");
				 break;
				 case 3: 
					 _ul.css("background-position","-20px -0px");//四颗星的样式
					 _input.val("4");
				 break;
				 case 4: 
					 _ul.css("background-position","0 0px");//五颗星的样式
					 _input.val("5");
				 break;
			 }
		 });
	 });	*/
	
	$("#J_comment").click(function(){
		var list = $(".oc-m");
		for(var i = 0,size=list.length; i < size; i++){
			//var _goods = $(list[i]).find("#J_rateResult0").val();;
			//if(_goods == "" || _goods.length == 0){//验证是否评分
			//	showDialog("请至少填写一项评分");
			//	return;
			//}
			var _describe = $(list[i]).find("#describe").val();
			if(_describe == "" || _describe.length == 0){
				showDialog("请给宝贝评分、填写评论内容");
				return;
			 }
			var _content = $(list[i]).find("#J_rateContent0").val();
			if(_content.trim() == "" || _content.trim().length == 0){
				showDialog("请填写评论内容");
				return;
			}
			if(_content.length>=400){
				showDialog("评论内容不超过400字");
				return;
			}
		}
		// var _service = $("#service").val();
		// if(_service == "" || _service.length == 0){
			// showDialog("请给卖家服务、发货速度、物流评分！");
			// return;
		// }		
		// var _deliver = $("#deliver").val();
		// if(_deliver == "" || _deliver.length == 0){
			// showDialog("请给卖家服务、发货速度、物流评分！");
			// return;
		// }
		var orderId = $("#orderId").val();
		var vipId = $("#vipId").val();
		submitCount = list.length;
		for(var i = 0,size=list.length; i < size; i++){
			//var _goods = $(list[i]).find("#J_rateResult0").val();
			var _describe = $(list[i]).find("#describe").val();
			var _content = $(list[i]).find("#J_rateContent0").val();
			var goodsId = $(list[i]).find("#goodsId").val();
			var _command = "ObjectCreate";
			//var _params = "{\"table\":WX_COMMENT,\"unionfk\":true,\"WX_APPENDGOODS_ID__ITEMNAME\":"+goodsId+",\"WX_ORDER_ID__DOCNO\":"+orderId+",\"WX_VIP_ID__VIPCARDNO\":"+vipId+",\"CONTENT\":"+_content+",\"GOODCOMMENT\":"+_describe+"}";
			var _params = {
						"table": "WX_COMMENT",
						"unionfk": true,
						"WX_APPENDGOODS_ID__ITEMNAME":goodsId,
						"WX_ORDER_ID__DOCNO":orderId,
						"WX_VIP_ID__VIPCARDNO":vipId,
						"CONTENT":_content,
						"GOODCOMMENT":_describe
					}
			//var _params = "{\"table\":22201,\"unionfk\":true,\"WX_APPENDGOODS_ID__ITEMNAME\":"+goodsId+",\"WX_ORDER_ID__DOCNO\":"+orderId+",\"WX_VIP_ID__VIPCARDNO\":"+vipId+",\"DESCRIBE\":"+_describe+",\"CONTENT\":"+_content+",\"SERVICE\":"+_service+",\"DELIVER\":"+_deliver+",\"GOODCOMMENT\":"+_goods+"}";
			submit(_command,_params);
		}
	});
	});
	
	function showDialog(content){//提示框
		$(".c-float-popWrap").find(".warnMsg").text(content);
		$(".c-float-popWrap").slideToggle();
		setTimeout(function(){$(".c-float-popWrap").slideUp(500);},1000);
	}
	
	var submitCount = 0;//物品评价总数   当一个订单有多个商品的时候，需要提交数量等于商品种类数量
	var tempSubmitCount = 0;//成功评论物品次数
	var tempCount = 0;//调用提交次数
	function submit(_command,_params){
		jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
			type: 'post',			
			data:{command:_command,params:JSON.stringify(_params)},
			success: function (data) {
				tempCount ++;
				var _data = eval("("+data+")");
				if (_data[0].code == 0) {
					tempSubmitCount ++;
					if(tempSubmitCount == submitCount){
						submitComment();						
					}else if(tempCount == submitCount){
						showDialog("评论失败");
					}					
				} else {
					showDialog("评论失败");
				}
			}					
		});
	}
	
	function submitComment(){//评论成功的时候，给这个订单提价已经评论过
		var orderId = $("#orderId").val();
		var docno = $("#docno").val();
		var vipId = $("#vipId").val();
		var _command = "ObjectModify";
		var _params = "{\"table\":15942,\"partial_update\":true,\"id\":"+orderId+",\"ISCOMMENT\":Y}";
		jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:{command:_command,params:_params},
		success: function (data) {			
			var _data = eval("("+data+")");
			if (_data[0].code == 0) {				
				showDialog("评论成功");
				setTimeout(function(){
					location.href = "/html/nds/oto/webapp/order/index_more.vml?vipid="+vipId+"&docno="+docno+"";
				},2000);				
			} else {
				showDialog("评论失败");
			}
		}					
	});
	}
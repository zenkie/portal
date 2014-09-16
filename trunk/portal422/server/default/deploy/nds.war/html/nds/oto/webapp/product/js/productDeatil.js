	function initDetil(photoUrl){
		calculate();
		showDetil();
	}

	function showConfirm(b){
		 var a = {
            sureNode: $("#notice-sure"),
            cancelNode: $("#notice-cancel"),
            contentNode: $("#notice-content"),
            dialogNode: $("#message-notice")
        };
       
		function c() {
			f.sureFn.call(this, arguments), e()
		}
		function d() {
			f.cancelFn.call(this, arguments), e()
		}
		function e() {
			a.contentNode.empty(), a.sureNode.html("确定").off("click", c), a.cancelNode.html("取消").off("click", d), a.dialogNode.addClass("qb_none")
		}
		var f = {
			describeText: "",
			sureText: "确定",
			cancelText: "取消",
			showNum: 2,
			sureFn: function () {
				return !0
			},
			cancelFn: function () {
				return !0
			}
		};
		$.extend(f, b), a.dialogNode.hasClass("qb_none") && (a.dialogNode.removeClass("qb_none"), a.sureNode.on("click", c), a.cancelNode.on("click", d), 1 == f.showNum && a.cancelNode.addClass("qb_none"), a.sureNode.html(f.sureText), a.cancelNode.html(f.cancelText), a.contentNode.html(f.describeText))
        
}
	
	function showBubble(message, speed) {
        if (message) {
            speed = speed || 1000;
            var bubble = $("#bubble");
            bubble.stop().css("opacity", 1), bubble.hasClass("qb_none") || bubble.html(message), bubble.html(message).removeClass("qb_none"), setTimeout(function () {
                bubble.animate({
                    opacity: 0
                }, 1000, "swing", function () {
                   $(this).addClass("qb_none").removeAttr("style");
                })
            }, speed)
        }
    }

	
	//显示商品详情
	function showDetil(){
		$("#info-arrow").click(function(){
			var detail = $("#detail-info");
		if(detail.hasClass("qb_none")){
			detail.removeClass("qb_none");
			$(".mod_fold").removeClass("fold");
		}else{
			detail.addClass("qb_none");
			$(".mod_fold").addClass("fold");
		}
		});	
	}
	
	function calculate(){
		var buyNumTemp=1;//存储当前商品数量
		var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量
		if(stockNum<=0 && Wmp.Detail.isLimitStock){
			$("#buyNum").val(0);
			buyNumTemp=0;
		}else{
			$("#stock-num").html(parseNum(--stockNum+""));
			buyNumTemp=1;
		}
		
		bindingEvent($('.minus'), 'click touchstart', function(){//减少商品数量
			var buyNum = parseInt($("#buyNum").val());
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量	
			if(buyNum <= 0) return;
			$("#stock-num").html(parseNum(++stockNum+""));
			$("#buyNum").val(--buyNum);			
			buyNumTemp = buyNum;
		});	
	
		bindingEvent($('.plus'), 'click touchstart', function(){//增加商品数量
			var buyNum = parseInt($("#buyNum").val());
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));
			if(stockNum <= 0 && Wmp.Detail.isLimitStock) return;
			$("#stock-num").html(parseNum(--stockNum+""));
			$("#buyNum").val(++buyNum);
			buyNumTemp = buyNum;
		});		
		
		bindingEvent($("#buyNum"),'click touchstart',function(){
			buyNumTemp = parseInt($("#buyNum").val());
			$("#buyNum").select();
		});
	
		$("#buyNum").blur(function(){
			var buys=parseInt($("#buyNum").val());
			if(!buys||!/^\d+$/.test(buys)){
				showBubble("购买数量只能为大于0的整数",1500);
				$("#buyNum").val(buyNumTemp);
				return;
			}
			var buyNum = buyNumTemp - buys;
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''))  + buyNum;
			if(stockNum < 0 && Wmp.Detail.isLimitStock){
				$("#buyNum").val(buyNumTemp);
				return;
			}
			$("#stock-num").html(parseNum(stockNum+""));
		});
		
		function parseNum(num){//数字超过3位添加逗号
			var number = num.replace(/(?=(?:\d{3})+(?!\d))/g,',');
			if(num.length % 3 == 0 && (number.search("-")==-1)){
				number = number.substring(1);
			}else if(num.length % 4 == 0 && number.search("-")==0){
				number = number.substring(2);
			}
			return number;
		}
	}
	
	//绑定事件
	function bindingEvent(obj, evname, callback){
		var names = evname.split(' ');
		var eventName;
		$.each(names, function(){
			var name = 'on'+this;
			eventName = (name in document) ? 'touchstart' : 'click';
			if(name === 'ontap')eventName = 'tap';
		});

		obj.on(eventName, function(ev){
			callback(ev);
			ev.preventDefault();
			ev.stopPropagation();
		});
	}

	function toPay(select,num){
		var pdtid=$("#pdtid").val();
		var vipid=$("#vipid").val();
		var spaces=$("#spacesInner").text();
		var _params = "{\"table\":16033,\"WX_VIP_ID\":"+vipid+",\"WX_APPENDGOODS_ID\":"+pdtid+",\"QTY\":"+num+",\"SPEC\":\""+spaces+"\"}";
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
					showBubble("订单提交失败！");
					setTimeout(function () {
						location.reload();
					},1000)
				}
            }
        });
}

	function addCart(select,num){
	var pdtid=$("#pdtid").val();
	var vipid=$("#vipid").val();
	var spaces=$("#spacesInner").text();
	var _params = "{\"table\":16004,\"unionfk\":true,\"WX_VIP_ID__VIPCARDNO\":"+vipid+",\"WX_APPENDGOODS_ID__ITEMNAME\":"+pdtid+",\"QTY\":"+num+",\"SPEC\":\""+spaces+"\"}";
	$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectCreate",params:_params},
			success: function (data) {			
				var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					showConfirm({
					describeText: "添加成功！",
					sureText: "去购物车结算",
					cancelText: "再逛逛",
					sureFn: function () {
						location.href = '/html/nds/oto/webapp/cart/index.vml'
					}
					});
                } else {
					showConfirm({
					describeText:"加入购物车失败，请稍候再试",
					sureText: "重试",
					cancelText: "取消",
					sureFn: function () {
						addCart()
					}
					});	
                }
            },
        });
	}

	function initspaces(){
		var objid=$("input[type=hidden][id=pdtid]").val();
		$.ajax({
			url: '/html/nds/oto/webapp/product/getAliasJson.jsp?id='+objid,
			type: 'post',
			async: false,
			success: function (data) {
				initAlias(data);
			},
			error:function(data){
			
			}
		});
	}

	function initAlias(spaces){
		if(spaces.trim()=="")return;
		try{obj = JSON.parse(spaces);}
		catch(e){obj=null;}
		product = [];
		properties = [];
		regexskus=[];
		spaceprice={};
		var sps="";
		if(obj&&obj.child){
			var tempspace;
			var tempspaces;
			var spacehtml=[];
			var selectspace={};
			var dk=[];
			var isInit=false;
				for(var i=0;i<obj.child.length;i++){
					jo=obj.child[i];
					if(jo.isdefault=="Y"){
						$("#spacesInner").html(jo.aliascode);
						continue;
					}
					if(jo.putaway=='N'||jo.putaway=='n'){continue;}
					tempspaces=jo.space;
					if(tempspaces){
						dk.push(tempspaces);
						var productStr="";
						var spanid;
						if(obj.child.length==1){$("#spacesInner").html(jo.aliascode);}
						for(var j=0;j<tempspaces.length;j++){
							tempspace=tempspaces[j];
							if(productStr){productStr+="_";}
							productStr +=tempspace.id;
							if(!isInit){
								regexskus.push("\\d+");
								properties.push({pid:tempspace.pid,ids:[]});
								spacehtml[j]="<dt value=\""+tempspace.pid+"\" class=\"spacestr\">"+obj.keys[j].name+":</dt><br><dd class=\"qb_color_weak mod_property\" index=\""+j+"\" value=\""+tempspace.pid+"\">";
							}
							if(!selectspace.hasOwnProperty(tempspace.pid)){selectspace[tempspace.pid]={};}
							if(!selectspace[tempspace.pid].hasOwnProperty(tempspace.id)){
								selectspace[tempspace.pid][tempspace.id]={pid:tempspace.pid,id:tempspace.id,name:tempspace.name,value:tempspace.value};

								spanid=tempspace.pid+"-"+tempspace.id;
								
								if(obj.child.length == 1){
									spacehtml[j]+="<span index=\""+j+"\" skuname=\""+jo.sku+"\" spanid=\""+spanid+"\" tpid=\""+tempspace.pid+"\" tid=\""+tempspace.id+"\"  data-value=\"item_"+tempspace.pid+"_"+tempspace.id+"\" value=\""+tempspace.value+"\" class=\"property bcf90\">"+tempspace.name+"</span>";
								}else{
									spacehtml[j]+="<span index=\""+j+"\" skuname=\""+jo.sku+"\" spanid=\""+spanid+"\" tpid=\""+tempspace.pid+"\" tid=\""+tempspace.id+"\"  data-value=\"item_"+tempspace.pid+"_"+tempspace.id+"\" value=\""+tempspace.value+"\" class=\"property\">"+tempspace.name+"</span>";
								}
								properties[j].ids.push(tempspace.id);
							}
						}
						isInit=true;
						product.push(productStr);
						try{spaceprice[productStr]=parseFloat(jo.sellprice).toFixed(2);}
						catch(e){spaceprice[productStr]=jo.sellprice;}
					}
				}
				var spacehtmls=spacehtml.join("</dd>")+"</dd>";
				$("#spacesdisplay").html(spacehtmls);
		}
	}
	
	function sliderimg(){
	//alert(123);
	$(".main_visual").hover(function(){
		$("#btn_prev,#btn_next").fadeIn()
	},function(){
		$("#btn_prev,#btn_next").fadeOut()
	});
	$dragBln = false;
	$(".main_image").touchSlider({
		flexible : true,
		speed : 200,
		btn_prev : $("#btn_prev"),
		btn_next : $("#btn_next"),
		paging : $(".flicking_con a"),
		counter : function (e){
			$(".flicking_con a").removeClass("on").eq(e.current-1).addClass("on");
		}
	});
	
	$(".main_image").bind("mousedown", function() {
		$dragBln = false;
	});
	
	$(".main_image").bind("dragstart", function() {
		$dragBln = true;
	});
	
	$(".main_image a").click(function(){
		if($dragBln) {
			return false;
		}
	});
	
	timer = setInterval(function(){
		$("#btn_next").click();
	}, 5000);
	
	$(".main_visual").hover(function(){
		clearInterval(timer);
	},function(){
		timer = setInterval(function(){
			$("#btn_next").click();
		},5000);
	});
	
	$(".main_image").bind("touchstart",function(){
		clearInterval(timer);
	}).bind("touchend", function(){
		timer = setInterval(function(){
			$("#btn_next").click();
		}, 5000);
	});
	}
function goTopEx() {
	var obj = document.getElementById("goTopBtn");
	function getScrollTop() {
		return document.documentElement.scrollTop + document.body.scrollTop;
	}
	function setScrollTop(value) {
		if (document.documentElement.scrollTop) {
			document.documentElement.scrollTop = value;
		} else {
			document.body.scrollTop = value;
		}
	}
	window.onscroll = function() {
		getScrollTop() > 300 ? obj.style.display = "": obj.style.display = "none";
	}
	obj.onclick = function() {
		var goTop = setInterval(scrollMove, 10);
		function scrollMove() {
			setScrollTop(getScrollTop() / 1.1);
			if (getScrollTop() < 1) clearInterval(goTop);
		}
	}
}

function slidercom(){
	$dragShow = false;
	
	$("#productContext").touchSliderCopy({
		flexible : true,
		counter : function (e){
			$(".custom-richtext").addClass("hide").eq(e.current-1).removeClass("hide"),
			$(".custom-store a").removeClass("showthis").eq(e.current-1).addClass("showthis");
		}
	});

	$("#productContext").bind("mousedown", function() {
		$dragShow = false;
	});

	$("#productContext").bind("dragstart", function() {
		$dragShow = true;
	});
}
function showcontent(){
	//商品详情
	$(".custom-store-name").click(function(){
		//商品信息
		$("#detail-info").removeClass("hide"),
		//评论内容
		$("#comment-info").addClass("hide"),
		//热卖商品
		$("#hot-info").addClass("hide"),
		//商品a标签
		$(".custom-store-name").addClass("showthis"),
		//评价a标签
		$(".comment-content").removeClass("showthis"),
		//热卖a标签
		$(".product-hot").removeClass("showthis");
	});
	//商品评价
	$(".comment-content").click(function(){
		$("#detail-info").addClass("hide"),
		$("#comment-info").removeClass("hide"),
		$("#hot-info").addClass("hide"),
		$(".custom-store-name").removeClass("showthis"),
		$(".comment-content").addClass("showthis"),
		$(".product-hot").removeClass("showthis");
	});
	//热卖商品
	$(".product-hot").click(function(){
		$("#detail-info").addClass("hide"),
		$("#comment-info").addClass("hide"),
		$("#hot-info").removeClass("hide"),
		$(".custom-store-name").removeClass("showthis"),
		$(".comment-content").removeClass("showthis"),
		$(".product-hot").addClass("showthis");
	});
}
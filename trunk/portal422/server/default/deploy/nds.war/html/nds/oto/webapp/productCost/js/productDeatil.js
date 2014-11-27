Wmp.Shopping = {
	settlement: function(){
		var items = $('#item-sec').children();
		var appItem = items.last();

		items = items.slice(0, items.length - 1);

		//if(!items.length)return false;

		var Model = Backbone.Model.extend({
			defaults: {
				toId: 0,
				price: 0,
				number: 0,
				sum: 0,
				done: false,
				obj: null
			},
			toggle: function(){
				this.set('done', !this.get('done'));
			}
		});

		var List = Backbone.Collection.extend({
			done: function(){
				return this.where({done: true});
			},
			remaining: function(){
				return this.where({done: false});
			},
			comparator: 'price'
		});
		var list = new List();

		var View = Backbone.View.extend({
			el: items.eq(0),
			events: {
				'keyup input.count': 'keyup',
				'blur input.count': 'blur',
				'tap': 'toggleDone',
				'click': 'toggleDone'
			},
			initialize: function(){
				this.listenTo(this.model, 'change', this.render);
			},
			render: function(){
				this.price = this.$el.find('span[name=price]');
				this.number = this.$el.find('input[name=num]');
				this.sum = this.$el.find('span[name=sum]');

				this.price.text(this.model.get('price'));
				this.number.val(this.model.get('number'));
				this.sum.text(this.model.get('sum'));

				this.$el.toggleClass('bcf90', this.model.get('done'));

				return this;
			},
			keyup: function(){
				var number = this.number.val();
				if(isNaN(number)){
					number = 1;
					this.number.val(1);
				};
				this.model.set('number', number);
				this.model.set('sum', this.price.text() * number);
			},
			blur: function(){
				var number = this.number.val();

				if(!number || isNaN(number) || number == 0){
					this.number.val(1);
					this.keyup();
				}
				ModifyNum(this.model.toJSON());
				//console.log(this.model.toJSON());
			},
			toggleDone: function(e){
				var ev = e||e.touches[0];
				if(ev.target.tagName === 'INPUT')return false;
				if(/icon_delete/.test(ev.target.className))return false;
				this.model.toggle();
			}
		});
		var appView = Backbone.View.extend({
			el: appItem,
			events: {
				'tap #choose-all': 'toggleAll',
				'click #choose-all': 'toggleAll',
				'tap span.confirm_order': 'settle',
				'click span.confirm_order': 'settle'
			},
			initialize: function(){
				this.total = this.$el.find('span[name=total]');
				this.checkBox = this.$el.find('#choose-all-btn');

				this.listenTo(list, 'add', this.addOne);
				this.listenTo(list, 'all', this.render);
			},
			addOne: function(model){
				var view = new View({model: model});
				view.setElement(model.get('obj'));
				view.render();
			},
			render: function(){
				var ds = list.done();
				var remainings = list.remaining();

				if(!ds.length){
					this.total.text(ds.length);
					this.checkBox.toggleClass('icon_checkbox_checked', ds.length);
					return false;
				}
				var sum = 0;

				ds.map(function(model){
					sum += Number(model.get('sum'));
				});
				this.checkBox.toggleClass('icon_checkbox_checked', !remainings.length);
				this.total.text(sum.toFixed(2));
			},
			toggleAll: function(ev){
				//if(ev.toElement.tagName === 'SPAN')return false;
				var done = this.checkBox.toggleClass('icon_checkbox_checked').hasClass('icon_checkbox_checked');
				
				list.map(function(model){ model.set('done', done) });
			},
			settle: function(ev){
				var l = new List(list.done());
				toCost(l.toJSON());
				//console.log(l.toJSON())
			}
		});

		new appView;
		

		items.each(function(){
			var j = {};

			var price = $(this).find('span[name=price]').text();
			var number = $(this).find('input[name=num]').val();
			var sum = $(this).find('span[name=sum]').text();
			var vipId = $(this).attr('vip')||0;
			var id = this.id;

			if(isNaN(price))price = 0;
			if(isNaN(number) || (number.trim() == '') || !number){
				$(this).find('input[name=num]').val(1);
				number = 1;
			}

			j.toId = id;
			j.vipId = vipId;
			j.price = price;
			j.number = number;
			j.sum = number*price;
			j.obj = $(this);

			var model = new Model(j);

			list.add(model);
		});
	}
};

	function initDetil(photoUrl){
		//backTop();
		calculate();
		showDetil();
		//loopImage(photoUrl);
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
		var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量
		if(stockNum<=0 && Wmp.Detail.isLimitStock){
			$("#buyNum").val(0);
		}else{
			$("#stock-num").html(parseNum(--stockNum+""));
		}
		
		bindingEvent($('.minus'), 'click touchstart', function(){//减少商品数量
			var buyNum = parseInt($("#buyNum").val());
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));	//剩余量	
			if(buyNum <= 0) return;
			$("#stock-num").html(parseNum(++stockNum+""));
			$("#buyNum").val(--buyNum);
		});	
	
		bindingEvent($('.plus'), 'click touchstart', function(){//增加商品数量
			var buyNum = parseInt($("#buyNum").val());
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''));
			if(stockNum <= 0 && Wmp.Detail.isLimitStock) return;
			$("#stock-num").html(parseNum(--stockNum+""));
			$("#buyNum").val(++buyNum);;
		});
		
		var buyNumTemp=1;//存储当前商品数量
		bindingEvent($("#buyNum"),'click touchstart',function(){
			buyNumTemp = parseInt($("#buyNum").val());
			// this.select();
			$("#buyNum").select();
		});
	
		$("#buyNum").blur(function(){
			var buys=parseInt($("#buyNum").val());
			if(!buys||!/^\d+$/.test(buys)){
				showBubble("购买数量只能为大于0的整数",1500);
				$("#buyNum").val(buyNumTemp);
				return;
			}
			var buyNum = buyNumTemp - parseInt($("#buyNum").val());
			var stockNum = parseInt($("#stock-num").html().replace(/[^0-9-.]/g, ''))  + buyNum;
			if(stockNum < 0){
				$("#buyNum").val(buyNumTemp);
				return;
			}
			$("#stock-num").html(parseNum(stockNum+""));
		});
		
		function parseNum(num){//数字超过3位添加逗号
			// return num.length > 3 ? num.replace(/(?=(?:\d{3})+(?!\d))/g,',') : num;
			var number = num.replace(/(?=(?:\d{3})+(?!\d))/g,',');
			if(num.length % 3 == 0){
				number = number.substring(1);
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

	function toCost(select,num){
		var pdtid=$("#pdtid").val();
		var vipid=$("#vipid").val();
		var spaces=$("#spacesInner").text();
		var _params = "{\"table\":22219,\"WX_VIP_ID\":"+vipid+",\"WX_APPENDGOODS_ID\":"+pdtid+",\"QTY\":"+num+",\"SPEC\":\""+spaces+"\"}";
		$.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectCreate",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
			var objID=_data[0].objectid;
                if (_data[0].code == 0) {
					location.href = '/html/nds/oto/webapp/orderCost/index.vml?objectid='+objID;
                }else{
					showBubble("订单提交失败！");
					setTimeout(function () {
						location.reload();
					},1000)
				}
            }
        });
}
	function initspaces(){
		var objid=$("input[type=hidden][id=pdtid]").val();
		//var _params = "{\"webaction\":\"wx_getariasjson\",\"id\":0,\"query\":{\"productid\":"+objid+"}}";
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
	
	//function getAliasPhoneJson(spaces){
	function initAlias(spaces){
		//var spaces=$("#spacesdesc").text();
		if(spaces.trim()=="")return;
		try{obj = JSON.parse(spaces);}
		catch(e){obj=null;}
		product = [];
		properties = [];
		regexskus=[];
		spaceprice={};
		//var spaces=$("#spacesdesc").text();
		//var obj = JSON.parse(spaces);
		if(obj&&obj.child){
			var tempspace;
			var tempspaces;
			var spacehtml=[];
			var selectspace={};
			var dk=[];
			var isInit=false;
			/*for(var l=0;l<obj.keys.length;l++){
				keys=obj.keys[l];
				regexskus.push("\\d+");
				spacehtml+="<dt value=\""+keys.id+"\" class=\"spacestr\">"+keys.name+":</dt><br><dd class=\"qb_color_weak mod_property\" index=\""+l+"\" value=\""+keys.id+"\">";
				var property ={
								pid:keys.id,
								ids:[]
							}*/
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
							//if(tempspace.pid!=keys.id){continue;}
							if(!selectspace.hasOwnProperty(tempspace.pid)){selectspace[tempspace.pid]={};}
							if(!selectspace[tempspace.pid].hasOwnProperty(tempspace.id)){
								selectspace[tempspace.pid][tempspace.id]={pid:tempspace.pid,id:tempspace.id,name:tempspace.name,value:tempspace.value};

								spanid=tempspace.pid+"-"+tempspace.id;
								
								if(obj.child.length == 1){
									spacehtml[j]+="<span index=\""+j+"\" skuname=\""+jo.sku+"\" spanid=\""+spanid+"\" tpid=\""+tempspace.pid+"\" tid=\""+tempspace.id+"\"  data-value=\"item_"+tempspace.pid+"_"+tempspace.id+"\" value=\""+tempspace.value+"\" class=\"property bcf90\">"+tempspace.name+"</span>";
									$("#spacesInner").html(jo.aliascode);
								}else{
									spacehtml[j]+="<span index=\""+j+"\" skuname=\""+jo.sku+"\" spanid=\""+spanid+"\" tpid=\""+tempspace.pid+"\" tid=\""+tempspace.id+"\"  data-value=\"item_"+tempspace.pid+"_"+tempspace.id+"\" value=\""+tempspace.value+"\" class=\"property\">"+tempspace.name+"</span>";
								}
								//property.ids.push(tempspace.id);
								properties[j].ids.push(tempspace.id);
							}
						}
						isInit=true;
						product.push(productStr);
						try{spaceprice[productStr]=parseFloat(jo.sellprice).toFixed(2);}
						catch(e){spaceprice[productStr]=jo.sellprice;}
						/*
						if(l==0){
							
							if(productStr){
								productStr = productStr.substring(0,productStr.length-1);
								product.push(productStr);
							}
							
						}*/
					}
				}
				//properties.push(property);
				//spacehtml+= "</dd>";
				var spacehtmls=spacehtml.join("</dd>")+"</dd>";
				$("#spacesdisplay").html(spacehtmls);
				//没有上架的商品 总库存 不计算在内
				if(product.length!=0){
					var priceSum =0;
					for(var i = 0;i<product.length;i++){
						var key = product[i];priceSum = priceSum + spacepqy[key];
					};
					$("#stock-num").html(priceSum);
					productqty = priceSum;	
				}
				//没有上架的商品 总库存 不计算在内 结束
			//}
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
		//商品详情a标签
		$(".custom-store-name").addClass("showthis"),
		//商品评价a标签
		$(".comment-content").removeClass("showthis");
	});
	//商品评价
	$(".comment-content").click(function(){
		//商品信息
		$("#detail-info").addClass("hide"),
		//评论内容
		$("#comment-info").removeClass("hide"),
		//商品详情a标签
		$(".custom-store-name").removeClass("showthis"),
		//商品评价a标签
		$(".comment-content").addClass("showthis");
	});
}
var Wmp = {};

Wmp.Detail = {
	isLimitStock:true,		//是否限制库存
	isOpenCard:"未启用",	//是否已开卡，1未开卡，2已开卡
	vipDiscount:1,//会员折扣
	spaceactualprice:0,
	selectSize: function (e, current, target, cb){
		var _this = this;
		_this.now = null;
		
		$(current).on(e, target, function(){
			if($(this).hasClass("cancleselectspace")){return;}
			var index;
			var regtip="";
			var sku=[];
			var tempselectsku;
			var regexskustemp=regexskus.slice();
			var tid;
			var tempindex;
			var isSelect=true;
			
			tempselectsku=$(this);
			index=tempselectsku.attr("index");
			tid=tempselectsku.attr("tid");
			tempindex=index;
			//判断当前组中是否有其它规格被选中
			var others=$("#spacesdisplay>dd[index="+index+"]>span:not([tid="+tid+"])[class*=bcf90]");
			//删除当前组内其它选中状态样式
			$("#spacesdisplay>dd[index="+index+"]>span:not([tid="+tid+"])").removeClass("bcf90");
			
			//判断是选中还是取消选中
			if($(this).hasClass("bcf90")){
				isSelect=false;
				$(this).removeClass("bcf90");
			}
			else{$(this).addClass('bcf90');}
			
			//获取所有被选中的元素
			var allSelects=$("#spacesdisplay>dd>span[class*=bcf90]");
			if(!allSelects||allSelects.length==0){
				$("#spacesdisplay>dd>span").removeClass("cancleselectspace");
				return;
			}
			for(var i=0;i<allSelects.length;i++){
				tempselectsku=$(allSelects[i]);
				index=parseInt(tempselectsku.attr("index"));
				tid=tempselectsku.attr("tid");
				sku[index]=tid;
				//if(allSelects.length==properties.length){continue;}
				regexskustemp[index]=tid;
			}
			if(allSelects.length==properties.length){
				var price=spaceprice[sku.join("_")];
				price=Wmp.Detail.getDiscountMoney(price);
				var qty=spacepqy[sku.join("_")];
				$("#spacesInner").html(sku.join("_"));
				$("#spaceprice").html(Wmp.Detail.formatNumber(price));
				
				if(!isNaN(qty)){qty=parseInt(qty);}
				var cqty=$("#buyNum").val();
				if(cqty&&!isNaN(cqty)){cqty=parseInt(cqty);}
				if(!isNaN(qty)&&!isNaN(cqty)&&Wmp.Detail.isLimitStock){
					/*if(cqty>=qty){cqty=qty;}
					else{cqty=1;}*/
					cqty=qty>0?1:0;
					$("#buyNum").val(cqty);
				}
				$("#stock-num").html(parseInt(qty-cqty));
			}else{
				$("#spacesInner").html("");
				$("#stock-num").html(productqty);
				$("#spaceprice").html(Wmp.Detail.formatNumber(Wmp.Detail.spaceactualprice));
			}
			
			//获取所有未选择的规格组,如果是最后一组规则，则判断其它组规格是否有效
			var space;
			space=$("#spacesdisplay>dd:not([index="+tempindex+"])");
			/*
			if(allSelects.length==properties.length){
				space=$("#spacesdisplay>dd:not([index="+tempindex+"])");
			}else if(!isSelect){
				space=$("#spacesdisplay>dd");
			}else{
				space=$("#spacesdisplay>dd:not("+regtip+")");
			}*/
			
			var regstr;//="(?:,|^)"+regexskustemp.join("_")+"(?=,|$)"; // /((?:(,|^)?)(?:295_)([^,]+)(?:(,|$)?))+?/g or /((,|^)?295_([^,]+)(,|$)?)+?/g
			var validsku;//=product.join(",").match(new RegExp(regstr,"g"));
			
			var tempsku;
			var tempskus=[];
			var tempele="";
			var tempreg;
			var temptidreg;
			for(var i=0;i<space.length;i++){
				tempselectsku=$(space[i]);
				index=parseInt(tempselectsku.attr("index"));
				//if(allSelects.length==properties.length||(!isSelect&&(allSelects.length==properties.length-1))){
					temptidreg=regexskustemp.slice();
					temptidreg[index]="\\d+";
					regstr="(?=[,^]?)"+temptidreg.join("_")+"(?=[,$]?)"; 
					validsku=product.join(",").match(new RegExp(regstr,"g"));
				//}
				for(var j=0;j<validsku.length;j++){
					tempsku=validsku[j];
					tempsku=tempsku.replace(new RegExp(",","gm"),"");
					tempskus=tempsku.split("_");
					tempreg="[tid="+tempskus[index]+"]";
					if(tempele.indexOf(tempreg)<0){
						if(tempele){tempele+=",";}
						tempele+=tempreg
					};
				}
				$("#spacesdisplay>dd[index="+index+"]>span"+tempele).removeClass("cancleselectspace");
				$("#spacesdisplay>dd[index="+index+"]>span:not("+tempele+")").addClass("cancleselectspace");
			}
		return false;
		
		
		
		
		
			/*if($(this).attr("class") == "property cancleselectspace"){return;}
			
			if($(this).attr("class") != "property bcf90"){
				for (var i=0;i<$('.bcf90').length ;i++ ){
					if($($('.bcf90')[i]).parent().attr("value")==$(this).parent().attr("value")){
						$($('.bcf90')[i]).removeClass('bcf90');
					}
				}
				_this.now = $(this).addClass('bcf90');
			}else{
				$(this).removeClass('bcf90');
			}			
			
			var selectIds = [];
			//所有选中的规格
			//var spacesParent;
			//var spacesTest;
			for(var j=0;j<$('.bcf90').length;j++){
				tempDateValue = $($('.bcf90')[j]).attr("data-value");
				selectIds.push(tempDateValue);
				
				//spacesParent = ($('.spacestr')[j]).innerHTML;
				//spacesTest = ($('.bcf90')[j]).innerHTML;
				
			}
			//space += spacesParent+spacesTest+" ";
			//spacesLength =spacesParent.length;
			
			var tempStr = [];
			for(var i=0;i<$('.property').length-1;i++){
					$($('.property')[i]).addClass('cancleselectspace');
					tempDateValue = $($('.property')[i]).attr("data-value");
					tempId = tempDateValue.split("_")[2];
					isShowButt = true;
					for(var j=0;j<properties.length;j++){
						var tempProperty = properties[j];
						if(tempProperty.pid!=tempDateValue.split("_")[1]){
							var tempIds = "";
							for(var k=0;k<tempProperty.ids.length;k++){
								tempIds+= tempProperty.ids[k]+",";
							}
							if(tempIds.length>0){
								tempIds = tempIds.substring(0,tempIds.length-1);
							}
							tempStr[j] = tempIds;
							for(var l=0;l<selectIds.length;l++){
								if(selectIds[l].split("_")[1].indexOf(tempProperty.pid)!=-1){
									tempStr[j] = selectIds[l].split("_")[2];
								}
							}
							
						}else{
							tempStr[j] = tempId;
						}
					}
					var toCheckPoint = [];
					var length = 0;
					for(var m=0;m<tempStr.length;m++){
						if(length<tempStr[m].split(",").length){
							length=tempStr[m].split(",").length
						}
						var showPro = tempStr[m];
						
					}
					for(var n=0;n<length;n++){
						for(m=0;m<tempStr.length;m++){
							if(tempStr[m].split(",")[n]){
								toCheckPoint[m] = tempStr[m].split(",")[n];
								if(toCheckPoint.length==tempStr.length){
									var checkStr = "";
									for(var l=0;l<toCheckPoint.length;l++){
										checkStr+=toCheckPoint[l]+"_";
									}
									checkStr = checkStr.substring(0,checkStr.length-1);
									if(product.indexOf(checkStr)!=-1){
										isShowButt = false;
									}
								}
							}
						}
					}

					if(!isShowButt){
						//alert("show:"+$($('.property')[i]).text());
						$($('.property')[i]).removeClass('cancleselectspace');
					}
			}
			//alert($('.spacestr').length);
			//alert($('.bcf90').length);
			
			var tids = [] ;
			var allTids;
			//alert(allTids);
			for(var j=0;j<$('.bcf90').length;j++){
				var allTids = $($('.bcf90')[j]).attr("tid");
				tids.push(allTids);
			}
			if(cb)cb(_this.now);
			$("#spacesInner").html(tids);
			//$("#spacesInner").html(space);*/
		});

	},
	addCart: function(e, current, cb){
		$(current).on(e, cb);
	},
	formatNumber:function(number){
		var n=number;
		if(number){
			try{number=parseFloat(n).toFixed(2);}
			catch(e){}
			n=number.toString().replace(/(?=(?:\d{3})+(?!\d))/g,",");
			n=n.replace(/^,|,$/g,"");
		}

		return n;
	},
	getDiscountMoney:function(orimoney){
		if(orimoney&&!isNaN(orimoney)){orimoney=parseFloat(orimoney);}
		var newmoney=orimoney;
		if(orimoney&&!isNaN(orimoney)&&Wmp.Detail.vipDiscount&&Wmp.Detail.isOpenCard=="已启用"){
			newmoney=Math.round(orimoney*Wmp.Detail.vipDiscount*100)/100;
			if(newmoney==0){newmoney=0.01;}
			else if(newmoney){newmoney=newmoney.toFixed(2);}
		}
		return newmoney;
	}
};

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
				toPay(l.toJSON());
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
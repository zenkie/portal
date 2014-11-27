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
			var others=$("#spacesdisplay>dd[index="+index+"]>span:not([tid="+tid+"])[class*=selected]");
			//删除当前组内其它选中状态样式
			$("#spacesdisplay>dd[index="+index+"]>span:not([tid="+tid+"])").removeClass("selected");
			
			//判断是选中还是取消选中
			if($(this).hasClass("selected")){
				isSelect=false;
				$(this).removeClass("selected");
			}
			else{$(this).addClass('selected');}
			
			//获取所有被选中的元素
			var allSelects=$("#spacesdisplay>dd>span[class*=selected]");
			if(!allSelects||allSelects.length==0){
				$("#spacesdisplay>dd>span").removeClass("cancleselectspace");
				return;
			}
			for(var i=0;i<allSelects.length;i++){
				tempselectsku=$(allSelects[i]);
				index=parseInt(tempselectsku.attr("index"));
				tid=tempselectsku.attr("tid");
				sku[index]=tid;
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
			
			var regstr;
			var validsku;
			
			var tempsku;
			var tempskus=[];
			var tempele="";
			var tempreg;
			var temptidreg;
			for(var i=0;i<space.length;i++){
				tempselectsku=$(space[i]);
				index=parseInt(tempselectsku.attr("index"));
					temptidreg=regexskustemp.slice();
					temptidreg[index]="\\d+";
					regstr="(?=[,^]?)"+temptidreg.join("_")+"(?=[,$]?)"; 
					validsku=product.join(",").match(new RegExp(regstr,"g"));
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
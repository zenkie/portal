
	var Slider = function(opt){

		this.container = jQuery(opt.container).eq(0);
		this.btnItem = this.container.find(opt.btnItem || 'ol').eq(0);
		this.btns = this.btnItem.children();
		this.listItem = this.container.find(opt.listItem || 'ul').eq(0);
		this.lists = this.listItem.children();

		this.next = this.container.find(opt.next || '.next');
		this.prev = this.container.find(opt.prev || '.prev');

		this.now = 0, this.iPrev = 0;
		this.activei=-1;
	};

	Slider.prototype.init = function(){

		this.lists.each(function(i){

			if(i == 0)
				jQuery(this).css('left', '0');
			else
				jQuery(this).css('left', '100%')

		});

		this.arrowEvent();
		this.setBtnEvent();
		//this.setMouseEvent();
	};
	Slider.prototype.setBtnEvent = function(event){

		var oThis = this;

		this.btns.click(function(){

			var _index = jQuery(this).index();

			if(_index == oThis.now)return;
			oThis.lists.eq(oThis.now).find("li span").removeClass("hover");
			oThis.now = _index;
			//oThis.activei=-1;
			oThis.tab();
		});
	};
	Slider.prototype.tab = function(){

		if(this.btns[0]){
			this.btns.removeClass('active');

			this.btns.eq(this.now).addClass('active');	
		}
		

		if(this.now > this.iPrev ){
			this.lists.eq(this.now).css('left', '100%');
			this.lists.eq(this.iPrev).animate({ left : '-100%' });
		}
		else if( this.now < this.iPrev){
			this.lists.eq(this.now).css('left', '-100%');
			this.lists.eq(this.iPrev).animate({ left : '100%' });
		};

		this.lists.eq(this.now).animate({ left : '0%' });

		this.iPrev = this.now;

	};
	Slider.prototype.click = function(){

		this.setBtnEvent('click');

	};
	Slider.prototype.arrowEvent = function(){

		var oThis = this;

		oThis.next.click(function(){

			oThis.fnNext();

		});
		oThis.prev.click(function(){

			oThis.fnPrev();

		});

	};
	Slider.prototype.fnNext = function(){
		/*var span=jQuery("span[class*=hover]",this.lists.eq(this.now)).not("[class*=bg_none]");
		var index= span.index();
		index+=1;
		if(index>=this.lists.eq(this.now).find("span").not("[class*=bg_none]").size()){return false;}
		this.activei=index;
		this.lists.eq(this.now).find("span").removeClass("hover");
		this.lists.eq(this.now).find("span").eq(index).addClass("hover");

		//jQuery("#big_frame .menu_show_main li").eq(this.now).find("span").removeClass("hover");
		//jQuery("#big_frame .menu_show_main li").eq(this.now).eq(index).addClass("hover");*/
		if(this.now == this.lists.length - 1){
			return;//this.now = 0;
		}
		else{
			this.now++;
		}
		this.tab();
	};
	Slider.prototype.fnPrev = function(){
		/*var span=jQuery("span[class*=hover]",this.lists.eq(this.now)).not("[class*=bg_none]");
		var index= span.index();
		if(index<0){index=this.lists.eq(this.now).find("span").not("[class*=bg_none]").size();}
		index-=1;
		if(index<0){return false;}
		this.activei=index;
		this.lists.eq(this.now).find("span").removeClass("hover");
		this.lists.eq(this.now).find("span").eq(index).addClass("hover");*/
		
		if(this.now == 0){
			return;//this.now = this.lists.length - 1;
		}
		else{
			this.now--;
		};
		this.tab();
	};
	Slider.prototype.setMouseEvent=function(){
		var oThis = this;
		
		/*this.lists.find("li").unbind("mouseover").bind("mouseover",function(){
			oThis.lists.find("li").eq(oThis.now).find("span").removeClass("hover");
			return false;
		});
		this.lists.unbind("mouseout").bind("mouseout",function(){
			oThis.lists.eq(oThis.now).find("span").eq(oThis.activei).addClass("hover");
			return false;
		});*/
		
		this.listItem.children().find("span").not("[class*=bg_none]").unbind("mouseover").bind("mouseover",function(){
			oThis.lists.eq(oThis.now).find("span").removeClass("hover");
		});
		this.listItem.children().find("span").not("[class*=bg_none]").unbind("mouseout").bind("mouseout",function(){
			if(oThis.activei<0){return;}
			oThis.lists.eq(oThis.now).find("span").eq(oThis.activei).addClass("hover");
		});
	}
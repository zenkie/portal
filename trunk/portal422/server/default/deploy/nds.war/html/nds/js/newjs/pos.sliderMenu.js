
	var SliderMenu = function(opt){		
		this.btnContainer = jQuery(opt.btnContainer);
		this.btns = this.btnContainer.find(opt.btns || 'li');
		this.listContainer = jQuery(opt.listContainer);
		this.lists = this.listContainer.find(opt.lists || 'div');
		this.now = 0, 
		this.iPrev = 0;
		this.init();
	};

	SliderMenu.prototype.init = function(){

		this.lists.each(function(i){
			if(i == 0)
				jQuery(this).css('left', '0');
			else
				jQuery(this).css('left', '100%');
		});
		// if(this.btns.length == 0){
			// this.btnContainer.find("ul").append("<li>1</li>");
			// this.btns = this.btnContainer.find(opt.btns || 'li');
		// }
		jQuery(this.btns[0]).addClass('menu_num_active');
		this.setBtnEvent();
	};
	SliderMenu.prototype.setBtnEvent = function(event){
		var oThis = this;
		this.btns.click(function(){
			var _index = jQuery(this).index();
			if(_index == oThis.now)return;
			oThis.now = _index;
			oThis.tab();
		});
	};
	SliderMenu.prototype.tab = function(){

		if(this.btns[0]){
			this.btns.removeClass('menu_num_active');
			this.btns.eq(this.now).addClass('menu_num_active');	
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
	SliderMenu.prototype.click = function(){
		this.setBtnEvent('click');
	};
SliderMenu.main = function(){
	opt = {
		btnContainer:".change_menu-mid_main-num",
		btns: "li",
		listContainer: ".change_menu-mid_main",
		lists: ".change_content",			
	};		
	new SliderMenu(opt);
};
jQuery(document).ready(SliderMenu.main);
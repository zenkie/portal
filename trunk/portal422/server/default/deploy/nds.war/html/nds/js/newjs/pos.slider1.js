var Slider = function(opt){

	this.container = jQuery(opt.container).eq(0);
	
	if(opt.listItem.charAt(0) == '#'){
		this.listItem = jQuery(opt.listItem);
	}
	else{
		this.listItem = this.container.find(opt.listItem || 'ul').eq(0);
	};
	this.lists = this.listItem.children();

	this.nextBtn = this.container.find(opt.next || '.next');
	this.prevBtn = this.container.find(opt.prev || '.prev');

	this.prev = 0;
	this.now = 0;
};
Slider.prototype.init = function(){

	this.lists.each(function(i){

		if(i == 0)return;

		jQuery(this).css('left', '100%')

	});

	if(this.prevBtn[0]){	
		this.arrowEvent();
	};
};
Slider.prototype.tab = function(){

	if(this.now > this.prev ){
		this.lists.eq(this.now).css('left', '100%');
		this.lists.eq(this.prev).animate({ left : '-100%' });
	}
	else if( this.now < this.prev){
		this.lists.eq(this.now).css('left', '-100%');
		this.lists.eq(this.prev).animate({ left : '100%' })
	};

	this.lists.eq(this.now).animate({ left : '0%' });

	this.prev = this.now;

};
Slider.prototype.arrowEvent = function(){

	var oThis = this;

	oThis.nextBtn.click(function(){

		oThis.fnNext();

	});
	oThis.prevBtn.click(function(){

		oThis.fnPrev();

	});

};
Slider.prototype.fnNext = function(){

	if(this.now == this.lists.length - 1){
		return;//this.now = 0;
	}
	else{
		this.now++;
	};

	this.tab();

};
Slider.prototype.fnPrev = function(){

	if(this.now == 0){
		return;//this.now = this.lists.length - 1;
	}
	else{
		this.now--;
	};

	this.tab();

};
Slider.prototype.autoPlay = function(){

	var oThis = this;
	var timer = null;

	function auto(){

		timer = setInterval(function(){

			oThis.fnNext();

		},4500);

	};
	auto();

	oThis.container.mouseover(function(){
		clearInterval(timer);
	});
	oThis.container.mouseout(function(){
		auto();
	});

};
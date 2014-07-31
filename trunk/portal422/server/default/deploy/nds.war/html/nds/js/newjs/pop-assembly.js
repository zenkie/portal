var PopAssembly = function(opt){
	this.container = jQuery(opt.container).eq(0); 
	this.lessenBtn = this.container.find(opt.lessenBtn || '.lessen_btn'); //最小化按钮
	this.amplifyBtn = this.container.find(opt.amplifyBtn || '.amplify_btn'); //最大化按钮
	this.closeBtn = this.container.find(opt.closeBtn || '.close_btn'); //关闭按钮

	this.containerParent = this.container.parent();
};
PopAssembly.prototype.init = function(){
	this.shrinkBtnFn();
	this.addClick();

	this.container.data('oldSize', {
		width : this.container.width(),
		height : this.container.height()
	});
};
PopAssembly.prototype.addClick = function(){
	var _this = this;
	_this.container.data('isAmplify',false);

	this.lessenBtn.click(function(){
		_this.lessenFn();
	});
	this.amplifyBtn.click(function(){
		_this.amplifyFn();
	});
	this.closeBtn.click(function(){
		_this.closeFn();
	});
};
PopAssembly.prototype.shrinkBtnFn = function(){
	var url = "http://www.miaov.com/images/quirkyPopupShowBtn.gif";
	var _this = this;

	this.shrinkBtn = jQuery('<div><img src='+ url +' /></div>').appendTo('body').css({
		position : 'absolute',
		left : -35, top: 0,
		width : 35, height : 64,
		transition : 'left .4s ease',
		overflow : 'hidden', cursor : 'pointer'
	});
	this.shrinkBtn.click(function(){
		_this.containerParent.slideDown(function(){
			_this.shrinkBtn.css({ left : -35});
		});
	});
};
PopAssembly.prototype.lessenFn = function(){
	var _this = this;
	this.containerParent.slideUp(function(){
		_this.shrinkBtn.css({ left : 0 });
	});
};
PopAssembly.prototype.amplifyFn = function(){
	var _this = this;
	var isAmplify = _this.container.data('isAmplify');

	if(!isAmplify){
		_this.container.css({
			width : '100%', height : '100%'
		});
	}
	else{
		_this.container.css(_this.container.data('oldSize'));
	}
	_this.container.data('isAmplify',!isAmplify);
};
PopAssembly.prototype.closeFn = function(){
	var _this = this;

	this.containerParent.css('opacity', '0');
	setTimeout(function(){
		_this.containerParent.hide();
	},666)
};
/*      需要引入静态limits类还有  drag类   */
var ScrollDrag = function(opt){

	this.container = jQuery(opt.container).eq(0);

	this.scrollBtnY = this.container.find(opt.scrollBtnY || ''); //Y轴的按钮
	this.scrollBtnX = this.container.find(opt.scrollBtnX || ''); //X轴的按钮

	this.scrollWindow = this.container.find(opt.scrollWindow || ''); //滚动的窗口
	if(this.scrollWindow.scrollHeight>this.scrollWindow.innerHeight){
		this.init();
	}
};
ScrollDrag.prototype.init = function(){ //初始化
	this.top();
};
ScrollDrag.prototype.top = function(){ //Y轴滚动方法

	this.windowMaxT = this.scrollWindow[0].scrollHeight - this.scrollWindow.innerHeight();
	
	var _this = this;

	this.bindDrag(this.scrollBtnY,function(l,t,maxL,maxT){
		//console.log(_this.scrollWindow[0].scrollHeight - _this.scrollWindow.innerHeight());
		_this.scrollWindow.scrollTop(  t / maxT *  (_this.scrollWindow[0].scrollHeight - _this.scrollWindow.innerHeight()));
		//_this.scrollWindow[0].scrollTop=100;
		//console.log(t/maxT+":"+_this.scrollWindow[0].scrollHeight+":"+_this.scrollWindow.innerHeight()+":"+(t / maxT *  (_this.scrollWindow[0].scrollHeight - _this.scrollWindow.innerHeight())));
	});

};
ScrollDrag.prototype.left = function(){	//X轴滚动方法

	this.windowMaxL = this.scrollWindow[0].scrollWidth - this.scrollWindow.innerWidth();

	var _this = this;

	this.bindDrag(this.scrollBtnX,function(l,t,maxL,maxT){

		_this.scrollWindow.scrollLeft(  l / maxL *  _this.windowMaxL);

	});

};
ScrollDrag.prototype.bindDrag = function(obj,fnMove){ //加拖拽

	var oDrag = new Drag({
			container : obj,
			fnMove : fnMove
		});
		oDrag.init();
	this.bindScroll( obj, oDrag.maxT);
};
ScrollDrag.prototype.bindScroll = function(obj,objMaxT){

	var _this = this;
	
	function mouseWheel(ev){
		var scrollTop = _this.scrollWindow.scrollTop();
		var oEvent = ev||event;
		var bDown = true;

		
		bDown=oEvent.wheelDelta?oEvent.wheelDelta<0:oEvent.detail>0;
		if(bDown && scrollTop >= 0){
			_this.scrollWindow.scrollTop(scrollTop+=10);
		}
		else if(!bDown && scrollTop >0){
			//scrollTop-=10;
			_this.scrollWindow.scrollTop(scrollTop-=10);
		}
		var t = scrollTop / (_this.scrollWindow[0].scrollHeight - _this.scrollWindow.innerHeight()) *  objMaxT;

		if(t<=0){t=0;}
		else if(t>=objMaxT){
			t=objMaxT;
		}
		obj.css('top',  t);
		if(oEvent.preEventDefault){
			oEvent.preEventDefault();
		}
		return false;
	};
		//_this.scrollWindow.bind('mousewheel', mouseWheel);
		//_this.scrollWindow.bind('DOMMouseScroll',mouseWheel);
		_this.scrollWindow[0].addEventListener('DOMMouseScroll',mouseWheel,false);
		_this.scrollWindow[0].addEventListener('mousewheel',mouseWheel,false);
};
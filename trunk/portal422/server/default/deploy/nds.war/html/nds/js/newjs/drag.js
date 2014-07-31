
var Drag = function(opt){

	this.obj = jQuery(opt.container);
	this.width = this.obj.innerWidth();
	this.height = this.obj.innerHeight();

	this.parent = this.obj.offsetParent();
	this.parentWidth = this.parent.innerWidth();
	this.parentHeight = this.parent.innerHeight();

	this.maxL = opt.maxL || this.parentWidth - this.width;;
	this.minL = opt.minL || 0;
	this.maxT = opt.maxT || this.parentHeight - this.height;
	this.minT = opt.minT || 0;
	this.fnMove = opt.fnMove || null;
	this.fnUp = opt.fnUp || null;
	this.fnDown = opt.fnDown || null;

};

Drag.prototype.init = function(){
	this.mousedown();
}
Drag.prototype.mousedown = function(){

	var oThis = this;

	oThis.obj.mousedown(function(ev){
		
		oThis.seconds = new Date().getTime();

		if(oThis.fnDown)oThis.fnDown.call(oThis.obj);

		
		
		oThis.disX = ev.pageX - oThis.obj.position().left;
		oThis.disY = ev.pageY -oThis.obj.position().top;


		if(oThis.obj[0].setCapture){
			oThis.obj[0].setCapture();
		}
		oThis.mousemove();
		oThis.mouseup();

		return false;	
	});
	
};
Drag.prototype.mousemove = function(){

	var oThis = this;
	jQuery(document).mousemove(function(ev){

			var l = ev.pageX - oThis.disX;
			var t = ev.pageY - oThis.disY;
			var left = limits(l, oThis.maxL , oThis.minL || 0 );
			var top = limits(t, oThis.maxT ,oThis.minT || 0 );

			oThis.obj.css({

				left : left,
				top : top

			});
			if(oThis.fnMove)oThis.fnMove.call(oThis.obj,left,top,oThis.maxL,oThis.maxT);
	});

};
Drag.prototype.mouseup = function(){
	
	var oThis = this;
	
	jQuery(document).mouseup(function(){

		oThis.obj.data('timer', new Date().getTime()- oThis.seconds);
		
		if(oThis.obj[0].releaseCapture){
			oThis.obj[0].releaseCapture();
		}
		jQuery(document).unbind('mousemove');
		jQuery(document).unbind('mouseup');

		if(oThis.fnUp)oThis.fnUp.call(oThis.obj);
	});

};

Drag.prototype.changeIndex = function(){

	var oThis = this;

	document.zIndex = 2;

	oThis.obj.mousedown(function(){

		this.style.zIndex = document.zIndex++;

	});

};
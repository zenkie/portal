var getViewSize = function(obj,arrNearObjs){

	var viewHeight = jQuery(window).height();

	jQuery.each(arrNearObjs, function(){

		viewHeight -= this;

	});

	jQuery(obj).eq(0).height(viewHeight);
};
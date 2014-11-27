/*
 * jQuery UI Multilevel Accordion v.1
 * 
 * 风琴菜单 2014-10-20
 *
 */

//plugin definition
(function($){
    $.fn.extend({

    //pass the options variable to the function
    accordion: function(options) {
        
		var defaults = {
			accordion: 'true',
			speed: 500
		};

		// Extend our default options with those provided.
		var opts = $.extend(defaults, options);
		//Assign current element to variable, in this case is UL element
 		var $this = $(this);

  		$this.find("li a").click(function() {
  			if($(this).parent().find("ul").size() != 0){
  				if(opts.accordion){
  					//Do nothing when the list is open
  					if(!$(this).parent().find("ul").is(':visible')){
  						parents = $(this).parent().parents("ul");
  						//visible = $this.find("ul:visible");
						visible = $this.find("ul:visible,ul.hide-ul");
  						visible.each(function(visibleIndex){
  							var close = true;
  							parents.each(function(parentIndex){
  								if(parents[parentIndex] == visible[visibleIndex]){
  									close = false;
  									return false;
  								}
  							});
  							if(close){
								//收缩样式变化
								$(this).parent().removeClass("active");
								$(this).parent().find(">a").removeClass("active");
							
  								if($(this).parent().find("ul") != visible[visibleIndex]){
  									$(visible[visibleIndex]).slideUp(opts.speed);
  								}
  							}
  						});
  					}
					//if($(this).parent().find("ul:first").is(":visible") || (!$(this).parent().find("ul:first").is(":visible") && $(this).parent().hasClass("active"))){
					if($(this).parent().find("ul:first").is(":visible")){	
						$(this).parent().find("ul:first").slideUp(opts.speed);
						
						//收缩样式变化
						$(this).parent().removeClass("active");
						$(this).removeClass("active");  					
					}else{
						$(this).parent().find("ul:first").slideDown(opts.speed);
						
						//展开样式变化
						$(this).parent().addClass("active");
						$(this).addClass("active");
					}
  				}else{
					var _clickElement = $(this);
					$this.find(">li").each(function(){
						if(_clickElement.parent()[0] != $(this)[0]){
							$(this).removeClass("active");
							$(this).find(">a").removeClass("active");
						}						
					});
					_clickElement.parent().toggleClass("active");
					_clickElement.toggleClass("active");
				}
  				
  			}else{
				var _clickElement = $(this);
				if(!opts.accordion){
					$this.find(">li").removeClass("active");
					$this.find(">li>a").removeClass("active");
					$this.find(">li>ul").hide();
					_clickElement.closest("ul").parent().addClass("active");
					_clickElement.closest("ul").parent().find(">a").addClass("active");
					_clickElement.closest("ul").show();
				}				
				_clickElement.closest("ul").find("li").each(function(){
					if(_clickElement.parent()[0] != $(this)[0]){
						$(this).removeClass("active");
					}					
				});
				_clickElement.parent().toggleClass("active");
			}
  		});
		return {
			setAccordion:function(){
				opts.accordion = !opts.accordion;
				return opts.accordion;
			}
		};
    }
});
})(jQuery);
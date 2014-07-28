(function ($) {
    var defaults = {
        x: 22,
        y: 20
    };

    var bindevt = function(obj,opts){
        obj.hover(function(e){
        $("body").append('<p id="bigimage"><img src="'+ this.href + '" alt="" /></p>');
        $(this).find('img').stop().fadeTo('slow',0.5); 
        widthJudge(e,opts);
        $("#bigimage").fadeIn('slow');
        },function(){
        $(this).find('img').stop().fadeTo('slow',1);
        $("#bigimage").remove();
        }); 
    
        obj.mousemove(function(e){
        //widthJudge(e,opts);
        }); 
    }

    var widthJudge = function(e,opts){
        //alert(opts);
        var marginRight = document.documentElement.clientWidth - e.pageX; 
        var theight=e.pageY-e.offsetY-opts.y;
        var viewhight=(document.documentElement.clientHeight-theight<$("#bigimage").height())?(document.documentElement.clientHeight-$("#bigimage").height()):(e.pageY - opts.y);
        //alert(e.pageY-e.offsetY);
        var imageWidth = $("#bigimage").width();
        if(marginRight < imageWidth)
        {
            x = imageWidth + 22;
            $("#bigimage").css({top:(viewhight ) + 'px',left:(e.pageX - opts.x ) + 'px'}); 
        }else{
            x = 22;
            $("#bigimage").css({top:(viewhight) + 'px',left:(e.pageX + opts.x ) + 'px'});
        };  
    }

    $.fn.imgShowPop = function (options) {
        var options = $.extend(defaults, options);
        return this.each(function () {
            var opts = options;
            var $this=$(this);
            bindevt($this,opts);
        });
    }
})(jQuery);
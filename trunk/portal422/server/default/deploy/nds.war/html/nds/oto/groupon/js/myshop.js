jQuery(function () {
    var x = 10;
    var y = 20;
    jQuery("a.tooltip").mouseover(function (e) {
        this.myTitle = this.title;
        this.title = "";
        var imgTitle = this.myTitle ? "<br/>" + this.myTitle : "";
        var tooltip = "<div id='tooltip'><img src='" + this.href + "' alt='产品预览图'/>" + imgTitle + "<\/div>"; //创建 div 元素
        jQuery("body").append(tooltip); //把它追加到文档中						 
        jQuery("#tooltip")
			.css({
			    "top": (e.pageY + y) + "px",
			    "left": (e.pageX + x) + "px"
			}).show("fast");   //设置x坐标和y坐标，并且显示
    }).mouseout(function () {
        this.title = this.myTitle;
        jQuery("#tooltip").remove();  //移除 
    }).mousemove(function (e) {
        jQuery("#tooltip")
			.css({
			    "top": (e.pageY + y) + "px",
			    "left": (e.pageX + x) + "px"
			});
    });
});
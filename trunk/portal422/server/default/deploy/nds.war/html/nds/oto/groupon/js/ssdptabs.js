(function (jQuery) {
    jQuery.fn.ssdptabs = function () {
        var jQuerywarp = jQuery(this);

        var tab = jQuerywarp.find("a.tag-panel-title");

        jQuerywarp.children(".tag-panel-content1").children("div").hide();
        jQuerywarp.children(".tag-panel-content1").children("div").eq(0).show();
        tab.eq(0).addClass("tag-panel-iscurrent");

        tab.click(function () {
            var a = jQuery(this);
            tab.removeClass("tag-panel-iscurrent");
            a.addClass("tag-panel-iscurrent");
            var name = a.attr("rel");
            jQuerywarp.children(".tag-panel-content1").children("div").hide();
            jQuery("" + name).show();
        });
    }
})(jQuery);
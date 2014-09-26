//图片延时加载工具
(function (ev) {
    if (ev.ImageDelay) { return; }

    function ImageDelay() { }

    var P = ImageDelay.prototype;

    P.Config = { scroll: true, uRL: 'data-src', loadCls: 'my-delay-picture', holder: false };
    P.Pictures = null;
    //延迟加载渲染
    P.Render = function (selector) {
		var cfg = this.Config;
        this.Search(selector);
        if (cfg.scroll == true) {
            this.DynamicRender();
        } else {
            this.StaticRender();
        }
    }
    //清空已经搜索的
    P.Clear = function () {
        this.Pictures = null;
    }
    //延迟加载方式一:静态渲染 非省流量模式
    P.StaticRender = function () {
        this.ImageRealURLRender(this.Pictures);
    }
    //延迟加载方式二:动态渲染 当指定图片出现在当前滚动页面后 才加载图片
    P.DynamicRender = function () {
        if (!this.isScrolled) {
            var body = jQuery(document.body);
            if (body.length > 0) {
                var self = this;
                this.isScrolled = true;
                jQuery(window).scroll(function () { setTimeout(function () { self.Scrolling(); }); });
            }
        }
        this.Scrolling();
    }
    //当窗体滚动滚动条时自动检测需要加载的图片
    P.Scrolling = function () {
        var wn = jQuery(window);
        var viewAreaTop = wn.scrollTop();
        this.min = viewAreaTop;
        var viewAreaBottom = this.max = viewAreaTop + window.innerHeight;
        var pictures = this.Pictures;
        var nPictures = [];
        var image = null;
        var bounds = { top: viewAreaTop, bottom: viewAreaBottom };
        for (var i = 0, k = pictures.length; i < k; i++) {
            image = pictures[i];
            if (!this.InViewAreaRender(bounds, image)) {
                nPictures.push(image);
            }
        }
        this.Pictures = nPictures;
    }
    //获取指定距离页面的上边距
    P.GetOffsetTop = function (element) {
        var top = 0;
        var doc = document;
        if (element == null) {
            return top;
        }
        if (element.getBoundingClientRect) {
            return element.getBoundingClientRect().top + (doc.documentElement.scrollTop || doc.body.scrollTop);
        }
        var top = element.offsetTop;
        var p = element.offsetParent;
        while (p) {
            top = top + p.offsetTop;
            p = p.offsetParent;
        }
        return top;
    }
    //渲染当前可用图片
    P.InViewAreaRender = function (bounds, image) {
        if (image == null || image.parentElement == null) { return true; }
        bounds = bounds || { top: 0, bottom: 0 };
        var myTop = this.GetOffsetTop(image);
        if (myTop >= bounds.top && myTop <= bounds.bottom) {
            this.ImageRealURLRender(image);
            return true;
        } else {
            return false;
        }
    }
    //创建一个标准延迟加载的img标签
    //uRL:图片地址 id:img标签的id cls:img标签的样式
    P.CreatePicture = function (uRL, id, cls) {
        var cfg = this.Config;
        cls = cfg.loadCls + " " + cls;
        return '<img id="' + id + '" src="" ' + cfg.uRL + '="' + uRL + '" class="' + cls + '"/>';
    }
    //搜索延迟加载图片
    P.Search = function (selector) {
        var cfg = this.Config;
        var contaienr = selector == null ? jQuery(document.body) : jQuery(selector);
        var pics = this.Pictures;
        if (pics == null) {
            this.Pictures = contaienr.find("img[" + cfg.uRL + "]");
        } else {
            this.Pictures = jQuery.merge(this.Pictures, contaienr.find("img[" + cfg.uRL + "]"));
        }
        jQuery(this.Pictures).addClass(cfg.loadCls).attr("src", "/html/nds/oto/webapp/product/images/background.png");
    }
    //加载多张图片
    P.ImageRealURLRender = function (images) {
        images = images.length == null ? [images] : images;
        if (images.length > 0) {
            var cfg = this.Config;
            var img = null;
            var picture = "";
            var p = this.Config.uRL;
            for (var i = 0, k = images.length; i < k; i++) {
                this.ImageRender(images[i], p, cfg.loadCls);
            }
        }
    }
    //记载指定图片
    P.ImageRender = function (image, p, loadCls) {
        if (image == null) { return; }
        var img = jQuery(image);
        var picture = img.attr(p);
        img.removeAttr(p);
        var config = this.Config;
        var holder = null;
        if (config.holder) {
            img.hide();
            holder = $('<div class="my-delay-holder"><div class="holder-animate"></div></div>');
            holder.insertBefore(image);
        }
        img.attr("src", picture);
        image.onload = function () {
            image.onload = null;
            if (holder) { img.show(); holder.remove(); }
            img.removeClass(loadCls);
            img = image = picture = null;
        }
    }
    ImageUtil = new ImageDelay();

    jQuery(function () { ImageUtil.Render(); });

}(window));
$(function(){$("#lay_head")[0].scrollIntoView();});

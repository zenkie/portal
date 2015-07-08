
/*****************************************************************
 * 名称：Portal 主题全局脚本对象
 * 日期：2015-04-16
 * 版本：0.0.1
 * 描述：Beven
 ****************************************************************/
(function (env) {
    if (env.PortalTheme) { return; }

    var ThemeClass = function () { }
    var myGlobal = env.PortalTheme = new ThemeClass();

    var Confiurature = { PlayAnimation: false };

    //切换动画列表
    var animationCss = [
        { inCss: 'translateFromTop', outCss: 'translateToBottom' },
        { inCss: 'translateFromRight', outCss: 'translateToLeft' },
        { inCss: 'translateFromBottom', outCss: 'translateToTop' },
        { inCss: 'translateFromLeft', outCss: 'translateToRight' },
        { inCss: 'scaleUpFadeIn', outCss: 'scaleDownFadeOut' },
        { inCss: 'rotateSlideLeftIn', outCss: 'rotateSlideRightOut' },
        { inCss: 'rotateSlideRightIn', outCss: 'rotateSlideLeftOut' },
        { inCss: 'rotateSlideUpIn', outCss: 'rotateScaleUpOut' },
        { inCss: 'rotateSlideDownIn', outCss: 'rotateScaleDownOut' }
    ];

    /**
     * 名称：验证指定数据是否为指定类型
     */
    ThemeClass.prototype.IsType = function (o, type) {
        return Object.prototype.toString.apply(o) == '[object ' + type + ']';
    }

    /**
    * 名称：验证指定数据是否为函数
    */
    ThemeClass.prototype.IsFunction = function (o) {
        return this.IsType(o, 'Function');
    }

    /**
     * 名称：body加载完毕指定指定事件
     */
    ThemeClass.prototype.Ready = function (handler) {
        this.addEventListener(window, 'load', handler);
    }

    /**
     * 名称：绑定指定元素播放动画结束事件
     */
    ThemeClass.prototype.OnceAnimationed = function (element, handler) {
        AnimationMiddler.OnceAnimationed(element, handler);
    }

    /**
     * 名称：开始一个定时动画
     */
    ThemeClass.prototype.Animation = function (handler) {
        var animationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame;
        if (animationFrame == null) {
            animationFrame = function (a) {
                return window.setTimeout(a, 1e3 / 60)
            }
        }
        animationFrame(handler);
    }

    /**
     * 名称：取消指定动画
     */
    ThemeClass.prototype.CancelAnimation = function () {
        var animationFrame = window.cancelAnimationFrame || window.webkitCancelAnimationFrame || window.mozCancelAnimationFrame;
        if (animationFrame == null) {
            animationFrame = function (a) {
                window.clearTimeout(a);
            }
        }
    }

    /**
     * 名称：阻止事件冒泡
     */
    ThemeClass.prototype.StopPropagation = function (ev) {
        if (ev == null) { return; }
        if (ev.stopPropagation) {
            ev.stopPropagation();
        }
        ev.cancelBubble = true;
    }

    /**
     * 名称：阻止事件默认行为
     */
    ThemeClass.prototype.PreventDefault = function (ev) {
        if (ev == null) { return; }
        if (ev.preventDefault) {
            ev.preventDefault();
        }
    }

    /**
     * 名称：添加不重复的事件函数
     */
    ThemeClass.prototype.addUniqueEventListener = function (element, name, handle) {
        this.removeEventListener(element, name, handle);
        this.addEventListener(element, name, handle);
    }

    /**
     * 名称：为指定元素添加指定事件
     */
    ThemeClass.prototype.addEventListener = function (element, name, handle) {
        if (element == null) {
            return;
        }
        if (element.addEventListener) {
            element.addEventListener(name, handle);
        } else if (element.attachEvent) {
            element.attachEvent('on' + name, handle);
        } else if (element['on' + name]) {
            element['on' + name] = handle;
        }
    }

    /**
     * 名称：判断指定元素是否有动画
     */
    ThemeClass.prototype.IsAnimation = function (element) {
        var v = this.GetStyle(element, 'animation');
        if (v == null) {
            v = this.GetStyle(element, '-webkitAnimationName');
        }
        if (v == null) {
            v = this.GetStyle(element, '-mozAnimationName');
        }
        return v != null && v != "" && v != "none";
    }
    //获取指定元素的指定样式值
    ThemeClass.prototype.GetStyle = function (obj, attr) {
        if (obj.currentStyle) {
            return obj.currentStyle[attr];
        }
        else {
            var s = document.defaultView.getComputedStyle(obj, null);
            return s == null ? null : s[attr];
        }
    }

    //检验指定参数是否为空
    ThemeClass.prototype.IsNullOrWhitesapce = function (v) {
        v = v || "";
        v = v.replace(/\s/g, "");
        return v == "";
    }

    /**
     * 名称：为指定元素添加取消指定事件
     */
    ThemeClass.prototype.removeEventListener = function (element, name, handle) {
        if (element == null) {
            return;
        }
        if (element.removeEventListener) {
            element.removeEventListener(name, handle);
        } else if (element.detachEvent) {
            element.detachEvent('on' + name, handle);
        } else if (element['on' + name]) {
            element['on' + name] = null;
        }
    }

    /**
     * 往指定元素中添加一个加载效果
     */
    ThemeClass.prototype.createLoading = function (container) {
        var ec = jQuery('<div class="loading-bouble-wrap"><div class="loading-boule"></div></div>');
        container.append(ec);
        return ec;
    }

    /**
     * 名称：是否播放弹出窗口动画，如果不执行则直接调用回掉函数，并且返回
     */
    ThemeClass.prototype.IsPlayAnimation = function (callback) {
        if (Confiurature.PlayAnimation != true) {
            setTimeout(function () {
                callback && callback();
            });
            return false;
        } else {
            return true;
        }
    }

    /**
     * 名称:播放Portal弹出框载入动画
     * @param modal 弹出窗口最外层元素
     * @param config 默认配置 {inCss:'',outCss:''}
     * @param callback 播放动画完毕后的回调函数
     */
    ThemeClass.prototype.PlayModalInAnimation = function (modal, config, callback) {
        try {
            if (!this.IsPlayAnimation(callback)) { return; }
            modal = GetJqueryElement(modal);
            var apa = null;
            if (config && config.inCss) {
                apa = config;
            } else {
                //随机获取一个入场动画
                var num = GetRandomAnimation();
                modal.attr("data-animation-index", num);
                apa = GetAnimationParams(num);
            }
            if (!this.SupportCSS3Animation()) {
                //如果不支持CSS3动画
                return this.PlayModalInAnimationNoCSS3(modal, apa, callback);
            }
            //添加3d效果
            this.Go3dAnimationRender(modal);
            //播放入场动画
            AnimationMiddler.AnimationInOut(modal[0], apa.inCss, apa.outCss, callback);
        } catch (ex) {
            this.Log(ex.message);
            callback && callback();
        }
    }

    /**
     * 名称:播放Portal 弹出框关闭动画
     * @param modal 弹出窗口最外层元素
     * @param config 默认配置 {inCss:'',outCss:''}
     * @param callback 播放动画完毕后的回调函数
     */
    ThemeClass.prototype.PlayModalOutAnimation = function (modal, config, callback) {
        try {
            if (!this.IsPlayAnimation(callback)) { return; }
            modal = GetJqueryElement(modal);
            var apa = null;
            if (config && config.inCss) {
                apa = config;
            } else {
                var num = modal.attr("data-animation-index");
                apa = GetAnimationParams(num);
            }
            if (!this.SupportCSS3Animation()) {
                //如果不支持CSS3动画
                return this.PlayModalOutAnimationNoCSS3(modal, apa, callback);
            }
            AnimationMiddler.AnimationInOut(modal[0], apa.outCss, apa.inCss, callback);
        } catch (ex) {
            this.Log(ex.message);
            callback && callback();
        }
    }

    /**
     * 名称：显示一个top window的加载条
     * @param message 要显示的提示信息 默认为：‘请稍后...'
     */
    ThemeClass.prototype.ShowLoading = function (message) {
        message = message || '请稍后...';
        var topWindow = top;
        var topLoadingProcess = topWindow.__loadingProcess;
        if (topLoadingProcess == null) {
            var TipClass = top.PortalTheme.Tip.constructor;
            topLoadingProcess = topWindow.__loadingProcess = new TipClass(-1);
        }
        topLoadingProcess.Message(message, 'tip-loading', -1);
    }
    /**
     * 名称：关闭top wnidow的加载条
     */
    ThemeClass.prototype.CloseLoading = function () {
        var topWindow = top;
        var topLoadingProcess = topWindow.__loadingProcess;
        if (topLoadingProcess) {
            topLoadingProcess.Hidden();
        }
    }

    /**
     * 名称：在不支持CSS3的浏览器播放模态窗口入场动画
     */
    ThemeClass.prototype.PlayModalInAnimationNoCSS3 = function (modal, config, callback) {
        //这里入场动画默认使用自定义的动画库播放入场动画
        if (!OriginAnimation.IsOriginAnimation(config.inCss)) {
            config = animationCss[0];
            modal.attr("data-animation-index", 0);
        }
        OriginAnimation.PlayAnimation(modal, config.inCss, callback, 400);
    }

    /**
     * 名称：在不支持CSS3的浏览器下播放模块窗口退场动画
     */
    ThemeClass.prototype.PlayModalOutAnimationNoCSS3 = function (modal, config, callback) {
        OriginAnimation.PlayAnimation(modal, config.outCss, callback, 400);
    }

    /**
     * 名称：判断浏览器是否支持CSS3动画
     */
    ThemeClass.prototype.SupportCSS3Animation = function () {
        return AnimationMiddler.SupportCSS3Animation();
    }


    /**
     * 名称:使指定元素支持Css3 d3效果
     */
    ThemeClass.prototype.Go3dAnimationRender = function (element) {
        var target = jQuery(element);
        if (!target.is(".animation3d")) {
            target.addClass("animation3d");
        }
        target.parent().addClass("animation3dparent");
    }

    /**
     * 输出日志到控制台
     */
    ThemeClass.prototype.Log = function (message) {
        if (console) {
            console.log(message);
        }
    }

    function GetJqueryElement(maybeJquery) {
        if (maybeJquery instanceof jQuery) {
            return maybeJquery;
        } else {
            return jQuery(maybeJquery);
        }
    }

    //根据获取的随机动画数字获取对应的动画参数对象
    function GetAnimationParams(num) {
        num = num || 0;
        return animationCss[num] || { inCss: 'noCss', outCss: 'noCss' };
    }

    var num = -1;
    //获取一个动画随机数
    function GetRandomAnimation() {
        var max = (animationCss.length - 1) | 1;
        //var max = animationCss.length;
        //num = num >= max ? 0 : (num + 1);
        var num = parseInt(Math.random() * max);
        return num;
    }

    /*简单消息提示*/
    function TipUtils(timeout, tipPositionCls) {
        this.Init(timeout, tipPositionCls);
    }
    TipUtils.prototype.tipPositionCls = "tip-right";
    TipUtils.prototype.timeout = 2000;
    TipUtils.prototype.element = null;
    TipUtils.prototype.content = null;
    TipUtils.prototype.keepTimeout = true;
    TipUtils.prototype.close = null;
    TipUtils.prototype.Init = function (timeout, tipPositionCls) {
        var tip = document.createElement("div");
        tip.innerHTML = '<div class="tip-content"><div class="tip-message"></div><div class="tip-close">X</div></div>';
        tip.style.display = "none";
        document.body.appendChild(tip);
        this.element = tip;
        this.content = this.element.firstChild.firstChild;
        this.timeout = isNaN(timeout) ? this.timeout : timeout;
        this.tipPositionCls = tipPositionCls || this.tipPositionCls;
        var self = this;
        PortalTheme.addEventListener(tip, 'mouseenter', function () { self.CancelTimeout(); });
        PortalTheme.addEventListener(tip, 'mouseout', function (ev) { (ev.currentTarget == tip) && self.RunTimeout(); });
        PortalTheme.addEventListener(tip, 'click', function (ev) { self.OnClick(ev); });
    }
    //显示指定类型消息
    TipUtils.prototype.Message = function (message, cls, timeout) {
        var tip = this.element;
        if (tip) {
            this.keepTimeout = true;
            this.content.innerHTML = message;
            tip.className = "tip-box " + cls + " " + this.tipPositionCls;
            tip.style.display = "";
            AnimationMiddler.Animation(tip, 'translateFromTop');
            this.RunTimeout(timeout);
        }
    }
    //隐藏消息提示
    TipUtils.prototype.Hidden = function () {
        var tip = this.element;
        if (tip) {
            this.keepTimeout = false;
            AnimationMiddler.Animation(tip, 'translateToBottom', function () { tip.style.display = "none"; });
        }
    }
    //显示一个‘提示’提示信息
    TipUtils.prototype.Info = function (message, timeout) {
        this.Message(message, 'tip-info', timeout);
    }
    //显示一个‘警告’ 提示信息
    TipUtils.prototype.Warning = function (message, timeout) {
        this.Message(message, 'tip-warning', timeout);
    }
    //显示一个‘成功’提示信息
    TipUtils.prototype.Success = function (message, timeout) {
        this.Message(message, 'tip-success', timeout);
    }
    //显示一个‘错误’提示消息
    TipUtils.prototype.Error = function (message, timeout) {
        this.Message(message, 'tip-error', timeout);
    }
    TipUtils.prototype.CancelTimeout = function () {
        clearTimeout(this.timer);
    }
    TipUtils.prototype.RunTimeout = function (timeout) {
        timeout = (timeout || this.timeout);
        if (this.keepTimeout && timeout > 0) {
            var self = this;
            this.CancelTimeout();
            this.timer = setTimeout(function () { self.Hidden(); }, timeout);
        }
    }
    TipUtils.prototype.OnClick = function (ev) {
        var target = (ev.srcElement || ev.target);
        if (target.className == "tip-close") {
            this.CancelTimeout();
            this.Hidden();
        }
    }
    PortalTheme.Ready(function () {
        ThemeClass.prototype.Tip = new TipUtils();
    });
})(window);

/***********************************************
名称：一个js动画播放工具
日期：2015-05-01
************************************************/
(function (jquery) {

    if (typeof AnimationMiddler != 'undefined') { return; }

    function AnimationMiddlerClass() { }

    window.AnimationMiddler = window.amd = new AnimationMiddlerClass();

    var prefix = null;
    var animationEnd = null;

    var p = AnimationMiddlerClass.prototype;

    /**
     * 名称：针对指定元素播放一个动画，在动画播放完毕后清除动画样式类
     * @param element 要实现动画的元素
     * @param animation 动画样式名称
     * @param callback 播放完毕后的回调函数
     */
    p.Animation = function (element, animation, callback) {
        var self = this;
        //加入动画样式
        this.AddClass(element, animation);
        //绑定一次动画回调函数
        this.OnceAnimationed(element, function () {
            self.RemoveClass(element, animation);
            callback && callback(element);
        });
        this.Redraw(element);//强制重绘
    }

    /**
     * 名称：交替一个元素的动画
     * @param element 要实现动画的元素
     * @param inAnimation 当前要实现的动画样式
     * @param outAnimation 要退出的动画样式
     * @param callback 播放完毕后的回调函数
     */
    p.AnimationInOut = function (element, inAnimation, outAnimation, callback) {
        var self = this;
        outAnimation && this.RemoveClass(element, outAnimation);
        //加入动画样式
        this.AddClass(element, inAnimation);
        //绑定一次动画回调函数
        this.OnceAnimationed(element, function () {
            self.RemoveClass(element, inAnimation);
            callback && callback(element);
        });
        this.Redraw(element)//强制重绘
    }

    /**
     * 名称：绑定指定元素播放动画结束事件
     */
    p.OnceAnimationed = function (element, handler) {
        var delay = parseFloat(GetStyleValue(element, 'animationDelay'));
        var duration = parseFloat(GetStyleValue(element, 'animationDuration'));
        var called = false;
        var callback = function () {
            if (!called) {
                called = true; handler && handler();
            }
        }
        var outtime = ((delay + duration) * 1000) + 50;
        if (jquery) {
            jquery(element).one(animationEnd, callback);
        } else if (element.addEventListener) {
            element.addEventListener(animationEnd, callback);
        }
        setTimeout(callback, outtime);
    }

    /**
     * 名称：在能运行css3动画情况下，为指定元素添加指定样式名称
     */
    p.AddClass = function (element, cls) {
        if (element && element.classList) {
            element.classList.add(cls);
        }
    }

    /**
     * 名称：尝试重绘元素
     */
    p.Redraw = function (element) {
        if (element) {
            var hei = element.offsetHeight;
            element.style.display = "";
        }
    }

    /**
     * 名称：在能运行css3动画情况下，为指定元素移除指定样式名称
     */
    p.RemoveClass = function (element, cls) {
        if (element && element.classList) {
            element.classList.remove(cls);
        }
    }

    /**
     * 名称：判断当前浏览器是否支持CSS3动画
     */
    p.SupportCSS3Animation = function () {
        var styles = GetStyles(document.body || document.documentElement);
        prefix = prefix || "";
        var name = prefix == "" ? "animationDuration" : prefix + "AnimationDuration";
        return name in styles;
    }

    //初始化容器
    function CompactLoader() {
        if (animationEnd == null) {
            var eventNames = { 'webkit': 'webkitAnimationEnd', 'o': 'oAnimationEnd', 'ms': 'MSAnimationEnd' };
            prefix = GetPrefix();
            animationEnd = eventNames[prefix] || 'animationend';
        }
        if (!AnimationMiddler.SupportCSS3Animation()) {
            var contaienr = document.documentElement || document.body;
            contaienr.className = contaienr.className + " not-support-animation";
        }
    }

    //获取不同浏览器特性样式前缀
    function GetPrefix() {
        var styles = GetStyles(document.documentElement) || {};
        var vendors = { 'webkitAnimationName': 'webkit', 'mozAnimationName': 'moz', 'msAnimationName': 'ms', 'oAnimationName': 'o', 'animation': '' };
        var prx = '';
        for (var i in vendors) {
            if (i in styles) {
                prx = vendors[i];
                break;
            }
        }
        return prx;
    }
    //获取指定元素的样式列表
    function GetStyles(element) {
        return (window.getComputedStyle ? window.getComputedStyle(element) : element.currentStyle);
    }
    //获取指定元素指定样式值
    function GetStyleValue(element, name) {
        name = name || "";
        var firstChar = (name[0] || "").toUpperCase();
        var afterChars = (name.substring(1));
        var cssName = prefix + firstChar + afterChars;
        var values = GetStyles(element);
        return values[cssName] || values[name];
    }
    CompactLoader();
}(window.jQuery));

(function (env, jquery) {
    if (env.OriginAnimation) {
        return env.OriginAnimation;
    }
    var animations = {};
    var OriginAnimationLibaray = function () { }
    var OriginAnimation = env.OriginAnimation = new OriginAnimationLibaray();

    /**
     * 名称：播放一个jquery原生态动画
     */
    OriginAnimationLibaray.prototype.PlayAnimation = function (modal, animation, callback, time) {
        var animationHandler = animations[animation];
        if (typeof animationHandler == 'function') {
            PlayAnimation(animationHandler, modal, callback, time);
        } else {
            callback && callback();
        }
    }
    /**
     * 名称：添加一个动画到动画库
     */
    OriginAnimationLibaray.prototype.AddAnimation = function (name, handler) {
        animations[name] = handler;
    }

    /**
     * 名称：判断指定动画是否可以播放
     */
    OriginAnimationLibaray.prototype.IsOriginAnimation = function (name) {
        var animationHandler = animations[name];
        return typeof animationHandler == 'function';
    }

    //动画：从屏幕上方开始逐渐淡入到元素目标位置
    OriginAnimation.AddAnimation('translateFromTop', translateFromTop);
    //动画：从元素当前位置逐渐下降淡出
    OriginAnimation.AddAnimation('translateToBottom', translateToBottom);
    //动画：滑动从右边淡入
    OriginAnimation.AddAnimation('translateFromRight', translateFromRight);
    //动画：滑动至左边淡出
    OriginAnimation.AddAnimation('translateToLeft', translateToLeft);
    //动画：滑动从下边边淡入
    OriginAnimation.AddAnimation('translateFromBottom', translateFromBottom);
    //动画：滑动至上边淡出
    OriginAnimation.AddAnimation('translateToTop', translateToTop);
    //动画：滑动从左边淡入
    OriginAnimation.AddAnimation('translateFromLeft', translateFromLeft);
    //动画：滑动至右边淡出
    OriginAnimation.AddAnimation('translateToRight', translateToRight);
    //动画：放大淡入
    OriginAnimation.AddAnimation('scaleUpFadeIn', scaleUpFadeIn);
    //动画：缩小淡出
    OriginAnimation.AddAnimation('scaleDownFadeOut', scaleDownFadeOut);

    function translateFromTop(modal, time, callback) {
        var top = ensureNumber(modal.css("top"), 0);
        modal.css({ top: -100, opacity: 0 });
        modal.animate({ top: top, opacity: 1 }, time, 'swing', callback);
    }

    function translateToBottom(modal, time, callback) {
        var top = ensureNumber(modal.css("top"), 0) + 150;
        modal.animate({ top: top, opacity: 0.5 }, time, 'swing', callback);
    }

    function translateFromRight(modal, time, callback) {
        var left = ensureNumber(modal.css("left"), 0);
        var width = ensureNumber(modal.width(), 200);
        modal.css({ left: width, opacity: 0.5 });
        modal.animate({ left: left, opacity: 1 }, time, 'swing', callback);
    }

    function translateToLeft(modal, time, callback) {
        var left = ensureNumber(modal.css("left"), 0);
        var toLeft = ensureNumber(left - 150, 0);
        modal.animate({ left: toLeft, opacity: 0.5 }, time, 'swing', callback);
    }

    function translateFromBottom(modal, time, callback) {
        var hei = ensureNumber(modal.height(), 0);
        var top = ensureNumber(modal.css("top"), 0);
        modal.css({ top: (top + hei), opacity: 0.5 });
        modal.animate({ top: top, opacity: 1 }, time, 'swing', callback);
    }

    function translateToTop(modal, time, callback) {
        var top = ensureNumber(modal.css("top"), 0);
        modal.animate({ top: top - 150, opacity: 0.5 }, time, 'swing', callback);
    }

    function translateFromLeft(modal, time, callback) {
        var left = ensureNumber(modal.css("left"), 0);
        var oriLeft = ensureNumber(left - modal.width(), 30);
        modal.css({ left: oriLeft, opacity: 0.5 });
        modal.animate({ left: left, opacity: 1 }, time, 'swing', callback);
    }

    function translateToRight(modal, time, callback) {
        var left = ensureNumber(modal.css("left"), 0);
        modal.animate({ left: left + 150, opacity: 0.5 }, time, 'swing', callback);
    }

    function scaleUpFadeIn(modal, time, callback) {
        var width = modal.width();
        var height = modal.height();
        modal.css({ width: width / 2, height: height / 2, opacity: 0.5 });
        modal.animate({ width: width, height: height, opacity: 1 }, time, 'swing', callback);
    }

    function scaleDownFadeOut(modal, time, callback) {
        var width = modal.width() / 2;
        var height = modal.height() / 2;
        modal.animate({ width: width, height: height, opacity: 0.5 }, time, 'swing', callback);
    }

    function ensureNumber(maybeNum, dv) {
        maybeNum = parseInt(maybeNum);
        dv = isNaN(dv) ? 0 : dv;
        return isNaN(maybeNum) ? dv : maybeNum;
    }

    function PlayAnimation(handler, modal, callback, time) {
        var called = false;
        time = isNaN(time) ? 500 : time;
        time = time < 0 ? 500 : time;
        var anyCallback = function () {
            if (called === true) { return; }
            called = true;
            anyCallback = function () { }
            callback && callback();
        }
        handler(modal, time, callback);
        setTimeout(anyCallback, time);
    }

}(window, window.jQuery));
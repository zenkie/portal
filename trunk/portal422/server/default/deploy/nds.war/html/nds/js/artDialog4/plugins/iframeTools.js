/*!
 * artDialog iframeTools
 * Date: 2011-11-25 13:54
 * http://code.google.com/p/artdialog/
 * (c) 2009-2011 TangBin, http://www.planeArt.cn
 *
 * This is licensed under the GNU LGPL, version 2.1 or later.
 * For details, see: http://creativecommons.org/licenses/LGPL/2.1/
 */

; (function ($, window, artDialog, undefined) {

    var _topDialog, _proxyDialog, _zIndex,
        _data = '@ARTDIALOG.DATA',
        _open = '@ARTDIALOG.OPEN',
        _opener = '@ARTDIALOG.OPENER',
        _winName = window.name = window.name
        || '@ARTDIALOG.WINNAME' + +new Date,
        _isIE6 = window.VBArray && !window.XMLHttpRequest;

    $(function () {
        !window.jQuery && document.compatMode === 'BackCompat'
        // 不支持怪异模式，请用主流的XHTML1.0或者HTML5的DOCTYPE申明
        && alert('artDialog Error: document.compatMode === "BackCompat"');
    });


    /** 获取 artDialog 可跨级调用的最高层的 window 对象 */
    var _top = artDialog.top = function () {
        var top = window,
        test = function (name) {
            try {
                var doc = window[name].document;	// 跨域|无权限
                doc.getElementsByTagName; 			// chrome 本地安全限制
            } catch (e) {
                return false;
            };

            return window[name].artDialog
            // 框架集无法显示第三方元素
            && doc.getElementsByTagName('frameset').length === 0;
        };

        if (test('top')) {
            top = window.top;
        } else if (test('parent')) {
            top = window.parent;
        };

        return top;
    }();
    artDialog.parent = _top; // 兼容v4.1之前版本，未来版本将删除此


    _topDialog = _top.artDialog;


    // 获取顶层页面对话框叠加值
    _zIndex = function () {
        return _topDialog.defaults.zIndex;
    };



    /**
     * 跨框架数据共享接口
     * @see		http://www.planeart.cn/?p=1554
     * @param	{String}	存储的数据名
     * @param	{Any}		将要存储的任意数据(无此项则返回被查询的数据)
     */
    artDialog.data = function (name, value) {
        var top = artDialog.top,
            cache = top[_data] || {};
        top[_data] = cache;

        if (value !== undefined) {
            cache[name] = value;
        } else {
            return cache[name];
        };
        return cache;
    };


    /**
     * 数据共享删除接口
     * @param	{String}	删除的数据名
     */
    artDialog.removeData = function (name) {
        var cache = artDialog.top[_data];
        if (cache && cache[name]) delete cache[name];
    };


    /** 跨框架普通对话框 */
    artDialog.through = _proxyDialog = function () {
        var api = _topDialog.apply(this, arguments);

        // 缓存从当前 window（可能为iframe）调出所有跨框架对话框，
        // 以便让当前 window 卸载前去关闭这些对话框。
        // 因为iframe注销后也会从内存中删除其创建的对象，这样可以防止回调函数报错
        if (_top !== window) artDialog.list[api.config.id] = api;
        return api;
    };

    // 框架页面卸载前关闭所有穿越的对话框
    _top !== window && $(window).bind('unload', function () {
        var list = artDialog.list, config;
        for (var i in list) {
            if (list[i]) {
                config = list[i].config;
                if (config) config.duration = 0; // 取消动画
                list[i].close();
                //delete list[i];
            };
        };
    });


    /**
     * 弹窗 (iframe)
     * @param	{String}	地址
     * @param	{Object}	配置参数. 这里传入的回调函数接收的第1个参数为iframe内部window对象
     * @param	{Boolean}	是否允许缓存. 默认true
     */
    artDialog.open = function (url, options, cache) {
        options = options || {};

        var api, DOM,
            $content, $main, iframe, $iframe, $idoc, iwin, ibody,
            top = artDialog.top,
            initCss = 'width:100%;height:100%;position:absolute;border:none 0;left:-10000px;top:0px;z-index:1;',//left:-9999em;top:-9999em;background:transparent在部分版本浏览器中会导致闪烁
            loadCss = 'width:100%;height:100%;*height:100%;border:none 0';

        if (cache === false) {
            var ts = +new Date,
                ret = url.replace(/([?&])_=[^&]*/, "$1_=" + ts);
            url = ret + ((ret === url) ? (/\?/.test(url) ? "&" : "?") + "_=" + ts : "");
        };

        var load = function () {
            var iWidth, iHeight,
                loading = DOM.content.find('.aui_loading'),
                aConfig = api.config;

            loading && loading.hide();

            try {
                iwin = iframe.contentWindow;
                iwin.linkWindow = window;
                iwin.Alers = iwin.Alers || window.Alers;
                iwin.closeArtModal = function () {
                    iwin.linkWindow = null;
                    api.close();
                    api = null;
                    iwin.close();
                }
                $idoc = $(iwin.document);
                ibody = iwin.document.body || iwin.document.documentElement;
                ibody.style.height = "100%";
                $idoc.find("html").css("height", "100%");
            } catch (e) {// 跨域
                iframe.style.cssText = loadCss;
                iframe.style.height = $content.height() + "px";

                aConfig.follow
                ? api.follow(aConfig.follow)
                : api.position(aConfig.left, aConfig.top);

                options.init && options.init.call(api, iwin, top);
                options.init = null;
                return;
            } finally {

            }

            // 适应iframe尺寸
            setTimeout(function () {
                iframe.style.cssText = loadCss;
                iframe.style.height = $content.height() + "px";
            }, 0);// setTimeout: 防止IE6~7对话框样式渲染异常

            // 调整对话框位置
            aConfig.follow
            ? api.follow(aConfig.follow)
            : api.position(aConfig.left, aConfig.top);

            options.init && options.init.call(api, iwin, top);

            //自定义滚动条 注意：perfect-scrollbar-0.4.10.with-mousewheel.min.js已被修改过
            //由于原本的脚本工具不支持body的滚动条 修正后使body支持滚动条
            if (iwin.jQuery && iwin.jQuery.fn.perfectScrollbar) {
                var jbody = iwin.jQuery(ibody);
                setTimeout(function () {
                    jbody.css("height", DOM.main.height());
                    iwin.commjs_registCustomerScrollBar(jbody);
                    jbody.children(".ps-scrollbar-y-rail,.ps-scrollbar-x-rail").css("z-index", 9000);
                    jbody.trigger("mousewheel");
                }, 200)
            } else {
                iframe.scrolling = "yes";
                ibody.style.overflow = "auto";
            }
            options.init = null;
        };

        function needHtmlOverflowHidden() {
            var userAgent = navigator.userAgent;
            var ie = userAgent.indexOf("Trident") > 0 && userAgent.indexOf("rv:11.0") > 0;
            if (ie || userAgent.indexOf("Firefox") > 0) {
                return true;
            } else {
                return false;
            }
        }


        var config = {
            zIndex: _zIndex(),
            init: function () {
                api = this;
                DOM = api.DOM;
                $main = DOM.main;
                $content = DOM.content;

                iframe = api.iframe = top.document.createElement('iframe');
                iframe.src = url;
                iframe.id = api.config.ifrid;
                iframe.name = 'Open' + api.config.id;
                iframe.style.cssText = initCss;
                iframe.setAttribute('frameborder', 0, 0);
                $content.addClass('aui_state_full');
                $iframe = $(iframe);
                api.content().appendChild(iframe);
                iwin = iframe.contentWindow;

                try {
                    iwin.name = iframe.name;
                    artDialog.data(iframe.name + _open, api);
                    artDialog.data(iframe.name + _opener, window);
                } catch (e) { };

                $iframe.bind('load', load);
            },
            close: function () {
                $iframe.css('display', 'none').unbind('load', load);

                if (options.close && options.close.call(this, iframe.contentWindow, top) === false) {
                    return false;
                };
                $content.removeClass('aui_state_full');

                // 重要！需要重置iframe地址，否则下次出现的对话框在IE6、7无法聚焦input
                // IE删除iframe后，iframe仍然会留在内存中出现上述问题，置换src是最容易解决的方法
                $iframe[0].src = 'about:blank';
                $iframe.remove();

                try {
                    artDialog.removeData(iframe.name + _open);
                    artDialog.removeData(iframe.name + _opener);
                } catch (e) { };
            },
            resize: function (w, h, wrap) {
                $iframe && $iframe.css({ height: $content.height() });
            }
        };

        // 回调函数第一个参数指向iframe内部window对象
        if (typeof options.ok === 'function') config.ok = function () {
            return options.ok.call(api, iframe.contentWindow, top);
        };
        if (typeof options.cancel === 'function') config.cancel = function () {
            return options.cancel.call(api, iframe.contentWindow, top);
        };

        delete options.content;

        for (var i in options) {
            if (config[i] === undefined) config[i] = options[i];
        };

        return _proxyDialog(config);
    };


    /** 引用open方法扩展方法(在open打开的iframe内部私有方法) */
    artDialog.open.api = artDialog.data(_winName + _open);


    /** 引用open方法触发来源页面window(在open打开的iframe内部私有方法) */
    artDialog.opener = artDialog.data(_winName + _opener) || window;
    artDialog.open.origin = artDialog.opener; // 兼容v4.1之前版本，未来版本将删除此

    /** artDialog.open 打开的iframe页面里关闭对话框快捷方法 */
    artDialog.close = function () {
        var api = artDialog.data(_winName + _open);
        api && api.close();
        return false;
    };

    // 点击iframe内容切换叠加高度
    _top != window && $(document).bind('mousedown', function () {
        var api = artDialog.open.api;
        api && api.zIndex();
    });


    /**
     * Ajax填充内容
     * @param	{String}			地址
     * @param	{Object}			配置参数
     * @param	{Boolean}			是否允许缓存. 默认true
     */
    artDialog.load = function (url, options, cache) {
        cache = cache || false;
        var opt = options || {};

        var config = {
            zIndex: _zIndex(),
            init: function (here) {
                var api = this,
                    aConfig = api.config;

                $.ajax({
                    url: url,
                    success: function (content) {
                        api.content(content);
                        opt.init && opt.init.call(api, here);
                    },
                    cache: cache
                });

            }
        };

        delete options.content;

        for (var i in opt) {
            if (config[i] === undefined) config[i] = opt[i];
        };

        return _proxyDialog(config);
    };


    /**
     * 警告
     * @param	{String}	消息内容
     */
    artDialog.alert = function (content, callback) {
        return _proxyDialog({
            id: 'Alert',
            zIndex: _zIndex(),
            icon: 'warning',
            fixed: true,
            lock: true,
            content: content,
            ok: true,
            close: callback
        });
    };


    /**
     * 确认
     * @param	{String}	消息内容
     * @param	{Function}	确定按钮回调函数
     * @param	{Function}	取消按钮回调函数
     */
    artDialog.confirm = function (content, yes, no) {
        return _proxyDialog({
            id: 'Confirm',
            zIndex: _zIndex(),
            icon: 'question',
            fixed: false,
            lock: true,
            opacity: .1,
            width: 300,
            animation: { inCss: 'scaleUpFadeIn', outCss: 'scaleDownFadeOut' },
            content: '<div style="padding:10px">' + content + '</div>',
            ok: function (here) {
                return yes.call(this, here);
            },
            cancel: function (here) {
                return no && no.call(this, here);
            }
        });
    };


    /**
     * 提问
     * @param	{String}	提问内容
     * @param	{Function}	回调函数. 接收参数：输入值
     * @param	{String}	默认值
     */
    artDialog.prompt = function (content, yes, value) {
        value = value || '';
        var input;

        return _proxyDialog({
            id: 'Prompt',
            zIndex: _zIndex(),
            icon: 'question',
            fixed: true,
            lock: true,
            opacity: .1,
            content: [
                '<div style="margin-bottom:5px;font-size:12px">',
                    content,
                '</div>',
                '<div>',
                    '<input value="',
                        value,
                    '" style="width:18em;padding:6px 4px" />',
                '</div>'
            ].join(''),
            init: function () {
                input = this.DOM.content.find('input')[0];
                input.select();
                input.focus();
            },
            ok: function (here) {
                return yes && yes.call(this, input.value, here);
            },
            cancel: true
        });
    };


    /**
     * 短暂提示
     * @param	{String}	提示内容
     * @param	{Number}	显示时间 (默认1.5秒)
     */
    artDialog.tips = function (content, time, type) {
        switch (type) {
            case 'warning':
                top.PortalTheme.Tip.Warning(content);
                break;
            case 'error':
                top.PortalTheme.Tip.Error(content);
                break;
            case 'success':
                top.PortalTheme.Tip.Success(content);
                break;
            default:
                top.PortalTheme.Tip.Info(content);
                break;
        }
    };

    artDialog.remotePage = function (url, options) {
        var animation = { inCss: 'translateFromTop', outCss: 'translateToBottom' };
        options.animation = options.animation || animation;
        var par = art.dialog(options);

        new Ajax.Request(url, {
            method: 'get',
            onSuccess: function (transport) {
                par.updateContent(transport.responseText, true);
                par.hcenter();
            },
            onFailure: function (transport) {
                //try{
                if (transport.getResponseHeader("nds.code") == "1") {
                    window.location = "/c/portal/login";
                    return;
                }
                var exc = transport.getResponseHeader("nds.exception");
                if (exc != null && exc.length > 0) {
                    alert(decodeURIComponent(exc));
                } else {
                    options.content = transport.responseText;
                    var par = art.dialog(options);
                }
            }
        });
    }


    // 增强artDialog拖拽体验
    // - 防止鼠标落入iframe导致不流畅
    // - 对超大对话框拖动优化
    $(function () {
        var event = artDialog.dragEvent;
        if (!event) return;

        var dragEvent = event.prototype;

        dragEvent._start = dragEvent.start;
        dragEvent._end = dragEvent.end;

        dragEvent.start = function () {
            var DOM = artDialog.focus.DOM;
            var ifr = DOM.content.find("iframe");
            ifr.hide();
            dragEvent._start.apply(this, arguments);
        };

        dragEvent.end = function () {
            var DOM = artDialog.focus.DOM;
            var ifr = DOM.content.find("iframe");
            ifr.show();
            dragEvent._end.apply(this, arguments);
        };
    });

})(this.art || this.jQuery, this, this.artDialog);


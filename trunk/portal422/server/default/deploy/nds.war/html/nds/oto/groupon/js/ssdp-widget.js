/// js
(function (window, $) {

    var ssdp = {};
    var $widgetHtml = null;

    // 对话框
    ssdp.dialog = function (options) {
        $.extend(this, this.defaults, options);
    };
    ssdp.dialog.prototype = {
        // 默认值
        defaults: {
            // 宽度
            width: "auto",
            // 高度
            height: "auto",
            // 显示遮罩
            isShowModal: true,
            // 距离上边多少像素
            top: "auto",
            // 距离左边多少像素
            left: "auto",
            // 标题
            title: "提示",
            // 按esc键关闭对话框
            esc: true,
            // 标题对齐方式
            titleAlign: "left",
            // 固定
            fixed: true,
            // 内容
            content: null,
            // 支持拖动
            drag: true,
            // z-index
            zIndex: 401,
            // 确定按钮的文字
            yesText: "确定",
            // 显示底栏 
            showFootBar: true,
            // 确定按钮回调函数
            yesFn: null,
            // 关闭对话框回调函数
            closeFn: null
        },
        _create: function () {
            var $html = getCompontentHtml("#global-dialog");
            $html.hide();
            $(document.body).append($html);
            this.$wrap = $html;
            this.$contentWrap = $html.find("#global-dialog-content");
            this.$titleWrap = $html.find("#global-dialog-title");
            this.$footWrap = $html.find("#global-dialog-footer");
            this.$yesButton = $html.find("#global-dialog-yesButton");
            this.$closeButton = $html.find("#global-dialog-closeButton");
            this.$drag = $html.find("#global-dialog-drag");

            this.modal = new ssdp.modal();
        },
        _setParams: function () {
            var _this = this;
            this.$titleWrap.text(this.title);
            this.$contentWrap.width(this.width);
            this.$contentWrap.height(this.height);
            this.$contentWrap.html(this.content);
            this.$wrap.css("z-index", this.zIndex);
            this.$yesButton.val(this.yesText);
            if (!this.showFootBar) {
                this.$footWrap.hide();
            }
            if (this.drag) {
                this.$drag.css("cursor", "move");

                var startX = 0,
                startY = 0,
                offsetX = 0,
                offsetY = 0,
                dragElement = null,
                dragging = false;

                _this.dragDownHandler = function (e) {
                    if (dragging || dragElement) return;
                    var event = libra.getEvent(e);
                    dragging = true;
                    dragElement = _this.$wrap;

                    startX = event.clientX;
                    startY = event.clientY;

                    offsetX = parseInt(dragElement[0].style.left, 10);
                    offsetY = parseInt(dragElement[0].style.top, 10);

                    $(document).bind("mousemove", _this.dragMoveHandler);
                    $(document).bind("mouseup", _this.dragUpHandler);

                    document.body.focus();
                    document.onselectstart = function () { return false; };
                    dragElement.ondragstart = function () { return false; };
                    return false;
                }
                _this.dragMoveHandler = function (e) {
                    if (!dragging || !dragElement) return;
                    var event = libra.getEvent(e);
                    dragElement[0].style.left = (offsetX + event.clientX - startX) + "px";
                    dragElement[0].style.top = (offsetY + event.clientY - startY) + "px";
                }
                _this.dragUpHandler = function (e) {
                    if (!dragging || !dragElement) return;
                    var event = libra.getEvent(e);
                    document.onmousemove = null;
                    document.onselectstart = null;
                    dragElement.ondragstart = null;

                    dragElement = null;
                    dragging = false;
                    offsetX = 0;
                    offsetY = 0;

                    $(document).unbind("mousemove", _this.dragMoveHandler);
                    $(document).unbind("mouseup", _this.dragUpHandler);
                }
                _this.$drag.bind("mousedown", _this.dragDownHandler);
            }
            // 处理按ESC退出
            if (this.esc) {
                this.escFn = function (e) {
                    var event = libra.getEvent(e);
                    var keyNum = libra.getNumFromKeyPress(event);
                    if (keyNum === libra.keycode.ESCAPE) {
                        _this.close();
                    }
                }
                $(document).bind("keydown", this.escFn);
            }
        },
        _bindEvent: function () {
            var _this = this;
            _this.$yesButton[0].onclick = function () {
                _this.yesFn && _this.yesFn();
            };
            _this.$closeButton[0].onclick = function () {
                _this.closeFn && _this.closeFn();
                _this.close();
            };
        },
        setContent: function (content) {
            this.content = content;
            this.$contentWrap.html(this.content);
        },
        setPosition: function () {
            var left = (($(parent.window).width() - this.$wrap.width()) / 2) - 170;
            var top = (($(parent.window).height() - this.$wrap.height()) / 2) - 80;
            this.$wrap.css({
                "position": "fixed",
                "z-index": this.zIndex,
                "left": this.left === "auto" ? (left < 0 ? 0 : left) + "px" : this.left,
                "top": this.top === "auto" ? (top < 0 ? 0 : top) + "px" : this.top
                //                "margin-left": -this.$wrap.width() / 2,
                //                "margin-top": -this.$wrap.height() / 2
            });
            if (!this.fixed || libra.browser.ie6) {
                this.$wrap.css("position", "absolute");
            }
        },
        open: function () {
            this._create();
            this._setParams();
            this.setPosition();
            this._bindEvent();

            this.$wrap.show();
            this.isShowModal && this.modal.open();
        },
        close: function () {
            this.$wrap.remove();
            this.isShowModal && this.modal.close();

            this.dragMoveHandler && $(document).unbind("mousemove", this.dragMoveHandler);
            this.dragUpHandler && $(document).unbind("mouseup", this.dragUpHandler);
            this.escFn && $(document).unbind("keydown", this.escFn);
        }
    };

    // 遮罩
    ssdp.modal = function (options) {
        $.extend(this, this.defaults, options);
    };
    ssdp.modal.prototype = {
        // 默认值
        defaults: {
            // 透明度
            opacity: 0.2,
            // z-index
            zIndex: 400
        },
        _create: function () {
            var $html = getCompontentHtml("#global-modal");
            $html.hide();
            $(document.body).append($html);
            this.$wrap = $html;
        },
        _setParams: function () {
            this.$wrap.height(getDocumentHeight());
            this.$wrap.css("opacity", this.opacity);
            this.$wrap.css("z-index", this.zIndex);
        },
        open: function () {
            this._create();
            this._setParams();
            this.$wrap.show();
        },
        close: function () {
            this.$wrap.remove();
        }
    };

    // 提示
    ssdp.tip = function (message, type, cb) {
        this.message = message;
        this.type = type;
        this.cb = cb;
    }
    ssdp.tip.prototype = {
        _create: function () {
            var html = $("#global-tip").html();
            this.$wrap = $(html);
            this.$wrap.hide();
            this.$wrap.text(this.message);
            $(document.body).append(this.$wrap);
            var left = (($(parent.window).width() - this.$wrap.width()) / 2) - 170;
            var top = (($(parent.window).height() - this.$wrap.height()) / 2) - 80;
            this.$wrap.css({
                "left": (left < 0 ? 0 : left) + "px",
                "top": (top < 0 ? 0 : top) + "px",
                //"margin-left": -this.$wrap.width() / 2,
                "z-index": 100000
            });
            if (this.type === "fail") {
                this.$wrap.addClass("success-reminder-fail");
            }
        },
        open: function () {
            var _this = this;
            this._create();
            this.$wrap.fadeIn("normal", "linear");
            setTimeout(function () {
                _this.close();
            }, 1500);
        },
        close: function () {
            var _this = this;
            this.$wrap.fadeOut("normal", "linear", function () {
                _this.$wrap.remove();
                _this.cb && _this.cb();
            });
        }
    };

    // 提示操作成功
    ssdp.tipSuccess = function (message, cb) {
        var tip = new ssdp.tip(message, "success", cb);
        tip.open();
    }

    // 提示操作成功
    ssdp.tipFail = function (message, cb) {
        var tip = new ssdp.tip(message, "fail", cb);
        tip.open();
    }

    // tab页
    ssdp.tab = function (options) {
        $.extend(this, this.defaults, options);
        this._init();
    };
    ssdp.tab.prototype = {
        defaults: {
            // 当前tab实例的选择器
            selector: "",
            // 选项卡导航选择器 $(".tab-header").children();
            tabSelector: "",
            // 选项卡内容选择器 $(".tab-content").children()
            panelSelector: "",
            // 触发事件类型
            event: "click",
            // 自动切换
            auto: false,
            // 自动切换时间
            interval: 500,
            // 当前选中选项卡的class样式
            selectedClass: "selected",
            // 回调函数
            callback: null
        },

        _init: function () {
            this.selectedIndex = 0;
            this.$wrap = $(this.selector);
            if (!this.$wrap.length) {
                libra.error("未找到tab元素 selector:" + this.selector);
            }
            if (this.tabSelector) {
                this.$tabs = this.$wrap.find(this.tabSelector);
                if (!this.$tabs.length) {
                    libra.error("未找到选项卡导航选择器 tabSelector:" + this.tabSelector);
                }
            }
            else {
                this.$tabs = this.$wrap.find(".tab-header").children();
            }
            if (this.panelSelector) {
                this.$panels = this.$wrap.find(this.panelSelector);
                if (!this.$panels.length) {
                    libra.error("未找到选项卡内容选择器 panelSelector:" + this.panelSelector);
                }
            }
            else {
                this.$panels = this.$wrap.find(".tab-content").children().not("script");
            }
            this.timer = null;

            // 默认选中第一项
            this.select(0);

            // 绑定事件
            this._bindEvent();

            if (this.auto) {
                this._autoRun();
            }
        },

        _bindEvent: function () {
            var self = this;
            this.$tabs.on(self.event, function () {
                var index = self.$tabs.index(this);
                self.selectedIndex = index;
                self.select(index);
            });
        },

        _autoRun: function () {
            if (!this.auto) return;
            var self = this;
            this.$panels.hover(function () {
                clearInterval(self.timer);
            }, function () {
                self.timer = setInterval(function () {
                    self.selectedIndex++;
                    if (self.selectedIndex >= self.$tabs.length) {
                        self.selectedIndex = 0;
                    }
                    self.select(self.selectedIndex);
                }, this.interval);
            });
            this.$panels.mouseout();
        },

        select: function (index) {
            index = ~ ~index;
            this.$tabs.removeClass(this.selectedClass).eq(index).addClass(this.selectedClass);
            this.$panels.hide().eq(index).show();
            if (libra.isFunction(this.callback)) {
                this.callback.call(this, this.$tabs[index], this.$panels[index], index);
            }
        },

        // 获取选中的信息
        getSelectInfo: function () {
            var $selectTab = this.$tabs.filter(".selected");
            var index = $selectTab.index();
            var $selectPanel = this.$panels.eq(index);
            return { index: index, $tab: $selectTab, $panel: $selectPanel };
        }
    };

    // step 通用tab
    ssdp.stepTab = function (callback) {
        var $leftTab = $("#leftTab");
        var $rightTab = $("#rightTab");
        var leftTabSelectClass = "leftBg isCurrent";
        var rightTabSelectClass = "rightBg isCurrent";
        var tabCancelClass = "noCurrent";

        var $leftPanel = $("#leftPanel");
        var $rightPanel = $("#rightPanel");

        $leftTab.click(function () {
            $rightTab.removeClass(rightTabSelectClass).addClass(tabCancelClass);
            $leftTab.removeClass(tabCancelClass).addClass(leftTabSelectClass);
            $rightPanel.hide();
            $leftPanel.show();

            callback(1);
        });
        $rightTab.click(function () {
            $leftTab.removeClass(leftTabSelectClass).addClass(tabCancelClass);
            $rightTab.removeClass(tabCancelClass).addClass(rightTabSelectClass);
            $rightPanel.show();
            $leftPanel.hide();

            callback(2);
        });
    }

    // 加载中
    ssdp.loading = function (msg) {
        this.msg = msg;
    };
    ssdp.loading.prototype = {
        open: function () {
            var html = $("#loadingContent").html();
            this.$html = $(html);
            this.$html.css({
                "position": "fixed",
                "z-index": 1000,
                "left": $(window).width() / 2 + "px",
                "top": $(window).height() / 2 + "px",
                "margin-left": -this.$html.width() / 2,
                "margin-top": -this.$html.height() / 2
            });
            if (this.msg) {
                this.$html.find(".J_text").text(this.msg);
            }
            $(document.body).append(this.$html);

            //            this.modal = new ssdp.modal();
            //            this.modal.open();
        },
        close: function () {
            //this.modal.close();
            this.$html.remove();
        }
    };

    // 重写ajax加入正在加载中效果
    var ajax = jQuery.ajax;
    jQuery.ajax = function (settings) {
        var loading = new ssdp.loading();
        if (settings["isLoading"] === true) {
            settings["beforeSend"] = function (xhr) {
                loading.open();
            };
            settings["complete"] = function (xhr) {
                loading.close();
            };
        }
        ajax(settings);
    };

    // 图片ajax上传
    ssdp.imageAjax = function (selector, successCallback) {
        $(selector).ajaxForm(libra.handleAjaxSettings({
            isAjaxFormPlugin: true,
            data: { "X-Requested-With": "XMLHttpRequest", "isAjaxFormPlugin": true },
            success: function (model, textStatus, jqXHR) {
                libra.isFunction(successCallback) && successCallback.call(this, model, textStatus, jqXHR);
                var $this = $(this);
                var tempHtml = $this.find(":file").parent().html();
                var $file = $this.find(":file");
                $file.remove();
                $file = $(tempHtml);
                $this.append($file);
            }
        }));
    }

    ssdp.openAppLinkDialog = function (linkID, title, callback) {
        $.ajax({
            type: "post",
            url: "/Link/Index",
            data: { appLinkID: linkID },
            async: false,
            isLoading: true,
            success: function (html) {
                var linkDialog = new ssdp.dialog();
                linkDialog.title = title || "设置链接";
                var linkHtml = "<div style='max-height:540px;overflow-y:auto;overflow-x:hidden;'>";
                linkHtml += html;
                linkHtml += "</div>";
                linkDialog.content = linkHtml;
                linkDialog.yesFn = function () {
                    callback();
                };
                linkDialog.open();
            }
        });
    }

    // 增加自定义频道
    ssdp.addCustomChannel = function (channelName, channelType, linkName, linkType, callback) {
        $.ajax({
            url: "/Channel/AddCustomChannel",
            type: "post",
            async: false,
            data: {
                channelName: channelName,
                channelType: channelType,
                linkName: linkName,
                linkType: linkType
            },
            success: function (model) {
                var channel = model.Entity.Item1;
                var appLink = model.Entity.Item2;

                callback(channel, appLink);
            }
        });
    }

    function getDocumentHeight() {
        return $(document).outerHeight(true) || $(document).height();
    }

    function getCompontentHtml(selector) {
        if (!$widgetHtml) {
            $widgetHtml = '<table class="popupBox" id="global-dialog">    <thead class="popupHead" id="global-dialog-drag">        <tr>            <th colspan="2">                <span class="originalName" id="global-dialog-title"></span>                <a class="closeBtn" href="javascript:;" id="global-dialog-closeButton"></a>            </th>        </tr>    </thead>    <tbody>        <tr>            <td id="global-dialog-content">                <!--内容在此-->            </td>        </tr>        <tr class="popupBox-lastTr" id="global-dialog-footer">            <td colspan="2" class="tocenter">                <input class="btn saveBtn" type="button" id="global-dialog-yesButton" value="保存" />            </td>        </tr>    </tbody></table><div id="global-modal" class="global-modal"></div>';
            $widgetHtml = $($widgetHtml);
        }
        var $html = $widgetHtml.filter(selector).clone();
        if (!$html.length) {
            alert("未载入组件html");
            return null;
        }
        else {
            return $html;
        }
    }

    function init() {
        $(function () {
            // 图片ajax提交
            $(document.body).on("change", "input[data-ajax-submit='true']", function () {
                var $this = $(this);
                if ($this.val()) {
                    $this.closest("form").submit();
                    $this.val("");
                }
            });
        });

        libra.tipFail = ssdp.tipFail;
    }
    init();

    var appLinkType =
    {
        /// <summary>
        /// 单品页
        /// </summary>
        GoodsItemPage: 10,
        /// <summary>
        /// 类目商品页
        /// </summary>
        CategoryGoodsListPage: 11,
        /// <summary>
        /// 自定义网址链接
        /// </summary>
        CustomUrlPage: 12,
        /// <summary>
        /// 系统页面
        /// </summary>
        SystemPage: 13,
        /// <summary>
        /// 自定义商品列表
        /// </summary>
        CustomGoodsListPage: 14,
        /// <summary>
        /// 文章列表
        /// </summary>
        ArticleListPage: 15,
        /// <summary>
        /// 文章单页
        /// </summary>
        ArticleItemPage: 16,
        /// <summary>
        /// 热线电话
        /// </summary>
        HotLine: 17
    };
    window.appLinkType = appLinkType;
    window.ssdp = ssdp;
})(window, jQuery);
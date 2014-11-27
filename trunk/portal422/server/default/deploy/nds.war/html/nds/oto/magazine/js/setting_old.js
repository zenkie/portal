(function () {
    //设计器
    function Designer() { }

    var P = Designer.prototype;

    P.jsPageRegionId = 2000;

    P.uploadifyId = 1000;

    //已经移除的 过场页
    P.imageRemoves = [];

    //已经移除的锚点
    P.anchorRemoves = [];

    P.Data = {
        "masterobj":
        { "table": "WX_MAGAZINE", "ID": -1 },
        "detailobjs": {
            "reftables": [1423, 1424],
            "refobjs": []
        }
    }

    //设计器初始化方法
    P.Init = function () {
        this.InitForms();
        this.InitHandlers();
        this.InitValidators();
        this.InitAnchors();
    }

    //提交数据
    P.Submit = function () {
        if (!this.SubmitValidate()) { return; }
        var magazine = FormUtil.Read("#appConfigForm");
        var id = magazine.ID;
        var other2 = FormUtil.Read("#myForm2");
        var other = FormUtil.Read("#myForm");
        magazine = $.extend(magazine, other, other2);
        //杂志数据
        magazine.table = "WX_MAGAZINE";
        var data = this.Data;
        var masterobj = data.masterobj;
        masterobj = $.extend(masterobj, magazine);
        data.detailobjs.refobjs = [this.GetCurrentMagazineImages(), this.GetCurrentMagazineAnchors()];
        delete masterobj.ID;
        masterobj.id = id;
        if (!this.SubmitValidate2(masterobj)) { return; }
        this.ShowMessage('正在保存中...');
        this.Rest('ProcessOrder', JSON2.stringify(data), this.GetCall(this.SubmitSuccess));
    }

    //数据验证2
    P.SubmitValidate2 = function (data) {
        var r = false;
        if (data.BGPHOTO == '') {
            this.ShowMessage('背景图片必须设置', true);
            this.ShowBasePanel();
        } else if (data.COLOR == '') {
            this.ShowMessage('背景色必须设置', true);
            this.ShowBasePanel();
        } else if (data.HOMEPHOTO == '') {
            this.ShowMessage('封面页必须设置', true);
            this.ShowImagePanel();
        } else if (data.CLEANSTATE == 'Y' && data.CLEANPHOTO == '') {
            this.ShowMessage('擦拭前图片必须设置', true);
            this.ShowImagePanel();
        } else {
            r = true;
        }
        return r;
    }


    //验证数据
    P.SubmitValidate = function () {
        var v = $("#appConfigForm").valid();
        if (!v) {
            this.ShowBasePanel();
        }
        return v;
    }

    //显示页面基本设置
    P.ShowBasePanel = function () {
        this.HideAppSidebar();
        $("#appConfigForm").parents(".app-sidebar:eq(0)").show();
    }

    //显示过场动画设置
    P.ShowImagePanel = function () {
        this.HideAppSidebar();
        $("#appFieldForm").parents(".app-sidebar:eq(0)").show();
    }

    //显示提示信息
    P.ShowMessage = function (message, iserror) {
        var target = $("#myMessage");
        var cls = iserror ? "error" : "tip-warn";
        target.attr("class", "tip-message " + cls);
        target.html((message || ''));
    }

    //提交成功
    P.SubmitSuccess = function (data) {
        if (data.code == 0) {
            this.ShowMessage("保存成功");
            window.location.reload();
        } else {
            this.ShowMessage('失败!,原因:' + data.message, true);
        }
    }

    //获取当前所有过场页
    P.GetCurrentMagazineImages = function () {
        var mmobj = {
            "table": "WX_MAGAZINEIMAGE",
            "deleteList": [],
            "modifyList": [],
            "addList": [],
        }
        var pages = $(".custom-scroll-pages .js-pages-region");
        var page = null;
        var self = this;
        pages.each(function () {
            page = self.ParseCustomPageToJson(this);
            if ((!isNaN(page.ID)) && page.ID > 0) {
                mmobj.modifyList.push(page);
            } else {
                delete page.ID;
                mmobj.addList.push(page);
            }
        });
        var deleteds = this.imageRemoves || [];
        var has = {};
        var id = 0;
        for (var i = 0, k = deleteds.length; i < k; i++) {
            id = deleteds[i];
            if (has[id] || isNaN(id) || id <= 0) {
                continue;
            }
            mmobj.deleteList.push({ id: id });
        }
        if (mmobj.addList.length <= 0) {
            delete mmobj.addList;
        }
        return mmobj;
    }

    //获取当前所有锚点
    P.GetCurrentMagazineAnchors = function () {
        var anchorbj = {
            "table": "WX_MAGAZINEANCHOR",
            "deleteList": [],
            "modifyList": [],
            "addList": []
        }
        var anchors = $(".app-container .map-link");
        var anchor = null;
        var self = this;
        anchors.each(function () {
            anchor = self.ParseAnchorJson(this);
            if ((!isNaN(anchor.ID)) && anchor.ID > 0) {
                anchorbj.modifyList.push(anchor);
            } else {
                delete anchor.ID;
                anchorbj.addList.push(anchor);
            }
        });
        var deleteds = this.anchorRemoves || [];
        var has = {};
        var id = 0;
        for (var i = 0, k = deleteds.length; i < k; i++) {
            id = deleteds[i];
            if (has[id] || isNaN(id) || id <= 0) {
                continue;
            }
            anchorbj.deleteList.push({ id: id });
        }
        if (anchorbj.addList.length <= 0) {
            delete anchorbj.addList;
        }
        return anchorbj;
    }

    //解析json字符串成json对象
    P.ParseDataOptions = function (str) {
        var s = {};
        try {
            return (new Function("return " + str + ";"))();
        } finally { }
        return s;
    }

    //解析单个过场页成josn数据
    P.ParseCustomPageToJson = function (page) {
        var obj = FormUtil.Read(page);
        return obj;
    }

    //解析单个锚点成json数据
    P.ParseAnchorJson = function (anchor) {
        var obj = FormUtil.Read(anchor);
        var container = $(".app-container");
        anchor = $(anchor);
        var opts = { rectWidth: 0, rectHeight: 0, title: '', href: '', x: this.GetIntCss(anchor, "left", 0), y: this.GetIntCss(anchor, "top", 0), width: anchor.width(), height: anchor.height(), shape: '' };
        opts.shape = anchor.attr("data-shape") || "rect";
        opts.rectHeight = container.height();
        opts.rectWidth = container.width();
        opts.title = anchor.attr("title");
        opts.href = anchor.attr("data-href");
        obj.ANCHOR = JSON2.stringify(opts);
        return obj;
    }

    P.GetIntCss = function (element, css, def) {
        var v = element.css(css);
        v = parseInt(v);
        return v || def;
    }

    //访问接口
    P.Rest = function (_command, _params, success) {
        var self = this;
        jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            dataType: 'json',
            data: { command: _command, params: _params },
            success: function (data) {
                var r = data[0];
                if (r.code == 0) {
                    self.Call(success, r);
                } else {
                    alert(r.message);
                }
            }, error: function () {
                alert('访问出错');
            }
        });
    }

    //初始化锚点
    P.InitAnchors = function () {
        var anchors = $(".map-link");
        var self = this;
        anchors.each(function () { self.InitAnchor(this); });
    }

    //初始化单个锚点
    P.InitAnchor = function (anchor) {
        anchor = $(anchor);
        var data = anchor.find("input[name=anchor]").val();
        var opts = this.ParseDataOptions(data);
        anchor.css({ href: '', title: '', left: opts.x, top: opts.y, width: (opts.width || 50), height: (opts.height || 50) });
        anchor.addClass((opts.shape || "rect"));
        anchor.attr("data-shape", ((opts.shape || "rect")));
        anchor.attr("data-href", (opts.href || ''));
        anchor.attr("title", (opts.title || ''));
        anchor.find(".actions").append('<label>' + (opts.title || '' + '<label>'));
    }

    //初始化设计器表单数据
    P.InitForms = function () {
        this.jsPageRegionId = Number($("#maxPageId").val() || 1);
        $(":checkbox[value=是]").attr("checked", "checked");
        this.Displayment('.ui-homepage-btn', $("input[name=homestate]")[0].checked);
        this.Displayment('.ui-music-btn', $("input[name=musicstate]")[0].checked);
        this.ChangePageWipePanel({ target: $("input[name=cleanstate]")[0] });
    }

    //初始化过场图片面验证器
    P.InitValidators = function () {
        var validator = $("#appConfigForm").validate({
            onclick: true,
            rules: {
                name: { required: true, minlength: 1, maxlength: 50 },
                describe: { required: true },
                bgphoto: { required: true }
            },
            messages: {
                name: { required: '标题必须填写', minlength: '标题长度不能少于一个字或者多余50个字5个字符', maxlength: '标题长度不能少于一个字或者多余50个字' },
                describe: { required: '描述不能为空' },
                bgphoto: { required: '背景图片必须设置' }
            }
        });
        $("#appConfigForm").on('blur', 'input', function () { validator.element(this); })
    }

    //初始化设计器控件事件
    P.InitHandlers = function () {
        //切换编辑视图功能注册
        $(".app-design").on('click', '.app-entry>div', this.GetCall(this.OnChangeAppSidebar));
        //新增一过场图片功能注册
        $(".app-design").find(".js-add-page").click(this.GetCall(this.AddPage));
        //删除指定过场图片功能注册
        $(".app-design").on('click', '.js-pages-region .delete', this.GetCall(this.DeletePage));
        //擦除图片切换设置
        $("input[name=cleanstate]").click(this.GetCall(this.ChangePageWipePanel));
        //切换显示过场图片功能注册
        $(".custom-scroll-page").on('click', '.js-pages-region', this.GetCall(this.OnClickCustomePage));
        //添加连接功能注册
        $(".custom-scroll-page").on('click', '.add-link', this.GetCall(this.OnAddLink));
        //删除锚点功能注册
        $(".app-container").on('click', '.delete', this.GetCall(this.OnDeleteLink));
        //锚点形状切换
        $(".app-container").on('dblclick', '.map-link', this.GetCall(this.OnChangeMapLinkShape));
        //上传音乐
        this.RegistUploadifys($(".choose-music"), this.GetCall(this.OnSetBGMusic), false);
        //背景颜色设置
        $("input[name=color]").change(function () { $(".app-container").css("background", $(this).val()); });
        //首页图标显示控制
        $("input[name=homestate]").click(function () { MicroDesigner.Displayment(".ui-homepage-btn", this.checked); });
        //音乐图标显示控制
        $("input[name=musicstate]").click(function () { MicroDesigner.Displayment(".ui-music-btn", this.checked); });
        //封面页图片上传
        this.RegistUploadifys($(".js-first-page-image"), "input[name=homephoto]");
        //擦除图片上传
        this.RegistUploadifys($(".js-first-page-wipe-image"), "input[name=cleanphoto]");
        //背景图片
        this.RegistUploadifys($(".js-trigger-image"), this.GetCall(this.UploadifyBackgroundImageSuccess));
        this.RegistAnchor(".map-link");
        //过场图片
        this.RegistUploadifys($('.app-design .add-image'));
    }

    //同步图片
    P.SyncDesignerImage = function () {
        var page = $(".js-pages-region.selected");
        if (page.length <= 0) {
            this.SelectPage(0);
        }
        this.SetCurrentDesignImage(page.find("img").attr("src"));
    }

    //切换元素显示与隐藏
    P.Displayment = function (selector, visible) {
        if (visible == true) {
            $(selector).show();
        } else {
            $(selector).hide();
        }
    }

    //注册上传图片功能
    P.RegistUploadifys = function (target, success, noWrapper) {
        this.UploadifyIdRender(target);
        var self = this;
        target.each(function () { self.RegistUploadify(this, success, noWrapper); });
    }

    //注册单个元素上传功能
    P.RegistUploadify = function (item, success, noWrapper) {
        var target = $(item);
        var id = target.attr("id");
		var isFile = target.attr("isFile");
        var up = this.GetUploadifyParams(id,isFile);
        var self = this;
        _upinit = up.upinit;
        _para = up.para;
        target.uploadify({
            'swf': '/html/prg/upload/uploadify.swf',
            'uploader': '/servlets/binserv/UploadforWebroot',
            //'cancelImg'   : '/html/prg/upload/uploadify-cancel.png',
            'folder': '/html/nds',
            'multi': false,
            //'auto'			:false,
            'sizeLimit': _upinit.sizeLimit,
            'buttonText': _upinit.buttonText,
            'fileDesc': _upinit.fileDesc,
            'fileExt': _upinit.fileExt,
            'formData': _para,
            'method': 'post',
            onUploadError: function (evt, b, c, s) {
                //alert(123);
                if (b == 404)
                    alert('Could not find upload script.');
                else
                    alert('error ' + b + ": " + c);
            },
            onUploadSuccess: function (a, b, c) {
                var script = $(b);
                var src = script.html();
                script.remove();
                if (noWrapper != true) {
                    self.UploadifySuccess(src, '#' + id);
                }
                if (typeof success == 'string') {
                    $(success).val(src, a);
                }
                self.Call(success, src, id);
                self.SyncDesignerImage();
                noWrapper = success = self = null;
            }
        });
    }

    //获取图片上传参数
    P.GetUploadifyParams = function (id,isFile) {
        var upinit = {
            'sizeLimit': 1024 * 1024 * 1,		//上传文件最大值
            'buttonText': '选择',
            'fileDesc': '上传文件(dat)',
            'fileExt': '*.dat;'		//文件类型过滤,暂时没用到
        };
        var para = {
            "next-screen": "ml/prg/msgjson.jsp",		//
            "formRequest": "ml/nds/msg.jsp",			//
            //"JSESSIONID":"<%=session.getId()%>",
            "isThum": true,
            "width": 640,
            "hight": 1010,
            "onsuccess": "$filepath$",
            "onfail": "alert(\"上传图片失败，请重新选择上传\");",
            "modname": "Magazine"
        };
		if(isFile){
			para["isFile"] = true;
			delete para["isThum"];
			delete para["width"];
			delete para["hight"];
		}
        return { upinit: upinit, para: para };
    }

    //上传背景图片成功
    P.UploadifyBackgroundImageSuccess = function (src, id) {
        this.SetCurrentDesignImage(src);
        $("input[name=bgphoto]").val(src);
    }

    //上传图片成功
    P.UploadifySuccess = function (src, id) {
        var self = this;
        var target = $(id);
        var imgbox = target.prev(".image-box:eq(0)");
        target.parents(".js-pages-region:eq(0)").find("input[name=photo]").val(src);
        if (imgbox.length > 0) {
            imgbox.find("img").attr("src", src);
            return;
        }
        var htmls = [
                    '<div class="image-box">',
                    '<img src="' + src + '" class="image">',
                    '</div>'
        ]
        var content = $(htmls.join('\n'));
        content.insertBefore(target);
    }

    //上传完音乐后 设置背景音乐值
    P.OnSetBGMusic = function (src) {
        $("input[name=bgmusic]").val(src);
        $("#myBGMusic").html(src);
    }

    //设计当前设计区域展示的图片
    P.SetCurrentDesignImage = function (src) {
        var container = $("#app_img_container");
        if (container.css("display") == "none") {
            container.show();
        }
        container.attr("src", src);
    }

    //删除指定过场图片
    P.DeletePage = function (ev) {
        var target = $(ev.target || ev.srcElement);
        var page = target.parents(".js-pages-region");
        var pagement = page.find("input[name=id]");
        if (pagement.length > 0) {
            var id = pagement.val();
            if (id > 0) {
                this.imageRemoves.push(id);
            }
        }
        page.remove();
    }

    //新增一过场图片
    P.AddPage = function (ev) {
        var target = $(ev.currentTarget).parents(".js-options:eq(0)");
        var htmls = $("#tempAddPage").html();
        var content = $(htmls);
        content.insertBefore(target);
        content.attr("id", this.GetNextJsPageRegionId());
        content.find("input[name=page]").val(this.jsPageRegionId);
        this.RegistUploadifys(content.find(".add-image"));
        $(document.body).scrollTop(target.offset().top);
    }

    //新增连接
    P.AddLink = function () {
        var page = this.GetSelectedJsPageRegion();
        if (page.length <= 0) { return; };
        var ind = page.find("input[name=page]").val();
        var id = page.attr("id");
        var mapLinks = $(".map-link[data-target=" + id + "]");
        if (mapLinks.length > 4) {
            this.ShowMessage("过场页最多只能添加5个链接");
            return;
        }
        var href = '';
        var htmls = [
            '<div class="map-link" data-target="' + id + '">',
            '<input type="hidden" name="fromid" value=""/>',
            '<input type="hidden" name="objectid" value=""/>',
            '<input type="hidden" name="id" value=""/>',
            '<input type="hidden" name="anchor" value="" />',
            '<input type="hidden" name="page" value="' + ind + '" />',
            '<div class="actions">',
            '<span class="action delete close-modal" title="删除">×</span>',
            '</div>',
            '</div>'
        ];
        var link = $(htmls.join('\n'));
        link.attr("title", "锚点");//设置锚点标题 用于area的 alt属性
        link.attr("data-href", "");//用于设置锚点的连接地址  用于area的 href属性 
        $(".app-container").append(link);
        this.RegistAnchor(link);
    }

    //注册锚点
    P.RegistAnchor = function (selector) {
        $(selector).draggable({ containment: '.app-container', scroll: false });
        $(selector).resizable({ containment: '.app-container' });
    }

    //渲染上传元素编号
    P.UploadifyIdRender = function (target) {
        var self = this;
        target.each(function () {
            $(this).attr("id", self.GetNextUploadifyId());
        });
        self = null;
    }

    //获取一下一个过场图片的id
    P.GetNextJsPageRegionId = function () {
        var id = this.jsPageRegionId;
        id = this.jsPageRegionId = id + 10;
        return "jsPageRegion" + id;
    }

    //获取下一个上传图片id
    P.GetNextUploadifyId = function () {
        var id = this.uploadifyId;
        id = this.uploadifyId = id + 10;
        return "uploadify" + id;
    }

    //锚点形状切换
    P.OnChangeMapLinkShape = function (ev) {
        var target = $(ev.currentTarget);
        var shape = target.attr("data-shape") || "rect";
        target.removeClass(shape);
        if (shape == "rect") {
            shape = "circle";
        } else {
            shape = "rect";
        }
        target.addClass(shape);
        target.attr("data-shape", shape);
    }

    //点击界面设计不同部位显示对应的配置面板
    P.OnChangeAppSidebar = function (ev) {
        var target = $(ev.currentTarget);
        this.HideAppSidebar();
        var ind = target.index();
        $(".app-design").find(".app-sidebar").eq(ind).show();
    }

    //切换擦除图片设置面板
    P.ChangePageWipePanel = function (ev) {
        var target = ev.target || ev.srcElement;
        if (target.checked) {
            $(".nopagewipe").hide();
            $(".pagewipe").show();
        } else {
            $(".nopagewipe").show();
            $(".pagewipe").hide();
        }
    }

    //隐藏设计过场图片面下所有的编辑面板
    P.HideAppSidebar = function () {
        $(".app-design").find(".app-sidebar").hide();
    }

    //获取当前选中的过场图片
    P.GetSelectedJsPageRegion = function () {
        return $(".js-pages-region.selected");
    }

    //切换屏幕当前显示图片
    P.ChangeDesignContainerImage = function () {
        var page = $(".js-pages-region.selected");
        if (page.length > 0) {
            this.SetCurrentDesignImage(page.find("img").attr("src"));
        }
    }

    //点击删除指定锚点
    P.OnDeleteLink = function (ev) {
        var target = $(ev.currentTarget);
        var anchor = target.parents(".map-link:eq(0)");
        var anchorment = anchor.find("input[name=id]");
        if (anchorment.length > 0) {
            var id = anchorment.val();
            if (id > 0) {
                this.anchorRemoves.push(id);
            }
        }
        anchor.remove();
    }

    //点击新增连接按钮添加连接
    P.OnAddLink = function (ev) {
        var evs = $(ev.currentTarget);
        this.SelectPage(evs.parents(".js-pages-region:eq(0)"));
        this.AddLink();
    }

    //点击过场图片时选择指定过场图片并且切换设计过场图片面展示效果
    P.OnClickCustomePage = function (ev) {
        var target = $(ev.currentTarget);
        this.SelectPage(target);
        this.ChangeDesignContainerImage();
    }

    //选中指定的过场图片
    P.SelectPage = function (ind) {
        if (typeof ind == 'number') {
            var pages = $(".custom-scroll-page");
            pages.find(".js-pages-region.selected").removeClass("selected");
            pages.find(".js-pages-region").eq(ind).addClass("selected");
            this.ChangeDesignContainerImage();
        } else if (typeof ind == 'object') {
            var pages = $(".custom-scroll-page");
            pages.find(".js-pages-region.selected").removeClass("selected");
            ind.addClass("selected");
        }
        var container = $(".app-container");
        var page = pages.find(".js-pages-region.selected");
        container.find(".map-link").css("display", "none");
        container.find(".map-link[data-target=" + page.attr("id") + "]").css("display", "");
    }

    //返回托管调用函数
    //hander1....handlerN:一系列的处理函数
    P.GetCall = function (handler1, handlerN) {
        var self = this;
        var handlers = arguments;
        return function (r) {
            var handler = null;
            if (handlers == null) { return; }
            var paras = [];
            var handler = null;
            var fnHandlers = [];
            paras.push.apply(paras, arguments);
            for (var i = 0, k = handlers.length; i < k; i++) {
                handler = handlers[i];
                if (typeof handler != 'function') {
                    paras.push(handler);
                } else {
                    fnHandlers.push(handler);
                }
            }
            handlers = fnHandlers;
            for (var i = 0, k = handlers.length; i < k; i++) {
                handler = handlers[i];
                if (k == 1) {
                    return handler.apply(self, paras);
                } else {
                    handler.apply(self, paras);
                }
            }
            self = paras = handlers = fnHandlers = null;
        }
    }

    //安全指定指定函数
    P.Call = function (handler, data) {
        if (typeof handler == 'function') {
            var paras = [];
            paras.push.apply(paras, arguments);
            paras.shift();
            handler.apply(this, paras);
        }
    }

    MicroDesigner = new Designer();

    $(function () { MicroDesigner.Init(); });
}(window));

//表单填充搜集工具
(function (ev) {
    if (ev.FormUtil) { return; }

    FormUtil = {};

    FormUtil.Fill = function (formid, data, changes) {
        data = data || {};
        var formContainer = $(formid);
        var v = null;
        var item = null;
        for (var i in data) {
            v = data[i];
            item = formContainer.find("input[name=" + i + "],select[name=" + i + "],textarea[name=" + i + "]");
            if (item.length > 0) {
                if (item.is(":radio")) {
                    formContainer.find(":radio[name=" + i + "][value=" + v + "]").attr("checked", "checked");
                } else if (item.is(":checkbox")) {
                    if (item.length == 1) {
                        item[0].checked = (v == true || (v || '').toLowerCase() == "true");
                    } else if (item.length > 1) {
                        v = (v || '').toString().split(',');
                        for (var j = 0, k = v.length; j < k; j++) {
                            formContainer.find(":checkbox[name=" + i + "][value=" + v[j] + "]").attr("checked", "checked");
                        }
                    }
                } else {
                    item.val(v);
                    if (item.is(changes)) {
                        item.change();
                    }
                }
            }
        }
    }
    FormUtil.Read = function (formid, upper) {
        upper = upper == null ? true : upper;
        var formContainer = $(formid);
        var inputs = formContainer.find("input[name!=''],select[name!=''],textarea[name!='']");
        var data = {};
        var item = null;
        var name = "", v = null;
        var reads = {};
        for (var i = 0, k = inputs.length; i < k; i++) {
            item = $(inputs[i]);
            name = item[0].name;
            var pname = name;
            if (upper == true) { pname = pname.toUpperCase(); }
            if (item.attr("type") == "button") {
                continue;
            }
            if (item.is(":radio")) {
                if (reads[pname] != null) { continue; }
                reads[pname] = true;
                v = formContainer.find(":radio[name=" + name + "]:checked").val();
                if (v != null) {
                    data[pname] = v;
                }
            } else if (item.is(":checkbox")) {
                if (reads[pname] != null) { continue; }
                reads[pname] = true;
                var chs = formContainer.find(":checkbox[name=" + name + "]");
                if (chs.length == 1) {
                    data[pname] = chs[0].checked ? "Y" : "N";
                } else if (chs.length > 1) {
                    v = [];
                    chs.each(function () { v.push(this.value); });
                    data[pname] = v.join(',');
                }
            } else {
                if (item.is("select") && item.attr("data-text") != null) {
                    var text = item.attr("data-text");
                    data[text] = item.find('option:selected').text();
                }
                data[pname] = item.val();
            }
        }
        return data;
    }

}(window));
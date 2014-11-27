//------------------------------------------------
//
// 对话框模块
// 1.tips 		dialog.tips("消息内容")
// 2.alert 	dialog.alert({
//					content:"消息",
//					sureText:"ok",
//					cancelText:"cancel",
//					icon:true,//显示警告
//				})
// 3.loading 	dialog.loading(true) //true显示 false隐藏
// 4.confirm dialog.confirm({
// 					content : "1231",
// 					orderContent : [{
// 						title : "运费",
// 						classType : "price",
// 						content : "123"
// 						}, {
// 						title : "运费",
// 						classType : "other",
// 						content : "123"
// 						}
// 					]
// 				});
//------------------------------------------------
;(function (jQuery, window, undefined) {
var artDialog = function(){
	artDialog.version = "1.0";
	
	var _thisScript,_skin;//_thisScript脚本路径 _skin样式类型

	var tips = function(message,time){
		var that = tips,DOM;
		that.DOM = DOM = that.DOM || _getDOM(tips._templates);
		if(message){
			time = time || 1500;
			DOM.stop().css("opacity",1),
			DOM.hasClass("qb_none") || DOM.html(message),
			DOM.html(message).removeClass("qb_none"),
			setTimeout(function(){
				DOM.animate({
					opacity: 0
				},1000,"swing",function(){
					DOM.addClass("qb_none").removeAttr("style").html("");
				})
			},time);
		}
	};
	
	var loading = function(_boolean){
		var that = loading,DOM;
		that.DOM = DOM = that.DOM || _getDOM(loading._templates);
		_boolean ? DOM.removeClass("qb_none") : (setTimeout(function(){
			DOM.addClass("qb_none")
		},1000));
	};
	
	var alert = function(config){
		var that = alert,DOM;
		that.DOM = DOM = that.DOM || _getDOM(alert._templates);
		var elements = {
			sureNode: DOM.find(".btn:eq(0)"),
			cancelNode: DOM.find(".btn:eq(1)"),
			contentNode: DOM.find("p:eq(0)"),
			iconNode: DOM.find(".icon"),
			dialogNode:DOM
		};
		
		function sureFn(){
			defaults.sureFn.call(this, arguments), clean();
		}
		
		function cancelFn(){
			defaults.cancelFn.call(this, arguments), clean();
		}
		
		function clean(){
			elements.sureNode.html("确定").off("click", sureFn),
			elements.cancelNode.html("取消").off("click", cancelFn),
			elements.contentNode.empty(),
			elements.iconNode.addClass("qb_none"),
			elements.dialogNode.addClass("qb_none");
		}
		
		var defaults = {
			content: "",//内容
			sureText: "确定",//按钮文本
			cancelText: "取消",
			showNum: 2,//显示按钮数
			icon:false,//是否需要警告
			sureFn: function () {//确定事件
				return !0
			},
			cancelFn: function () {//取消事件
				return !0
			}
		};
		jQuery.extend(defaults, config),
		elements.dialogNode.hasClass("qb_none") && (elements.dialogNode.removeClass("qb_none"),
		elements.sureNode.on("click", sureFn),
		elements.cancelNode.on("click", cancelFn),
		1 == defaults.showNum && elements.cancelNode.addClass("qb_none"),
		0 == defaults.showNum && (elements.sureNode.addClass("qb_none"),elements.cancelNode.addClass("qb_none")),
		true == defaults.icon && elements.iconNode.removeClass("qb_none"),
		elements.sureNode.html(defaults.sureText),
		elements.cancelNode.html(defaults.cancelText),
		elements.contentNode.html(defaults.content));
	};
	
	var confirm = function(config){
		var that = confirm,DOM;
		that.DOM = DOM = that.DOM || _getDOM(confirm._templates);
		var elements = {
			sureNode: DOM.find("button[type=button]"),
			cancelNode: DOM.find("button[type=cancel]"),
			closeNode: DOM.find(".wx_confirm_close"),
			contentNode: DOM.find(".wx_confirm_tit"),
			orderNode: DOM.find(".confirm_order"),
			dialogNode:DOM
		};
		function sureFn(){
			defaults.sureFn.call(this, arguments), clean();
		}
		
		function cancelFn(){
			defaults.cancelFn.call(this, arguments), clean();
		}
		
		function closeFn(){
			defaults.closeFn.call(this, arguments), clean();
		}
		
		function clean(){
			elements.sureNode.html("确定").off("click", sureFn),
			elements.cancelNode.html("取消").off("click", cancelFn),
			elements.closeNode.removeClass("qb_none").off("click",closeFn),
			elements.contentNode.empty(),
			elements.contentNode.parent().removeClass("wx_confirm_show"),
			elements.orderNode.addClass("qb_none").empty(),
			elements.dialogNode.addClass("qb_none");
		}
		
		var defaults = {
			content: "",
			sureText: "确定",
			cancelText: "取消",
			close:true,
			showNum: 2,			
			sureFn: function () {
				return !0
			},
			cancelFn: function () {
				return !0
			},
			closeFn: function(){
				return !0
			}
		};
		jQuery.extend(defaults, config),
		elements.dialogNode.hasClass("qb_none") && (elements.dialogNode.removeClass("qb_none"),
		elements.sureNode.on("click", sureFn),
		elements.cancelNode.on("click", cancelFn),
		elements.closeNode.on("click", closeFn),
		1 == defaults.showNum && elements.cancelNode.addClass("qb_none"),
		0 == defaults.showNum && (elements.sureNode.addClass("qb_none"),elements.cancelNode.addClass("qb_none")),
		false == defaults.close && elements.closeNode.addClass("qb_none"),
		elements.sureNode.html(defaults.sureText),
		elements.cancelNode.html(defaults.cancelText),
		elements.contentNode.html(defaults.content),
		defaults.orderContent && (elements.contentNode.parent().addClass("wx_confirm_show"),elements.orderNode.removeClass("qb_none"),
			ags = defaults.orderContent,
			list = jQuery.isArray(ags[0]) ? ags[0] : [].slice.call(ags),
			jQuery.each(list,function(i,val){
				var _templates = "";
				if(val.classType == "price"){
					_templates = '<p>'+val.title+'：'+
										'<span class="price">￥'+
											'<span id="cod_total">'+val.content+'</span>'+
										'</span>'+
									'</p>';
				}else{
					_templates = '<p class="other">'+
									val.title+'：<span id="cod_yun_nouse">'+val.content+'</span>'
								'</p>';
				}
				elements.orderNode.append(_templates);
			})
		)
		);	
	};
	
	var _getDOM = function (_templates){//根据模板 创建元素
		var _element = jQuery(_templates);
		jQuery("body").append(_element);
		return _element;
	};
	
	// 获取dialog路径
	_path = (function (script, i, me) {
		for (i in script) {
			// 如果通过第三方脚本加载器加载本文件，请保证文件名含有"dialog"字符
			if (script[i].src && script[i].src.indexOf('dialog') !== -1) me = script[i];
		};
		
		_thisScript = me || script[script.length - 1];
		me = _thisScript.src.replace(/\\/g, '/');
		return me.lastIndexOf('/') < 0 ? '.' : me.substring(0, me.lastIndexOf('/'));
	}(document.getElementsByTagName('script')));



	// 无阻塞载入CSS (如"dialog.js?skin=aero")
	_skin = _thisScript.src.split('skin=')[1];
	if (_skin) {
		var link = document.createElement('link');
		link.rel = 'stylesheet';
		link.href = _path + '/skins/' + _skin + '.css?' + artDialog.version;
		_thisScript.parentNode.insertBefore(link, _thisScript);
	};

//各个模板的布局
tips._templates = '<div class="address_tips qb_none"></div>';

loading._templates = '<div class="wx_loading qb_none">'
+						'<div class="wx_loading_inner">'
+							'<i class="wx_loading_icon"></i>'
+							'请求加载中...'
+						'</div>'
+					'</div>';

alert._templates = '<div id="dialogConent" class="mod_alert fixed qb_none">'
+						'<i class="icon qb_none"></i>'
+						'<p></p>'
+						'<p>'
+							'<a href="javascript:;" class="btn btn_1" attr-tag="ok">确认</a>'
+               			'<a href="javascript:;" class="btn">取消</a>'
+						'</p>'
+					'</div>';

confirm._templates = '<div id="codFloat" class="qb_none">'
+						'<div class="wx_mask"></div>'
+						'<div class="wx_confirm">'
+							'<div class="wx_confirm_inner">'
+								'<div class="wx_confirm_hd">'
+									'<div class="wx_confirm_tit"></div>'
+									'<div class="wx_confirm_close" id="codGoPayCancel2" title="关闭"></div>'
+								'</div>'
+								'<div class="wx_confirm_bd">'
+									'<div class="wx_confirm_cont">'
+										'<div class="confirm_order qb_none">'
+										'</div>'
+									'</div>'
+									'<div class="wx_confirm_btns">'
+										'<button type="button">确认</button>'
+										'<button type="cancel">取消</button>'
+									'</div>'
+								'</div>'
+							'</div>'
+						'</div>'
+					'</div>';

	return {
		tips:tips,
		loading:loading,
		alert:alert,		
		confirm:confirm
	};
};
window.dialog = new artDialog();
}(this.jQuery, this));
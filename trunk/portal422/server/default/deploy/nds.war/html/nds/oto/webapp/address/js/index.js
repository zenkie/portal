(function(window){
	function Address(type,opt){//type类型 list收货地址管理 edit编辑地址
		this.config = jQuery.extend(true,{},Address.config,opt);
		this.init(type);
	}
	
	Address.prototype = {
		init: function(type){
			var _this = this;
			if(type == "List"){//根据类型初始化不同的事件
				//获取cookie值 判断是否更新地址，需要重新加载页面
				//获取cookie，update为true，则刷新界面，并且先删除此类cookie
				//然后重新加载js就不会重新加载页面
				var isUpdate = this.getCookie("AddressUpdate");
				if(isUpdate){
					this.delCookie("AddressUpdate","false");
					location.reload();
					return false;
				}else if(jQuery("#addList").val() == 0){
					setTimeout(function(){
						location.href="/html/nds/oto/webapp/address/editAddress.vml?type="+_this.config.type;
					},500);
				}
				this.bindListEvent();
			}else{
				this.bindEditEvent();
			}
		},
		
		//列表地址显示 事件绑定
		bindListEvent: function(){
			var _this = this;			
			//返回上一页
			jQuery('#listPageback').bind('click', function () {
				history.back();
			});
			//绑定删除事件
			jQuery('.del').click(function () {
				var _element = jQuery(this);
				dialog.alert({
					content:"确认删除地址吗？",
					sureFn:function(){
						dialog.loading(true);
						var delId = _element.parent().attr('delId');
						var _params = _this.config.params;
						_params["id"] = delId;
						var removeElement = _element.closest("div");
						_this.submitData("ObjectDelete",_params,function(){
							removeElement.remove();
						});
					}
				});
			});
			//点击新增地址
			jQuery('#new,#_new').bind('click', function () {
				location.href="/html/nds/oto/webapp/address/editAddress.vml?type="+_this.config.type;
			});
			//绑定 左移显示删除按钮
			jQuery('#addressList ul').bind({
				'touchmove' : function (event) {
					event = event.originalEvent;
					if (event.targetTouches.length == 1) {
						var touch = event.targetTouches[0],
						leftX;
						leftX = touch.pageX - this.startX;
						this.isMove = true;
						this.leftX = leftX;
						this.style.webkitTransition = "-webkit-transform 0s ease";
						if (leftX < 0) {
							this.re = 'l';
							if (leftX < -70) {
								leftX = -70;
							}
							if (this.stats == 'r') {
								this.style.webkitTransform = 'translateX(' + leftX + 'px)';
							}
						} else {
							this.re = 'r';
							if (leftX > 70) {
								leftX = 70;
							}
							if (this.stats == 'l') {
								this.style.webkitTransform = 'translateX(' + (leftX - 70) + 'px)';
							}
						}
						if (Math.abs(leftX) > 10) {}
						else {
							this.style.webkitTransform = 'translateX(0px)';
						}
					}
				},
				'touchstart' : function (event) {
					event = event.originalEvent;
					if (event.targetTouches.length == 1) {
						if (!this.stats)
							this.stats = 'r';
						this.startTime = new Date().getTime();
						var touch = event.targetTouches[0];
						this.startX = touch.pageX;
						this.isMove = false;
					}
				},
				'touchend' : function (event) {
					event = event.originalEvent;
					if (!this.leftX || this.leftX == 0 || !this.isMove) {
						setTimeout(function () {
							runClickEvent(event.target);//回调编辑按钮事件或当type为pagePay时 点击地址选中为默认地址
						}, 500);
						return;
					}
					this.style.webkitTransition = "-webkit-transform 0.5s ease";
					if (this.re == 'r') {
						this.style.webkitTransform = 'translateX(0px)';
						this.stats = 'r';
					} else {
						if (this.leftX > -35) {
							this.style.webkitTransform = 'translateX(0px)';
							this.stats = 'r';
						} else {
							this.style.webkitTransform = 'translateX(-70px)';
							this.stats = 'l';
						}
					}
				}
			});
			//编辑地址按钮事件
			function runClickEvent(t) {
				if ((t.tagName.toLowerCase() == 'a' && jQuery(t).parent().attr('class') === 'edit') || (t.tagName.toLowerCase() === 'li' && t.className.toLowerCase() === 'edit')) {
					if (t.tagName.toLowerCase() == 'a') {//点击编辑按钮 编辑地址信息
						t = t.parentElement;
					}
					location.href="/html/nds/oto/webapp/address/editAddress.vml?adId="+jQuery(t).attr("adId")+"&type="+_this.config.type;
				}else if(_this.config.type == "pagePay"){//选择默认地址
					dialog.loading(true);
					if (t.tagName.toLowerCase() == 'li') {
						t = t.parentElement;
					}
					if (t.tagName.toLowerCase() == 'strong') {
						t = t.parentElement.parentElement;
					}
					var _params = {
						"table": "WX_ADDRESS",
						"partial_update": true,
						"id":jQuery(t).attr("adId"),
						"ISADDRESS":2
					}
					_this.submitData("ObjectModify",_params,function(){
						history.back();
					});
				}
			}
		},		
		
		//编辑地址 事件绑定
		bindEditEvent: function(){
			var _this = this;
			jQuery("#add,#editBtn").bind('click',function(){
				if(!_this.checkAddressForm()){
					return false;
				}
				dialog.loading(true);
				//新增收货地址
				var _command = _this.config.command;
				var _params = _this.config.params;
				jQuery("input[name!=''],select").each(function(){
					var _this = jQuery(this);
					var key = _this.attr("name");
					var value = _this.val();
					_params[key] = value;
				});
				_params["ADDRESS"] = _params["PROVINCE"]+_params["CITY"]+_params["REGIONID"]+_params["ADDRESS"];
				_this.submitData(_command,_params,function(){
					_this.goPage(_this.config.type);
				});
			});
		},
		
		//编辑地址数据提交验证
		checkAddressForm: function (){
			//验证收货人的姓名
			var NAME = jQuery("#NAME");
			NAME.val(NAME.val().replace(/[\?\&\~\^*\%\$\"\']/g, "").replace(/^ *| *$/g, "").replace(/ +/g, " "));
			var tempName = NAME.val().replace(/[^\x00-\xff]/g, "aaa");
			if (tempName.length == 0) {
				dialog.tips("请填写收货人姓名。");
				return false;
			} else if (tempName.length > 30) {
				dialog.tips("姓名必须少于等于10个汉字。");
				return false;
			} else if (tempName.length < 3) {
				dialog.tips("姓名过短，请填写正确的收货人姓名。");
				return false;
			} else if (tempName.length > 0 && tempName.length <= 30 && !(/^[A-Za-z ]{3,30}$/).test(tempName)) {
				dialog.tips("收货人姓名只能输入中文和字母。");
				return false;
			}
			//验证手机号码
			var PHONENUM = jQuery("#PHONENUM");
			PHONENUM.val(PHONENUM.val().replace(/[ \?\&\~\^*\%\$\"\']/g, ""));
			var tempMobile = PHONENUM.val();
			if (tempMobile == "") {
				dialog.tips("请填写手机号码");
				return false;
			} else if (!this.isMobile(tempMobile)) {
				dialog.tips('手机号码格式不正确。');
				return false;
			}
			//验证省市区
			var PROVINCE = jQuery("#PROVINCE").val();
			PROVINCE = PROVINCE == "请选择省" ? "" : PROVINCE;
			if(PROVINCE == ""){
				jQuery("#PROVINCE").closest("label").addClass("error");
				dialog.tips("请选择省份！");
				return false;
			}
			//城市无需验证，只需要验证 省 和 区县
			var REGIONID = jQuery("#REGIONID").val();
			REGIONID = REGIONID == "请选择区" ? "" : REGIONID;
			REGIONID = REGIONID == "市辖区" ? "" : REGIONID;
			if(REGIONID == ""){
				jQuery("#REGIONID").closest("label").addClass("error");
				dialog.tips("请选择区/县！");
				return false;
			}
			//验证详细地址
			var ADDRESS = jQuery("#ADDRESS").val();
			ADDRESS = ADDRESS.replace(/^ *| *$/g, "").replace(/\?/g, "？").replace(/&/g, "﹠").replace(/~/g, "").replace(/\^/g, "").replace(/\$/g, "﹩").replace(/"/g, "〞").replace(/'/g, "＇").replace(/#/g, "﹟");
			if (ADDRESS.length < 1) {
				dialog.tips("请填写详细地址");
				return false;
			} else if (ADDRESS.replace(/[^\x00-\xff]/g, "aaa").length < 4) {
				dialog.tips("详细地址过短，请填写正确的详细地址。");
				return false;
			} else if (ADDRESS.replace(/[^\x00-\xff]/g, "aaa").length > 255) {
				dialog.tips("详细地址过长，不能超过85个汉字。");
				return false;
			}
			return true;
		},

		//编辑地址手机号码验证
		isMobile: function (v) {
			var cm = "134,135,136,137,138,139,150,151,152,157,158,159,187,188,147,182,183",//移动
			cu = "130,131,132,155,156,185,186,145",//联通
			ct = "133,153,180,181,189",//电信
			v = v || "",
			h1 = v.substring(0, 3),
			h2 = v.substring(0, 4),
			v = (/^1\d{10}$/).test(v) ? (cu.indexOf(h1) >= 0 ? "联通" : (ct.indexOf(h1) >= 0 ? "电信" : (h2 == "1349" ? "电信" : (cm.indexOf(h1) >= 0 ? "移动" : "未知")))) : false;
			return v;
		},
		
		goPage: function(type){
			if(type == "pageAddress"){
				//写入cookie 告诉上一层界面 地址我已经新增或者修改过，你需要重新加载页面
				//doSomething()
				this.setCookie("AddressUpdate","true");
				history.back();//地址管理，编辑地址成功 只返回上一层
			}else{
				//返回二层，订单页面有个js获取默认收货地址，然后更新界面
				history.go(-2);//订单地址管理，编辑成功，返回二层 返回到订单页面
			}
		},
		
		setCookie: function(name, value, expires, path, domain, secure) {
			var exp = new Date(),
			expires = arguments[2] || null,
			path = arguments[3] || "/",
			domain = arguments[4] || null,
			secure = arguments[5] || false;
			expires ? exp.setMinutes(exp.getMinutes() + parseInt(expires)) : "";
			document.cookie = name + '=' + escape(value) + (expires ? ';expires=' + exp.toGMTString() : '') + (path ? ';path=' + path : '') + (domain ? ';domain=' + domain : '') + (secure ? ';secure' : '');
		},
		
		getCookie: function(name) {
			var reg = new RegExp("(^| )" + name + "(?:=([^;]*))?(;|$)"),
			val = document.cookie.match(reg);
			return val ? (val[2] ? unescape(val[2]) : "") : null;
		},
		
		delCookie: function(name,value){
			this.setCookie(name,value,-10000);//
		},
		
		//数据提交接口
		submitData: function(_command,_params,_success){
			jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				dataType: 'json',
				data:{command:_command,params:JSON.stringify(_params)},//将json对象转换成字符串
				success: function (data) {
					dialog.loading(false);
					if(data[0].code == 0){
						_success && _success(data);
					}else{
						dialog.tips(data[0].message);
					}
				},
				error: function () {
					alert("网络出现问题，请检查网络链接！");
				}
			});
		}
	};
	
	Address.config = {
		command: "ObjectCreate",
		params: {
			"table" : "WX_ADDRESS"
		},
		type: "pageAddress" //pageAddress收货地址管理，不涉及订单管理； pagePay表示订单收货地址管理
	};
	
	window.Address = Address;
}(window));
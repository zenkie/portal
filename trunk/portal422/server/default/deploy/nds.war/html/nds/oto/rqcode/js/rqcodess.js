var wem=null;
var wemenu=Class.create();

wemenu.prototype={
	initialize:function(){
		this.id=0;
		this.isChangeMenu=false;
		this.isChangeReply=false;
		this.menu=null;
		this.content={};
		this.tempContent=null;
		this.menuType=null;
		this.ad_client_id=0;
		this.msgtypes={
			Link:"链接",
			Words:"文本",
			Image:"图片",
			Language:"语音",
			Video:"视频",
			Music:"音乐",
			News:"图文",
			Action:"动作定义"
		};
		//显示图文操作按钮
		jQuery("#divRelpyNews .appmsgItem").live('mouseover', function () {
			jQuery(this).addClass("sub-msg-opr-show");
		}).live('mouseout', function () {
			jQuery(this).removeClass("sub-msg-opr-show");
		});
		//多图文删除
		jQuery("#divRelpyNews .appmsgItem .iconDel").live('click', function () {
			//从tuwen中删除
			var listNode = jQuery(this).closest(".appmsgItem");
			listNode.remove();
			if(jQuery("#divRelpyNews .msg-item").children().length<10){jQuery("#divRelpyNews .sub-add").show();}
			/*if(!(wem.menu&&wem.menu.key)){return;}
			var key=jQuery(listNode).attr("id");
			if(key){
				wem.content[wem.menu.key].count--;
				var ct=wem.content[wem.menu.key].tuwen[key];
				delete wem.content[wem.menu.key].tuwen[key];
				
				for(key in wem.content[wem.menu.key].tuwen){
					if(wem.content[wem.menu.key].tuwen[key].sort>=ct.sort){wem.content[wem.menu.key].tuwen[key].sort--;}
				}
			}*/
		});
		//拖动多图文
		jQuery("#divRelpyNews .appmsgItem").live("mousedown",function(e){
			
		});
		//jQuery("#initmenu .webfx-tree-item>a").live("mousedown",function(e){
		jQuery("ssssssssssssss").live("mousedown",function(e){
			if(e.which!=1&&window.moveMenu){return;}
			e.preventDefault(); // 阻止选中文本
			var _this = jQuery(this).closest(".webfx-tree-item"); // 点击选中块
			var node=webFXTreeHandler.all[_this.attr("id")];
			var x = e.pageX;
			var y = e.pageY;
			var w = _this.width();
			var h = _this.height();
			var wm = w/2;
			var hm = h/2;
			var p = _this.offset();
			var left = p.left;
			var top = p.top;
			window.moveMenu = true;
			var childNode=jQuery("#"+node.id+"-cont");
			var ch=childNode.height();
			var isInsert=true;
			var wid;
			//jQuery("#ddddd").html("");
			jQuery(document).bind("mousemove",function(e){
				if(isInsert){
					// 添加虚线框
					_this.before('<div id="kp_widget_holder"></div>');
					wid = jQuery("#kp_widget_holder");
					wid.css({"border":"2px dashed #ccc", "height":_this.outerHeight(true)+jQuery("#"+node.id+"-cont").outerHeight(true)-4});
					// 保持原来的宽高
					
					_this.css({"width":w, "height":h+ch, "position":"absolute", opacity: 0.8, "z-index": 999, "left":left, "top":top});
					jQuery("#"+node.id+"-cont").css({"width":w, "height":h+ch, "position":"absolute", opacity: 0.8, "z-index": 999, "left":left, "top":top});
					isInsert=false;
				}
			
				e.preventDefault();
				var l = left + e.pageX - x;
				var t = top + e.pageY - y;
				_this.css({"left":l, "top":t});
				jQuery("#"+node.id+"-cont").css({"left":l, "top":t+h});

				// 选中块的中心坐标
				var ml = l+wm;
				var mt = t+hm;
				
				// 遍历所有块的坐标
				jQuery("#"+node.parentNode.id+"-cont>div").not("[id$=-cont]").not(_this).not(wid).each(function(i) {
					var obj = jQuery(this);
					var cNode=jQuery("#"+obj.attr("id")+"-cont");
					if(cNode.attr("class").with("show-child")){}
					var p = obj.offset();
					var cl = p.left;
					var cal = p.left + obj.width();
					var cp = p.top;
					var cap = p.top + obj.height();
					// 移动虚线框
					if(cl < ml && ml < cal && cp < mt && mt < cap) {
						if(!obj.next("#kp_widget_holder").length) {
							wid.insertAfter(this);
						}else{
							wid.insertBefore(this);
						}
						return;
					}
				});
			});
			// 绑定mouseup事件
			jQuery(_this).bind("mouseup",function() {
				jQuery(document).unbind("mousemove").unbind("mouseup");
				//不会从一个节点移动到另一个父节点中，所以不用判断容器是否为空
				// 检查容器为空的情况
				/*$(container).each(function() {
					var obj = $(this).children();
					var len = obj.length;
					if(len == 1 && obj.is(_this)) {
						$("<div></div>").appendTo(this).attr("class", "kp_widget_block").css({"height":100});
					}else if(len == 2 && obj.is(".kp_widget_block")){
						$(this).children(".kp_widget_block").remove();
					}
				});*/
				// 拖拽回位，并删除虚线框
				var p = wid.offset();
				//jQuery("#ddddd").append("===========================================");
				jQuery(_this).animate(
					{"left":p.left, "top":p.top}, 
					{
						duration:100, 
						step:function(now,fx){
							//jQuery("#"+node.id+"-cont").css({"left":p.left, "top":p.top+h});
							jQuery("#"+node.id+"-cont").css(fx.prop,now);
							//var data = fx.elem.id + ' ' + fx.prop + ': ' + now;
							//jQuery("#ddddd").append('<div>' + data + '</div>');
						},
						complete:function() {
							_this.removeAttr("style");
							jQuery("#"+node.id+"-cont").removeAttr("style");
							wid.replaceWith(_this);
							_this.after(jQuery("#"+node.id+"-cont"));
							window.kp_only = false;
						}
					}
				);
			});
		});
		this.initMenuReply();
		application.addEventListener("SAVE_REPLYMENU", this._onSaveReply, this);
		application.addEventListener("DELETE_MENU", this._onDeleteMenu, this);
		application.addEventListener("ISSUE_MENU", this._onIssueMenu, this);
		application.addEventListener("PERFECTION_VIPINFO", this._onPerfectionVipinfo, this);
	},
	getMessageKeyByValue:function(value){
		var key;
		switch(value){
			case "文本":
				key= "Words";
				break;
			case "图片":
				key= "Image";
				break;
			case "语音":
				key= "Language";
				break;
			case "视频":
				key= "Video";
				break;
			case "音乐":
				key= "Music";
				break;
			case "图文":
				key= "News";
				break;
			default :
				key="Link";
				break;
		}
		return key;
	},
	
	//初始化所有菜单回复
	initMenuReply:function(){
		var wemenu=this;
		jQuery.ajax({
			url:'/html/nds/oto/menu/getMenuReply.jsp',
			type:'get',
			async: false,
			success: function (data) {
				var con=eval('('+data+')');
				wemenu.ad_client_id=con.ad_client_id;
				delete con.ad_client_id;
				wemenu.content=con;
			},
			error:function(data){
				alert("error");
			}
		});
	},
	//编辑菜单
	editMenu:function(oItem){
		var tItem=webFXTreeHandler.all[oItem.id.replace('-anchor','')];
		if(tItem.index<0){
			jQuery("#relpys").hide();
			jQuery("#buttons").hide();
			jQuery("#defaultrelpy").show();
			return false;
		}
		var me;
		var parent=tItem.parentNode;
		if(parent.index<0){me=webFXTreeHandler.nodeJson["button"][tItem.index];}
		else{me=webFXTreeHandler.nodeJson["button"][parent.index]["sub_button"][tItem.index];}
		
		if(this.menu===me){return false;}
		if(this.isChangeReply){
			art.dialog({title:"警告",
			lock:true,
			icon:"warning",
			//cancelVal: "关闭",
			content:"菜单回复修改未保存，确定要放弃修改吗？",
			ok:function(){
				wem.isChangeReply=false;
				wem.menu=me;
				wem.changeMenu(tItem);
			},
			cancel:true
			});
		}else{
			wem.menu=me;
			wem.changeMenu(tItem);
		}
	},
	changeMenu:function(tItem){
		jQuery("#defaultrelpy").hide();
		var cContent=wem.content[wem.menu.key];
		if(cContent){wem.menu.menuType=wem.getMessageKeyByValue(cContent.msgtype);}
		
		tItem.focus();
		if(wem.menu["sub_button"]&&wem.menu["sub_button"].size()>0){
			jQuery("#relpys").hide();
			jQuery("#buttons").hide();
			jQuery("#notrelpys").show();
		}else{
			if(!wem.menu.menuType){wem.menu.menuType="Link";}
			var text = wem.msgtypes[wem.menu.menuType];
			jQuery("#returnType").html(text);
			
			switch(wem.menu.menuType){
				case "Link":
					wem.showLink();
					break;
				case "Words":
					wem.showWords();
					break;
				case "News":
					wem.showNews();
					break;
				default:
					wem.init();
					break;
			}
			
			jQuery("#notrelpys").hide();
			jQuery("#buttons").show();
			jQuery("#relpys").show();
			//切换回复类型的文字
			//wem.setMenuType(wem.menu.menuType);
			jQuery("#divRelpys >div[id!=divRelpy"+wem.menu.menuType+"]").hide();
			jQuery("#divRelpy"+wem.menu.menuType).show();
		}
		wem.menuType=wem.menu.menuType;
		return true;
	},
	//显示初始化
	init:function(){
		this.initNews();
		this.initWords();
		this.initLink();
	},
	//初始化多图文
	initNews:function(){
		var defaultNews="<div class=\"msg-item multi-msg\">"
					+		"<div class=\"appmsgItem\" flag=\"0\" imagetype=\"bigImage\">"
					+			"<p class=\"msg-meta\"><span class=\"msg-date\">&nbsp;</span></p>"
					+			"<span class=\"cover\" style=\"position: absolute;width: 322px;\">"
					+				"<p id=\"pDefaultTip\" class=\"default-tip\" style=\"\">封面图片</p>"
					+				"<img id=\"imgPic\" class=\"i-img\" style=\"display:none;\">"
					+			"</span>"
					+			"<div class=\"cover\">"
					+				"<div class=\"msg-t h4\">"
					+					"<span id=\"spnTitle\" class=\"i-title\"></span>"
					+				"</div>"
					+				"<ul class=\"abs tc sub-msg-opr\">"
					+					"<li class=\"b-dib sub-msg-opr-item\">"
					+						"<a href=\"javascript:void(0);\" onclick=\"wem.editTuwen(this)\" class=\"th icon18 iconEdit\">编辑</a>"
					+					"</li>"
					+				"</ul>"
					+			"</div>"
					+		"</div>"
					+		"<div class=\"sub-add\">"
					+			"<a href=\"javascript:;\" class=\"block tc sub-add-btn\" onclick=\"wem.addNews()\"><span class=\"vm dib sub-add-icon\"></span>增加一条</a>"
					+		"</div>"
					+	"</div>"
		jQuery("#divRelpyNews").html(defaultNews);
		jQuery("#spnAddLink").hide();
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").hide();
		jQuery("#spanReplyNews").show();
		/*if(!this.menu.key){return;}
		var reply=this.content[this.menu.key];
		if(!reply){return;}
		reply.tuwen={};
		this.content[this.menu.key]=reply;*/
	},
	//初始化文本
	initWords:function(){
		jQuery("#txtReplyWords").val("");
		jQuery("#spnAddLink").show();
		wem.setRemainString();
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").show();
		jQuery("#spanReplyNews").hide();
	},
	//初始化链接
	initLink:function(){
		jQuery("#Linktitle").removeAttr("fromid");
		jQuery("#Linktitle").removeAttr("replace");
		jQuery("#Linktitle").val("");
		jQuery("#spnAddLink").hide();
		jQuery("#spanReplyLink").show();
		jQuery("#spanReplyWords").hide();
		jQuery("#spanReplyNews").hide();
	},
	showLink:function(){
		if(wem.menu&&wem.menu.key&&wem.content.hasOwnProperty(wem.menu.key)){
			var reply=wem.content[wem.menu.key];
			if(!reply){return;}
			if(wem.getMessageKeyByValue(reply.msgtype)=="Link"){
				//jQuery("#Linktitle").val(reply.title);
				jQuery("#Linktitle").val(wem.menu.name);
				var uc=eval('('+reply.urlcontent+')');
				if(!uc||uc.length<=0){return;}
				jQuery("#Linktitle").attr({"fromid":uc[0].fromid,"replace":uc[0].replace});
			}else{
				jQuery("#Linktitle").val("");
				jQuery("#Linktitle").removeAttr("fromid");
				jQuery("#Linktitle").removeAttr("replace");
			}
		}
		else{wem.initLink();}
		jQuery("#spanReplyLink").show();
		jQuery("#spanReplyWords").hide();
		jQuery("#spanReplyNews").hide();
		jQuery("#spnAddLink").hide();
	},
	showWords:function(){
		if(wem.menu&&wem.menu.key&&wem.content.hasOwnProperty(wem.menu.key)){
			jQuery("#txtReplyWords").val(wem.content[wem.menu.key].content);
			wem.setRemainString();
		}else{wem.initWords();}
		jQuery("#spnAddLink").show();
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").show();
		jQuery("#spanReplyNews").hide();
	},
	showNews:function(){
		jQuery("#spnAddLink").hide();
		wem.initNews();
		if(!wem.menu.key){return;}
		
		//if(!wem.content.hasOwnProperty(wem.menu.key)){wem.content[wem.menu.key]=wem.initContent("News");}
		var cContent=wem.content[wem.menu.key];
		if(!cContent){return;}
		//cContent.keyword=this.menu.key;
		//if(!cContent.tuwen){cContent.tuwen={};}
		//this.content[this.menu.key]=cContent;
		var alltuwen = cContent.tuwen;
		if(!alltuwen||jQuery.isEmptyObject(alltuwen)){return;}
		
		
		var sort=0;
		var replys=[];
		jQuery.each(alltuwen,function(key,tuwen){
			//大图
			sort=parseInt(tuwen.sort);
			if(tuwen.imageSize=="bigImage"||Object.getOwnPropertyNames(cContent.tuwen).length<=1){
				var pp = jQuery("#divRelpyNews>div div:first");
				pp.find(".i-title").text(tuwen.title1);
				if(tuwen.url1){
					pp.find(".i-img").attr("src",tuwen.url1);
					pp.find(".i-img").css("display","block");
					pp.find(".default-tip").css("display","none");
				}
				jQuery(pp).attr({"id":key,"fromid":tuwen.fromid,"replace":tuwen.objid,"title":tuwen.title1,"url":tuwen.url1,"content":tuwen.content1});
				//wem.content[wem.menu.key].tuwen[key]=jQuery.extend(tuwen);
				return true;
			}
			//小图
			var s = '';
			/*var pps = jQuery("#divRelpyNews>div div[id="+key+"]");
			if(pps.length>0){
				pps.find(".i-title").text(tuwen.title1);
				if(tuwen.url1){
					pps.find(".i-img").attr("src",tuwen.url1);
					pps.find(".i-img").css("display","block");
					pps.find(".default-tip").css("display","none");
				}
			}else{*/
				s='';
				//{"fromid":obj.fromid,"replace":obj.objid,"title":obj.title1,"url":obj.url1,"content":obj.content1}
				s += '<div id="'+key+'" class="rel sub-msg-item appmsgItem" flag="1" imagetype=\"smallImage\" fromid='+tuwen.fromid+' replace=\"'+tuwen.objid+'\" title=\"'+tuwen.title1+'\" url=\"'+tuwen.url1+'\" content=\"'+tuwen.content1+'\" >';
				s += '    <span class="thumb">';
				s += '        <span class="default-tip" style="display:'+(tuwen.url1?"none":"block")+';">缩略图</span>';
				s += '        <img class="i-img" style="display:'+(tuwen.url1?"block":"none")+';" src="'+tuwen.url1+'">';
				s += '    </span>';
				s += '    <div class="msg-t h4">';
				s += '        <span class="i-title">'+tuwen.title1+'</span>';
				s += '    </div>';
				s += '    <ul class="abs tc sub-msg-opr">';
				s += '        <li class="b-dib sub-msg-opr-item">';
				s += '            <a href="javascript:void(0);" onclick="wem.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
				s += '        </li>';
				s += '        <li class="b-dib sub-msg-opr-item">';
				s += '            <a href="javascript:;" class="th icon18 iconDel" data-rid="2">删除</a>';
				s += '        </li>';
				s += '    </ul>';
				s += '</div>';
				replys[sort]=s;
				//jQuery("#divRelpyNews .sub-add").before(s);
			/*}*/
			//插入文字
			//wem.content[wem.menu.key].tuwen[key]=jQuery.extend(tuwen);
		});
		cContent.tuwen=alltuwen;
		wem.content[wem.menu.key]=cContent;
		if(replys.length>0){
			var divReply=[];
			for(var i=0;i<replys.length;i++){
				if(replys[i]){continue;}
				replys.splice(i,1);
			}
		}
		if(replys.length>0){jQuery("#divRelpyNews .sub-add").before(replys.join(""));}
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").hide();
		jQuery("#spanReplyNews").show();
		if(alltuwen&&Object.getOwnPropertyNames(alltuwen).length>=10){jQuery("#divRelpyNews .sub-add").hide();}
	},
	//设置链接菜单
	setMenuLinkValue:function(){
		var options={width:963,height:399,title:'选择菜单',resize:false,drag:true,lock:true,esc:true,skin:'chrome',ispop:false,close:function(){wem.setResultMenuLink();}}; 
		var url="/html/nds/oto/menu/menuUrl.jsp";
		var fromid=jQuery("#Linktitle").attr("fromid");
		var replace=jQuery("#Linktitle").attr("replace");;
		
		//if(fromid&&!isNaN(fromid)){url+="?fromid="+fromid+"&objid="+replace+"&title="+jQuery("#Linktitle").val().trim();}
		if(fromid&&!isNaN(fromid)){url+="?fromid="+fromid+"&objid="+replace+"&title="+wem.menu.name;}
		else{url+="?title="+wem.menu.name;}
		//if(this.menu&&this.menu.hasOwnProperty("fromid")){url+="?fromid="+this.menu.fromid+"&objid="+this.menu.objid+"&title="+this.menu.title;}
		art.dialog.open(url,options);
	},
	//设置APPID与APPSECRET
	setWeixin:function(){
		var options={width:"auto",height:"auto",title:'微信接口配置',resize:false,drag:true,lock:true,esc:true,skin:'chrome',ispop:false}; 
		var url="/html/nds/oto/object/object.jsp?table=WX_INTERFACESET";
		art.dialog.open(url,options);
	},
	//设置链接菜单返回值
	setResultMenuLink:function(){
		var result=art.dialog.data('dataObj');
		if(this.menu&&result){
			/*this.menu.title=result.title;
			this.menu.fromid=result.fromid;
			this.menu.objid=result.objid;*/
			jQuery("#Linktitle").val(result.title);
			jQuery("#Linktitle").attr({"fromid":result.fromid,"replace":result.objid});
			/*if(!this.menu.key){this.menu.key=this.initKey();}
			if(!this.content.hasOwnProperty(this.menu.key)){this.content[this.menu.key]=this.initContent("Link");}
			var cContent=this.content[this.menu.key];
			cContent.keyword=this.menu.key;
			cContent.msgtype=wem.msgtypes["Link"];
			cContent.title=result.title;
			cContent.tuwen={};
			cContent.content="";
			cContent.urlcontent=[{"fromid": result.fromid, "replace": result.objid, "oldreplace": "@ID@", "receive": ""}];
			this.content[this.menu.key]=cContent;
			//this.setMenuType("Link");*/
			this.isChangeReply=true;
		}
	},
	//设置文本链接
	setTarget:function(){
		var titleName="设置链接";
		var url='/html/nds/oto/menu/jumpUrl.jsp';
		var options={
			width:800,
			height:505,
			title:titleName,
			resize:false,
			drag:true,
			lock:true,
			esc:true,
			skin:'chrome',
			ispop:false,
			close:function(){
				var result=art.dialog.data('dataObj');
				if(wem.menu&&result){
					wem.insertText("#txtReplyWords",result.url);
					/*wem.setRemainString();
					if(!wem.menu.key){wem.menu.key=wem.initKey();}
					if(!wem.content.hasOwnProperty(wem.menu.key)){wem.content[wem.menu.key]=wem.initContent("News");}
					var cContent=wem.content[wem.menu.key];
					cContent.title="";
					cContent.keyword=wem.menu.key;
					cContent.tuwen={};
					cContent.msgtype=wem.msgtypes["Words"];
					cContent.content=jQuery("#txtReplyWords").val().trim();
					//wem.setMenuType("Words");*/
					wem.isChangeReply=true;
					jQuery("#txtReplyWords").focus();
				}
			}
		}; 
		 
		art.dialog.open(url,options);
	},
	//增加一个多图
	addNews:function(){
		/*if(!this.menu){return;}
		var key;
		if(!wem.menu.key){
			key=this.initKey();
			wem.menu.key=key;
		}
		if(!key){key=wem.menu.key;}
		if(!wem.content.hasOwnProperty(key)||!wem.content[wem.menu.key]){wem.content[key]=wem.initContent("News");}
		var cContent=wem.content[key];
		if(!cContent.tuwen){cContent.tuwen={};}
		if(jQuery.isEmptyObject(cContent.tuwen)){
			var pp = jQuery("#divRelpyNews>div>div:first");
			key=jQuery(pp).attr("id");
			if(!key){
				key=wem.initKey();
				jQuery(pp).attr("id",key);
			}
			cContent.tuwen[key]=wem.initTuWen("bigImage");;
		}
		key=this.initKey();
		cContent.tuwen[key]=this.initTuWen();
		cContent.keyword=this.menu.key;
		cContent.msgtype=wem.msgtypes["News"];
		this.content[this.menu.key]=cContent;*/
			
		var s = ""
		//s += "<div id=\""+key+"\" class=\"rel sub-msg-item appmsgItem\" flag=\"1\" imagetype=\"smallImage\">";
		s += "<div class=\"rel sub-msg-item appmsgItem\" flag=\"1\" imagetype=\"smallImage\">";
		s += "    <span class=\"thumb\">";
		s += "        <span class=\"default-tip\" style=\"\">缩略图</span>";
		s += "        <img src=\"\" class=\"i-img\" style=\"display:none\">";
		s += "    </span>";
		s += "    <div class=\"msg-t h4\">";
		s += "        <span class=\"i-title\"></span>";
		s += "    </div>";
		s += "    <ul class=\"abs tc sub-msg-opr\">";
		s += "        <li class=\"b-dib sub-msg-opr-item\">";
		s += "            <a href=\"javascript:void(0);\" onclick=\"wem.editTuwen(this);\" class=\"th icon18 iconEdit\">编辑</a>";
		s += "        </li>";
		s += "        <li class=\"b-dib sub-msg-opr-item\">";
		s += "            <a href=\"javascript:;\" class=\"th icon18 iconDel\" data-rid=\"2\">删除</a>";
		s += "        </li>";
		s += "    </ul>";
		s += "    <input type=\"hidden\" name=\"urlTitle\" />";
		s += "    <input type=\"hidden\" name=\"urlParams\" />";
		s += "</div>";
		jQuery("#divRelpyNews .sub-add").before(s);
		if(jQuery("#divRelpyNews .sub-add").parent().children().length>=10){jQuery("#divRelpyNews .sub-add").hide();}
		jQuery(".replyItems .space").hide();
	},
	editTuwen:function(objEle){
		art.dialog.data('objEle',objEle);
		var divNews=jQuery(objEle).closest(".appmsgItem");
		var objectTuwen = {};

		/*var key;
		if(!this.menu){return;}
		if(!wem.menu.key){wem.menu.key=wem.initKey();}
		if(!wem.content.hasOwnProperty(wem.menu.key)||!wem.content[wem.menu.key]){wem.content[wem.menu.key]=wem.initContent("News");}
		var cContent=wem.content[wem.menu.key];
		var allTuWen=cContent.tuwen;
		if(jQuery.isEmptyObject(allTuWen)){
			var pp = jQuery("#divRelpyNews>div>div:first");
			key=jQuery(pp).attr("id");
			if(!key){
				key=wem.initKey();
				jQuery(pp).attr("id",key);
			}
			cContent.tuwen[key]=wem.initTuWen("bigImage");;
		}
		key=jQuery(divNews).attr("id");
		if(key){objectTuwen=cContent.tuwen[key];}
		else{
			key=wem.initKey();
			jQuery(divNews).attr("id",key);
			objectTuwen=this.initTuWen("bigImage");
			cContent.tuwen[key]=objectTuwen;
			cContent.keyword=this.menu.key;
		}
		
		wem.content[wem.menu.key]=cContent;*/
		
		//{"fromid":obj.fromid,"replace":obj.objid,"title":obj.title1,"url":obj.url1,"content":obj.content1}
		var fromid=jQuery(divNews).attr("fromid");
		var replace=jQuery(divNews).attr("replace");
		var title=jQuery(divNews).attr("title")
		var url=jQuery(divNews).attr("url");
		var content=jQuery(divNews).attr("content");
		var imageSize=jQuery(divNews).attr("imagetype");
		objectTuwen.fromid=fromid;
		objectTuwen.objid=replace;
		objectTuwen.title1=title;
		objectTuwen.url1=url;
		objectTuwen.imageSize=imageSize;
		objectTuwen.content1=content;
		
		//var url="/html/nds/oto/menu/editTuwen.jsp";//?objectTuwen="+JSON.stringify(objectTuwen);
		var url="/html/nds/oto/menu/editTuwen.jsp?objectTuwen="+JSON.stringify(objectTuwen);
		//art.dialog.data("objectTuwen",objectTuwen);
		/*var htmlContent="";
		jQuery.ajax({
			url: '/html/nds/oto/menu/editTuwen.jsp',
			type: 'post',
			async: false,
			data:{"objectTuwen":JSON.stringify(objectTuwen)},
			success:function(data){
				htmlContent = data;
			},
			error:function(data){
				alert("请求异常！");
				return;
			}
		});*/
		var url='/html/nds/oto/menu/editTuwen.jsp';
		var titleName="设置链接";
		var options={
					width:800,
					height:505,
					title:titleName,
					resize:false,
					drag:true,
					lock:true,
					esc:true,
					skin:'chrome',
					ispop:false,
					close:function(){
							//返回的json类型
					var obj;
					var objEle=art.dialog.data("objEle");
					obj = art.dialog.data('obj'); 
					if(jQuery.isEmptyObject(obj)){return true;}
					var parentN = jQuery(objEle).closest(".appmsgItem");
					if(obj.title1){parentN.find(".i-title").text(obj.title1);}
					if(obj.url1){
						parentN.find(".default-tip").css("display","none");
						parentN.find(".i-img").attr("src",obj.url1);
						parentN.find(".i-img").css("display","block");
					}
					jQuery(parentN).attr({"fromid":obj.fromid,"replace":obj.objid,"title":obj.title1,"url":obj.url1,"content":obj.content1});
					/*var key=jQuery(parentN).attr("id");
					//插入文字
					if(!key){return;}
					obj.content="";
					obj.title="";
					wem.content[wem.menu.key].msgtype=wem.msgtypes["News"];
					wem.content[wem.menu.key].tuwen[key]=obj;*/
					wem.isChangeReply=true;
				}
			}; 
		var data = { objectTuwen : JSON.stringify(objectTuwen)};
		art.dialog.load(url,data,options,false);
		 
		//art.dialog.open(url,options);
	},
	setMenuType:function(type){
		if(!this.menu){return;}
		//if(this.menu){this.menu["menuType"]=type;}
		if(type=="Link"){this.menu.type="view";}
		else{this.menu.type="click";}
		this.menu.menuType=type;
		//if(this.content[this.menu.key]){this.content[this.menu.key].msgtype=this.msgtypes[type];}
	},
	changeMenuType:function(type){
		if(!this.menu){return;}
		var text = this.msgtypes[type];
		jQuery("#returnType").html(text);
		var replyMenu=this.content[this.menu.key];

		switch(type){
			case "Link":
				wem.showLink();
				break;
			case "Words":
				wem.showWords();
				break;
			case "News":
				wem.showNews();
				break;
			default:
				this.init();
				break;
		}
		//切换回复类型
		jQuery("#divRelpys >div").hide();
		jQuery("#divRelpy"+type).show();
		this.menuType=type;
		//this.setMenuType(type);
		return false;
	},
	setRemainString:function(){
		jQuery("#spnCnt").text(this.mbStringLength(jQuery("#txtReplyWords").val()));
		/*if(!wem.menu.key){wem.menu.key=wem.initKey();}
		if(!wem.content.hasOwnProperty(wem.menu.key)){wem.content[wem.menu.key]=wem.initContent("Words");}
		var cContent=wem.content[wem.menu.key];
		cContent.title="";
		cContent.keyword=wem.menu.key;
		cContent.tuwen={};
		cContent.msgtype=wem.msgtypes["Words"];
		cContent.content=jQuery("#txtReplyWords").val().trim();
		//wem.setMenuType("Words");
		wem.isChangeMenu=false;*/
	},
	changeWords:function(){
		this.isChangeReply=true;
	},
	//求字符串所占字节数
	mbStringLength:function(str){
		var len = 0;  
		for(var i=0;i<str.length;i++){  
            if (str.charCodeAt(i)>255){len += 2;}
			else {len++;}  
        }  
        //return (1000-len);
		return len;
	},
	//根据id向textarea中插入内容
	insertText:function(textarea, str){
		var obj = typeof(textarea) == "object" ? textarea : jQuery(textarea);
		var txt = obj.val()||"";
		obj.val(txt + str);
		/*if (txt==""){obj.val(str +"\n");}
		else{obj.val(obj.val() + str +"\n");}*/
	},
	//保存菜单回复内容
	saveReply:function(){
		if(!this.setMenuReply()){return;}
		//if(!this.verifyMenu()){return false;}
		var replyMenu=this.tempContent;
		if(!replyMenu||jQuery.isEmptyObject(replyMenu)){
			alert("请设置菜单动作！");
			return;
		}
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="SAVE_REPLYMENU";
		
		if(!replyMenu.msgtype){replyMenu.msgtype=this.msgtypes[this.menu.menuType];}
		if(!replyMenu.keyword){replyMenu.keyword=this.menu.key;}
		/*if(replyMenu.msgtype=="链接"){
			replyMenu=jQuery.extend({msgtype:"文本"},replyMenu);
			replyMenu.msgtype="文本";
		}*/
		evt.param=Object.toJSON(replyMenu);
		evt.table="wx_messageautoq";
		evt.action = "aud";
		evt.permission="r";
		this._executeCommandEvent(evt);
	},
	_onSaveReply:function(e){
		if(!wem.menu){return;}
		wem.content[this.menu.key]=wem.tempContent;
		wem.tempContent=null;
		wem.setMenuType(wem.menuType);
		var fromid=jQuery("#Linktitle").attr("fromid");
		var replace=jQuery("#Linktitle").attr("replace");
		if(wem.menuType=="Link"){
			wem.menu.fromid=parseInt(fromid);
			wem.menu.objid=replace;
		}
		wem.isChangeReply=false;
		alert("保存成功！");
	},
	//设置保存内容到本地JSON中
	setMenuReply:function(){
		if(!this.menu){
			alert("请选择要编辑的菜单！");
			return false;
		}
		
		var type=this.menuType;;
		var isCorrect=true;
		//var replyDiv=jQuery("#divRelpys>div[id^=divRelpy]:not[style*=\"display: none\"]");
		//type=jQuery(replyDiv).attr("id");
		//if(type){type=type.replace("divRelpy","");}
		if(!this.menu.key){
			this.isChangeMenu=true;
			this.menu.key=this.initKey();
		}
		
		//if(!this.content.hasOwnProperty(this.menu.key)){this.content[this.menu.key]=this.initContent(type);}
		switch(type){
			case "Link":
				isCorrect=wem.setMenuLink();
				break;
			case "Words":
				isCorrect=wem.setMenuWords();
				break;
			case "News":
				isCorrect=wem.setMenuNews();
				break;
			default:
				wem.tempContent=null;
				isCorrect=false;
				break;
		}
		return isCorrect;
	},
	verifyMenu:function(){
		var replyMenu=this.content[this.menu.key];
		if(!replyMenu||replyMenu.msgtype!=this.msgtypes[this.menu.menuType]){
			alert("请输入数据再保存！");
			return false;
		}
		if(replyMenu.msgtype=="图文"){
			if(jQuery.isEmptyObject(replyMenu.tuwen)){
				alert("请输入图文再保存！");
				return false;
			}
			var reply;
			for(key in replyMenu.tuwen){
				reply=replyMenu.tuwen[key];
				if(reply.fromid<=0){
					alert("请完善所有图文资料！");
					return false;
				}
			}
		}
		return true;
	},
	setMenuLink:function(){
		var title=jQuery("#Linktitle").val().trim();
		var fromid=jQuery("#Linktitle").attr("fromid");
		var replace=jQuery("#Linktitle").attr("replace");
		if(!title||isNaN(fromid)){
			alert("菜单链接为空，请设置菜单链接！");
			return false;
		}
		var cContent=this.initContent("Link");
		cContent.keyword=this.menu.key;
		cContent.msgtype=wem.msgtypes["Link"];
		cContent.title=title;
		var uc=[{"fromid": parseInt(fromid), "replace": replace, "oldreplace": "@ID@", "receive": ""}];
		cContent.urlcontent=JSON.stringify(uc.slice()).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\");
		this.tempContent=cContent;
		return true;
	},
	setMenuWords:function(){
		var content=jQuery("#txtReplyWords").val().trim();
		if(content==null||content==""){
			alert("文本内容，请输入文本内容！");
			return false;
		}
		var cContent=this.initContent("Words");
		cContent.keyword=wem.menu.key;
		cContent.content=content;
		a=[];
		var ia;
		var reg=new RegExp("@@[^(@@)]+@@","g");
		
		if(reg.test(content)){
			var res=content.match(reg);
			if(res){
				for(var i=0;i<res.length;i++){
					ia=res[i].replace("@@","{");
					ia=ia.replace("@@","}");
					ia=ia.replace("@@$","}");
					ia=ia.replace(new RegExp("\\\\","g"),"");
					try{ia=eval('('+ia+')');}
					catch(e){ia=null;}
					if(!ia){continue;}
					ia["oldreplace"]="@ID@";
					ia["receive"]=res[i];//.replace("\"","\\\"");
					a.push(ia);
				}
			}
		}
		if(a.length>0){cContent["urlcontent"]=JSON.stringify(a.slice()).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\");}
		this.tempContent=cContent;
		return true;
	},
	setMenuNews:function(){
		var replyNew;
		var replyNews=jQuery("#divRelpyNews>div>div[class*=appmsgItem]");
		if(replyNews.length<=0){
			alert("图文数据为空，不能保存！");
			return false;
		}
		//{"fromid":result.fromid,"replace":result.objid,"title":obj.title1,"url":obj.url1,"content":obj.content1}
		var fromid;
		var replace;
		var title;
		var url;
		var content;
		var cContent=this.initContent("News");
		cContent.keyword=wem.menu.key;
		var tuwen={};
		for(var i=0;i<replyNews.length;i++){
			replyNew=replyNews[i];
			fromid=jQuery(replyNew).attr("fromid");
			replace=jQuery(replyNew).attr("replace");
			title=jQuery(replyNew).attr("title");
			url=jQuery(replyNew).attr("url");
			content=jQuery(replyNew).attr("content");
			if(isNaN(fromid)){
				alert("请为所有图文设置链接！");
				return false;
			}
			if(!replace){replace="";}
			tuwen=wem.initTuWen(i?"smallImage":"bigImage");
			tuwen.fromid=parseInt(fromid);
			tuwen.objid=replace;
			tuwen.title1=title;
			tuwen.url1=url;
			tuwen.sort=i;
			tuwen.content1=content;
			cContent.tuwen[wem.initKey()]=jQuery.extend({},tuwen);
		}
		cContent.count=replyNews.length;
		this.tempContent=cContent;
		return true;
	},
	//保存菜单
	saveMenu:function(){
		if(!webFXTreeHandler.nodeJson||jQuery.isEmptyObject(webFXTreeHandler.nodeJson)){
			alert("请先创建菜单再保存！");
			return;
		}
		if(wem.isChangeReply){
			art.dialog({title:"警告",
				lock:true,
				icon:"warning",
				//cancelVal: "关闭",
				content:"菜单回复修改未保存，确定要放弃修改吗？",
				ok:function(){
					wem.doSaveMenu();
				},
				cancel:true
			});
		}else{
			wem.doSaveMenu();
		}
	},
	doSaveMenu:function(){
		if(wem.id){
			var _params = "{table:\"WX_MENUSET\",MENUNAME:\"menu_"+wem.ad_client_id+"\",id:"+wem.id+",MENUCONTENT:{button:"+JSON.stringify(webFXTreeHandler.nodeJson.button).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\")+"}}";
			jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:"ObjectModify",params:_params},
				async: false,
				success: function (data) {
					var mess =eval("("+data+")")[0];
					if(mess.code==-1){
						alert(mess.message);
					}else{
						wem.isChangeReply=false;
						wem.isChangeMenu=false;
						alert("保存成功");
					}
				}
			});
		}else{
			var _params = "{table:\"WX_MENUSET\",MENUNAME:\"menu_"+wem.ad_client_id+"\",MENUCONTENT:{button:"+JSON.stringify(webFXTreeHandler.nodeJson.button).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\")+"}}";
			jQuery.ajax({
				url: '/html/nds/schema/restajax.jsp',
				type: 'post',
				data:{command:"ObjectCreate",params:_params},
				async: false,
				success: function (data) {
					var mess =eval("("+data+")")[0];
					if(mess.code==-1){
						alert(mess.message);
					}else{
						wem.isChangeReply=false;
						wem.isChangeMenu=false;
						wem.id=mess.objectid;
						alert("保存成功");
					}
				}
			});
		}
	},
	//发布菜单
	publishMenu:function(){
		if(this.isChangeMenu){
			alert("请先保存菜单，再发布！");
			return false;
		}
		var evt={};
		evt.command="nds.weixin.ext.CreateMenuCommand";
		evt.callbackEvent="ISSUE_MENU";
		this._executeCommandEvent(evt);
	},
	
	_onIssueMenu:function(e){
		var data=e.getUserData();
		if(data&&data.code==0){alert("发布成功!");}
		else if(data&&data.message){alert(data.message);}
		else{alert("发布失败");}
	},
	//预览菜单
	previewMenu:function(){
		if(this.isChangeMenu){
			alert("请先保存菜单，再预览！");
			return false;
		}
		this.replacejscssfile("/html/nds/oto/js/artDialog4/skins/default.css","/html/nds/oto/js/artDialog4/skins/simple.css","css");
		var url="/html/nds/oto/menu/previewMenu.jsp";
		var titleName="菜单预览";
		var options={
			width:"auto",
			height:"auto",
			title:titleName,
			resize:false,
			drag:true,
			lock:true,
			esc:true,
			skin:'simple',
			padding:0,
			ispop:false,
			close:function(){
				wem.replacejscssfile("/html/nds/oto/js/artDialog4/skins/simple.css","/html/nds/oto/js/artDialog4/skins/default.css?4.1.6","css");
			}
		}; 
		 
		art.dialog.open(url,options);
	},
	//停用(删除微信)菜单
	deleteWeixinMenu:function(){
		art.dialog({
			title:"警告",
			lock:true,
			icon:"warning",
			//cancelVal: "关闭",
			content:"确定要删除微信菜单吗！",
			ok:function(){
				evt={};
				evt.command="nds.weixin.ext.DeleteWeixinMenuCommand";
				evt.callbackEvent="DELETE_MENU";
				wem._executeCommandEvent(evt);
			},
			cancel:true
		});
	},
	_onDeleteMenu:function(e){
		var data=e.getUserData();
		if(data){
			if(data.code==0){alert("菜单已停用！");}
			else{alert("操作失败！");}
		}else{
			alert("操作失败！");
		}
	},
	//初始化内容
	initContent:function(messageType){
		var mt=wem.msgtypes[messageType];
		if(!mt){
			art.dialog.tips("messageType error");
			return;
		}
		return {
			keyword:"",
			title:"",
			content:"",
			msgtype:mt,
			nytype:"Y",
			pptype:"Y",
			url:"",
			gourl:"",
			hurl:"",
			num:0,
			wx_media_id:0,
			count:0,
			ad_client_id:wem.ad_client_id,
			tuwen:{},
			groupid:null,
			urlcontent:[]
		};
	},
	initTuWen:function(imageSize){
		return{
			"fromid":-1,
			"objid":"",
			"title1":"",
			"content1":"",
			"sort":0,
			"wx_media_id1":"",
			"url1":"",
			"gourl1":"",
			"groupid1":"",
			"imageSize":imageSize||"smallImage"
		};
	},
	initKey:function(){
		var key="meun_";
		var currentDate = new Date();
		key+=currentDate.getFullYear();
		key+=currentDate.getMonth();
		key+=currentDate.getDate();
		key+=currentDate.getHours();
		key+=currentDate.getMinutes();
		key+=currentDate.getMilliseconds();
		key+=Math.random();
		key=key.replace(".","_");
		return key;
	},
	perfectionVipinfo:function(){
		var evt={};
		evt.command="nds.weixin.ext.PerfectionVipCommand";
		evt.callbackEvent="PERFECTION_VIPINFO";
		this._executeCommandEvent(evt);
	},
	_onPerfectionVipinfo:function(e){
		var data=e.getUserData();
		if(data&&data.code==0){alert("发布成功!");}
		else if(data&&data.message){alert(data.message);}
		else{alert("发布失败");}
	},
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				art.dialog.tips(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	},
	createjscssfile:function(filename, filetype){
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		if (filetype=="js"){
			var fileref=w.document.createElement('script')
			fileref.setAttribute("type","text/javascript")
			fileref.setAttribute("src", filename)
		}else if (filetype=="css"){
			var fileref=w.document.createElement("link")
			fileref.setAttribute("rel", "stylesheet")
			fileref.setAttribute("type", "text/css")
			fileref.setAttribute("href", filename)
		}
		return fileref
	},

	replacejscssfile:function(oldfilename, newfilename, filetype){
		var w = window.opener;
		if(w==undefined){w= window.parent;}
		var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none"
		var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none"
		var allsuspects=w.document.getElementsByTagName(targetelement)
		for (var i=allsuspects.length; i>=0; i--){
			if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(oldfilename)!=-1){
			   var newelement=this.createjscssfile(newfilename, filetype);
			   allsuspects[i].parentNode.replaceChild(newelement, allsuspects[i]);
			}
		}
	}
}

wemenu.main=function(){wem=new wemenu();}
jQuery(document).ready(wemenu.main);

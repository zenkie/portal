var editKeyWords;
var keywords = Class.create();
//参数
var jumpBox;
var msgtypes={
	Words:"文本",
	News:"图片",
	Language:"语音",
	Video:"视频",
	Music:"音乐",
	News:"图文"
}
var submitObj={
	add:{},
	title:"",
	content:"",
	msgtype:"文本",
	nytype:"Y",
	url:"",
	gourl:"",
	hurl:"",
	num:0,
	wx_media_id:0,
	count:0,
	ad_client_id:0,
	tuwen:{},
	groupid:0,
	urlcontent:[]
};
var addJsonObj={};
//多图文
var tuwen = {};
//获取到wx_messagesutoone单条数据
var getjsonObjAll;
var proData;
			
//弹出框对象
var EditKeywordObj;
keywords.prototype={
	initialize:function(){
	
		application.addEventListener("COMMIT_DATA", this._commitSave, this);
		
		window.onload=function(){
			//将公司的AD_CLIENT_ID保存到最终提交的json中
			submitObj.ad_client_id=art.dialog.data("ad_client_id");
			
			getjsonObjAll=art.dialog.data("jsonObjAll");
			
			if(getjsonObjAll==""){
				
				//获取sequence
				/*
				var groupidnum = 0;
				jQuery.ajax({
					url:'/html/nds/oto/attention/getSequence.jsp',
					data:{"tableid":"WX_MESSAGEAUTO"},
					type:'get',
					async: false,
					success: function (data) {
						groupidnum = data;
					}
				});
				submitObj.groupid=parseInt(groupidnum);*/
				submitObj.groupid=0;
				submitObj.nytype="Y";
				return;
			}
			//初始化title
			if(!jQuery.isEmptyObject(getjsonObjAll) && getjsonObjAll.hasOwnProperty("TITLE"))
				jQuery("#txtRuleName").val(getjsonObjAll.TITLE);
			//初始化关键字显示
			var keywordNames ='';
			if(!jQuery.isEmptyObject(getjsonObjAll) && getjsonObjAll.hasOwnProperty("KEYWORDS"))
				keywordNames = getjsonObjAll.KEYWORDS.split(",");
			var pptypes = getjsonObjAll.PPTEPY.split(",");
			
			var s="";
			for(var i = 0; i < keywordNames.length; i++){
				s+='<li class="item float-p">';
				s+='<label class="left">';
				s+='<input type="checkBox" class="left" value="'+keywordNames[i]+'_'+pptypes[i]+'">';
				s+='<div class="val left" title="111">'+keywordNames[i]+'</div>';
				s+='</label>';
				if(pptypes[i]=="Y")	
					s+='<label class="right c-gA matchMode matchMode1">全匹配</label>';
				else
					s+='<label class="right c-gA matchMode">模糊匹配</label>';
				s+='<a href="javascript:;" class="keywordEditor" onclick="editKeyWords.ShowAddKeyword(this)">编辑</a>';
				s+='</li>';
				proData={};
				proData[keywordNames[i]+"_"+pptypes[i]]={
							"keyword":keywordNames[i],
							"pptype":pptypes[i],
							};
				addJsonObj=jQuery.extend({},addJsonObj,proData); 
			}
			jQuery("#keywordItems").html(s);
			
			//将相关数据存放到submitObj中
			submitObj.groupid = parseInt(getjsonObjAll.GROUPID);
			submitObj.msgtype = getjsonObjAll.MESSAGETYPE;
			submitObj.nytype=getjsonObjAll.NYTEPY;
			//根据首个id查具体的回复内容
			if(jQuery.isEmptyObject(getjsonObjAll.TABLEID)) return;
			var objids = getjsonObjAll.TABLEID.split(",");
			if(jQuery.isEmptyObject(objids[0])) return;
			//根据首个id查询内容
			//如果是文本
			if(submitObj.msgtype=="文本"){
				jQuery.post("/html/nds/oto/attention/getContentClob.jsp",
						{tid:objids[0],tableName:"wx_messageauto"},
						function(data){
							jQuery("#txtReplyWords").html(data.trim());
							editKeyWords.setRemainString();
					}
				);
			}
			if(submitObj.msgtype=="图文"){
				//this.SetReplyType("News");
				//添加图文的具体内容
				jQuery.post("/html/nds/oto/attention/getTuwenData.jsp",
						{groupid:submitObj.groupid,tableName:"WX_MESSAGEAUTOITEM"},
						function(tudata){
							var menuAll = eval("("+tudata+")");
							var keySort = menuAll.keysSort;
							//var order = 0;
							var jsonObject=menuAll.menuArr;
							jQuery.each(keySort,function(index,val){
								var value = jsonObject[val];
								if(index==0){
									var pp = jQuery("#divRelpyNews div div:first");
									pp.attr("orderKey",value.title1+"_"+value.fromid);
									pp.find(".i-title").text(value.title1);
									pp.find(".i-title").attr("fromid",value.fromid);
									pp.find(".i-title").attr("objid",value.objid);
									pp.find(".i-img").attr("src",value.url1);
									pp.find(".i-img").css("display","block");
									pp.find(".default-tip").css("display","none");
									tuwen[value.title1+"_"+value.fromid] = value;
								
									return true;
								}
								//小图
								var s = '';
								s += '<div class="rel sub-msg-item appmsgItem" flag="1" orderKey="'+value.title1+"_"+value.fromid+'">';
								s += '    <span class="thumb">';
								s += '        <span class="default-tip" style="display:none">缩略图</span>';
								s += '        <img class="i-img" style="display:block;" src="'+value.url1+'">';
								s += '    </span>';
								s += '    <div class="msg-t h4">';
								s += '        <span class="i-title" fromid="'+value.fromid+'" objid="'+value.objid+'">'+value.title1+'</span>';
								s += '    </div>';
								s += '    <ul class="abs tc sub-msg-opr">';
								s += '        <li class="b-dib sub-msg-opr-item">';
								s += '            <a href="javascript:void(0);" onclick="editKeyWords.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
								s += '        </li>';
								s += '        <li class="b-dib sub-msg-opr-item">';
								s += '            <a href="javascript:;" class="th icon18 iconDel" data-rid="2">删除</a>';
								s += '        </li>';
								s += '    </ul>';
								s += '</div>';
								jQuery("#divRelpyNews .sub-add").before(s);
								//插入文字
								tuwen[value.title1+"_"+value.fromid] = value;
							});
							if(keySort.length>=9)
								jQuery("#divRelpyNews .sub-add").hide();
							/*jQuery.each(data,function(){
								//大图
								if(order==0){}
								var jsonObject = eval("("+value+")");
								alert(value);
								order++
							});*/
							
					}
					
				);
				editKeyWords.SetReplyType('News');
			}
		};
		//绑定关键字“全匹配”按钮点击事件
		jQuery("#keywordItems .matchMode").live('click', function () {
			//修改前是否是全匹配 true 全匹配
			var flag = jQuery(this).hasClass("matchMode1");
			var keywordName = jQuery(this).siblings(".left").find(".val").html();
			//修改以后的N,Y
			var pptype = (flag)?"N":"Y";
			var pptypeFormer = (flag)?"Y":"N";
			//判断json能否修改 验证数据是否唯一 
			if(!jQuery.isEmptyObject(addJsonObj) && !jQuery.isEmptyObject(addJsonObj[keywordName+"_"+pptype])){
				art.dialog({
					content: '您修改的关键字、是否匹配已存在，无法修改！',
					icon: 'succeed',
					fixed: true,
					lock: true,
					time: 2
				});
				return;
			}
			//判断数据库中是否存在，checkdataonly.jsp 如果返回的id 不在addJsonObj中则无法修改@@@@@
			var addparamsObj = {
				table : "wx_messageauto",
				params : {
						KEYWORD:"="+keywordName,
						PPTYPE:pptype
					}
			};
			var objids = [];
			if(!jQuery.isEmptyObject(getjsonObjAll.TABLEID))
				objids = getjsonObjAll.TABLEID.split(",");
			var arr=JSON.stringify(addparamsObj);
			var flagA = true;
			jQuery.ajax({
					url:'/html/nds/oto/attention/checkDataOnly.jsp',
					type:'get',
					async: false,
					data:{"params":arr},
					success: function (data) {
						var a = eval("("+data+")");
						if(jQuery.isEmptyObject(a)){
							return false;
						}
						if(jQuery.isEmptyObject(objids)){
							return false;
						}
						jQuery.each(a,function(key,value){
							if(jQuery.inArray(key,objids)==-1){
								flagA = false;
								return false;
							}
						});
					}
				});
			if(!flagA){
				art.dialog({
					content: '您修改的关键字、是否匹配已存在，无法修改！',
					icon: 'succeed',
					fixed: true,
					lock: true,
					time: 2
				});
				 return false;
			}
		
            //切换class
            jQuery(this).toggleClass("matchMode1");
			
			//修改文字提示并修改数组
            if (jQuery(this).hasClass("matchMode1"))
                jQuery(this).html("全匹配");
            else 
                jQuery(this).html("模糊匹配");
			
			addJsonObj[keywordName+"_"+pptypeFormer].pptype = pptype;
			addJsonObj[keywordName+"_"+pptype]=addJsonObj[keywordName+"_"+pptypeFormer];
			delete addJsonObj[keywordName+"_"+pptypeFormer];
			
        });
		//显示操作按钮
		jQuery("#divRelpyNews .appmsgItem").live('mouseover', function () {
			jQuery(this).addClass("sub-msg-opr-show");
		}).live('mouseout', function () {
			jQuery(this).removeClass("sub-msg-opr-show");
		});
		//删除一个多图文
		jQuery("#divRelpyNews .appmsgItem .iconDel").live('click', function () {
			//从tuwen中删除
			var listNode = jQuery(this).closest(".appmsgItem");
			var title=listNode.find("span[class='i-title']").text();
			var fromid = listNode.find("span[class='i-title']").attr("fromid");
			//var objid = listNode.find("span[class='i-title']").attr("objid");
			delete tuwen[title+"_"+fromid];
			//listNode.find();
			listNode.remove();
			if(jQuery("#divRelpyNews .msg-item").children().length<10)
				jQuery("#divRelpyNews .sub-add").show();
		});
		
		
	},	
	//切换多图文和文本
	SetReplyType:function(type){
		var text = msgtypes[type];
		submitObj.msgtype = text;
		//切换恢复类型的文字
		jQuery("#returnType").html(text);
		if(type!='Words'){
			jQuery("#spnReplyWordsInfo").hide();
			jQuery("#spnAddLink").hide();
		}else{
			jQuery("#spnReplyWordsInfo").show();
			jQuery("#spnAddLink").show();
		}
		//切换显示内容
		jQuery("#divRelpys > div").css("display","none");
		
		jQuery("#divRelpy"+type).show();
		return false;
	},
	//添加或编辑关键字
	ShowAddKeyword:function(obj){
	
		var s = '';
		var keyword='';
		var isAllMatch = false;
		var titleName='添加关键字';
		var act = 'add';
		
		
		if(obj!=null && typeof(obj)!=obj){
			titleName = '修改关键字';
			act='edit';
			keyword = jQuery(obj).siblings(".left").find(".val").html();
			EditKeywordObj = obj;
			//判断是否全匹配
			if(jQuery(obj).siblings(".matchMode").hasClass("matchMode1"))
				isAllMatch = true ;
		}
		
		s+='<div class="win-addkeyword"><span class="red">*</span>关键词：<input type="input" name="win-keyword" onfocus="this.select()" class="txt250" maxlength="30" formerValue="'+keyword+'" value="' + keyword + '" />';
		s+= '<p>';
		s+='<input type="checkbox"' + ((isAllMatch) ? " checked" : "") + ' formerChecked="'+((isAllMatch) ? " Y" : "N")+'" />&nbsp;全字匹配&nbsp;&nbsp;';
		s += '<span class="red" id="spnWinErr"></span>';
		s += '</p>';
		s += '<div class="win-operate">';
		s += ' <input type="button" class="btn btn_submit" value=" 确 定 " style="float: left;" onclick="editKeyWords.ModifyKeyword(\'' + act + '\')" />&nbsp;';
		s += '<input type="button" class="btn btn_cannel" value=" 取 消 " onclick="jQuery.close(\'addKeyword\'); " />';
		s += '  </div>';
		s += '</div>';
		
		asyncbox.open({
                id : 'addKeyword',
                html: s,
                title: titleName,
                modal: true
            });
	},
	//校验 添加或编辑关键字 是否重复
	CheckAddKeyword:function(obj,pptepy){
		var keyword = jQuery(obj).val();
		if(keyword==""){
			 jQuery("#spnWinErr").html("请输入关键字");
			  return false;
		}
		//验证数据是否唯一 
		if(!jQuery.isEmptyObject(addJsonObj) && !jQuery.isEmptyObject(addJsonObj[keyword+"_"+pptepy])){
			jQuery("#spnWinErr").html("您输入的关键字、是否匹配已存在，无法添加！");
			 return false;
		}
		//判断如果id不存在addJsonObj中，则无法添加；否则可以
		var addparamsObj = {
			table : "wx_messageauto",
			params : {
					KEYWORD:"="+keyword,
					PPTYPE:pptepy
				}
		};
		var objids = [];
		if(!jQuery.isEmptyObject(getjsonObjAll.TABLEID))
			objids= getjsonObjAll.TABLEID.split(",");
		var arr=JSON.stringify(addparamsObj);
		var flag = true;
		jQuery.ajax({
				url:'/html/nds/oto/attention/checkDataOnly.jsp',
				type:'get',
				async: false,
				data:{"params":arr},
				success: function (data) {
					var a = eval("("+data+")");
					if(jQuery.isEmptyObject(a)){
						return false;
					}
					if(jQuery.isEmptyObject(objids)){
						return false;
					}
					jQuery.each(a,function(key,value){
						if( jQuery.inArray(key,objids)==-1){
							flag = false;
							return false;
						}
					});
				}
			});
		if(!flag){
			jQuery("#spnWinErr").html("您输入的关键字、是否匹配已存在，无法添加！");
			 return false;
		}
		
		
		return true;
	},
	//保存 添加或编辑关键字
	ModifyKeyword:function(act){
		jQuery("spnWinErr").html("");
		//关键字校验
		var keywordBoxObj = jQuery(".win-addkeyword input[name='win-keyword']");
		var isAllMatch = jQuery(".win-addkeyword :checkbox").attr("checked");
		var saveMatch=(isAllMatch)?"Y":"N";
		
		
		var keyword = jQuery.trim(keywordBoxObj.val());
		//未做任何修改 直接关闭页面
		if(jQuery(".win-addkeyword :checkbox").attr("formerchecked").trim()==saveMatch && keywordBoxObj.attr("formervalue").trim()==jQuery.trim(keywordBoxObj.val())){
			jQuery.close('addKeyword');
		}
		//校验是否输入以及输入的合法性
		if(!this.CheckAddKeyword(keywordBoxObj,saveMatch)) return;
		
		//添加关键字修改json
		//获取key(自定义，插入数据库自动生成)
		var num = Object.keys(addJsonObj).length+1;
		if(addJsonObj=="") num=1;
		
		//添加数据到json
		var proData={};
		proData[keyword+"_"+saveMatch]={
						keyword:keyword,
						pptype:saveMatch
						};
		
		if(act == "edit"){
			//删除原有数据
			delete addJsonObj[keywordBoxObj.attr("formervalue")+"_"+jQuery(".win-addkeyword :checkbox").attr("formerchecked").trim()];
			var editKeyWordObj = jQuery(EditKeywordObj).siblings(".left").find(".val");
			var editMatchMode = jQuery(EditKeywordObj).siblings(".matchMode");
			editKeyWordObj.html(keyword);
			editKeyWordObj.attr("title",editKeyWordObj);
			if(isAllMatch){
				editMatchMode.addClass("matchMode1");
				editMatchMode.html("全匹配");
			}else{
				editMatchMode.removeClass("matchMode1");
				editMatchMode.html("全匹配");
			}
		}else{
			var addhtml='';
			addhtml+= '<li class="item float-p">';
			addhtml += '    <label class="left">';
            addhtml += '        <input type="checkBox" class="left" value="'+keyword+"_"+saveMatch+'">';
            addhtml += '        <div class="val left" title="' + keyword + '">' + keyword + '</div>';
            addhtml += '    </label>';
			
			if (isAllMatch)
				addhtml += '    <label class="right c-gA matchMode matchMode1">全匹配</label>';
			else
				addhtml += '    <label class="right c-gA matchMode">全匹配</label>';

			addhtml += '    <a href="javascript:void(0);" class="keywordEditor oh z c-opr" onclick="editKeyWords.ShowAddKeyword(this)">编辑</a>';
			addhtml += '</li>';
			jQuery("#keywordItems").append(addhtml);	
		}
		//将添加的数据添加到addJsonObj去
		addJsonObj=jQuery.extend({},addJsonObj,proData);
		jQuery.close('addKeyword');
		
	},
	DeleteKeyword:function(){
		var delObj;
		jQuery("#keywordItems li").each(function(){
			delObj = jQuery(this).find("input:checkbox");
			if(delObj.attr("checked")){
				delete addJsonObj[delObj.val()];
				this.remove();
			}
		});
		return;
	},
	commitSave:function(){
		//最后保存
		//获取更新数据中的title
		submitObj.title=jQuery("#txtRuleName").val();
		if(submitObj.title.trim()==""){
			art.dialog.tips("您未输入规则名");
			return;
		}
		//关键字个数
		submitObj.num = Object.keys(addJsonObj).length;
		if(submitObj.num==0){
			art.dialog.tips("您未输入关键字");
			return;
		}	
		//获取回复的内容 判断是图文还是文本abbr
		var i=0;
		//把addJsonObj放到提交的数组中
		jQuery.each(addJsonObj,function(key,value){
			submitObj.add[i]=value;
			i++;
		});
		//submitObj.add=addJsonObj;
		
		//判断类型，保存值
		if(submitObj.msgtype=="文本"){
			var str = jQuery("#txtReplyWords").val();
			if(str.trim()==""){
				art.dialog.tips("您未输入文本");
				return;
			}
			submitObj.content =str;
		}
		//判断图文保存值
		if(submitObj.msgtype=="图文"){
			//修改图文的order
			jQuery.each(jQuery(".multi-msg").children(),function(index,val){
				if(jQuery.isEmptyObject(jQuery(val).attr("orderkey"))) return true;
				tuwen[jQuery(val).attr("orderkey")].sort=index;
				submitObj.tuwen[index]=tuwen[jQuery(val).attr("orderkey")];
			});
			
			//submitObj.tuwen = tuwen;
			submitObj.count =  Object.keys(tuwen).length;
		}
		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="COMMIT_DATA";
		a=[];
		var ia;
		var reg=new RegExp("@@[^(@@)]+@@","g");
		
		if(reg.test(submitObj.content)){
			var res=submitObj.content.match(reg);
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
		//submitObj.content=submitObj.content.replace(new RegExp("^[\r\n]*|[\r\n]$","g"),"");
		//submitObj.content=submitObj.content.replace(new RegExp("\"","g"),"\\\"");
		//submitObj.content="{\"a\":"+JSON.stringify(a.slice()).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"")+",\"content\":\""+submitObj.content+"\"}";
		if(a.length>0){submitObj["urlcontent"]=JSON.stringify(a.slice()).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\");}
		evt.param=Object.toJSON(submitObj);
		evt.table="wx_messageauto";
		evt.action = "aud";
		evt.permission="r";
		editKeyWords._executeCommandEvent(evt);
		
	},
	_commitSave:function(e){
		tuwen={};
		art.dialog.close();
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
	AddSubscribeMark:function(){
		var _params = "{table:'WX_INTERFACESET',columns:['ORIGINALID']}";
		jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
            type: 'post',
			async: false,
            data:{command:"Query",params:_params},
			success: function (data) {
				editKeyWords.insertText("#txtReplyWords","<a href=\"weixin://contacts/profile/"+eval("("+data+")")[0].rows+"\">点击关注</a>");
				editKeyWords.setRemainString();
			}
		});
		
		
	},
	//导航目录
	AddMenuMark:function(){
		var _params = "{table:'WX_INTERFACESET',columns:['ORIGINALID']}";
		jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
            type: 'post',
			async: false,
            data:{command:"Query",params:_params},
			success: function (data) {
				var s= '>><a href="@@\\"fromid\\":29,\\"replace\\":\\"\\"@@">点此逛逛微商城</a>\n【新品】<a href="@@\\"fromid\\":27,\\"replace\\":\\"\\"@@">新品上市</a>\n【微官网】<a href="@@\\"fromid\\":42,\\"replace\\":\\"\\"@@">微官网</a>\n【微相册】<a href="@@\\"fromid\\":32,\\"replace\\":\\"\\"@@">微相册</a>\【会员】<a href="@@\\"fromid\\":37,\\"replace\\":\\"\\"@@">会员中心</a>\n';
				editKeyWords.insertText("#txtReplyWords",s+"<a href=\"weixin://contacts/profile/"+eval("("+data+")")[0].rows+"\">点击关注</a>");
				editKeyWords.setRemainString();
			}
		});
		
		//
	},
	//设置插入链接
	setTarget:function(){
		var titleName="设置链接";
		var url='/html/nds/oto/attention/jumpUrl.jsp';
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
				var url = art.dialog.data('url');
				if(jQuery.isEmptyObject(url)) return;
				editKeyWords.insertText("#txtReplyWords",url);
				editKeyWords.setRemainString();
			}
		}; 
		 
		art.dialog.open(url,options);
		/*
		jumpBox = asyncbox.open({
			id : 'jump',
			url: '/html/nds/oto/attention/jumpUrl.jsp',
			width:800,
			height:570,
			title: '设置链接',
			modal: true
		});*/
	},
	//根据id向textarea中插入内容
	insertText:function(textarea, str){
		var obj = typeof(textarea) == "object" ? textarea : jQuery(textarea);
		var txt = obj.val();
		if (txt=="") 
			obj.val(str +"\n");
		else
			obj.val(obj.val() + str +"\n");
			
		
	},
	//关闭窗口
	closeBox:function(boxId){
		artDialog.close();
	},
	//回复消息为文本时，输入框失去焦点
	CheckReplyWords:function(){
		jQuery("#snpReplyErr").html("");
		var val = jQuery.trim(jQuery("#txtReplyWords").val());
		if (val.length == 0) {
			jQuery("#snpReplyErr").html("* 请输入回复内容");
			return false;
		}
		else if (val.length > 1000){
			jQuery("#snpReplyErr").html("* 回复内容超出");
			return false;
		}
		return true;
	},
	//增加一个多图
	addNews:function(){
		var s = '';
		s += '<div class="rel sub-msg-item appmsgItem" flag="1">';
		s += '    <span class="thumb">';
		s += '        <span class="default-tip" style="">缩略图</span>';
		s += '        <img src="" class="i-img" style="display:none">';
		s += '    </span>';
		s += '    <div class="msg-t h4">';
		s += '        <span class="i-title"></span>';
		s += '    </div>';
		s += '    <ul class="abs tc sub-msg-opr">';
		s += '        <li class="b-dib sub-msg-opr-item">';
		s += '            <a href="javascript:void(0);" onclick="editKeyWords.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
		s += '        </li>';
		s += '        <li class="b-dib sub-msg-opr-item">';
		s += '            <a href="javascript:;" class="th icon18 iconDel" data-rid="2">删除</a>';
		s += '        </li>';
		s += '    </ul>';
		s += '    <input type="hidden" name="urlTitle" />';
		s += '    <input type="hidden" name="urlParams" />';
		s += '</div>';
		jQuery("#divRelpyNews .sub-add").before(s);
		if(jQuery("#divRelpyNews .sub-add").parent().children().length>=10)
			jQuery("#divRelpyNews .sub-add").hide();
		jQuery(".replyItems .space").hide();
	},
	editTuwen:function(objEle){
		art.dialog.data('objEle',objEle);
		var paren =jQuery(objEle).offsetParent().parent().parent();
		var i_titleF ="";
		var fromidF ="";
		var ppObj;
		
		var objectTuwen = {
		};
		
		//第一个大图
		if(jQuery(objEle).offsetParent().parent().parent().attr("flag")==0){
			ppObj = jQuery(objEle).offsetParent().parent().parent();
		}else{
			ppObj = jQuery(objEle).offsetParent().offsetParent();
		}
		loop:if(!jQuery.isEmptyObject(ppObj)){
			i_titleF = ppObj.find(".i-title").text();
			if(i_titleF==""){break loop;}
			fromidF = ppObj.find(".i-title").attr("fromid");
			if(fromidF==""){break loop;}
			objectTuwen= tuwen[i_titleF+"_"+fromidF];
		}
		
		var url='/html/nds/oto/attention/editTuwen.jsp?objectTuwen='+JSON.stringify(objectTuwen);
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
					//如果是取消不执行下面的操作 flag是false
					if(art.dialog.data('flagFunc')!=1) return true;
					var objEle = art.dialog.data('objEle');
					art.dialog.data('objEle','');
					//返回的json类型
					var obj ={};
					obj = art.dialog.data('obj'); 
					if(jQuery.isEmptyObject(obj))
						return true;
					//第一个大图
					if(jQuery(objEle).offsetParent().parent().parent().attr("flag")==0){
						var pp = jQuery(objEle).offsetParent().parent().parent();
						pp.find(".i-title").text(obj.title1);
						pp.find(".i-title").attr("fromid",obj.fromid);
						pp.find(".i-title").attr("objid",obj.objid);
						pp.find(".i-img").attr("src",obj.url1);
						pp.find(".i-img").css("display","block");
						pp.find(".default-tip").css("display","none");
						if(!jQuery.isEmptyObject(objectTuwen))  delete tuwen[objectTuwen.title1+"_"+objectTuwen.fromid];
						//从0开始
						obj.sort=pp.parent().children().index(pp);
						jQuery(pp).attr("orderkey",obj.title1+"_"+obj.fromid);
						tuwen[art.dialog.data('obj').title1+"_"+art.dialog.data('obj').fromid] = obj;
						//tuwen=jQuery.extend({},tuwen,obj);
						return true;
					}
					//其余的
					var parentN = jQuery(objEle).offsetParent().offsetParent();
					if(obj.title1!=""){
						parentN.find(".i-title").text(obj.title1);
						parentN.find(".i-title").attr("fromid",obj.fromid);
						parentN.find(".i-title").attr("objid",obj.objid);
					}
					if(obj.url1!=""){
						parentN.find(".default-tip").css("display","none");
						parentN.find(".i-img").attr("src",obj.url1);
						parentN.find(".i-img").css("display","block");
					}
					if(!jQuery.isEmptyObject(objectTuwen))  delete tuwen[obj.title1+"_"+obj.fromid];
					//从0开始
					obj.sort=parentN.parent().children().index(parentN);
					jQuery(parentN).attr("orderkey",obj.title1+"_"+obj.fromid);
					//插入文字
					tuwen[art.dialog.data('obj').title1+"_"+art.dialog.data('obj').fromid] = obj;
					//tuwen=jQuery.extend({},tuwen,obj);
					//obj="";
					//editKeyWords.insertText("#txtReplyWords",url);
				}
			}; 
		 
		art.dialog.open(url,options);
	},
	setRemainString:function(){
		jQuery("#spnCnt").text(this.mbStringLength(jQuery("#txtReplyWords").val()));
	},
	//求字符串所占字节数
	mbStringLength:function(str){
		var len = 0;  
		for(var i=0;i<str.length;i++){  
             if (str.charCodeAt(i)>255) {  
                 len += 2;  
             }else {  
                 len++;  
             }  
         }  
        return (1000-len);
	},
	//关闭窗口
	commitCancel:function(){
		art.dialog.close();
	}
	
};
keywords.main = function () {
	editKeyWords=new keywords();
};
//添加提示
jQuery(document).ready(keywords.main);

var attentionKey;
var attentionkeywords = Class.create();
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
	content:"",
	msgtype:"文本",
	nytype:"Y",
	url:"",
	gourl:"",
	hurl:"",
	wx_media_id:0,
	count:0,
	ad_client_id:0,
	tuwen:{},
	groupid:0,
	dotype:2,
	urlcontent:[]
};

//多图文
var tuwen = {};
//获取到wx_messagesutoone单条数据
var getnotjsonObjAll;
var proData;
			
//弹出框对象
var EditKeywordObj;
attentionkeywords.prototype={
	initialize:function(){
	
		application.addEventListener("COMMIT_DATA", this._commitSave, this);
		
		window.onload=function(){
			getnotjsonObjAll=eval("("+notData+")");
			//getnotjsonObjAll={};
			//将公司的AD_CLIENT_ID保存到最终提交的json中
			submitObj.ad_client_id=ad_client_id;
			
			if(jQuery.isEmptyObject(getnotjsonObjAll)){
				var groupidnum = 0;
				//获取sequence
				/*jQuery.ajax({
					url:'/html/nds/oto/attention/getSequence.jsp',
					data:{"tableid":"WX_ATTENTIONSET"},
					type:'get',
					async: false,
					success: function (data) {
						groupidnum = data;
					}
				});
				submitObj.groupid=parseInt(groupidnum);*/
				submitObj.groupid=0;
				return;
			}
			
			//将相关数据存放到submitObj中
			submitObj.groupid = parseInt(getnotjsonObjAll.GROUPID);
			submitObj.msgtype = getnotjsonObjAll.MESSAGETYPE;
			
			//根据首个id查询内容
			//如果是文本
			if(submitObj.msgtype=="文本"){
				jQuery.post("/html/nds/oto/attention/getContentClob.jsp",
						{tid:getnotjsonObjAll.ID,tableName:"WX_ATTENTIONSET"},
						function(data){
							jQuery("#txtReplyWords").html(data.trim());
							attentionKey.setRemainString();
					}
				);
			}
			if(submitObj.msgtype=="图文"){
				//this.SetReplyType("News");
				//添加图文的具体内容
				jQuery.post("/html/nds/oto/attention/getTuwenData.jsp",
						{groupid:submitObj.groupid,tableName:"WX_ATTENTIONSETITEM"},
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
								s += '            <a href="javascript:void(0);" onclick="attentionKey.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
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
							
					}
					
				);
				attentionKey.SetReplyType('News');
			}
		};
		
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
	commitSave:function(){
		//最后保存
		
		//获取回复的内容 判断是图文还是文本abbr
		
		//把addJsonObj放到提交的数组中
		
		
		//判断类型，保存值
		if(submitObj.msgtype=="文本"){
			var str = jQuery("#txtReplyWords").val();
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
		evt.table="WX_ATTENTIONSET";
		evt.action = "aud";
		evt.permission="r";
		attentionKey._executeCommandEvent(evt);
		
	},
	_commitSave:function(e){
		//tuwen={};
		art.dialog.tips("操作成功");
		//window.location.reload();		
		//art.dialog.close();
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
				attentionKey.insertText("#txtReplyWords","<a href=\"weixin://contacts/profile/"+eval("("+data+")")[0].rows+"\">点击关注</a>");
				attentionKey.setRemainString();
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
				var s= '>><a href="@@\\"fromid\\":29,\\"replace\\":\\"\\"@@">点此逛逛微商城</a>\n【新品】<a href="@@\\"fromid\\":27,\\"replace\\":\\"\\"@@">新品上市</a>\n【微官网】<a href="@@\\"fromid\\":42,\\"replace\\":\\"\\"@@">微官网</a>\n【微相册】<a href="@@\\"fromid\\":32,\\"replace\\":\\"\\"@@">微相册</a>\n【会员】<a href="@@\\"fromid\\":37,\\"replace\\":\\"\\"@@">会员中心</a>\n';
				attentionKey.insertText("#txtReplyWords",s+"<a href=\"weixin://contacts/profile/"+eval("("+data+")")[0].rows+"\">点击关注</a>");
				attentionKey.setRemainString();
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
					if(typeof(url)!="undefined"){
						attentionKey.insertText("#txtReplyWords",url);
						attentionKey.setRemainString();
					}
				}
			}; 
		 
		art.dialog.open(url,options);
		
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
		s += '            <a href="javascript:void(0);" onclick="attentionKey.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
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
						pp.attr("orderKey",obj.title1+"_"+obj.fromid);
						pp.find(".i-title").text(obj.title1);
						pp.find(".i-title").attr("fromid",obj.fromid);
						pp.find(".i-title").attr("objid",obj.objid);
						pp.find(".i-img").attr("src",obj.url1);
						pp.find(".i-img").css("display","block");
						pp.find(".default-tip").css("display","none");
						if(!jQuery.isEmptyObject(objectTuwen))  delete tuwen[objectTuwen.title1+"_"+objectTuwen.fromid];
						tuwen[art.dialog.data('obj').title1+"_"+art.dialog.data('obj').fromid] = obj;
						//tuwen=jQuery.extend({},tuwen,obj);
						return true;
					}
					//其余的
					var parentN = jQuery(objEle).offsetParent().offsetParent();
					parentN.attr("orderKey",obj.title1+"_"+obj.fromid);
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
					if(!jQuery.isEmptyObject(objectTuwen))  delete tuwen[objectTuwen.title1+"_"+objectTuwen.fromid];
					//插入文字
					tuwen[art.dialog.data('obj').title1+"_"+art.dialog.data('obj').fromid] = obj;
					//tuwen=jQuery.extend({},tuwen,obj);
					//obj="";
					//attentionKey.insertText("#txtReplyWords",url);
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
attentionkeywords.main = function () {
	attentionKey=new attentionkeywords();
};
//添加提示
jQuery(document).ready(attentionkeywords.main);

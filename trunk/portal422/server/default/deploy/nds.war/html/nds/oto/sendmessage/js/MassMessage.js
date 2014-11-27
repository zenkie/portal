var send;
var sendMessage = Class.create();
var dialog;
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
	msgtype:"文本",
	title:"",
	content:"",
	orginalcontent:"",
	wx_media_id:0,
	url:"",
	count:0,
	gourl:"",
	hurl:"",
	groupid:0,
	ad_client_id:0,
	tuwen:{},
	urlcontent:[],
	openId:"",
	type:"mass",//群发消息
	opendIdList:"",//群发OPENID 例如：opendIdList:{"opendId1":"","opendId2":""}
	replyid:0,
};

//多图文
var tuwen = {};
//获取到wx_messagesutoone单条数据
var getnotjsonObjAll;
var proData;
			
//弹出框对象
var EditKeywordObj;
sendMessage.prototype={
	initialize:function(){		
		application.addEventListener("COMMIT_DATA", this._commitSave, this);
		//将公司的AD_CLIENT_ID保存到最终提交的json中		
		submitObj.ad_client_id=ad_client_id;
		//submitObj.openId = openId;
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
			delete tuwen[title+"_"+fromid];
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
			jQuery(".emotion").hide();
			jQuery("#spnReplyWordsInfo").hide();
			jQuery("#spnAddLink").hide();
		}else{
			jQuery(".emotion").show();
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
		var openList = jQuery(jQuery("input")[1]).val();
		if(openList.trim()==""||openList.length<=0){
			art.dialog.tips("需要选择发送的vip卡号!");
			return false;
		}
		submitObj.opendIdList=openList;
		
		
		if(submitObj.msgtype=="文本"){
			if(jQuery("#spnCnt").text()<0){
				art.dialog.tips("输入的文本必须少于1000个字符");
				return false;
			}
			if(!(jQuery("#txtReplyWords").find("img").length > 0) && jQuery("#txtReplyWords").children().length==jQuery("#txtReplyWords").children(jQuery("<br>")).length && jQuery("#txtReplyWords").text().trim()==""){
				art.dialog.tips("您未输入除空格、换行外任何内容！");
				return false;
			}
			var diClone = jQuery("#txtReplyWords").clone();
			
			jQuery.each(diClone.children(),function(index,val){
				if(jQuery.isEmptyObject(jQuery(val).attr("data-title"))) return true;
				jQuery(val).replaceWith("/"+jQuery(val).attr("data-title"));
			});			 
			submitObj.orginalcontent = jQuery("#txtReplyWords").html();
			submitObj.content = diClone.html();
		}
		//判断图文保存值
		if(submitObj.msgtype=="图文"){
			//修改图文的order
			jQuery.each(jQuery(".multi-msg").children(),function(index,val){
				if(jQuery.isEmptyObject(jQuery(val).attr("orderkey"))) return true;
				tuwen[jQuery(val).attr("orderkey")].sort=index;
				submitObj.tuwen[index]=tuwen[jQuery(val).attr("orderkey")];
			});
			if(jQuery.isEmptyObject(submitObj.tuwen)){
				art.dialog.tips("请填写回复的图文！");
				return false;
			}
			submitObj.count =  Object.keys(tuwen).length;
		}		
		a=[];
		var ia;
		var reg=new RegExp("\\[@","g");
		submitObj.content=submitObj.content.replace(reg,"<");
		reg=new RegExp("@\\]","g");
		submitObj.content=submitObj.content.replace(reg,">");
		reg=new RegExp("<br>","g");
		submitObj.content=submitObj.content.replace(reg,"\n");
		reg=new RegExp("@@[^(@@)]+@@","g");
		
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
					ia["receive"]=res[i];
					a.push(ia);
				}
			}
		}		
		if(a.length>0){submitObj["urlcontent"]=JSON.stringify(a.slice()).replace(new RegExp("^\"|\"$","g"),"").replace(new RegExp("(\\\\\")","g"),"\"").replace(/\\\\\\\\\\/g,"\\\\");}
		dialog = art.dialog({lock:true,cancel: false,content: '正在发送，请稍后.....'});
		var _command = "ObjectCreate";
		var opendIdList = submitObj.opendIdList;
		var _params = "{\"table\":\"WX_NOTIFYTEMP\",\"unionfk\":true,\"MASSOPENID\":\""+opendIdList+"\"}";		
		jQuery.ajax({
			url: '/html/nds/schema/restajax.jsp',
			type: 'post',
			//dataType:'json',//返回的数据是json
			data:{command:_command,params:_params},
			success: function (data) {			
				var _data = eval("("+data+")");
				if (_data[0].code == 0) {				
					submitObj.opendIdList = _data[0].objectid;
					var evt={};
					evt.command="DBJSON";
					evt.callbackEvent="COMMIT_DATA";
					evt.param=Object.toJSON(submitObj);
					evt.table="WX_NOTIFY";
					evt.action = "aud";
					evt.permission="r";		
					send._executeCommandEvent(evt);	
				} else {
					dialog.close();
					sendCommand._showDialog({content:"数据提交失败，请重新提交！"});
				}
			}					
		});	
	},
	_commitSave:function(e){		
		//var memberid = e.getUserData()jsonResult.evalJSON().memberid;
		//sendCommand.send_mass_message(memberid);
		dialog.close();
		sendCommand._showDialog({content:"发送信息成功"});
		// sendCommand._showDialog({content:"发送信息成功"});
	},
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				dialog.close();
				art.dialog.tips(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	},
	//设置插入链接
	setTarget:function(){
		var titleName="设置链接";
		var url='/html/nds/oto/sendmessage/jumpUrl.jsp';
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
					if(!jQuery.isEmptyObject(url) && url!=""){
						send.insertText("#txtReplyWords",url);
						send.setRemainString();
					}
					window.art.dialog.list={};
				}
			}; 
		 
		art.dialog.open(url,options);
		
	},
	//根据id向textarea中插入内容
	insertText:function(textarea, str){
		if(jQuery.isEmptyObject(range)){
			jQuery("#txtReplyWords").html(jQuery("#txtReplyWords").html()+str+"<br>");
			jQuery("#spnCnt").text(send.mbStringLength(send.mbStringLength()));
			return;
		}
		if (!window.getSelection){
			document.getElementById('txtReplyWords').focus();
			selection= window.getSelection ? window.getSelection() : document.selection;
			range= selection.createRange ? selection.createRange() : selection.getRangeAt(0);
			range.pasteHTML(str);
			range.collapse(false);
			range.select();
		}else{
			document.getElementById('txtReplyWords').focus();
			range.collapse(false);
			var hasR = range.createContextualFragment(str);
			var hasR_lastChild = hasR.lastChild;
			while (hasR_lastChild && hasR_lastChild.nodeName.toLowerCase() == "br" && hasR_lastChild.previousSibling && hasR_lastChild.previousSibling.nodeName.toLowerCase() == "br") {
			var e = hasR_lastChild;
			hasR_lastChild = hasR_lastChild.previousSibling;
			hasR.removeChild(e)
			}                                
			range.insertNode(hasR);
			if (hasR_lastChild) {
			range.setEndAfter(hasR_lastChild);
			range.setStartAfter(hasR_lastChild)
			}
			selection.removeAllRanges();
			selection.addRange(range)
		}
		jQuery("#spnCnt").text(send.mbStringLength(jQuery("#txtReplyWords").val()));
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
		s += '            <a href="javascript:void(0);" onclick="send.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
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
		var flag = 0;
		
		var objectTuwen = {
		};
		
		//第一个大图
		if(jQuery(objEle).offsetParent().parent().parent().attr("flag")==0){
			ppObj = jQuery(objEle).offsetParent().parent().parent();
		}else{
			ppObj = jQuery(objEle).offsetParent().offsetParent();
			var flag = 1;
		}
		loop:if(!jQuery.isEmptyObject(ppObj)){
			i_titleF = ppObj.find(".i-title").text();
			if(i_titleF==""){break loop;}
			fromidF = ppObj.find(".i-title").attr("fromid");
			if(fromidF==""){break loop;}
			objectTuwen= tuwen[i_titleF+"_"+fromidF];
		}
		
		var url='/html/nds/oto/sendmessage/editTuwen.jsp?flag='+flag+'&objectTuwen='+JSON.stringify(objectTuwen);
		var titleName="设置链接";
		var options={
				id:'artDialog',
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
					window.art.dialog.list={};
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
						window.art.dialog.list={};
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
					window.art.dialog.list={};
				}
			}; 
		 
		art.dialog.open(url,options);
	},
	setRemainString:function(){
		jQuery("#spnCnt").text(this.mbStringLength(jQuery("#txtReplyWords").val()));
	},
	//求字符串所占字节数
	mbStringLength:function(){
		var str = jQuery("#txtReplyWords").text();
		var len = 0; 
		jQuery.each(jQuery("#txtReplyWords").children(),function(index,val){
			if(val.tagName!="IMG"){
				return true;
			}
			str+='/'+jQuery(val).attr("data-title");
		});
        return (1000-str.length);
	},
	//关闭窗口
	commitCancel:function(){
		art.dialog.close();
	}
	
};
sendMessage.main = function () {
	send=new sendMessage();
};
//添加提示
jQuery(document).ready(sendMessage.main);

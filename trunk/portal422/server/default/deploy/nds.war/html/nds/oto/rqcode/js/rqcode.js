var rq=null;
var rqcode=Class.create();

rqcode.prototype={
	initialize:function(){
		this.id=0;
		this.msgtype="";
		this.content={};
		this.ad_client_id=0;
		this.tempContent={};
		this.msgtypes={
			Link:"链接",
			Words:"文本",
			Image:"图片",
			Voice:"语音",
			Video:"视频",
			Music:"音乐",
			News:"图文",
			Action:"动作定义"
		};
		this.actiontype={
			url:"URL",
			sp:"存储过程",
			adproc:"任务程序",
			js:"JavaScript",
			bsh:"BeanShell",
			shell:"OS Shell",
			py:"Python"
		};
		this.actiontype="";
		
		this.deleteTuwen();
		application.addEventListener("SAVE_RQCODE", this._onSaveRqcode, this);
		application.addEventListener("CREATE_TWODIMENSIONALCODE", this._oncreateTwoDimensionalCode, this);
	},
	
	getMessageKeyByValue:function(value){
		var key;
		switch(value){
			case "链接":
				key= "Link";
				break;
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
			case "动作定义":
				key= "Action";
				break;
			default :
				key="Link";
				break;
		}
		return key;
	},
		
	initRqcodeMessage:function(){
		jQuery("#rqcodename").val(rq.content.title);
		jQuery("#rqcodeparam").val(rq.content.rqcodeparam);
		jQuery("#rqcodetype input[type=radio][value="+rq.content.rqcodetype+"]").attr("checked","checked");
		jQuery("#rqcodedisposeid").val(rq.content.wx_rqcodedispose_id);
		jQuery("#rqcodedisposeidobjid").val(rq.content.objid);
		jQuery("#rqcodedisposename").val(rq.content.name);
		jQuery("#rqcodelogo").attr("src",rq.content.rqcodelogo);
		jQuery("#rqcodeimage").attr("src",rq.content.rqcodeimage);
		jQuery("#ticket").val(rq.content.ticket);
		jQuery("#gourl").val(rq.content.gourl);
		
		if(rq.content.isenable=="N"){
			jQuery("#isenable").attr("value","N");
			jQuery("#isenable").html("启用");
		}else{
			jQuery("#isenable").attr("value","Y");
			jQuery("#isenable").html("失效");
		}
	},
	
	initRqcode:function(){
		if(this.id<=0){
			var ct=this.initContent("Words");
			ct.rqcodeparam=this.content.rqcodeparam;
			this.content=ct;
		}
		this.initRqcodeMessage();
		this.msgtype=this.content.msgtype;
		this.changeMenuType(this.msgtype);
	},
	
	changeMenuType:function(type){
		var text = this.msgtypes[type];
		jQuery("#returnType").html(text);
		switch(type){
			case "Link":
				rq.showLink();
				break;
			case "Words":
				rq.showWords();
				break;
			case "News":
				rq.showNews();
				break;
			case "Action":
				rq.showAction();
				break;
			default:
				this.init();
				break;
		}
		//切换回复类型
		rq.msgtype=type;
		jQuery("#divRelpys >div").hide();
		jQuery("#divRelpy"+type).show();
		return false;
	},
	
	//初始化多图文
	initNews:function(){
		var defaultNews="<div class=\"msg-item multi-msg\">"
					+		"<div class=\"appmsgItem\" flag=\"0\" imagetype=\"bigImage\" style=\"position:relative;\">"
					+			"<p class=\"msg-meta\"><span class=\"msg-date\">&nbsp;</span></p>"
					+			"<span class=\"cover\" style=\"position: absolute;width: 322px;left:0;\">"
					+				"<p id=\"pDefaultTip\" class=\"default-tip\" style=\"\">封面图片</p>"
					+				"<img id=\"imgPic\" class=\"i-img\" style=\"display:none;\">"
					+			"</span>"
					+			"<div class=\"cover\">"
					+				"<div class=\"msg-t h4\">"
					+					"<span id=\"spnTitle\" class=\"i-title\"></span>"
					+				"</div>"
					+				"<ul class=\"abs tc sub-msg-opr\">"
					+					"<li class=\"b-dib sub-msg-opr-item\">"
					+						"<a href=\"javascript:void(0);\" onclick=\"rq.editTuwen(this)\" class=\"th icon18 iconEdit\">编辑</a>"
					+					"</li>"
					+				"</ul>"
					+			"</div>"
					+		"</div>"
					+		"<div class=\"sub-add\">"
					+			"<a href=\"javascript:;\" class=\"block tc sub-add-btn\" onclick=\"rq.addNews()\"><span class=\"vm dib sub-add-icon\"></span>增加一条</a>"
					+		"</div>"
					+	"</div>"
		jQuery("#divRelpyNews").html(defaultNews);
		jQuery("#spnAddLink").hide();
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").hide();
		jQuery("#spanReplyNews").show();
	},
	
	//初始化文本
	initWords:function(){
		jQuery("#txtReplyWords").val("");
		jQuery("#spnAddLink").show();
		rq.setRemainString();
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
	
	//初始化动作定义
	initAction:function(){
		
	},
	
	//显示文本
	showWords:function(){
		jQuery("#replyheads>div").hide();
		jQuery("#ordinaryReply").show();
		jQuery("#spnAddLink").show();
		jQuery("#spanReplyLink").hide();
		jQuery("#spanReplyWords").show();
		jQuery("#spanReplyNews").hide();
		
		if(rq.content.msgtype!="Words"){
			rq.initWords();
			return;
		}
		jQuery("#txtReplyWords").val(rq.content.content);
		rq.setRemainString();
	},
	
	//显示多图文
	showNews:function(){
		jQuery("#replyheads>div").hide();
		jQuery("#ordinaryReply").show();
		jQuery("#spnAddLink").hide();
		rq.initNews();
		if(rq.content.msgtype!="News"){return;}
		
		//if(!rq.content.hasOwnProperty(rq.menu.key)){rq.content[rq.menu.key]=rq.initContent("News");}
		var cContent=rq.content;
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
				pp.find(".i-title").text(tuwen.title);
				if(tuwen.url){
					pp.find(".i-img").attr("src",tuwen.url);
					pp.find(".i-img").css("display","block");
					pp.find(".default-tip").css("display","none");
				}
				jQuery(pp).attr({"id":tuwen.id,"fromid":tuwen.fromid,"replace":tuwen.objid,"title":tuwen.title,"url":tuwen.url,"content":tuwen.content});
				//rq.content[rq.menu.key].tuwen[key]=jQuery.extend(tuwen);
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
				s += '<div id="'+tuwen.id+'" class="rel sub-msg-item appmsgItem" flag="1" imagetype=\"smallImage\" fromid='+tuwen.fromid+' replace=\"'+tuwen.objid+'\" title=\"'+tuwen.title+'\" url=\"'+tuwen.url+'\" content=\"'+tuwen.content+'\" >';
				s += '    <span class="thumb">';
				s += '        <span class="default-tip" style="display:'+(tuwen.url?"none":"block")+';">缩略图</span>';
				s += '        <img class="i-img" style="display:'+(tuwen.url?"block":"none")+';" src="'+tuwen.url+'">';
				s += '    </span>';
				s += '    <div class="msg-t h4">';
				s += '        <span class="i-title">'+tuwen.title+'</span>';
				s += '    </div>';
				s += '    <ul class="abs tc sub-msg-opr">';
				s += '        <li class="b-dib sub-msg-opr-item">';
				s += '            <a href="javascript:void(0);" onclick="rq.editTuwen(this);" class="th icon18 iconEdit">编辑</a>';
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
			//rq.content[rq.menu.key].tuwen[key]=jQuery.extend(tuwen);
		});
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
	
	//显示动作定义
	showAction:function(){
		jQuery("#replyheads>div").hide();
		jQuery("#actionReply").show();
		
		if(rq.content.msgtype=="Action"){
			jQuery("#divRelpyAction #actioncontent").val(rq.content.content);
			jQuery("#actiontype option[value="+rq.content.actiontype).attr("selected","selected");
		}else{
			jQuery("#divRelpyAction #actioncontent").val("");
		}
	},
	
	//增加一个多图
	addNews:function(){
		var s = ""
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
		s += "            <a href=\"javascript:void(0);\" onclick=\"rq.editTuwen(this);\" class=\"th icon18 iconEdit\">编辑</a>";
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
	
	//编辑多图文
	editTuwen:function(objEle){
		art.dialog.data('objEle',objEle);
		var divNews=jQuery(objEle).closest(".appmsgItem");
		var objectTuwen = {};

		var fromid=jQuery(divNews).attr("fromid");
		var replace=jQuery(divNews).attr("replace");
		var title=jQuery(divNews).attr("title")
		var url=jQuery(divNews).attr("url");
		var content=jQuery(divNews).attr("content");
		var imageSize=jQuery(divNews).attr("imagetype");
		objectTuwen.fromid=fromid;
		objectTuwen.objid=replace;
		objectTuwen.title=title;
		objectTuwen.url=url;
		objectTuwen.imageSize=imageSize;
		objectTuwen.content=content;

		//var url="/html/nds/oto/rqcode/editTuwen.jsp?objectTuwen="+JSON.stringify(objectTuwen);
		var url='/html/nds/oto/rqcode/editTuwen.jsp';
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
				if(obj.title){parentN.find(".i-title").text(obj.title);}
				if(obj.url){
					parentN.find(".default-tip").css("display","none");
					parentN.find(".i-img").attr("src",obj.url);
					parentN.find(".i-img").css("display","block");
				}
				jQuery(parentN).attr({"fromid":obj.fromid,"replace":obj.objid,"title":obj.title,"url":obj.url,"content":obj.content});
			}
		}; 
		var data = {"objectTuwen" : JSON.stringify(objectTuwen)};
		art.dialog.load(url,data,options,false);
	},
	
	//绑定删除多图文功能
	deleteTuwen:function(){
		//多图文删除
		jQuery("#divRelpyNews .appmsgItem .iconDel").live('click', function () {
			//从tuwen中删除
			var listNode = jQuery(this).closest(".appmsgItem");
			if(rq.content.msgtype=="News"){
				var id=jQuery(listNode).attr("id");
				var tuwen=rq.content.tuwen[id];
				if(tuwen&&tuwen.id){
					rq.content.tuwen[id].operate="delete";
				}
			}
			listNode.remove();
			if(jQuery("#divRelpyNews .msg-item").children().length<10){jQuery("#divRelpyNews .sub-add").show();}
		});
	},
	
	//设置是否失效
	setEnable:function(){
		var isEnable=jQuery("#isenable").attr("value");
		if(isEnable=="Y"){
			jQuery("#isenable").attr("value","N");
			jQuery("#isenable").html("启用");
		}else{
			jQuery("#isenable").attr("value","Y");
			jQuery("#isenable").html("禁用");
		}
	},
	
	//保存二维码信息
	saveReply:function(){
		if(!this.msgtype){
			alert("请设置二维码内容！");
			return;
		}
		var title=jQuery("#rqcodename").val().trim();
		if(!title){
			alert("名称不能为空！");
			return;
		}
		var rqcodeparam=jQuery("#rqcodeparam").val().trim();
		if(!rqcodeparam||rqcodeparam.indexOf(".")>-1||isNaN(rqcodeparam)){
			alert("参数必须是1-100000之间的整数");
			return;
		}
		var rqcodetype=jQuery("#rqcodetype input[name=rqocdetype]:checked").val();
		if(!rqcodetype){
			alert("请选择类型！");
			return;
		}
		var rqcodeimage=jQuery("#rqcodeimage").attr("src");
		if(!rqcodeimage){
			alert("请生成二维码！");
			return;
		}
		var ticket=jQuery("#ticket").val();
		if(!ticket){
			alert("请生成二维码！");
			return;
		}
		
		var gourl=jQuery("#gourl").val();
		if(!ticket){
			alert("请生成二维码！");
			return;
		}
		
		if(!this.setMenuReply()){return;}
		if(rq.content.id>0){
			this.tempContent.id=rq.content.id;
			this.tempContent.operate="modify";
		}
		var isenable="Y";
		isenable=jQuery("#isenable").attr("value");
		this.tempContent.title=title;
		this.tempContent.rqcodeparam=rqcodeparam;
		this.tempContent.rqcodetype=rqcodetype;
		this.tempContent.wx_rqcodedispose_id=parseInt(jQuery("#rqcodedisposeid").val());
		this.tempContent.objid=jQuery("#rqcodedisposeidobjid").val();
		this.tempContent.rqcodelogo=jQuery("#rqcodelogo").attr("src");
		this.tempContent.rqcodeimage=rqcodeimage;
		this.tempContent.ticket=ticket;
		this.tempContent.gourl=gourl;
		this.tempContent.isenable=isenable;
		this.tempContent.ad_client_id=this.ad_client_id;
		
		var replyMenu=this.tempContent;
		if(!replyMenu||jQuery.isEmptyObject(replyMenu)){
			alert("请设二维码回复信息！");
			return;
		}

		var evt={};
		evt.command="DBJSON";
		evt.callbackEvent="SAVE_RQCODE";

		evt.param=Object.toJSON(replyMenu);
		evt.table="wx_rqcodemessage";
		evt.action = "aud";
		evt.permission="r";
		this._executeCommandEvent(evt);
	},
	
	_onSaveRqcode:function(e){

		alert("保存成功！");
	},
	
	//设置保存内容到本地JSON中
	setMenuReply:function(){
		var isCorrect=true;
		switch(this.msgtype){
			case "Link":
				isCorrect=rq.setMenuLink();
				break;
			case "Words":
				isCorrect=rq.setMenuWords();
				break;
			case "News":
				isCorrect=rq.setMenuNews();
				break;
			case "Action":
				isCorrect=rq.setAction();
				break;
			default:
				rq.tempContent=null;
				isCorrect=false;
				break;
		}
		return isCorrect;
	},
	
	setMenuWords:function(){
		var content=jQuery("#txtReplyWords").val().trim();
		if(content==null||content==""){
			alert("文本内容，请输入文本内容！");
			return false;
		}
		var cContent=this.initContent("Words");
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
		var id;
		var fromid;
		var replace;
		var title;
		var url;
		var content;
		var cContent=this.initContent("News");
		if(this.content.msgtype=="News"){cContent.tuwen=jQuery.extend({},this.content.tuwen);}
		var tuwen={};
		for(var i=0;i<replyNews.length;i++){
			replyNew=replyNews[i];
			id=jQuery(replyNew).attr("id");
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
			
			if(id){
				tuwen=rq.content.tuwen[id];
				tuwen.operate="modify";
			}else{
				tuwen=rq.initTuWen(i?"smallImage":"bigImage");
				tuwen.id=rq.initKey();
			}
			
			tuwen.fromid=parseInt(fromid);
			tuwen.objid=replace;
			tuwen.title=title;
			tuwen.url=url;
			tuwen.sort=i;
			tuwen.content=content;
			cContent.tuwen[tuwen.id]=jQuery.extend({},tuwen);
		}
		cContent.count=replyNews.length;
		this.tempContent=cContent;
		return true;
	},
	
	setAction:function(){
		var cContent=this.initContent("Action");
		var content=jQuery("#divRelpyAction #actioncontent").val().trim();
		if(!content){
			alert("动作内容不能为空");
			return false;
		}
		var actiontype=jQuery("#actiontype option:checked").val();
		if(!actiontype){
			alert("请选择动作类型");
			return false;
		}
		cContent.content=content;
		cContent.actiontype=actiontype;
		rq.tempContent=cContent;
		return true;
	},
	
	setRqcodeDispose:function(){
		var formid=jQuery("#rqcodedisposeid").val();
		var objid=jQuery("#rqcodedisposeidobjid").val();
		
		var url='/html/nds/oto/rqcode/setRqcodeDispose.jsp';
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
				var dispose = art.dialog.data('dispose'); 
				if(jQuery.isEmptyObject(dispose)){return true;}
				jQuery("#rqcodedisposeid").val(dispose.fromid);
				jQuery("#rqcodedisposeidobjid").val(dispose.objid);
				jQuery("#rqcodedisposename").val(dispose.name);
			}
		}; 
		var data = {"fromid":formid,"objid":objid};
		art.dialog.load(url,data,options,false);
	},
	
	setRemainString:function(){
		jQuery("#spnCnt").text(this.mbStringLength(jQuery("#txtReplyWords").val()));
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

	//初始化内容
	initContent:function(messageType){
		return {
			id:0,
			operate:"add",
			title:"",
			ticket:"",
			rqcodeparam:"",
			rqcodetype:"permanent",
			content:"",
			msgtype:messageType,
			actiontype:"",
			wx_rqcodedispose_id:null,
			objid:null,
			url:"",
			isenable:"Y",
			gourl:"",
			hurl:"",
			wx_media_id:null,
			count:0,
			ad_client_id:rq.ad_client_id,
			tuwen:{},
			urlcontent:[]
		};
	},
	//初始化图文
	initTuWen:function(imageType){
		return{
			"id":0,
			"operate":"add",
			"fromid":-1,
			"objid":"",
			"title":"",
			"content":"",
			"sort":0,
			"wx_media_id":"",
			"url":"",
			"gourl":"",
			"imagetype":imageType||"smallImage"
		};
	},
	
	//创建二维码
	createTwoDimensionalCode:function(){
		var evt={};
		var con=jQuery("#rqcodeparam").val();
		if(!con){
			alert("参数不能为空");
			return;
		}
		if(con.indexOf(".")>-1||isNaN(con)){
			alert("参数必须是1-100000之间的整数");
			return;
		}

		con=parseInt(con)||1;
		
		var type=jQuery("#rqcodetype input[name=rqocdetype]:checked").val();
		if(!type){
			alert("必须选择类型");
			return;
		}
		var logo=jQuery("#rqcodelogo").attr("src");
		evt.command="nds.weixin.ext.TwoDimensionalCodeCommand";
		evt.callbackEvent="CREATE_TWODIMENSIONALCODE";
		var param={"logopath":logo,"scene_id":con,"rqcodetype":type};
		evt.params=Object.toJSON(param);
		
		this._executeCommandEvent(evt);
	},
	
	_oncreateTwoDimensionalCode:function(e){
		var data=e.getUserData();
        if(data&&data.imgpath){
			jQuery("#rqcodeimage").attr("src",data.imgpath);
			jQuery("#ticket").val(data.ticket);
			jQuery("#gourl").val(data.url);
		}
	},
	
	initKey:function(){
		var key="";
		var currentDate = new Date();
		key+=currentDate.getFullYear();
		key+=currentDate.getMonth();
		key+=currentDate.getDate();
		key+=currentDate.getHours();
		key+=currentDate.getMinutes();
		key+=currentDate.getMilliseconds();
		key+=Math.random();
		key=key.replace(".","");
		return key;
	},
	
	_executeCommandEvent:function(evt){
		Controller.handle( Object.toJSON(evt), function(r){
            var result= r.evalJSON();
            if (result.code !=0 ){
				//art.dialog.tips(result.message);
				alert(result.message);
            }else {
                var evt=new BiEvent(result.callbackEvent);
                evt.setUserData(result.data);
                application.dispatchEvent(evt);
            }
        });
	}
}

rqcode.main=function(){
	rq=new rqcode();
}
//jQuery(document).ready(rqcode.main);
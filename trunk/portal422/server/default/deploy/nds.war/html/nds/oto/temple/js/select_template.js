var st;
var Select_templateControl = Class.create();

Select_templateControl.prototype = {
	initialize: function() {
		dwr.engine.setErrorHandler(function(message, ex) {
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;			
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else alert(message);
		});		
		application.addEventListener( "SelectTemplate", this._onselect_template, this);
	},
	choose_template : function (e,ptype) {
		var clientId=jQuery("#ad_client_id").val();//公司ID
		var templateid=jQuery(e).find("a").attr("id");//模板ID
		templateid = templateid.replace(/tempImg/,"");
		if(confirm("是否要修改为该模板？")){		
			var evt={};
			evt.command="SelectTemplate";//调用的java类
			evt.params={"templateid":templateid,"clientId":clientId,"ptype":ptype};	//参数 templateid模板 clientId公司 ptype商城或者官网
			evt.callbackEvent="SelectTemplate";//回调js函数
			this._executeCommandEvent(evt);	
		}	
	},
	_onselect_template : function (e) {//回调函数
		var r=e.getUserData(); 		
		if(r.code!=0){
			this._showMessage(r.message,true);			
		}
		else {
			var name = "#tempImg"+r.data.tmpid;
			var selected_tempImg = jQuery(name);//找到选择的模板
			var tempUl = selected_tempImg.closest("#temp1");//找到祖先节点ul
			//selected_tempImg.closest(".tag-panel-content").find(".selected").removeClass("selected");
			selected_tempImg.closest(".tempListBox").find(".selected").removeClass("selected");
			selected_tempImg.addClass("selected");
			tempUl.prepend(selected_tempImg.parent());
			art.dialog({time: 2,lock:true,cancel: false,content: '您选择的模板已修改!'});
		}
	},	
	
	_executeCommandEvent :function (evt) {
		Controller.handle( Object.toJSON(evt), function(r){
			var result= r.evalJSON();
			var evt=new BiEvent(result.callbackEvent);
			evt.setUserData(result);
			application.dispatchEvent(evt);
		}
	  );
	},
	_showMessage:function(msg, bError){//显示错误信息
		if(msg!=null&&bError){
			alert(msg);
		}
	},
	init_template:function(){//初始化模板
		var stylelist = jQuery(".stylelist");//类目 和 列表没有风格 将风格Tab隐藏
		for(var i=0,size=stylelist.length; i < size;i++){
			if(jQuery(stylelist[i]).find("a").length <= 0){
				jQuery(stylelist[i]).css("display","none");
			}
		}
	
		var list = jQuery(".tag-panel-contnt1>div");//初始化界面，显示首页，列表，类目下的界面
		list.eq(0).addClass("show");
		list.eq(0).find("ul").eq(0).addClass("show");
		list.eq(0).find(".stylelist>a").eq(0).addClass("selected");
		
		var homeTemp = jQuery(jQuery("#homeTemp").val());//将默认的首页，列表，类目模板放在第一位
		var listTemp = jQuery(jQuery("#listTemp").val());
		var classTemmp = jQuery(jQuery("#classTemmp").val());
		homeTemp.addClass("selected");//给默认模板加选择样式
		listTemp.addClass("selected");
		classTemmp.addClass("selected");
		
		homeTemp.closest("ul").prepend(homeTemp.parent());//找到祖先节点ul并且加入节点第一位
		listTemp.closest("ul").prepend(listTemp.parent());
		classTemmp.closest("ul").prepend(classTemmp.parent());
	}
};

Select_templateControl.main = function () {
	st=new Select_templateControl();
	st.init_template();
};
jQuery(document).ready(Select_templateControl.main);

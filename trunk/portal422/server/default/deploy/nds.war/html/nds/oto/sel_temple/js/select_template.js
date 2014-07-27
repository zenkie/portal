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
	var clientId=jQuery("#ad_client_id").val();
	var templateid=jQuery(e).find("a").attr("id");
	templateid = templateid.replace(/tempImg/,"");
	if(confirm("是否要修改为该模板？")){		
		var evt={};
		evt.command="SelectTemplate";
		evt.params={"templateid":templateid,"clientId":clientId,"ptype":ptype};	
	    evt.callbackEvent="SelectTemplate";
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
			var tempHtml;//临时变量，用来存储交换的html
			selected_tempImg.closest(".tag-panel-content").find(".selected").removeClass("selected");
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
	_showMessage:function(msg, bError){
			if(msg!=null&&bError){
				alert(msg);
			}
	},
	page: function(pageindex,totpage){
		window.location="/html/nds/webclient/select_template.jsp?pagesize="+pageindex;
	},
	init_template:function(){//将默认的模板排到第一位  添加的代码
		var list = jQuery("a.selected");
		var tempUl;
		for(var i = 0; i < list.length;i++){
			tempUl = list.eq(i).closest("#temp1");//找到祖先节点ul
			tempUl.prepend(list.eq(i).parent());
		}
	}
	
};

Select_templateControl.main = function () {
	st=new Select_templateControl();
	st.init_template();
};

jQuery(document).ready(Select_templateControl.main);

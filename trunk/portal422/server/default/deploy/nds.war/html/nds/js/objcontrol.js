var inlineObject=null;// this is for inline object
var oc;
var ObjectControl = Class.create();
// define constructor
ObjectControl.prototype = {
	initialize: function() {
		this._masterObj=masterObject;
		dwr.engine.setErrorHandler(function(message, ex) {
			$("timeoutBox").style.visibility = 'hidden';
			if (message == null || message == "") {
				while(ex!=null && ex.cause!=null) ex=ex.cause;
				if(ex!=null)message=ex.javaClassName;
				msgbox(gMessageHolder.INTERNAL_ERROR+":"+ message);
			}
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else msgbox(message);
	  		oc._showMessage("<font color='#FF0000'>"+message+"</font>", ex);
			oc._toggleButtons(false);
		});		
		application.addEventListener( "SaveObject", this._onSaveObject, this);
		application.addEventListener( "SaveObjectNew", this._onSaveObjectNew, this);
		application.addEventListener( "DeleteObject", this._onDeleteObject, this);
		application.addEventListener( "SubmitObject", this._onSubmitObject, this);
		application.addEventListener( "UnsubmitObject", this._onSubmitObject, this);// share the same handling method _onSubmitObject
		application.addEventListener( "ExecuteAudit", this._onExecuteAudit, this);
		application.addEventListener( "PrintJasper", this._onPrintJasper, this);
		this.MAX_INPUT_LENGTH=1000;// this is used for selection range
		this._tryAddCloseButton();
		this._tryUpdateTitle();
		this._url= window.location.href;
		this._closeWindow=false;// if true, will close window immdiately
	},
	/**
	 * Get column by id in master object, return null if not found
	 * column properties:
	 * 	@see nds.schema.Column.toJSONObject(locale)
	 */
	getColumnById:function(id){
		var i;
		for(i=0;i<this._masterObj.columns.length;i++){
			if( this._masterObj.columns[i].id==id) return this._masterObj.columns[i];
		}
		return null;
	},
	timeoutRefresh:function(){
		$("timeoutBox").style.visibility = 'hidden';
		dwr.engine.abortAll();
	    oc._toggleButtons(false);
		this.doRefresh();
	},
	timeoutWait:function(){
		$("timeoutBox").style.visibility = 'hidden';
	},	
	doNewObject:function(){
		var url="/html/nds/object/object.jsp?input=true&table=" +
			this._masterObj.table.id+ "&id=-1";
		window.location=url;
    },
    doShowObject:function(tableId, objectId){
		var url="/html/nds/object/object.jsp?input=true&table=" +tableId+ "&id=" + this._masterObj.hiddenInputs.id;
		window.location=url;
    },
    doSelectView:function(viewIdString){
    	var url= "/html/nds/objext/selectview.jsp?table=" +viewIdString + "&id=" + this._masterObj.hiddenInputs.id;
    	window.location=url;
    },
    doCopyTo:function(){
    	var url="/html/nds/objext/copyto.jsp?src_table="+ this._masterObj.hiddenInputs.table+
		"&dest_table=-1&fixedcolumns="+ this._masterObj.hiddenInputs.fixedcolumns+
		"&objectids="+this._masterObj.hiddenInputs.id;
		window.location=url;
    },
    doPrintSetting:function(){
		var url="/html/nds/print/options.jsp?table=" + 
			this._masterObj.hiddenInputs.table + "&id=" + this._masterObj.hiddenInputs.id;
	    window.location=url;
    },
	/**
	@param e either string for file or object from server containing printfile attribute
	*/
	_onPrintJasper:function(e){
		//console.log(e);
		var pf;
		if(typeof(e)=="string") pf=e;
		else
			pf=e.getUserData().data.printfile;
		var f="/servlets/binserv/GetFile?filename="+encodeURIComponent(pf)+"&del=Y";
		var ifm=window.print_iframe;
		var disabledZone=$('disabledZone');
		if(disabledZone)disabledZone.style.visibility = 'visible';
		if(Prototype.Browser.IE){
			/*$("print_iframe").onreadystatechange=function () {
    	   		if(this.readyState=="complete"){
					if(disabledZone)disabledZone.style.visibility = 'hidden';
        	   		ifm.focus();
        	   		ifm.print();
    	   			if(oc._closeWindow) {
    	   				alert(gMessageHolder.CLOSE_AFTER_PRINT);
    	   				oc._closeWindowOrShowMessage(null);
    	   			}
    	   		}
     		};*/
			if(disabledZone)disabledZone.style.visibility = 'hidden';
			if(oc._closeWindow) {
				window.location.href=f;
			}else{
				popup_window(f);	
			}
		}else{
			$("print_iframe").onload=function () {
				//firefox will call onload before pdf is loaded completely, so we wait here
 				setTimeout('oc.waitOneMomentToPrint()', 1000);
     		};	
			ifm.location.href= f;
		}

	},   
	waitOneMomentToPrint:function(){
		if($('disabledZone'))$('disabledZone').style.visibility = 'hidden';
   		window.print_iframe.focus();
   		window.print_iframe.print();
   		//console.log("waitOneMomentToPrint:"+ oc._closeWindow);
   		if(oc._closeWindow) {
   			alert(gMessageHolder.CLOSE_AFTER_PRINT);
   			oc._closeWindowOrShowMessage(null);
   		}
	}, 
    doPrint:function(){
    	var evt={};
		evt.tag="Print";
		evt.command="PrintJasper";
		evt.callbackEvent="PrintJasper";
		evt.params={"table":this._masterObj.hiddenInputs.table,"id":this._masterObj.hiddenInputs.id};	
		this._executeCommandEvent(evt);

    },
	doGoModifyPage:function(tableId, objectId, url){
		window.location=url;
	},
	doCreate:function(){
		this.saveAll();
    },
    doTemplate:function(){
    	window.location="/html/nds/objext/template.jsp?table="+ this._masterObj.hiddenInputs.table;
	},
	doRefresh:function(){
		window.location=this._url;
		//window.location.reload();
	},
	doModify:function(){
		this.saveAll();
    },
    doUnsubmit:function(bShouldWarn){
    	if(bShouldWarn){
    		if (!confirm(gMessageHolder.DO_YOU_CONFIRM_UNSUBMIT)) {
            	return false;
        	}
    	}
    	var evt=$H();
		evt.command=this._masterObj.table.name+"Unsubmit";
		evt.parsejson="Y";
		evt.callbackEvent="UnsubmitObject";
		evt.merge(this._masterObj.hiddenInputs);
		this._executeCommandEvent(evt);
    },
    doSubmitPrint:function(bSaveFirst,bShouldWarn){
    	if(bShouldWarn){
    		if (!confirm(gMessageHolder.DO_YOU_CONFIRM_SUBMIT)) {
            	return false;
        	}
    	}
    	var evt=$H();
		evt.printAfterSubmit="Y"; // submit then print
		if(bSaveFirst){
			if(this._checkObjectInputs()==false){
		       	return;
	    	}
			evt.command="ProcessObject";
			evt["nds.control.ejb.UserTransaction"]="N";//each line will have a seperate transaction
			evt.submitAfterSave="Y"; // then submit
			if(gc!=undefined)gc.fillProcessEvent(evt); // grid control
			// hash type
			evt.masterobj=$H(Form.serializeElements( this._getInputs("obj_inputs_1"),true));
			var addtionalInputs=$("obj_inputs_2");
			if(addtionalInputs!=null){
				evt.masterobj.merge(Form.serializeElements( this._getInputs(addtionalInputs),true));
			}
			evt.masterobj.merge(this._masterObj.hiddenInputs);
			evt.callbackEvent="SubmitObject";
			this._executeCommandEvent(evt);
		}else{
			evt.command=this._masterObj.table.name+"Submit";
			evt.parsejson="Y";
			evt.callbackEvent="SubmitObject";
			evt.merge(this._masterObj.hiddenInputs);
			this._executeCommandEvent(evt);
		}
    },
    doSubmit:function(bSaveFirst,bShouldWarn){
    	if(bShouldWarn){
    		if (!confirm(gMessageHolder.DO_YOU_CONFIRM_SUBMIT)) {
            	return false;
        	}
    	}
    	var evt=$H();
		if(bSaveFirst){
			if(this._checkObjectInputs()==false){
		       	return;
	    	}
			evt.command="ProcessObject";
			evt["nds.control.ejb.UserTransaction"]="N";//each line will have a seperate transaction
			evt.submitAfterSave="Y"; // then submit
			if(gc!=undefined)gc.fillProcessEvent(evt); // grid control
			// hash type
			evt.masterobj=$H(Form.serializeElements( this._getInputs("obj_inputs_1"),true));
			var addtionalInputs=$("obj_inputs_2");
			if(addtionalInputs!=null){
				evt.masterobj.merge(Form.serializeElements( this._getInputs(addtionalInputs),true));
			}
			evt.masterobj.merge(this._masterObj.hiddenInputs);
			evt.callbackEvent="SubmitObject";
			this._executeCommandEvent(evt);
		}else{
			evt.command=this._masterObj.table.name+"Submit";
			evt.parsejson="Y";
			evt.callbackEvent="SubmitObject";
			evt.merge(this._masterObj.hiddenInputs);
			this._executeCommandEvent(evt);
		}
    },
	
	doDelete:function(){
    	if (!confirm(gMessageHolder.DO_YOU_CONFIRM_DELETE+" "+ this._masterObj.table.description+"?")) {
            return false;
        }
		var evt=$H();
		evt.command=this._masterObj.table.name+"Delete";
		evt.parsejson="Y";
		evt.callbackEvent="DeleteObject";
		evt.merge(this._masterObj.hiddenInputs);
		this._executeCommandEvent(evt);
    },
    _onSubmitObject:function(e){
    	//console.log(e);
		var r=e.getUserData(); 
		if(r.code!=0){
			this._showMessage(r.message,true);
		}else{
			if(r.data!=null && r.data.printfile!=null){
				msgbox(r.message);
				this._closeWindow=true;
				this._onPrintJasper(r.data.printfile);
			}else
				this._closeWindowOrShowMessage(r.message);
		}
    },
    _onDeleteObject:function(e){
		var r=e.getUserData(); 
		if(r.code!=0){
			this._showMessage(r.message,true);
		}else{
			this._closeWindowOrShowMessage(r.message);
		}
    },
    
    _closeWindowOrShowMessage:function(msg){
		var isclosed=false;
    	var w = window.opener;
    	if(w==undefined)w= window.parent;
    	if (w ){
			var iframe=w.document.getElementById("popup-iframe-0");
			if(iframe){
	    		w.setTimeout("Alerts.killAlert(document.getElementById('popup-iframe-0'))",1);
				if(msg!=null)msgbox(msg);
	    		isclosed=true;
    		}
    	}
    	if(!isclosed){
			var body = document.getElementsByTagName("body")[0];
			if(msg==null)msg="";
			body.innerHTML="<div class='returnmsg'>"+msg+"</div>";
			window.close();
    	}
    },
	/**
	 * Includes input and textarea of parent element
	 */
	_getInputs:function(form){
	    form = $(form);
	    var inputs = $A(form.getElementsByTagName('input'));
		inputs=inputs.concat($A(form.getElementsByTagName('textarea')));
		inputs=inputs.concat($A(form.getElementsByTagName('select')));
	    return inputs.map(Element.extend);
	},
	/**
	* Save objects,  create update command and execute
	* only checked lines will be saved
	* @param bIsNew if is new, will callback SaveObjectNew, else SaveObject
	*/
	saveAll : function () {
		this._toggleButtons(true);		
		if(this._checkObjectInputs()==false){
			this._toggleButtons(false);		

	       	return;
    	}
		var inlineObjInputs=$("inline-obj-inputs");
		if(inlineObjInputs!=null){
			if(this._checkInlineObjectInputs()==false){
				this._toggleButtons(false);		
	       		return;
    		}
		}
		var evt={};
		evt.command="ProcessObject";
		evt["nds.control.ejb.UserTransaction"]="N";//each line will have a seperate transaction
		if(gc!=undefined && !gc.isDestroied() )gc.fillProcessEvent(evt); // grid control
		// hash type
		evt.masterobj=$H(Form.serializeElements( this._getInputs("obj_inputs_1"),true));
		// special treatment on clob type column
		evt.masterobj.merge(this._loadClobs());
		
		var addtionalInputs=$("obj_inputs_2");
		if(addtionalInputs!=null){
			evt.masterobj.merge(Form.serializeElements( this._getInputs(addtionalInputs),true));
		}
		evt.masterobj.merge(this._masterObj.hiddenInputs);
		if(inlineObjInputs!=null){
			evt.inlineobj=$H(Form.serializeElements( this._getInputs("inline-obj-inputs"),true));
			evt.inlineobj.merge(inlineObject.hiddenInputs);
		}
		evt.callbackEvent="SaveObject"+(evt.masterobj.id==-1?"New":"");
		this._executeCommandEvent(evt);
	},
	/**
	 * Load clob objects
	 * @return Hash object
	 */
	_loadClobs:function(){
		var clobs={};
		
		var cols= this._masterObj.columns;
		for(var i=0;i<cols.length;i++){
			var col= cols[i];
			if(col.displaySetting=="clob"){
				var oEditor = FCKeditorAPI.GetInstance("column_"+ col.id) ;
				if(oEditor!=null){
					clobs[col.name.toLowerCase()] = oEditor.GetHTML();
				}
			}
		}		
		return clobs;
	},
	_toggleButtons:function(disable){
		var es=$("buttons").getElementsBySelector("input[type='button']");
		if(disable){
			for(var i=0;i< es.length;i++){
				es[i].disable();
			}
		}else{
			for(var i=0;i< es.length;i++){
				es[i].enable();
			}
		}
	},	
	/**
	* Request server handle command event
	* @param evt CommandEvent
	*/
	_executeCommandEvent :function (evt) {
		//showProgressWindow(true);
		
		Controller.handle( Object.toJSON(evt), function(r){
				//try{
					$("timeoutBox").style.visibility = 'hidden';
					oc._toggleButtons(false);
					var result= r.evalJSON();
					if (result.code !=0 ){
						msgbox(result.message);
					}else {
						var evt=new BiEvent(result.callbackEvent);
						evt.setUserData(result);
						application.dispatchEvent(evt);
					}
				/*}catch(ex){
					msgbox(ex.message);
				}*/
			
		});
	},
	_checkInlineObjectInputs: function(){
		var cols=inlineObject.columns,i,col, d;
		var maskPos= inlineObject.hiddenInputs.id==-1?1:3;
		var blank,ele,d;
		for(i=0;i< cols.length;i++){
			col= cols[i];
			if(col.mask.substr(maskPos,1)==1){
				ele=$("column_"+ col.id);
				if(ele==null )continue;
				if(!ele.disabled && this._checkInput(col,ele)==false) return false;
			}
		}
		return true;	
	},
	/**
	 * @return false if object panel contains invalid data
	 */
	_checkObjectInputs: function(){
		var cols=this._masterObj.columns,i,col, d;
		var maskPos= this._masterObj.hiddenInputs.id==-1?1:3;
		var blank,ele,d;
		for(i=0;i< cols.length;i++){
			col= cols[i];
			if(col.mask.substr(maskPos,1)==1){
				ele=$("column_"+ col.id);
				if(ele==null )continue;
				if(!ele.disabled && this._checkInput(col,ele)==false) return false;
			}
		}
		return true;	
	},
	/**
	 * @param col GridColumn
	 * @param ele Element for input
	 * @return false if contains invalid data
	 */
	_checkInput: function(col,ele){
		var d=String(dwr.util.getValue( ele));
		var blank=(String(d)).blank();
		if(!col.isNullable &&  (blank || (col.isValueLimited && d=="0") )){
			msgbox( col.description+ gMessageHolder.CAN_NOT_BE_NULL);
			dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
			return false;
		}
		if(!col.isValueLimited && !blank ){
			if(col.refColumnId!=-1) col= col.refTableAK;
			if(col.type==Column.NUMBER && isNaN(d,10)){
				msgbox( col.description+ gMessageHolder.MUST_BE_NUMBER_TYPE);
				dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
				return false;
			}else if((col.type==Column.DATE || col.type==Column.DATENUMBER) && !isValidDate(d) ){
				msgbox( col.description+ gMessageHolder.MUST_BE_DATE_TYPE);
				dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
				return false;
			}
		}
		return true;
	},
	_showMessage:function(msg, bError){
		if(msg==null ||(String(msg)).blank() ){
			$("message").style.visibility="hidden";
		}else{
			if(bError){
				msg="<div class='err-msg'>"+msg+"</div>";
			}else{
				msg="<div class='info-msg'>"+msg+"</div>";
			}
			$("message_txt").innerHTML=msg+"<div class='ptime'>"+this._currentTime()+"</div>";
			$("message").style.visibility="visible";
		}
	},
	/**
	 * @return string contains date infomration
	 */
	_currentTime:function(){
		var d=new Date();
		return d.getHours()+":"+d.getMinutes()+":"+d.getSeconds();
	},
	/**
	 * try close window
	 */
	_checkShouldClose:function(e){
		var r=e.getUserData().data; 
		if(r.closewindow){
			this._closeWindowOrShowMessage(r.message);
			return true;
		}else{
			return false;
		}
	},
	/**
	 * Current object id
	 */
	getObjectId:function(){
		return this._masterObj.hiddenInputs.id;
	},
	_onSaveObjectNew:function(e){
		if(this._checkShouldClose(e)) return;
		var n=e.getUserData().data.nextscreen;
		if(!n){
			// grid found error
			// reconstruct fixedcolumns and refresh url
			this._masterObj.hiddenInputs.fixedcolumns=e.getUserData().data.fixecolumnstr;
			if(gc!=undefined  && !gc.isDestroied()){
				gc.updateFixedColumns( e.getUserData().data.fixecolumnstr,
					e.getUserData().data.fixecolumns.toJSON());
			}
			this._url= e.getUserData().data.url;
			this._onSaveObject(e);
		}else{
			window.location=e.getUserData().data.nextscreen;
		}
	},
	/**
	 * Contains both master object information and detail object information
	 * @param r data set by nds.control.ejb.command.ProcessObject
	 */
	_onSaveObject : function (e) {
		if(this._checkShouldClose(e)) return;
		// detal objects
		if(gc!=undefined  && !gc.isDestroied())gc.updateGrid(e);
		// master object
		var r=e.getUserData().data; 
		this._masterObj.hiddenInputs.id=r.masterid;
		//try{
		var te=r.masterpage;
		var p= te.indexOf("<!--BUTTONS_BEGIN-->");
		var pe= te.indexOf("<!--BUTTONS_END-->");
		if(p>0 && pe>p){
			$("buttons").innerHTML=te.substring(p+ "<!--BUTTONS_BEGIN-->".length,pe);
		}	
		p= te.indexOf("<!--OBJ_INPUTS1_BEGIN-->");
		pe= te.indexOf("<!--OBJ_INPUTS1_END-->");
		if(p>0 && pe>p)
			$("obj_inputs_1").innerHTML=te.substring(p+ "<!--OBJ_INPUTS1_BEGIN-->".length,pe);

		p= te.indexOf("<!--OBJ_INPUTS2_BEGIN-->");
		pe= te.indexOf("<!--OBJ_INPUTS2_END-->");
		var inputs2=$("obj_inputs_2");
		if(inputs2!=null){
			if(p>0 && pe>p)
				$("obj_inputs_2").innerHTML=te.substring(p+ "<!--OBJ_INPUTS2_BEGIN-->".length,pe);
		}
		try{executeLoadedScript($("buttons"));}catch(ex){alert("buttons:exception:"+e);}
		try{
			executeLoadedScript($("obj_inputs_1"));
		}catch(ex){alert("obj_inputs_1:exception:"+e);}
		try{
			if(inputs2!=null)executeLoadedScript($("obj_inputs_2"));
		}catch(ex){alert("obj_inputs_2:exception:"+e);}

		// load inline object if current tab is that type
		if(inlineObject!=null){
			var t= jQuery('#tabs > ul');
			if(t!=null){
				t.tabs("select", t.data('selected.ui-tabs') );
			}
		}
/*		}catch(e){
			alert(e);
		}*/
		var msg=e.getUserData().message;
		this._showMessage(msg);
	},
	/**
	 * On key press on FK column, will remove hidden input "fk_"+inputId
	 */
	onKeyPress:function(event){
	  var e=$(Event.element(event));
	  if(e.id){
	  	e=$("fk_"+e.id);
	  	if(e!=null && e.value)e.value="";
	  }
	},
	/**
	 * @return false if failed to close
	 */
	closeDialog:function(){
		var w = window.opener;
		if(w==undefined)w= window.parent;
		if (w ){
			var iframe=w.document.getElementById("popup-iframe-0");
			if(iframe){
	    		w.setTimeout("Alerts.killAlert(document.getElementById('popup-iframe-0'));",1);
	    		return true;
			}
		}
		return false;
	},
	_tryAddCloseButton:function(){
		var w = window.opener;
		if(w==undefined)w= window.parent;
		var bCloseBtn=false;
		if (w ){
			var iframe=w.document.getElementById("popup-iframe-0");
			if(iframe){
				$("closebtn").innerHTML="<input class='cbutton' type='button' value='"+ gMessageHolder.CLOSE_DIALOG+
					"(C)' accessKey='C' onclick='oc.closeDialog()' name='Close'>";
				bCloseBtn=true;	
			}
		}
		if(!bCloseBtn){
			if(self==top){
				$("closebtn").innerHTML="<input type='button' class='cbutton' value='"+ gMessageHolder.CLOSE_DIALOG+
					"(C)' accessKey='C' onclick='window.close()' name='Close'>";
			}
		}
	},
	isempty:function(column_acc_Id,fk_column_acc_Id){
			if($(column_acc_Id).value==""){
		 		$(fk_column_acc_Id).value="";
			}
	},
	audit:function(audittype,objectId){
		var evt={};
		evt.command="ExecuteAudit";
		evt.callbackEvent="ExecuteAudit";
		evt.auditAction=audittype;
		evt.parsejson="Y";
		var iids=new Array();
		iids[0]=objectId;
		evt.itemid=iids;
		evt.comments=$("comments").value;
		this._executeCommandEvent(evt);
	},	
	_onExecuteAudit:function(e){
		var r=e.getUserData(); 
		if(r.message){
			msgbox(r.message.replace(/<br>/g,"\n"));
		}
		  this.closeDialog();
	},
	_tryUpdateTitle:function(){
		var w = window.opener;
		if(w==undefined)w= window.parent;
		if (w ){
			var te=w.document.getElementById("pop-up-title-0");
			if(te){
				te.innerHTML=masterObject.table.description;//+" ";
			}
		}
	}
};
// define static main method
ObjectControl.main = function () {
	try{
	oc=new ObjectControl();
	}catch(e){}
};
/**
* Init
*/
jQuery(document).ready(ObjectControl.main); 
/*
if (window.addEventListener) {
  window.addEventListener("load", ObjectControl.main, false);
}
else if (window.attachEvent) {
  window.attachEvent("onload", ObjectControl.main);
}
else {
  window.onload = ObjectControl.main;
}*/
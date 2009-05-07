/*var log = log4javascript.getLogger("main"); 
var popUpAppender = new log4javascript.PopUpAppender();
log.addAppender(popUpAppender);
var lastDebugTime=(new Date()).getTime();
* 
function logdebug(s){
	var d=new Date();
	log.debug("["+d.getSeconds()+":"+ d.getMilliseconds()+"] "+ s + "("+ (d.getTime()-lastDebugTime)+")");
	lastDebugTime=d.getTime();
}*/
 
var gc=null;
var GridControl = Class.create();
// define
GridControl.prototype = {
	isDestroied:function(){
		return this._isDestroied;
	},
	destroy:function(){
		application.removeEventListener("RefreshGrid", this._refreshGrid, this);
		application.removeEventListener( "UpdateGrid", this.updateGrid, this);
		application.removeEventListener( "CheckProductAttribute", this._checkProductAttribute, this);
		application.removeEventListener( "ShowProductAttribute", this._showProductAttribute, this);
		this._isDestroied=true;
	},
	initialize: function() {
		this._isDestroied=false;
		this._isDirty=false;
		this._objpage="/html/nds/object/object.jsp";
		this._currentNewRowId=1;
		this._currentRow= -1;// which row index is editing, start from 0, -1 means a new line
		this._data=null; // table data, first column is rowIdx
		var initObj=new GridInitObject();
		this._fixedColumns= initObj.getFixedColumns();// key: column id, value: fixed data
		this._fixedColumnsStr= initObj.getFixedColumnsStr(); // string for upload to server
		this._tableActions= initObj.getTableActions();// table actions AMDS
		this._supportAttributeDetail = initObj.supportAttributeDetail();// table support 
		this._gridQuery= initObj.getGridQueryObj();
		this._inlineMode= initObj.getInlineMode();
		var metaObj=new EditableGridMetadata(initObj.getGridMetadata());
		this._gridMetadata= metaObj;
		this._tmpData=null;
		this.MAX_INPUT_LENGTH=1000;// this is used for selection range
		this._gridTable= null;// @see _initTable
		// init dwr
		dwr.util.useLoadingMessage(gMessageHolder.LOADING);
		dwr.util.setEscapeHtml(false);
		/** A function to call if something fails. */
		/*dwr.engine._errorHandler =  function(message, ex) {
	  		while(ex!=null && ex.cause!=null) ex=ex.cause;
	  		if(ex!=null)message=ex.message;// dwr.engine._debug("Error: " + ex.name + ", " + ex.message+","+ ex.cause.message, true);
			if (message == null || message == "") msgbox("A server error has occured. More information may be available in the console.");
	  		else if (message.indexOf("0x80040111") != -1) dwr.engine._debug(message);
	  		else msgbox(message);
		};*/
		application.addEventListener( "RefreshGrid", this._refreshGrid, this);
		application.addEventListener( "UpdateGrid", this.updateGrid, this);
		application.addEventListener( "CheckProductAttribute", this._checkProductAttribute, this);
		application.addEventListener( "ShowProductAttribute", this._showProductAttribute, this);
		
		// call _initGrid when recieved data
		var q=Object.clone(this._gridQuery);
		q.callbackEvent="RefreshGrid";
		this._executeQuery(q);
		this.newLine(false);
		if(this._inlineMode=="Y"){
			this._toggleEditableFields(true);
		}
		this._initTable();
	},
	/**
	 When in table with single child, the child (grid) will be loaded the same time with parent
	 yet fixed columns must be updated when parent gets id from server.
	*/
	updateFixedColumns:function(fcStr, fcObj){
		this._fixedColumns=fcObj;// key: column id, value: fixed data
		this._fixedColumnsStr= fcStr;
		this._gridQuery.fixedcolumns=fcStr;
	},
	/**
	 * Get column by id in _gridMetadata object, return null if not found
	 * column properties:
	 * 	@see nds.control.util.GridColumn.toJSONObject()
	 */
	getColumnById:function(id){
		var i;
		for(i=0;i<this._gridMetadata.columns.length;i++){
			if( this._gridMetadata.columns[i].columnId==id) return this._gridMetadata.columns[i];
		}
		return null;
	},
	setObjectPage:function(url){
		this._objpage=url;
	},
	_syncGridControl:function(qr){
		this._gridQuery.totalRowCount=qr.totalRowCount;
		this._gridQuery.start=qr.start;
		//this._gridQuery.range=qr.range;
		//dwr.util.setValue("range_select", qr.range);
		if( this._gridQuery.order_columns!=null){
			var ele=$("title_"+this._gridQuery.order_columns);
			if(ele!=null){
				ele.innerHTML="<img src='/html/nds/images/"+( this._gridQuery.order_asc?"up":"down")+"simple.png'>";
			}
		}
		if($("txtRange")!=null){
			$("txtRange").innerHTML=((qr.start+1)+"-"+ (qr.start+qr.rowCount)+"/"+ qr.totalRowCount);
			if(qr.start>0){
				 $("begin_btn").setEnabled(true);
				 $("prev_btn").setEnabled(true);
			}else{
				 $("begin_btn").setEnabled(false);
				 $("prev_btn").setEnabled(false);
			}
			if((qr.start+qr.rowCount)< qr.totalRowCount){
				 $("next_btn").setEnabled(true);
				 $("end_btn").setEnabled(true);
			}else{
				 $("next_btn").setEnabled(false);
				 $("end_btn").setEnabled(false);
			}
		}
	},
	/**
	 * mark all check box checked
	 */
	selectAll:function(){
		var i;
		var b= dwr.util.getValue($("chk_select_all"));
		for(i=0;i< this._data.length;i++){
			if(["D","E","N"].indexOf(this._data[i][1])>-1) continue;
			 dwr.util.setValue($(this._data[i][0]+"_chk"), b);
		}
	},
	/**
	 * do quick search according to input
	 */
	quickSearch: function(){
		if(this.checkNew()) return;
		if(this.checkDirty()==false){
			this._gridQuery.quick_search_data= dwr.util.getValue("quick_search_data");
			this._gridQuery.quick_search_column= dwr.util.getValue("quick_search_column");
			this._gridQuery.start=0;
			this._executeQuery(this._gridQuery);
		}
	},	
	/**
	 * Open current row in new window
	 */
	openLineInNewWindow :function(bCheckSelected){
		if(!this._gridMetadata.popupitem){
			msgbox(gMessageHolder.NOT_ALLOW_TO_POPUP_AS_NOT_MENUOBJ);
			return; // FOR AU_PHASE TYPE
		}
		if(bCheckSelected==undefined)bCheckSelected=false;
		if(bCheckSelected){
			this._currentRow=this._getSelectedRow();
			if(this._currentRow==-1){
				msgbox(gMessageHolder.PLEASE_CHECK_SELECTED_LINES);
				return;
			}
		}
		if(this._currentRow==-1){
			popup_window(this._objpage+"?"+ (new GridInitObject()).getLineCreationLink());
		}else{
			popup_window((new GridInitObject()).getLinePage()+this._data[this._currentRow][4]);
		}
	},
	/**
	Note this function will be called by objcontrol.js
	@param evt the evt object to fill
	@return boolean whether there's data to handle or not
	*/
	fillProcessEvent:function(evt){
		var meta=this._gridMetadata;
		var i; 
		evt.column_masks=meta.column_masks;
		evt.table=meta.table;
		evt.fixedColumns= this._fixedColumnsStr;
		evt.bestEffort=true;//each line will have a seperate transaction
		evt.addList=[];
		evt.modifyList=[];
		evt.deleteList=[];
		var hasData=false;
		for(i=0;i< this._data.length;i++){
			var line= this._data[i];
			//if( dwr.util.getValue($(line[0] +"_chk"))==true ){
				switch(line[1]){
					case "A": 
						// add
						evt.addList.push(this._getArrayOfRow(i, line, meta.columnsWhenCreate));
						hasData=true;
						break;
					case "M":
						// modify
						evt.modifyList.push(this._getArrayOfRow(i,line, meta.columnsWhenModify));
						hasData=true;
						break;
					case "D":
						evt.deleteList.push(this._getArrayOfRow(i,line, meta.columnsWhenDelete));
						hasData=true;
						break;
					default:
				}
			//}
		}
		
		evt.queryRequest=this._gridQuery;	
		return hasData;	
	},
	/**
	* Save objects,  create update command and execute
	* only checked lines will be saved
	*/
	saveAll : function () {
		var evt={};
		evt.command="UpdateGridData";
		evt.callbackEvent="UpdateGrid";
		var hasData=this.fillProcessEvent(evt);
		if(!hasData){
			msgbox(gMessageHolder.NO_DATA_TO_PROCESS);
			return;
		}
		this._executeCommandEvent(evt);
	},
	/**
	 * @return -1 or first selected line
	 */
	_getSelectedRow:function(){
		var i,d=-1;
		for(i=0; i<this._data.length;i++){
			var line= this._data[i];
			if( dwr.util.getValue($(line[0]+"_chk"))==true){
				d=i;
				break;
			}
		}
		return d;
	},

	/**
	* Mark selected rows in grid as delete, will save when SaveAll
	*/
	deleteSelected:function(){
		var i,d;
		for(i=this._data.length-1;i>-1 ;i--){
			var line= this._data[i];
			if( dwr.util.getValue($(line[0]+"_chk"))==true){
				d=line[1];
				if("A"==d){
					$( line[0]+"_templaterow" ).remove();
					this._data.splice(i,1);
					/*line[1]="E";
					this._updateGridLineState(line);*/
				}else if(["M","S"].indexOf(d)>-1 ){
					line[1]="D";
					this._updateGridLineState(line);
					this._isDirty=true;
					if(this._currentRow==i){
						this.newLine(false);	
					}
				}
			}
		}
	},
	/**
	 * @return false if discard modification or not dirty
	 */
	checkDirty: function(){
		if(this._isDirty){
        	return !confirm(gMessageHolder.CONFIRM_DISCARD_CHANGE) ;
		}
		return false;
	},
	/**
	 * @return false if current page is new master object
	 */
	checkNew:function(){
		if(oc!=undefined && oc.getObjectId()==-1){
        	alert(gMessageHolder.DENY_AS_NEW_OBJ);
        	return true;
		}
		return false;
	},
	/**
	* export 
	*/
	exportGrid:function(){
		if(this.checkDirty()) return;
		if(this.checkNew()) return;
		showProgressWindow(true);
		var s= Object.toJSON(this._gridQuery);
		var fm= $("export_form");
		$("resulthandler").value=NDS_PATH+"/reports/create_report.jsp";
		$("query_json").value=s;
		fm.submit();
	},
	importGrid:function(){
		if(this.checkDirty()) return;
		if(this.checkNew()) return;
		window.location=("/html/nds/objext/import_excel.jsp?table="+this._gridMetadata.table+"&fixedcolumns="+encodeURIComponent(this._fixedColumnsStr));
	},
	analyzeGrid:function(){
		showProgressWindow(true);
		var s= Object.toJSON(this._gridQuery);
		var fm= $("export_form");
		$("resulthandler").value=NDS_PATH+"/cxtab/quickview.jsp"; 
		$("query_json").value=s;
		fm.submit();
	},
	/**
	* create query request and execute query
	*/
	refreshGrid : function () {
		//if(this.checkNew()) return;
		if(this.checkDirty()==false)
			this._executeQuery(this._gridQuery);
	},


	/**
	* Construct an array which contains only part of array cells, the
	  part is specified by indices
	  @param dataRow row of data
	* @param line one row in this._data
	* @param indices int[] meta.getCreationColumns() or meta.getModifyColumns()
	* @return Array object, which elements from columns of grid
	*  specified by indices
	*/
	_getArrayOfRow: function (dataRow , line, indices) {
		var i,v;
		var obj=new Array();
		obj.push(dataRow);
		for(i=0;i<indices.length;i++){
			v=line[indices[i]];
			if(v==undefined) v=null;
			obj.push(v);
		}
		//debug(obj);
		return obj;
	},
	/***
	* Invoke by buttons, include btn_begin,btn_next,btn_prev,btn_end
	@param t id of the button
	*/
	scrollPage: function (t) {
		//var t=event.target.id;
		if(this.checkDirty()) return;
		if(this.checkNew()) return;
		
		var s;
		var qr=Object.clone(this._gridQuery);
		var qs=qr.start;
		var qrange=parseInt( $("range_select").value,10);
		var qtot=qr.totalRowCount;
		if(t=="begin_btn")s=0;
		else if(t=="prev_btn") s= qs-qrange;
		else if(t=="next_btn") s= qs+qrange;
		else if(t=="end_btn") s= qtot-qrange;
		else s= qs;
		
		qr.start=s;
		qr.range=qrange;
		this._gridQuery.range=qrange;
		this._executeQuery(qr);
	},
	/**
	 * Reorder grid query
	 * @param columnId the column id that will be ordered by, if the same as old
	 * order by column, will toggle asc and desc, else do asc 
	 */
	orderGrid: function(columnId){
		if(this.checkNew()) return;
		if(this.checkDirty()==false){
			var oldOrderBy=this._gridQuery.order_columns;
			var oldAsc=this._gridQuery.order_asc;
			if(oldOrderBy==columnId ){
				this._gridQuery.order_asc=!oldAsc;
			}else{
				var ele=$("title_"+oldOrderBy);
				if(ele!=null)ele.innerHTML="";
				this._gridQuery.order_columns=columnId;
				this._gridQuery.order_asc=true;
			}		
			this._executeQuery(this._gridQuery);
		}
	},

	_executeQuery : function (queryObj) {
		var s= Object.toJSON(queryObj);
		Controller.query(s, function(r){
				//try{
					$("timeoutBox").style.visibility = 'hidden';
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
		  	}		
		);
	},
	/**
	* Request server handle command event
	* @param evt CommandEvent
	*/
	_executeCommandEvent :function (evt) {
		showProgressWindow(true);
		Controller.handle( Object.toJSON(evt), function(r){
				//try{
					$("timeoutBox").style.visibility = 'hidden';
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
	
	/**
	 * @return false if object panel contains invalid data
	 */
	_checkObjectInput: function(){
		var cols=this._gridMetadata.columns,i,col, d;
		var blank,ele,d;
		for(i=4;i< cols.length;i++){
			col= cols[i];
			if(col.isVisible && ( this._currentRow==-1? col.isUploadWhenCreate:col.isUploadWhenModify )){
				ele=$("eo_"+ col.name);
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
	/**
	 * Check line validity, call product attribute form if nessisary and store to grid
	 * @param can has one argument for current event
	 */
	saveLine:function(){
		if( this._tableActions.indexOf("A")<0 && this._currentRow==-1 ){
			msgbox(gMessageHolder.NO_PERMISSION);
			return;
		}
		if( this._tableActions.indexOf("M")<0 && this._currentRow>-1 ){
			msgbox(gMessageHolder.NO_PERMISSION);
			return;
		}
		var e=null;
		if( arguments.length==0 ) e=window.event;
		else e= arguments[0];
		if(e!=null) e = e.target != null ? e.target : e.srcElement;
		// check input validity
		if(this._checkObjectInput()==false) return;
		var chkProductAttribute=$("check_product_attribute");
		if(chkProductAttribute){
			var pdtValue=String($("eo_"+chkProductAttribute.value).value);
			if(chkProductAttribute!=null && chkProductAttribute.checked && !pdtValue.blank() 
					&& ( $("eo_"+chkProductAttribute.name)==null || 
					( $("eo_"+chkProductAttribute.name)!=null&& String($("eo_"+chkProductAttribute.name).value).blank() ) )
				){
				// check matrix first
				var evt={};
				evt.command="CheckProductAttribute";
				evt.callbackEvent="CheckProductAttribute";
				evt.product=pdtValue;
				evt.fixedColumns=this._fixedColumns;
				evt.tableId=this._gridMetadata.tableId;
				if(this._currentRow!=-1 && this._data[this._currentRow][1]!="A") evt.trymatrix=false;
				this._executeCommandEvent(evt);
			}else{
				this._saveLineToGrid(null,e);
			}	
		}else{
			this._saveLineToGrid(null,e);
		}
	},
	/**Copied from dwr.util.onReturn, I need event be transfered 
	 * Enables you to react to return being pressed in an input
	 */
	onLineReturn : function(event, action) {
	  if (!event) event = window.event;
	  if (event && event.keyCode && event.keyCode == 13) action(event);
	},
	/**
	 * Convert enter to tab key
	 * @param event key event
	 * @param nextInputId next input id, so when enter pressed, go to next input
	 * @return false to cancel that key
	 */
	onMatrixKey: function(event, nextInputId){
		if(event.keyCode==13){
			if(event.ctrlKey||event.altKey || event.shiftKey){
				gc.saveItemDetail();
				return true;
			}else{
				var ne=$(nextInputId);
				if(ne!=null) {
					ne.focus();
					dwr.util.selectRange(ne, 0, this.MAX_INPUT_LENGTH);
				}
				return false;
			}
		}else if( event.keyCode==27) Alerts.killAlert($("itemdetail_div"));
		return true;		
	},
	/**
	* Clear item detail inputs 
	*
	*/
	clearItemDetailInputs:function(){
		var eles=$("itemdetail_form").getInputs("text");
		for(i=0;i<eles.length;i++){
			ele=eles[i];
			dwr.util.setValue(ele, "");
		}		
	},
	/**	*  Save itemdetail_form inputs, this is matrix
	*  json format [[attribute1, value1],[attribute2, value2],..], array of array of 2 elements pair
	   attribute set instance id will have id as "A"+id, value should be number for all
	*/
	saveItemDetail:function(){
		var a=new Array(),i,ele,v,d;
		v=dwr.util.getValue("itemdetail_defaultvalue");
		var dfValue=0;
		var bNotCreateForNull= dwr.util.getValue("itemdetail_notnull");
		if(!v.blank() && !bNotCreateForNull){
			dfValue=parseInt(v,10);
			if(isNaN(dfValue)){
				msgbox(gMessageHolder.MUST_BE_NUMBER_TYPE);
				dwr.util.selectRange("itemdetail_defaultvalue", 0, this.MAX_INPUT_LENGTH);
				return;
			}
		}
		var asum=0;
		var eles=$("itemdetail_form").getInputs("text");
		for(i=0;i<eles.length;i++){
			ele=eles[i];
			if(String(ele.value).blank()) v= dfValue;
			else{
				v=parseInt(ele.value,10);
				if(isNaN(v)){
					msgbox(gMessageHolder.MUST_BE_NUMBER_TYPE);
					dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
					return;
				}
			}
			if(v!=0){
				a.push([ ele.id, v]); 
				asum+=v;
			}
		}
		//if(a.length==0) a="";
		Alerts.killAlert($("itemdetail_div"));
		var chkResult = this._tmpData;
		if(chkResult==null) chkResult={};
		chkResult.asi_objs=a;
		chkResult.asi_sum=asum;
		var chkProductAttribute=$("check_product_attribute");
		var pdt=$("eo_"+chkProductAttribute.value);
		this._saveLineToGrid(chkResult,pdt);
		this._tmpData=null;
	},
	/**
	 * Update line to grid, and wait for upload to server, if currentRow is -1, then a new row created
	 * else update data and grid line of that row
	 * 
	 * @param chkResult if not null will contain attributes:
		 * 		product_id: id of the product, set when code!=0
		 * 		product_name: name of the product, set when code!=0
		 * 		product_value: value of the product
		 * 		product_asi_id: attribute set instance id of the product
		 * 		product_asi_name: attribute set instance name of the product
		 * 		asi_objs: json object that contains attributeset instance selection and qty
		 *                like: [["A133",12],["A134",1]] first element is asi_id, second is qty
		 * 		asi_sum: total qty of asi selection, will replace input one
		 @param focusInput if not null, will set focus and select that input element
	 */
	_saveLineToGrid : function (chkResult, focusInput) {
		var line; // array
		var cols=this._gridMetadata.columns,i,col,v;
		// update asi_sum to first column that contains name "QTY"
		if(chkResult!=null && chkResult.asi_sum!=undefined){
			for(i=5;i<cols.length;i++){
				col=cols[i];
				if((col.isUploadWhenCreate || col.isUploadWhenModify) && col.name.indexOf("QTY")>=0 ){
					 dwr.util.setValue("eo_"+ col.name, chkResult.asi_sum);
					 break;
				}
			}
		}
		// add from line input
		if(this._currentRow==-1){
			line=["A"+this._getNextRowId(), "A",null,null,-1];
			for(i=5;i<cols.length;i++){
				col=cols[i];
				if(col.isUploadWhenCreate) v= this._getValue("eo_"+ col.name);
				else v=null;
				line.push(v);
			}
		}else{// existing row in grid, can also be a new line
			line= this._data[this._currentRow];
			if(line[4]!=-1) line[1]="M";
			line[2]=line[3]=null;
			for(i=5;i<cols.length;i++){
				col=cols[i];
				if( (line[4]==-1?col.isUploadWhenCreate:col.isUploadWhenModify)) line[i]= this._getValue("eo_"+ col.name);
				//else line[i]=null; remain unchanged
			}
		}
		if(chkResult!=null ){
			line[3]=chkResult.asi_objs;
			var ele=$("check_product_attribute");
			if (ele!=null && dwr.util.getValue(ele)==true){
			/*
				 * 		product_id: id of the product, set when code!=0
				 * 		product_name: name of the product, set when code!=0
				 * 		product_value: value of the product
				 * 		product_asi_id: attribute set instance id of the product
				 * 		product_asi_name: attribute set instance name of the product
			 */		
		 		if(chkResult.product_id!=null){
			 		i= this._getPositionInData("M_PRODUCT_ID__ID");
			 		if(i!=-1) line[i]= chkResult.product_id;
			 		i= this._getPositionInData("M_PRODUCT_ID__NAME");
			 		if(i!=-1) line[i]= chkResult.product_name;
			 		i= this._getPositionInData("M_PRODUCT_ID;VALUE");
			 		if(i!=-1) line[i]= chkResult.product_value;
			 		i= this._getPositionInData("M_ATTRIBUTESETINSTANCE_ID__ID");
			 		if(i!=-1) line[i]= chkResult.product_asi_id;
			 		i= this._getPositionInData("M_ATTRIBUTESETINSTANCE_ID__DESCRIPTION");
			 		if(i!=-1) line[i]= chkResult.product_asi_name;
			 		i= this._getPositionInData("M_PRODUCT_ID;PRICELIST");
			 		if(i!=-1) line[i]= chkResult.product_pricelist;
			 		i= this._getPositionInData("M_ATTRIBUTESETINSTANCE_ID;VALUE1");
			 		if(i!=-1) line[i]= chkResult.product_value1; 
			 		i= this._getPositionInData("M_ATTRIBUTESETINSTANCE_ID;VALUE2");
			 		if(i!=-1) line[i]= chkResult.product_value2;
		 		}
			}
		}
		// check line no for add/update action
		if(this._currentRow==-1){
			this._data.push(line);
	//		this._currentRow= this._data.length-1;
			this._insertGridLine(this._data.length-1,true);
			if( dwr.util.getValue("clear_after_insert")==true) this.newLine(false);
		}else{
			this._updateGridLine(this._currentRow);
		}
		// following line is to sync selection, but will lower down speed 
		//this._gridTable.clearSelection();
		//this._gridTable.setItemSelected($(line[0]+"_templaterow"), true);
		this._isDirty=true;
		if(focusInput!=null){
			dwr.util.selectRange(focusInput,0,this.MAX_INPUT_LENGTH);
		}
			
	} ,
	/**
	  @param colName column name in this._gridMetadata
	* @return column index in this._data, -1 if not found
	*/
	_getPositionInData : function(colName){
		var cols=this._gridMetadata.columns,i;
		for(i=0;i<cols.length;i++){
			if(cols[i].name==colName) return i;
		}
		return -1;
	},
	_updateGridLine: function(row){
		var cols=this._gridMetadata.columns,i,col;
		var line= this._data[row];
		if(line[1]=="E"){
			$( line[0]+"_templaterow" ).remove();
			this._data.splice(row,1);
			return;
		}
		//update grid line
		$( line[0]+"_row" ).innerHTML="<input type='checkbox' id='"+ line[0] +"_chk' value='Y' class='cbx' /><a href='javascript:gc.editLine(\""+line[0]+"\")'>"+ (row+1+this._gridQuery.start)+"</a>";
		$( line[0]+"_state__" ).innerHTML="";
		$( line[0]+"_errmsg" ).innerHTML=(line[2]==null?"":"<a class='helpLink' onclick='showHelpTip(event, gc._data["+row+"][2], false); return false' href='javascript:void(0);'><img src='/html/nds/images/alert.gif' border='0'/></a>");
		var jsonhtml="";
		if(line[3]==null){
			if(this._supportAttributeDetail && this._data[row][1]=="A")
				jsonhtml="<a href='javascript:gc.loadJsonObj("+row+")'><img src='/html/nds/images/detail.gif' border='0'/></a>";
		}else if(line[3]!=""){
			jsonhtml="<a href='javascript:gc.showJsonObj("+row+")'><img src='/html/nds/images/detail.gif' border='0'/></a>";
		}
		$( line[0]+"_jsonobj" ).innerHTML=jsonhtml;
		for(i=4;i< cols.length;i++){
			col= cols[i];
			if(col.isVisible){
				this._setValue(line[0]+"_"+ col.name,line[i] );
			}
		}
		this._updateGridLineState(line);
	},
	/**
	 * Show json object, will request server send back screen
	 * @param row the row in this._data
	 */
	showJsonObj: function(row){
		this.editRow(row);
		var line= this._data[row];
		if(["D","E","N"].indexOf(line[1])>-1) return;
		var pdtValue, pdtColIndex;
		pdtColIndex = this._findColumnByName("M_PRODUCT_ID__NAME");
		if(pdtColIndex <0) return;
		pdtValue= this._data[row][pdtColIndex];
		var evt={};
		evt.command="CheckProductAttribute";
		evt.callbackEvent="ShowProductAttribute";
		evt.product=pdtValue;
		evt.tableId=this._gridMetadata.tableId;
		evt.tag= row; // will return unchanged
		this._executeCommandEvent(evt);
	},
	/**
	 * Try load json obj from server for specified row
	 */
	loadJsonObj: function(row){
		var evt={};
		evt.command="LoadProductAttribute";
		evt.callbackEvent="ShowProductAttribute";
		evt.tableId=this._gridMetadata.tableId;
		evt.recordId= this._data[row][4];
		evt.tag= row; // will return unchanged
		this._executeCommandEvent(evt);
	},
	/**
	 * handle product attribute information.
	 * returned data should contained 3 segments:1 is script, 2 is dom, 3 is other scripts
	 */
	_checkProductAttribute:function(e){
		var chkResult=e.getUserData().data; // data
		var chkProductAttribute=$("check_product_attribute");
		var pdt=$("eo_"+chkProductAttribute.value);
		if(chkResult.code!=0){
			msgbox(chkResult.message);
			pdt.focus();
			dwr.util.selectRange(pdt, 0, this.MAX_INPUT_LENGTH);			
		}else{
			if(chkResult.showDialog){
				var ele = Alerts.fireMessageBox(
				{
					width: 600,
					modal: true,
					title: gMessageHolder.SET_PRODUCT_ATTRIBUTE
				});
				ele.innerHTML=chkResult.pagecontent;
				executeLoadedScript(ele);
				if(this._currentRow!=-1){
					var jo= this._data[this._currentRow][3]; // array, each elements is array of eleId and value
					var i;
					if(jo!=null)for(i=0;i< jo.length;i++){
						this._setValue( jo[i][0], jo[i][1]);
					}				
				}
				try{$("itemdetail_form").focusFirstElement();}catch(e){}
				this._tmpData=chkResult;
			}else{
				this._saveLineToGrid(chkResult,pdt);
			}
		}
	},	
	/**
	 * set product attribute information with locale json 
	 * returned data should contained 3 segments:1 is script, 2 is dom, 3 is other scripts
	 */
	_showProductAttribute:function(e){
		var chkResult=e.getUserData().data; // data
		if(chkResult.code!=0){
			msgbox(chkResult.message);
		}else{
			var row=chkResult.tag; 
			if(chkResult.jsondetail!=null){
				if(chkResult.jsondetail=="")$( this._data[row][0]+"_jsonobj" ).innerHTML="";
				else{
					this._data[row][3]=	chkResult.jsondetail;
					$( this._data[row][0]+"_jsonobj" ).innerHTML="<a href='javascript:gc.showJsonObj("+row+")'>"+gMessageHolder.SHOW_ATTRIBUTE+"</a>";
				}
			}
			if(chkResult.showDialog){
				var row= chkResult.tag;// @see showJsonObj
				this.editLine(row);
				var ele = Alerts.fireMessageBox(
				{
					width: 600,
					modal: true,
					title: gMessageHolder.SET_PRODUCT_ATTRIBUTE
				});
				ele.innerHTML=chkResult.pagecontent;
				executeLoadedScript(ele);
				this._tmpData=chkResult;
				var jo= this._data[row][3]; // array, each elements is array of eleId and value
				var i;
				if(jo!=null)for(i=0;i< jo.length;i++){
					dwr.util.setValue( jo[i][0], jo[i][1]);
				}
				try{$("itemdetail_form").focusFirstElement();}catch(e){}
			}
			
		}
	},	
	/**
	 * Find column in this._data by column name
	 * @param cn column name
	 * @return index of that column, start from 0, -1 if not found
	 */
	_findColumnByName: function(cn){
		var i, cols=this._gridMetadata.columns, col;
		for(i=0;i<cols.length;i++){
			if(cols[i].name == cn) return i;
		}
		return -1;
	},
	/**
	 * update grid line state
	 * @param line the row in this._data
	 */
	_updateGridLineState: function(line){
		if( line[1]!="S"){
			var ele=$( line[0]+"_templaterow" );
			var s={};
			switch(line[1]){
				//case "S":break;// Starndard
				case "A": ele.addClassName("row-A");break;//Add (not saved)
				case "M": ele.addClassName("row-M");break;//Modify(not saved)
				case "N": ele.addClassName("row-N");break;//Not Available
				case "D": ele.addClassName("row-D");break;//Delete (not saved)
				case "E": ele.addClassName("row-E");break;//dEleted
			}
			ele.setStyle(s);
			// some state will not allow any action further
			if(line[1]=="E" || line[1]=="N" || line[1]=="D"){
				ele=$( line[0]+"_chk" );
				dwr.util.setValue(ele, false);
				ele.disabled=true;
				var cols=this._gridMetadata.columns,i,col;
				for(i=4;i< cols.length;i++){
					col= cols[i];
					if(col.isVisible){
						$(line[0]+"_"+ col.name).disabled=true;
					}
				}
				$( line[0]+"_jsonobj" ).innerHTML="";
			}
			$( line[0]+"_state__" ).innerHTML="<img src='/html/nds/images/line_"+line[1]+".gif' width='16' height='16'/>";
			this._isDirty=true;			
		}
	},
	
	/** 
	 * Insert a line into grid
	 * @param row, which row in data array, start from 0
	   @param bScrollToView if true, will try to scroll the row to view
	 */
	_insertGridLine:function(row, bScrollToView){
		var line= this._data[row];
		//debug(line);
		dwr.util.cloneNode("templaterow",{ idPrefix:line[0]+"_" });
		var ele=$( line[0]+"_"+"templaterow" );
		ele.toggle();
		if(row%10>4) ele.toggleClassName('odd-row');
		this._updateGridLine(row);
		if(bScrollToView)ele.scrollIntoView(false);
	},
	/**
	 * copy row information to object
	 * @row index in data
	 */
	editRow:function(row){
		var line= this._data[row];
		if(["D","E","N"].indexOf(line[1])>-1) return;
		if(this._inlineMode=="N"){
			this._currentRow= row;
			this.openLineInNewWindow();
		}else if(this._inlineMode=="Y"){
			this._prepareEditableFields(row);
			this._currentRow= row;
			var cols=this._gridMetadata.columns,i,col;
			for(i=4;i< cols.length;i++){
				col= cols[i];
				if($("eo_"+ col.name) && (col.isVisible)){// when fk=table.id, both columns have the same name, but only one is visible
					this._setValue("eo_"+ col.name,line[i]);
				}
			}
			$("legend_line").innerHTML= gMessageHolder.EDIT_LINE +"("+ (row+1)+")";
			var e=$("btn_copyline");
			if(e!=null)e.setEnabled(true);
			if( this._tableActions.indexOf("M")<0){
				if($("btn_saveline")!=null)$("btn_saveline").hide();
			}else{
				if($("btn_saveline")!=null)$("btn_saveline").show();
			}
		}else if(this._inlineMode=="B"){
			
		}
	},
	/**
	 * copy row information to object
	 * @line0 will search for row whose first element equals line0
	 */
	editLine:function(line0){
		var i,row=-1;
		for(i=0;i< this._data.length;i++){
			if(this._data[i][0]==line0){
				row=i;
				break;
			}
		}
		if(row==-1) return;
		this.editRow(row);

	},
	/**
	 * Copy current line to create a new line,will not save immediately
	 */
	copyLine:function(){
		this._prepareEditableFields(-1);
		$("legend_line").innerHTML= gMessageHolder.NEW_LINE ;
		this._currentRow=-1;
	},
	_toggleEditableFields:function(nextFormStateIsAdd){
		//clear and disable those columns that change
		var cols=this._gridMetadata.columns,i,col,e,el,isEnabled;
		for(i=4;i< cols.length;i++){
			col= cols[i];
			if(col.isVisible && (col.isUploadWhenModify!=col.isUploadWhenCreate)){
				//change
				e=$("tf_eo_"+ col.name);
				el=$("lb_eo_"+ col.name);
				//nextFormStateIsAdd=true and isUploadWhenCreate=true, or nextFormStateIsAdd=false and isUploadWhenModify=true
				isEnabled=(nextFormStateIsAdd == col.isUploadWhenCreate );// enable
				if(isEnabled){
					 e.show();
					 el.show();
				}else{
					e.hide();
					el.hide();
				}
			}
		}
	},
	/**
	 * When edit row is changing between Add form and Modify form, some fields should be disabled
	 */
	_prepareEditableFields:function(row){
		var currentFormStateIsAdd=true; // true for Add, false for Modify
		var nextFormStateIsAdd=true;
		if(this._currentRow!=-1 ){
			if (this._data.length>this._currentRow){
				currentFormStateIsAdd = (this._data[this._currentRow][4]==-1);
			}else{
				currentFormStateIsAdd=false;
			}
		}
		if(row!=-1){
			nextFormStateIsAdd= (this._data[row][4]==-1);
		}
		if(currentFormStateIsAdd==nextFormStateIsAdd)return;
		this._toggleEditableFields(nextFormStateIsAdd);
	},
	/**
	* New line for edit, all columns in metaData will initiate in new object form
	* @param b if true, will bring up new window if not isInlineMode, else will do
	* nothing if not is inline mode
	*/
	newLine:function(bForceNewWindow){
		if(this._inlineMode=="N"){
			this._currentRow=-1;
			if(bForceNewWindow)this.openLineInNewWindow();
		}else{
			this._prepareEditableFields(-1);
			this._currentRow=-1;
			$("legend_line").innerHTML= gMessageHolder.NEW_LINE ;
			var cols=this._gridMetadata.columns,i,col;
			for(i=4;i< cols.length;i++){
				col= cols[i];
				if(col.isVisible && $("eo_"+ col.name)!=null){
					//check fixed columns
					if( this._fixedColumns[col.columnId]!=undefined){
						dwr.util.setValue("eo_"+ col.name,gMessageHolder.MAINTAIN_BY_SYS);				
					}else{
						this._setValue("eo_"+ col.name,col.defaultValue);
					}
				}
			}
			var e=$("btn_copyline");
			if(e!=null)e.setEnabled(false);
			if( this._tableActions.indexOf("A")<0){
				if($("btn_saveline")!=null)$("btn_saveline").hide();
			}else{
				if($("btn_saveline")!=null)$("btn_saveline").show();
			}
		}
	},
		/**
	 * new row index
	 */
	_getNextRowId:function(){
		return this._currentNewRowId++;
	},
	
	/**
	 Refresh Grid according to data result from server
	*@param r data set by nds.control.ejb.command.UpdateGridData,contains results for each row handling result
	 and qresult for new data for successful rows
	*/
	updateGrid: function (e) {
		var r=e.getUserData().data; //@see nds.control.ejb.command.UpdateGridData
		var rs=r.results; //[] elements like: {rowIdx: 12, id:11, msg:null,action:"A"}
		var qr=r.qresult;// QueryResultImpl.toJSONObject
		var i, rsOne, oId,row,a,y, rowIdx,line,j;
		var bRefresh=false;
		var errFound=false;
		var rowsToDelete=new Array();
		var bToDelete;
		for(i=0;i<rs.length;i++){
			rsOne=rs[i];
			y= rsOne.row ;//
			line= this._data[y];
			rowIdx=line[0];
			bToDelete=false;
			if(rsOne.msg==null){
				// success, 3 condition:add/modify/delete
				oId= rsOne.objId;
				if(rsOne.action=="A" ||rsOne.action=="M"){
					row=this._getQueryResultRowForId(qr,oId);
					if(row!=null){
						a=[rowIdx,"S",null,line[3]].concat(row);
						if(rsOne.jsoncreated=="T"){
							a[2]="*"+gMessageHolder.ATTRIBUTE_MATRIX_SPLITTED;
							bRefresh=true;
						}
					}else{
						// not found,out of where clause, move it out(delete)
						//a=[rowIdx,"N",null,line[3]];
						a=[rowIdx,"E",null,null];
						bToDelete=true;
						rowsToDelete.push(y);
						// 通常在此情况下需要refresh grid
						bRefresh=true;
					}
				}else if(rsOne.action=="D"){
					a=[rowIdx,"E",null,null];
					bToDelete=true;
					rowsToDelete.push(y);
				}
			}else{
				//error found
				a=[rowIdx,rsOne.action,rsOne.msg,line[3]];			
				errFound=true;
			}
			for(j=0;j<a.length;j++) line[j]= a[j];
			if(!bToDelete)this._updateGridLine(y);
		}
		if(rowsToDelete.length>0){
			rowsToDelete.sort(function cmp(a, b) {return b - a;});
			for(i=0;i< rowsToDelete.length;i++) this._updateGridLine(rowsToDelete[i]);
		}
		this._isDirty=false;
		this.newLine(false);
		if(errFound==false && bRefresh==true){
			//if(confirm(gMessageHolder.RELOAD_SINCE_ATTRIBUTE_MATRIX_SPLITTED)) #MANTIS0000026
			this.refreshGrid();
		}
	},
	
	/**
	* Return row of QueryResult which has the ID equals to oId
	  @param qr QueryResultImpl.toJSONObject, which has ID column in the first column of qr.rows
	  @param oId object id to be searched for
	  @return row (array) of QueryResult.data, null if not found
	*/
	_getQueryResultRowForId:function(qr, oId){
		var rows= qr.rows;
		var i,row;
		for(i=0;i< rows.length;i++){
			row=rows[i];
			if(row[0]==oId) return row;
		}
		return null;
	},

	/**
	*Reload grid data according to query result
	* @param qr QueryResult.toJSONObject()
	*/
	_refreshGrid :function (e) {
		var qr=e.getUserData().data; 
		var rowCount=qr.rowCount;
		var i,s,a;
		var q=this._gridQuery;
		s=qr.start;
		q.start= s;
		dwr.util.removeAllRows("grid_table", { filter:function(tr) {
		      return (tr.id != "templaterow");
	    }});
		
		this._data=new Array();
		for(i=0;i< rowCount;i++){
			a=["M"+qr.rows[i][0] ,"S",null,null];
			this._data.push(a.concat(qr.rows[i]));
			this._insertGridLine(i,false);
		}
		this._syncGridControl(qr);
		if(this._currentRow!=-1)this.newLine(false);
		this._isDirty=false;
	},
	/**
	* Setup line template for input
	*/
	openLineTemplate: function(){
		popup_window("/html/nds/objext/template.jsp?table="+ this._gridMetadata.tableId);
	},
	/**
	 * Init modify table, support mouse selection
	 */
	_initTable: function(){
		
		this._gridTable= new SelectableTableRows($("modify_table"), false);
		this._gridTable.ondoubleclick = function (trRow) {
			gc.editRow(trRow.sectionRowIndex);
		};	 
		/*this._gridTable.onchange = function () {
			var i,s,v;
			var curSelected=  gc._gridTable.getSelectedIndexes();
			for(i=0;i< gc._data.length;i++){
				if(["D","E","N"].indexOf(gc._data[i][1])>-1)continue;
				v=(curSelected.indexOf(i)>-1);
				s=dwr.util.getValue(gc._data[i][0]+"_chk");
				if(v!=s) dwr.util.setValue(gc._data[i][0]+"_chk", !s);
			}
			dwr.util.setValue("chk_select_all", false);
		};	*/ 
		
	},
	
	/**
	 * When key pressed in table, move focus
	 */
	moveTableFocus: function(e){
		var r,ele;
		switch(e.keyCode){
			case 38:{//UP
				r= this._getCurrentPositionInData(e);
				if(r!=null)while(r.row>0){
					r.row = r.row-1;
					if(["M","A","S"].indexOf( this._data[r.row][1])>-1){
						ele= this._data[r.row][0]+"_"+  this._gridMetadata.columns[r.column].name;
						dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
						break;
					}
				}
				break;
			}
			case 40://DOWN
			case 13:{//Enter
				r= this._getCurrentPositionInData(e);
				if(r!=null)while(r.row<this._data.length-1){
					r.row = r.row+1;
					if(["M","A","S"].indexOf( this._data[r.row][1])>-1){
						ele= this._data[r.row][0]+"_"+  this._gridMetadata.columns[r.column].name;
						dwr.util.selectRange(ele, 0, this.MAX_INPUT_LENGTH);
						break;
					}
				}
				break;
			}
		}		
	},
/**
	 * When cell value changed in table, this method will be called
	 */
	cellChanged: function(e){
		var r=this._getCurrentPositionInData(e);
		if(r==null)return;
		//debug("r="+ r.row+","+ r.column+";ele="+(e.target != null ? e.target.id : e.srcElement.id));
		var line=this._data[r.row];
		line[r.column]=this._getValue( e.target != null ? e.target : e.srcElement) ;
		if(line[1]!="A"){
			line[1]="M";
		}
		this._updateGridLineState(line);
	},
	/**
	 * Wrapper dwr.util.getValue for checkbox value conversion "true" to "Y", "false" to "N"
	 */
	_getValue :function(ele, options) {
		var e=$(ele);
		if(e==null) return "";
		var v= dwr.util.getValue( e,options);
		if(e.type == "checkbox"){
			if(v==true) v="Y";
			else if(v==false) v="N";
		}
		return v;
	},
	/**
	 * This is modified one of dwr.2.0.1 for checkbox value setting.
		Old one only let "true" for checked, now "Y" will also be checked one
	 */
	_setValue: function(ele, val, options) {
		var e=$(ele);
		if(e==null) return;
		try{
		if(e.type == "checkbox"){
			if(val=="Y") val=true;
			else if(val=="N") val=false;
		}
		dwr.util.setValue(e,val,options);
		}catch(ex){
			debug("_setValue Error::::"+ex+",ele="+ele+", $ele="+e+"");
		}
	},
	
	/**
	 * Get row and column in this._data of current focus in table
	 * @param e event object
	 * @return {row:int, column:int},null if not found or reach the boundary of grid
	 */
	_getCurrentPositionInData:function(e){
		if(e!=null) e = e.target != null ? e.target : e.srcElement;
		if(e==null) return null;
		var p= e.id.indexOf("_",0);
		var d0= e.id.substr(0,p);
		var d1= e.id.substr(p+1);
		var i, r={row:-1, column:-1};
		var cols=this._gridMetadata.columns;
		for(i=0;i< this._data.length;i++){
			if(this._data[i][0]==d0){
				r.row=i;
				break;
			}
		}
		for(i=0;i<cols.length;i++ ){
			if(cols[i].name== d1){
				r.column= i;
				break;
			}
		}
		if(r.row==-1 || r.column==-1){
			//debug("found position error:row="+ r.row+",col="+ r.column);
			return null;
		}		
		return r;
	}
	
};
// define static main method
GridControl.main = function () {
	
	gc=new GridControl();
};

var EditableGridMetadata = Class.create();
// define constructor
EditableGridMetadata.prototype = {
	/**
	* Load data from object from server
	*/
	initialize: function(o){
		this.columns=o.columns;
		this.table=o.table;	
		this.tableId=o.tableId;
		this.column_masks=o.column_masks; //elements are GridColumn
		this.ismenuobj= o.ismenuobj;
		this.popupitem=o.popupitem;
		this.columnsWhenCreate=this._getColumnsWhenCreate();
		this.columnsWhenModify=this._getColumnsWhenModify();
		this.columnsWhenDelete=this._getColumnsWhenDelete();
	},
	/**
	* Columns that will be uploaded to server for ObjectCreate
	*@return int[] for column index in Grid columns
	*/
	_getColumnsWhenCreate :function () {
		var rt=new Array();
		var col;
		for(var i=0;i< this.columns.length;i++){
			col= this.columns[i];
			if (col.isUploadWhenCreate)	rt.push(i);
		}
		return rt;
	},
	/**
	* Columns that will be uploaded to server for ObjectCreate
	*@return int[] for column index in Grid columns
	*/
	_getColumnsWhenModify :function () {
		var rt=new Array();
		var col;
		for(var i=0;i< this.columns.length;i++){
			col= this.columns[i];
			if (col.isUploadWhenModify)	rt.push(i);
		}
		return rt;
	},
	/**
	* Columns that will be uploaded to server for ObjectCreate
	*@return int[] for column index in Grid columns
	*/
	_getColumnsWhenDelete :function () {
		return [4];//ID
	}
	
};

function msgbox(msg, title, boxType ) {
	showProgressWindow(false);
	alert(msg);
}
/**
* Show table object info

function dlgo(tableId, objId){
	popup_window("/html/nds/object/object.jsp?table="+tableId+"&id="+objId);
}
*/

function showProgressWindow(bShow){
	
}
function debug(message, stacktrace){
	dwr.engine._debug(message, stacktrace);
}
function doSaveLine(){
	gc.saveLine();
}	
function doAdd(){
	gc.newLine(true);
}
function doDeleteLine(){
	gc.deleteSelected();	
}
function doListDelete(){
	if (!confirm(gMessageHolder.CONFIRM_DELETE_CHECKED)) {
         return false;
    }
    gc.deleteSelected();
}
function doProcess(){
	gc.saveAll();
}
function doTemplate(){
	gc.openLineTemplate();
}

function doQuickSearch(){
	gc.quickSearch();
}



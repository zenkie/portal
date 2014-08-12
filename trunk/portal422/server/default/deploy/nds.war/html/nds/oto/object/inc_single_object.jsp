<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<table class="<%=uiConfig.getCssClass()%>" cellspacing="0" cellpadding="0" align="center">
	<%
    colIdx=-1;
    //lable_des="<a>&nbsp;</a>";
    //String lable_des;
    //String rms;
	rowspans=new JSONArray();
	currentrow=-1;
    for(int i=columnIndex;i< columns.size();i++){
    	colIdx++;
    	columnIndex++;
		isFind=false;
        column=(Column)columns.get(i);
        String showcomment=column.getShowcomment();
        //out.print("showcomment "+showcomment);
        ds= column.getDisplaySetting();
        String attributesText="";//Validator.isNull(column.getRegExpression())? " ": column.getRegExpression()+" ";
		colspan=ds.getColumns()>columnsPerRow?columnsPerRow:ds.getColumns();
        if(colIdx%columnsPerRow == 0){
        	colIdx=0;
        	if(ds.getObjectType()==DisplaySetting.OBJ_BLANK&& seperateObjectByBlank){
        		break;
        	}
			currentrow++;
			%>
			<tr <%=(ds.getObjectType()==DisplaySetting.OBJ_BLANK?" class='blankrow'":"")%>>
		<%}
        if(ds.isUIController()){
        	if (ds.getObjectType()==DisplaySetting.OBJ_HR){
        		// occupy whole row
        		if(colIdx !=0){
        			for(int ri=0;ri< columnsPerRow-colIdx;ri++) out.print("<td>&nbsp;</td><td>&nbsp;</td>");
        			out.print("</tr><tr c='c'>");
        		}
        		//out.print("<td colspan='"+(columnsPerRow*2)+"'><font class='beta'><b>"+column.getDescription(locale)+"</b></font><div class='hrRule'><span/></div></td>");
        		out.print("<td colspan='"+(columnsPerRow*2)+"'><div class='tabnav-"+columnsPerRow+"'><span>"+column.getDescription(locale)+"</span></div></td>");
        		out.print("</tr>");
        		colIdx=-1;
        	}else{
        		// blank
        		if(seperateObjectByBlank){
	        		if( colspan> columnsPerRow-colIdx){
	        			// occupy whole row
	        			if(colIdx !=0){
	        				out.print("<td colspan='"+(columnsPerRow-colIdx)*2 +"'/>");
	        				out.print("</tr>");
	        			}
	        		}
	        		break;
        		}else{
	        		if( colspan> columnsPerRow-colIdx){
	        			// occupy whole row
	        			if(colIdx !=0){
	        				for(int ri=0;ri< columnsPerRow-colIdx;ri++) out.print("<td></td><td></td>");
	        				out.print("</tr><tr class='blankrow'>");
	        			}
	        		}
	        		out.print("<td colspan='"+(colspan*2)+"'>&nbsp;</td>");
	        		if(colIdx+colspan>columnsPerRow-1 ){
	        			colIdx=-1;
	        			out.print("</tr>");
	        		}// colIdx will be increment 1 after continue
        		}
        	}
			currentrow++;
       		continue;
        }
        
        dataValue = "";
		fixedColumnMark= (fixedColumns.get(new Integer(column.getId())) ==null)?"":"DISABLED";
		isFixedColumn= (fixedColumns.get(new Integer(column.getId())) ==null)?false:true;
		
        String desc=  model.getDescriptionForColumn(column);
        dataWithoutNBSP=null;
        if(result !=null){
              data=result.getString(i+1,true);
              dataWithoutNBSP=result.getString(i+1,false);
              coid=result.getObjectID( i+1);
              dataDB =result.getObject(i+1);
        }else{
        	//dataWithoutNBSP=objprefs.getProperty(column.getName(),column.getDefaultValue(bReplaceVariable));
        	dataWithoutNBSP=objprefs.getProperty(column.getName(), 
        		userWeb.getUserOption(column.getName(),column.getDefaultValue(bReplaceVariable)));
        	if(bReplaceVariable)dataWithoutNBSP=userWeb.replaceVariables(dataWithoutNBSP);
        	dataDB = dataWithoutNBSP;
        }
        refTable= column.getReferenceTable();
		/**Note : the inputName should not get from model, which is for Query, not this one*/
		//                          String inputName=model.getNameForInput(column);
        inputName=column.getName().toLowerCase();
	    column_acc_Id="column_"+column.getId();
        
        type=model.toTypeIndicator(column,column_acc_Id,locale);
        
        if( refTable !=null) {
               inputName=inputName+"__"+ refTable.getAlternateKey().getName().toLowerCase();
               
        }
        inputSize=bReplaceVariable?model.getSizeForInput(column):4000;// if show variable, which may be script,so should be longer

        values = column.getValues(locale);
        if(rowspans.length()>0){
			startcolumn=1000;
			for(int k=0;k<rowspans.length();k++){
				currentrowspan=rowspans.optJSONObject(k);
				//if(currentrowspan==null){continue;}
				
				if(currentrow>=currentrowspan.optInt("startrow",10000)&&currentrow<=currentrowspan.optInt("endrow",-1)
				&&((colIdx>=currentrowspan.optInt("startcolumn",10000)&&colIdx<=currentrowspan.optInt("endcolumn",-1))
				||((colIdx+colspan-1)>=currentrowspan.optInt("startcolumn",10000)
				&&(colIdx+colspan-1)<=currentrowspan.optInt("endcolumn",-1)))){
					isFind=true;
					startcolumn=currentrowspan.optInt("startcolumn",1000);
					endcolumn=currentrowspan.optInt("endcolumn",-1);
					
					if(colIdx<startcolumn){
						for(int ri=colIdx;ri< startcolumn;ri++) out.print("<td></td><td></td>");
					}
					colIdx=endcolumn+1;
					if(colIdx>=columnsPerRow||colIdx+colspan-1>=columnsPerRow){
						currentrow++;
						if(colIdx<columnsPerRow){
							for(int ri=colIdx;ri< columnsPerRow;ri++) out.print("<td></td><td></td>");
						}
						out.print("</tr><tr>");
						colIdx=0;
						
					}/*else{
						out.print("<td></td>");
					}*/
				}/*else if(currentrow>=currentrowspan.optInt("startrow",10000)&&currentrow<=currentrowspan.optInt("endrow",-1)){
					startcolumn=currentrowspan.optInt("startcolumn",1000);
					endcolumn=currentrowspan.optInt("endcolumn",-1);
					break;
				}*/
			}
			while(isFind){
				isFind=false;
				for(int k=0;k<rowspans.length();k++){
					currentrowspan=rowspans.optJSONObject(k);
					if(currentrow>=currentrowspan.optInt("startrow",10000)&&currentrow<=currentrowspan.optInt("endrow",-1)
					&&((colIdx>=currentrowspan.optInt("startcolumn",10000)&&colIdx<=currentrowspan.optInt("endcolumn",-1))
					||((colIdx+colspan-1)>=currentrowspan.optInt("startcolumn",10000)
					&&(colIdx+colspan-1)<=currentrowspan.optInt("endcolumn",-1)))){
						isFind=true;
						startcolumn=currentrowspan.optInt("startcolumn",1000);
						endcolumn=currentrowspan.optInt("endcolumn",-1);

						if(colIdx<startcolumn){
							for(int ri=colIdx;ri< startcolumn;ri++) out.print("<td></td><td></td>");
						}
						colIdx=endcolumn+1;

						if(colIdx>=columnsPerRow||colIdx+colspan-1>=columnsPerRow){
							currentrow++;
							if(colIdx<columnsPerRow){
								for(int ri=colIdx;ri< columnsPerRow;ri++) out.print("<td></td><td></td>");
							}
							out.print("</tr><tr>");
							colIdx=0;
						}/*else{
							out.print("<td></td>");
						}*/
					}
				}
			}
		}
		
		if(colspan+colIdx> columnsPerRow){
			// start from first column  
		 	// occupy previous whole row
			
        	if(colIdx !=0){
        		for(int ri=0;ri< columnsPerRow-colIdx;ri++) out.print("<td></td><td></td>");
        		out.print("</tr><tr cccc='x'>");
        		colIdx=0;
        	}
        	currentrow++;
        }
		colIdx=colIdx+colspan-1; 
		
		if(column.getRowspan()){
			currentrowspan=new JSONObject();
			try{
				currentrowspan.put("startrow",currentrow);
				currentrowspan.put("endrow",currentrow+ds.getRows()-1);
				currentrowspan.put("startcolumn",colIdx);
				currentrowspan.put("endcolumn",colIdx+colspan-1);
				rowspans.put(currentrowspan);
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		
		// if button, or security grade greater than user's sgrade, will not display
		//boolean shouldDescTdDisplay=!(ds.getObjectType()==DisplaySetting.OBJ_BUTTON || column.getSecurityGrade()>userWeb.getSecurityGrade());
		boolean shouldDescTdDisplay=column.getShowtitle()&&column.getSecurityGrade()<=userWeb.getSecurityGrade();
		%>
		<td id="tdd_<%=column.getId()%>" width="auto" nowrap align="left" valign='middle' <%=(shouldDescTdDisplay?"class='desc'":"")%> <%=ds.getRows()>1&&column.getRowspan()?" rowspan='"+ds.getRows()+"'":""%>>
			<%
			if(shouldDescTdDisplay){
				//cyl lable 动态关联字段
				if(column.getJSONProps()!=null){
					JSONObject jor=column.getJSONProps();
					if(jor.has("islable")){
						//System.out.println("adsfasdfadsf");
						//System.out.println(data);
						//lable_des=dataWithoutNBSP;
						continue;
					}else if(jor.has("lable")){
						JSONObject jo=column.getJSONProps().getJSONObject("lable");
						int lable_id=jo.optInt("id",0);
						String lable_name=jo.optString("name","");
						Column lable_col=(Column)table.getColumn(lable_id);
						//lable_des=lable_col.getDefaultValue(bReplaceVariable);
						String lable_des=new String();
						//QueryResultMetaData meta= result.getMetaData();
						if(result !=null){
						  int pos = result.getMetaData().findPositionInSelection(lable_col);// starts from 0
						  lable_des= result.getString(pos+1,false);
						}else{
							lable_des= objprefs.getProperty(lable_col.getName(),
							userWeb.getUserOption(lable_col.getName(),lable_col.getDefaultValue(bReplaceVariable)));
						}
						//System.out.println(lable_col.getDefaultValue(bReplaceVariable));
						//System.out.println(dataWithoutNBSP1);
						//System.out.println(desc);
						//System.out.println(tableId);
						//支持lable_id change write
						%>
						<div id="tdc_<%=lable_id%>" onclick="oc.lable_change(<%=lable_id%>);"><%=lable_des%><span class="desc-txt<%=column.isNullable()?"":" nn"%>">:</span></div>
						<input style="display:none;width:83px;" name="<%=lable_name%>" id="column_<%=lable_id%>" type="text" maxLength="16" value="<%=lable_des%>"/>
				   <%}else if(jor.has("reflable")){
						JSONObject jo=column.getJSONProps().getJSONObject("reflable");
						int lable_id=jo.optInt("ref_id",0);
						int lable_tabid=jo.optInt("tabid",0);
						Table reftable= manager.getTable(lable_tabid);
						query=QueryEngine.getInstance().createRequest(userWeb.getSession());
						query.setMainTable(lable_tabid);
						query.addSelection(reftable.getAlternateKey().getId());
						query.addParam( reftable.getPrimaryKey().getId(), ""+ lable_id);
						QueryResult rs=QueryEngine.getInstance().doQuery(query); 
						if(lable_id !=0 || (rs!=null && rs.getTotalRowCount()>0)){
							while(rs.next()) {
								desc=rs.getObject(1).toString(); 
							}
						}%>
						<div class="desc-txt<%=column.isNullable()?"":" nn"%>"><%=desc%>:</div>
					<%}else{%>
						<div class="desc-txt<%=column.isNullable()?"":" nn"%>"><%=desc%>:</div>
					<%}%>
				<%}else{%>
					<div class="desc-txt<%=column.isNullable()?"":" nn"%>"><%=desc%>:</div>
				<%}%>
			<%}%>
		</td>
		<td  id="tdv_<%=column.getId()%>" class="value" nowrap align="left" valign='middle' <%=(colspan-1)*2>0? "colspan='"+((colspan-1)*2+1)+"'":"" %> <%=ds.getRows()>1&&column.getRowspan()?" rowspan='"+ds.getRows()+"'":""%>>
			<%
			//check security grade
			if( userWeb.getSecurityGrade()>=column.getSecurityGrade()){
				if(values != null){// combox or check or redio
					//Hawke Begin
					StringHashtable o = new StringHashtable();
					o.put(PortletUtils.getMessage(pageContext, "combobox-select",null),"0");
					Iterator i1 = values.keys();
					Iterator i2 = values.values();
					while(i1.hasNext() && i2.hasNext()){
						String tmp1 = String.valueOf(i2.next());
						String tmp2 = String.valueOf(i1.next());
						o.put(tmp1,tmp2);
						
						if(data != null && data.equals(tmp1)){
							dataValue = tmp2;
						}
					}
					java.util.HashMap a = new java.util.HashMap();
					a.put("id", column_acc_Id);
					//Hawke end
					if(data !=null){
						data=data.trim();
							
						if(canEdit && column.isModifiable(actionType)){
							a.put("tabIndex", (++tabIndex)+"");
							if(ds.getObjectType()==DisplaySetting.OBJ_CHECK){
								%>
								<input:checkbox name="<%=inputName%>" default="<%=dataValue%>" value="Y" attributes="<%=a%>" attributesText="<%=(attributesText+"class='cbx2'")%>"/>
							<%}else{
								a.put("class", "objsl");
								a.put("onkeydown", "oc.moveTableFocus(event)");
								%>
								<input:select name="<%=inputName%>" default="<%=dataValue%>" attributes="<%= a %>" options="<%= o %>" attributesText="<%=(attributesText+fixedColumnMark)%>" />
								<%
							}
						}else{%>
							<span id="<%=column_acc_Id%>"><%=data%></span>
						<%}
					}else{
						if( canEdit&&column.isModifiable(actionType)){
							a.put("tabIndex", (++tabIndex)+"");
							//String defaultValue=objprefs.getProperty(column.getName(),column.getDefaultValue(bReplaceVariable));
							String defaultValue=objprefs.getProperty(column.getName(), 
							userWeb.getUserOption(column.getName(),column.getDefaultValue(bReplaceVariable)));
							if(defaultValue==null){ defaultValue="0";}
							if(bReplaceVariable){defaultValue=userWeb.replaceVariables(defaultValue);}
							if(ds.getObjectType()==DisplaySetting.OBJ_CHECK){
								%>
								<input:checkbox name="<%=inputName%>" default="<%=defaultValue%>" value="Y" attributes="<%=a%>" attributesText="<%=(attributesText+"class='cbx2'")%>"/>
							<%}else if(ds.getObjectType()==DisplaySetting.OBJ_RAIDO){
								a.put("class", "objsl");
								a.put("onkeydown", "oc.moveTableFocus(event)");
								%>
								<input:select name="<%=inputName%>" default="<%=defaultValue%>" attributes="<%= a %>" options="<%= o %>" attributesText="<%=(attributesText+fixedColumnMark)%>" />
							<%}else{
								a.put("class", "objsl");
								a.put("onkeydown", "oc.moveTableFocus(event)");
								%>
								<input:select name="<%=inputName%>" default="<%=defaultValue%>" attributes="<%= a %>" options="<%= o %>" attributesText="<%=(attributesText+fixedColumnMark)%>" />
							<%}
						}else{
							%>
							<%= PortletUtils.getMessage(pageContext, "maintain-by-sys",null)%>
							<%
						}
					}
				}// end if(value != null)
				else{ // begin if value ==null
					if(column.getReferenceTable() !=null){		
						fkQueryModel=new FKObjectQueryModel(true,column.getReferenceTable(), column_acc_Id,column,null);
						fkQueryModel.setQueryindex(-1);
						if(maintabid!=-1&&column.isFilteredByWildcard()){fkQueryModel.setWfcfixcol(fixedColumns);}
					}else{
						fkQueryModel=null;
					}
						  
					if( canEdit&& column.isModifiable(actionType)){
						if(dataWithoutNBSP==null && isFixedColumn){
							// is fixed column, so will be maintained by system
							dataWithoutNBSP=PortletUtils.getMessage(pageContext, "maintain-by-sys" ,null);
						}
						if( ds.getObjectType()==DisplaySetting.OBJ_TEXT){
							java.util.Hashtable h = new java.util.Hashtable();
							h.put("id", column_acc_Id);
							h.put("size", "" + ds.getCharsPerRow());
							h.put("maxlength", String.valueOf(inputSize));
							h.put("tabIndex", (++tabIndex)+"");
							h.put("class", TableQueryModel.getTextInputCssClass(columnsPerRow,column));
							h.put("onkeydown", "oc.moveTableFocus(event)");
							if(fkQueryModel!=null){
								//add key catcher 
								//h.put("onkeydown",fkQueryModel.getKeyEventScript());
								//column.getRegExpression() may be a javascript function 
								if(column.isFilteredByWildcard() && Validator.isNotNull(column.getRegExpression())){
									h.put("readonly","readonly");
								}
								if(WebUtils.getBrowserType(request)==0){
									//特此注意在IE8下可能发生value循环BUG
									//修正bug在ie8下如果有查询条件设有过滤时
									//查询返回结果焦点触发onblur清除id的问题
										h.put("onKeyPress","oc.onKeyPress(event)");
								}else{
								h.put("oninput","oc.onKeyPress(event)");	
									//h.put("onblur", "oc.isempty("+column_acc_Id+","+"fk_"+column_acc_Id+")");
								}
							}//end if(fkQueryModel!=null)
							if(column.isAutoComplete()){
								boolean flag=true;
								for(int j=0;j<dcqjsonarraylist.length();j++){
									if(dcqjsonarraylist.getJSONObject(j).get("column_acc_Id").equals(column_acc_Id)){
										flag=false;break;
									}
								}
								if(flag){
									dcqjsonObject=new org.json.JSONObject();
									dcqjsonObject.put("column_acc_Id",column_acc_Id);
									dcqjsonObject.put("tableId",column.getReferenceTable().getId());
									dcqjsonObject.put("columnId",column.getId());
									dcqjsonObject.put("newvalue","");
									dcqjsonObject.put("oldvalue","");
									dcqjsonarraylist.put(dcqjsonObject);
								}
								h.put("autocomplete","off");
							}
							if(Validator.isNotNull(column.getRegExpression())){
								h.put("onchange", column.getRegExpression()+"()");
							}
							//System.out.print(inputName+"       "+column.getSQLType());
							if (column.getType() == 3){
								h.put("onfocus", "WdatePicker()");
							}else if (column.getType() == 1) {
							   h.put("onfocus", "WdatePicker({dateFmt:'yyyy/MM/dd HH:mm:ss'})");
							}
							h.put("title", model.getInputBoxIndicator(column,column_acc_Id,locale));
							String attributeText2= (column.getJSONProps()!=null?column.getJSONProps().optString("input_attr",""):"");
							//System.out.println(column.getName()+"~~~"+attributeText2+"!!!!!!!!!!!!!!!!!");
							%>
							<%
							if(column.getJSONProps()!=null){
								JSONObject jor=column.getJSONProps();
								if(jor.has("ispassword")){ %>
									<input:password name="<%=inputName%>" attributes="<%= h %>" default="<%=dataWithoutNBSP %>" attributesText="<%=(attributeText2+" "+attributesText+fixedColumnMark)%>"/><%= type%>
								<%}else if(jor.has("cfold")){%>
									<div id="div_<%=inputName%>" objid=<%=objectId%> sku="<%=jor.optString("sku")%>" price="<%=jor.optString("price")%>" costprice="<%=jor.optString("costprice")%>" inventory="<%=jor.optString("inventory")%>">
									<input:text name="<%=inputName%>" default="<%=dataWithoutNBSP %>" attributesText="style=display:none;" />
									<%
									JSONArray jasss=jor.optJSONArray("cfold");
									if(jasss.length()>0){%>
										<input objid=<%=objectId%> ac="<%=inputName%>" type="button" onclick="<%=jasss.optJSONObject(0).optString("ac")%>" value="<%=jasss.optJSONObject(0).optString("name")%>" disabled="true">
									<%}%>
									</div>
									<div id="space_<%=inputName%>"></div>
									<iframe id="iframe_<%=inputName%>" name="iframe_<%=inputName%>" src="/html/nds/oto/product/extendspec.jsp?eid=<%=inputName%>" class="custom_spaceitem" style="min-height:200px;max-height:500px;width:100%;padding: 0.8em 1em;border: 1px solid #CCC;box-shadow: #CCC 0 0 .25em;border-radius: 6px;margin-bottom: 10px;"></iframe>
									<div id="divs_<%=inputName%>" style=" float: right; ">
									<%
									for(int k=1;k<jasss.length();k++){%>
										<input objid=<%=objectId%> ac="<%=inputName%>" type="button" onclick="<%=jasss.optJSONObject(k).optString("ac")%>" value="<%=jasss.optJSONObject(k).optString("name")%>" disabled="true">
									<%}%>
									</div>
									<!--<script>
										jQuery(document).ready(
											function init(){
												var spc=jQuery("#div_<%=inputName%> input[type=text][name=<%=inputName%>]").val();
												var url="/html/nds/oto/product/extendspec.jsp";
												cf.showSpaceItem(url,spc);
												jQuery.ajax({
													url:url,
													type:"post",
													data:{"specification":spc},
													success:function(data){
														alert(data);
													},
													error:function(data){
														alert(data);
													}
												});
											}
										);
									</script>-->
								<%}else if(jor.has("fold")&&jor.optBoolean("fold",false)){%>
									<input:text name="<%=inputName%>" isFold="true" attributes="<%= h %>" default="<%=dataWithoutNBSP %>" attributesText="<%=(attributeText2+" "+attributesText+fixedColumnMark)%>"/><%= type%>
								<%}else{%>
									<input:text name="<%=inputName%>" attributes="<%= h %>" default="<%=dataWithoutNBSP %>" attributesText="<%=(attributeText2+" "+attributesText+fixedColumnMark)%>"/><%= type%>
								<%}
							}else{%>
								<input:text name="<%=inputName%>" attributes="<%= h %>" default="<%=dataWithoutNBSP %>" attributesText="<%=(attributeText2+" "+attributesText+fixedColumnMark)%>"/><%= type%>
							<%}%>
							<%if(fkQueryModel!=null){%>
								<input type="hidden" id="fk_<%=column_acc_Id%>" name="<%=column.getName()%>" value="<%=(coid==-1?"":String.valueOf(coid))%>">
							<%}
						}else if( ds.getObjectType()==DisplaySetting.OBJ_TEXTAREA){
							java.util.Hashtable htextArea = new java.util.Hashtable();
							htextArea.put("id", column_acc_Id);
							htextArea.put("cols", ""+ ds.getCharsPerRow());
							htextArea.put("rows", ""+  ds.getRows());
							htextArea.put("wrap", "soft");
							htextArea.put("tabIndex", (++tabIndex)+"");
							htextArea.put("class", TableQueryModel.getTextAreaInputCssClass(columnsPerRow,column));
							//htextArea.put("onkeydown", "oc.moveTableFocus(event)");
							%>
							<input:textarea name="<%=inputName%>" attributes="<%= htextArea %>" default="<%=dataWithoutNBSP %>" attributesText="<%=(attributesText+fixedColumnMark)%>"/><%= type%>
							
						<%}else if( ds.getObjectType()==DisplaySetting.OBJ_CLOB){
							/**
							net.fckeditor.FCKeditor fckEditor = new net.fckeditor.FCKeditor(request,column_acc_Id,"98%","370px",null, null, "/html/nds/oto/js/fckeditor");
							fckEditor.setValue(dataWithoutNBSP==null?"":dataWithoutNBSP);
							
							/*
							com.ckeditor.CKEditorConfig settings = new com.ckeditor.CKEditorConfig();
							settings.addConfigValue("width", "800");
							//settings.addConfigValue("width", "200");				 
							com.ckeditor.EventHandler eventHandler = new com.ckeditor.EventHandler();
							eventHandler.addEventHandler("instanceReady", "function iResize(ev) {var iFrames = jQuery('iframe');var height=0;for (var i = 0, j = iFrames.length; i < j; i++) {height += iFrames[i].contentWindow.document.body.offsetHeight;}ev.editor.resize(800,height+200);}");
							*/
							%>
							<textarea cols="80" id="<%=column_acc_Id%>" name="<%=column_acc_Id%>" rows="10"><%=dataWithoutNBSP==null?"":dataWithoutNBSP%></textarea>
							
							<!--%=fckEditor%-->
							<script>
								CKEDITOR.replace('<%=column_acc_Id%>', {"width":"800","on":{"instanceReady":function iResize(ev) {var iFrames = jQuery('iframe');var height=0;for (var i = 0, j = iFrames.length; i < j; i++) {height += iFrames[i].contentWindow.document.body.offsetHeight;}ev.editor.resize(800,height+200);}}});
							</script>
						<%}else if ( ds.getObjectType()==DisplaySetting.OBJ_FILE){%>		
							<input id="<%=column_acc_Id%>" type='hidden' name="<%=inputName%>" value="<%=dataDB==null?"":dataDB%>">
							<span id="att_<%=column_acc_Id%>"><%=dataWithoutNBSP==null?"":dataWithoutNBSP%></span>
						<%}else if(ds.getObjectType()==DisplaySetting.OBJ_IMAGE){
							int maximagewidth= (colspan==1?200:500);
							%>
							<input type='hidden' id="<%=column_acc_Id%>" name="<%=inputName%>" value="<%=dataDB==null?"":dataDB%>">
							<%
							String imgHREFStyle="";
							String Pdata="";
							if(nds.util.Validator.isNull((String)dataDB)){
								imgHREFStyle="style='display:block;'";
							}
							if(dataDB!=null&&((String)dataDB).indexOf("Attach")>0){
								Pdata=dataDB+"&thum=Y";
							}else{
								Pdata=(String)dataDB;
							}
							int width=0;
							int height=0;
							if(column.getJSONProps()!=null){
								JSONObject jori=column.getJSONProps();
								if(jori.has("imageshowsize")){
									JSONObject isjo=jori.optJSONObject("imageshowsize");
									if(isjo.has("width")){width=isjo.optInt("width",0);}
									if(isjo.has("height")){height=isjo.optInt("height",0);}
								}
							}
							String st="style=\"background: #007BFF;";
							if(width>0){st+="width:"+width+"px;";}
							if(height>0){st+="height:"+height+"px;";}
							st+="\"";
							%>
							<a style="width:20px;" <%=imgHREFStyle%> id="imga_<%=column_acc_Id%>" target="_blank" href="<%=dataDB==null?"/html/nds/oto/themes/01/images/upimg.jpg":dataDB%>"><img id="img_<%=column_acc_Id%>" <%=st%>  border=0 src="<%=dataDB==null?"/html/nds/oto/themes/01/images/upimg.jpg":Pdata%>" class="img-<%=columnsPerRow%>-<%=colspan%>"  >
							<%if(column.getJSONProps()!=null&&dataDB!=null){
								JSONObject jor=column.getJSONProps();
								if(jor.has("imgshow")){
									JSONObject img_opt=null;
									JSONObject jo=column.getJSONProps().getJSONObject("imgshow");
									if(jo.has("option")){
										img_opt=jo.getJSONObject("option");
									}
									%>
									<script>
										try{jQuery('#imga_<%=column_acc_Id%>').jqzoom(<%=img_opt%>);}catch(e){};
									</script>
								<%}
							}%>
							</a>
						<%}else if( ds.getObjectType()==DisplaySetting.OBJ_XML){
							java.util.Hashtable hxml = new java.util.Hashtable();
							hxml.put("tabIndex", (++tabIndex)+"");
							
							hxml.put("class",ds.getRows()>1? TableQueryModel.getTextAreaInputCssClass(columnsPerRow,column):TableQueryModel.getTextInputCssClass(columnsPerRow,column));
							String filterXml=(dataDB==null?"":dataDB.toString());
							nds.schema.Filter fo=new nds.schema.Filter(filterXml);
							%>
							<input:filter id="<%=column_acc_Id%>" columnId="<%=String.valueOf(column.getId())%>" desc="<%=fo.getDescription()%>" xml="<%=filterXml%>" name="<%=inputName%>" attributes="<%=hxml%>" attributesText=""/>
						<%}else{
							throw new NDSException("Unexpected condition flow reached for "+ column +"("+ds.getObjectType()+")!"+ ", values="+ values);
						}
						// adding button if possible
						if(column.getReferenceTable() !=null){
							if(isFixedColumn==false){
								%>
								<span id="<%=namespace%>cbt_<%=column.getId()%>"  onclick="<%=fkQueryModel.getButtonClickEventScript()%>"><img border=0 width=16 height=16 align=absmiddle src="/html/nds/oto/themes/01/images/find.gif" title='<%= PortletUtils.getMessage(pageContext, "open-new-page-to-search" ,null)%>'></span>
								<script>
									<%if(Validator.isNotNull(column.getRegExpression())){%>
										createAction("<%=column_acc_Id%>", "<%=column.getRegExpression()%>");
									<%}%>	
									createButton(document.getElementById("<%=namespace%>cbt_<%=column.getId()%>"));
								</script>
								<%if (coid !=-1){%>
									<a <%=fkURLTarget%> href="/html/nds/oto/object/object.jsp?table="+column.getReferenceTable().getId()+"&id="+coid%>'><img border="0" src="/html/nds/oto/themes/01/images/out.png"/></a>
								<%}
							}
						}else if(column.getJSONProps()!=null){
							//动态配置弹出动作定义qlink
							  JSONObject jor=column.getJSONProps();
							if(jor.has("qlink")){
								JSONObject jo=column.getJSONProps().getJSONObject("qlink");
								String on_ac=jo.optString("ac","");
								%>
									<span id="<%=namespace%>cbt_<%=column.getId()%>" tab="<%=column.getJSONProps().optString("tab")%>" onclick="<%=on_ac%>"><img border=0 width=16 height=16 align=absmiddle src='/html/nds/oto/themes/01/images/find.gif' title='Find'></span>
								 <%
							}
						}
						if ( ds.getObjectType()==DisplaySetting.OBJ_FILE ||ds.getObjectType()==DisplaySetting.OBJ_IMAGE ){
								if(column.getJSONProps()!=null){
								JSONObject jor=column.getJSONProps();
								if(jor.has("imgfold")){
								String imgfold=column.getJSONProps().getString("imgfold");
								String onsuccess=column.getJSONProps().optString("onsuccess");
								String onfail=column.getJSONProps().optString("onfail");
								Boolean isthm=column.getJSONProps().optBoolean("isthum");
								int width=column.getJSONProps().optInt("width");
								int hight=column.getJSONProps().optInt("height");
								if(imgfold.equals("webhome")){%>
								<input id="<%=namespace%>upload_<%=column.getId()%>" name="file1" size="35" type="file"/>
								<script>
								var upinit={
									'sizeLimit':1024*1024 *1,
									'buttonText'    : "上传图片",
									'fileDesc'      : "上传图片(dat)",
									'fileExt'       :'*.dat;'
								};
								var upload_<%=column.getId()%>={
									"JSESSIONID":"<%=session.getId()%>",
									"isThum":<%=isthm%>,
									"width":<%=width%>,
									"hight":<%=hight%>,
									"onsuccess":"<%=onsuccess%>",
									"onfail":"<%=onfail%>",
									"modname":"<%=table.getName()%>"
								};
								jQuery(document).ready(function(){
									 fup.initForm(upinit,upload_<%=column.getId()%>,"<%=namespace%>upload_<%=column.getId()%>");
								});
								</script>
								<%}%>
								<%}}else{%>
							<span id="<%=namespace%>att_<%=column.getId()%>" onclick="javascript:showDialog('<%=NDS_PATH+"/objext/upload.jsp?table="+tableId+"&column="+column.getId()+"&objectid="+objectId+"&input="+column_acc_Id%>',940, 400,false)"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/attach.gif' title='<%= PortletUtils.getMessage(pageContext, "open-new-page-to-config" ,null)%>'>
							</span>
							<script>
								createButton(document.getElementById("<%=namespace%>att_<%=column.getId()%>"));
							</script>
							<%}
						}
						//自动备注显示 cyl 10.11
						//out.print(showcomment);
						if (showcomment.equals("Y")){
							//out.print(showcomment);
							String rms=TableManager.getInstance().getComments(column);
							%>
							<div id="rms_<%=column.getId()%>" class="obj-rms_v"><%=rms==null?"":rms%></div>
							<!--script type="text/javascript">  
								jQuery(function(){  
									jQuery("#column_"+<%=column.getId()%>).focus(function () {  
												jQuery("#rms_"+<%=column.getId()%>).css('display','block'); 
									}).blur(function () {  
										jQuery("#rms_"+<%=column.getId()%>).css('display','none');
									});  
								});  
							</script-->
						<%}
				   
					}// end if column isModifiable()
					else{ // begin column not isModifiable()
						if( column.getReferenceTable() !=null){
							if( data==null || "".equals(data)){%> 
								<%= PortletUtils.getMessage(pageContext, "maintain-by-sys" ,null)%>
								
							<%}else{
								//String objectURL=QueryUtils.getTableRowURL(column.getReferenceTable(),true);
								String objectURL="/html/nds/oto/object/object.jsp?table="+column.getReferenceTable().getId();
								%>
								<a <%=fkURLTarget%> href='<%=objectURL+"&input=false&id="+coid%>'><span id="<%=column_acc_Id%>"><%=data%></span></a>
							<%}
						}else{
							// button check
							if(ds.getObjectType()==DisplaySetting.OBJ_BUTTON){
								nds.web.button.ButtonCommandUI uic= (nds.web.button.ButtonCommandUI)column.getUIConstructor();
								out.print( uic.constructHTML(request, column, objectId));
							}else{// not button
								if( data ==null || "".equals(data)){%>
									<%= PortletUtils.getMessage(pageContext, "maintain-by-sys" ,null)%>
								<%}else{
									if(ds.getObjectType()==DisplaySetting.OBJ_IMAGE){
										int maximagewidth= (colspan==1?200:500);
										if(!nds.util.Validator.isNull((String)dataDB)){
											int width=0;
											int height=0;
											if(column.getJSONProps()!=null){
												JSONObject jori=column.getJSONProps();
												if(jori.has("imageshowsize")){
													JSONObject isjo=jori.optJSONObject("imageshowsize");
													if(isjo.has("width")){width=isjo.optInt("width",0);}
													if(isjo.has("height")){height=isjo.optInt("height",0);}
												}
											}
											String st="style=\"background: #007BFF;";
											if(width>0){st+="width:"+width+"px;";}
											if(height>0){st+="height:"+height+"px;";}
											st+="\"";
											%>
											<a <%=fkURLTarget%> href="<%=dataDB%>"><img <%=st%> border=0 src="<%=dataDB%>" class="img-<%=columnsPerRow%>-<%=colspan%>" onmousewheel="resize_img_by_wheel(this);"></a>
										<%}
									}else{
										if(ds.getObjectType()==DisplaySetting.OBJ_TEXTAREA || ds.getObjectType()==DisplaySetting.OBJ_XML){
											java.util.Hashtable htextArea = new java.util.Hashtable();
											htextArea.put("cols", ""+ ds.getCharsPerRow());
											htextArea.put("rows", ""+  ds.getRows());
											htextArea.put("wrap", "soft");
											htextArea.put("tabIndex", (++tabIndex)+"");
											htextArea.put("class", TableQueryModel.getTextAreaInputCssClass(columnsPerRow,column));
											%>
											<input:textarea name="<%=inputName%>" attributes="<%= htextArea %>" default="<%=dataWithoutNBSP %>" attributesText="readonly"/>
										<%}else if( ds.getObjectType()==DisplaySetting.OBJ_CLOB){
											/**
											net.fckeditor.FCKeditor fckEditor = new net.fckeditor.FCKeditor(request,column_acc_Id,"98%","370px","None", null, "/html/nds/oto/js/fckeditor");
											fckEditor.setValue(dataWithoutNBSP==null?"":dataWithoutNBSP);
										   
										   com.ckeditor.CKEditorConfig settings = new com.ckeditor.CKEditorConfig();
											settings.addConfigValue("width", "800");				 
											com.ckeditor.EventHandler eventHandler = new com.ckeditor.EventHandler();
											eventHandler.addEventHandler("instanceReady", "function iResize(ev) {var iFrames = jQuery('iframe');var height=200;for (var i = 0, j = iFrames.length; i < j; i++) {height += iFrames[i].contentWindow.document.body.offsetHeight;}ev.editor.resize(800,height);}");
											*/
											%>
											<!--%=fckEditor%-->
											<textarea cols="80" id="<%=column_acc_Id%>" name="<%=column_acc_Id%>" rows="10"><%=dataWithoutNBSP==null?"":dataWithoutNBSP%></textarea>
											<script>
											CKEDITOR.replace('<%=column_acc_Id%>', {"width":"800","on":{"instanceReady":function iResize(ev) {var iFrames = jQuery('iframe');var height=0;for (var i = 0, j = iFrames.length; i < j; i++) {height += iFrames[i].contentWindow.document.body.offsetHeight;}ev.editor.resize(800,height+200);}}});
											</script>
										<%}else {
											if(nds.util.Validator.isNotNull(data)){data=data.replaceAll("<ori>.*</ori>", "");}
											%>
											<span id="<%=column_acc_Id%>"><%=data%></span>
										<%}
									}
								}
							}
						}
					}

				}//end if value ==null
			}// end security grade check          
			%>
		</td>
		<%
		if(colIdx%columnsPerRow == (columnsPerRow -1)){out.print("</tr>");}
	}//for(int i=0;i< columns.size();i++)
	%>
</table>

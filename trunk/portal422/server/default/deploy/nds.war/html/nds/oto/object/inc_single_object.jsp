<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<table class="<%=uiConfig.getCssClass()%>" cellspacing="0" cellpadding="0" align="center">
	<%
    colIdx=-1;
	rowspans=new JSONArray();
	currentrow=-1;
    for(int i=columnIndex;i< columns.size();i++){
    	colIdx++;
    	columnIndex++;
		isFind=false;
        column=(Column)columns.get(i);
        String showcomment=column.getShowcomment();
        ds= column.getDisplaySetting();
        String attributesText="";//Validator.isNull(column.getRegExpression())? " ": column.getRegExpression()+" ";
		colspan=ds.getColumns()>columnsPerRow?columnsPerRow:ds.getColumns();
		currentEvent="";
		refTable= column.getReferenceTable();
		/**Note : the inputName should not get from model, which is for Query, not this one*/	//String inputName=model.getNameForInput(column);
        inputName=column.getName().toLowerCase();
	    column_acc_Id="column_"+column.getId();
        type=model.toTypeIndicator(column,column_acc_Id,locale);
        if(refTable !=null){inputName=inputName+"__"+ refTable.getAlternateKey().getName().toLowerCase();}
		
		String desc=  model.getDescriptionForColumn(column);
        dataWithoutNBSP=null;
        if(result !=null){
              data=result.getString(i+1,true);
              dataWithoutNBSP=result.getString(i+1,false);
              coid=result.getObjectID( i+1);
              dataDB =result.getObject(i+1);
        }else{
        	//dataWithoutNBSP=objprefs.getProperty(column.getName(),column.getDefaultValue(bReplaceVariable));
        	dataWithoutNBSP=objprefs.getProperty(column.getName(), userWeb.getUserOption(column.getName(),column.getDefaultValue(bReplaceVariable)));
        	if(bReplaceVariable)dataWithoutNBSP=userWeb.replaceVariables(dataWithoutNBSP);
        	dataDB = dataWithoutNBSP;
        }
		
		//判断字段是否显示
		if(column.getJSONProps()!=null){
			JSONObject pfjo=column.getJSONProps();
			if(nds.util.Validator.isNull(String.valueOf(dataDB))){dataDB=null;}
			if(pfjo.has("isshow")&&pfjo.optBoolean("isshow",false)){%>
				<div style="dispose:none;"><input type="text" id="<%=inputName%>" name="<%=inputName%>" value=<%=dataDB%> style="display:none;" /></div>
			<%
			continue;
			}
		}
        if(colIdx%columnsPerRow == 0){
        	colIdx=0;
        	if(ds.getObjectType()==DisplaySetting.OBJ_BLANK&& seperateObjectByBlank){
        		break;
        	}
			if(isFold){currentEvent=ds.getObjectType()==DisplaySetting.OBJ_HR &&colIdx==0?"id='"+tableName+"_"+couurntrc+"' onclick='oc.fold(\"#"+tableName+"_"+couurntrc+"\",\"#"+tableName+"_"+(couurntrc+1)+"\")'":"";}
			currentrow++;
			%>
			<tr <%=(ds.getObjectType()==DisplaySetting.OBJ_BLANK?" class='blankrow'":"")%> <%=currentEvent%>>
		<%}
        if(ds.isUIController()){
        	if (ds.getObjectType()==DisplaySetting.OBJ_HR){	// occupy whole row
        		if(colIdx !=0){
					if(isFold){currentEvent="id='"+tableName+"_"+couurntrc+"' onclick='oc.fold(\"#"+tableName+"_"+couurntrc+"\",\"#"+tableName+"_"+(couurntrc+1)+"\")'";}
        			for(int ri=0;ri< columnsPerRow-colIdx;ri++) out.print("<td>&nbsp;</td><td>&nbsp;</td>");
					out.print("</tr><tr "+currentEvent+">");
        		}
        		//out.print("<td colspan='"+(columnsPerRow*2)+"'><font class='beta'><b>"+column.getDescription(locale)+"</b></font><div class='hrRule'><span/></div></td>");
        		out.print("<td colspan='"+(columnsPerRow*2)+"'><div class='tabnav-"+columnsPerRow+"'><span>"+column.getDescription(locale)+"</span></div></td>");
        		out.print("</tr>");
        		colIdx=-1;
				couurntrc++;
        	}else{	// blank
        		if(seperateObjectByBlank){
	        		if( colspan> columnsPerRow-colIdx){	// occupy whole row
	        			if(colIdx !=0){
	        				out.print("<td colspan='"+(columnsPerRow-colIdx)*2 +"'/>");
	        				out.print("</tr>");
	        			}
	        		}
	        		break;
        		}else{
	        		if( colspan> columnsPerRow-colIdx){		// occupy whole row
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
        	if(colIdx !=0){
        		for(int ri=0;ri< columnsPerRow-colIdx;ri++) out.print("<td></td><td></td>");
        		out.print("</tr><tr>");
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
			<%	//check security grade
			if( userWeb.getSecurityGrade()>=column.getSecurityGrade()){
				iaz.getHtml(locale,column,request,objectId,result,i,pageContext);
			}// end security grade check          
			%>
		</td>
		<%
		if(colIdx%columnsPerRow == (columnsPerRow -1)){out.print("</tr>");}
	}//for(int i=0;i< columns.size();i++)
	%>
</table>
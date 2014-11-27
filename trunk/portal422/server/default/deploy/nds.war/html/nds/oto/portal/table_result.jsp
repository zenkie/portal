<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*"%>
<%!
    private final static int SELECT_NONE=1;
    private final static int SELECT_SINGLE=2;
    private final static int SELECT_MULTIPLE=3;
    private final static int MAX_COLUMNLENGTH_WHEN_TOO_LONG=20;//QueryUtils.MAX_COLUMN_CHARS -3
	/**
	* if s.length()> maxLength, return it's first maxLength chars, else, return full
	*/
	private String getStringOfLimitLength(String s, int maxLength){
		return ( s.length()> maxLength)?s.substring(0,maxLength-1):s;
	}
%>

<%
/**
  Fetch "result" from HttpRequest.Attribute, and construct result data
  This page is used for client to request server constructing query result html code directly
  @see AjaxController.query for more details
 */
 QueryResult result=(QueryResult) request.getAttribute("result");
 if(result==null) {
 	out.print("No data");
 	return;
 }
QueryRequest qRequest =result.getQueryRequest();
TableManager manager= TableManager.getInstance();


boolean isMultiSelectEnabled=true;
int returnType=SELECT_NONE;	
int range = qRequest.getRange();


String[] showColumns = qRequest.getDisplayColumnNames(false);
int[] showColumnsIds = qRequest.getDisplayColumnIndices();
String[] showColumnLinks = new String[showColumns.length];
for(int i =0;i < showColumns.length;i++){
	int[] tmp = qRequest.getSelectionColumnLink(showColumnsIds[i]);
	showColumnLinks[i] = "";
	for(int j=0;j < tmp.length;j++){
		if(j > 0) showColumnLinks[i] += ",";
		showColumnLinks[i] += tmp[j];
	}
}

int count = result.getRowCount();
int totalCount = result.getTotalRowCount();
int startIndex = qRequest.getStartRowIndex()+1;// 0 is the begin
int endIndex = startIndex + qRequest.getRange()-1;
endIndex = (endIndex > totalCount)?totalCount:endIndex;
if(startIndex > totalCount){startIndex=0;endIndex=0;}
CollectionValueHashtable tableAlertHolder=new CollectionValueHashtable();
QueryResultMetaData meta=result.getMetaData();
if(result.getRowCount() == 0){
    out.print("<tr style='display: none;'><td colspan='"+ (meta.getColumnCount()+1) +"'></td></tr>");
	return;
}
    
int totalLength =10;// serial no length
String[] columnAligns= new String[meta.getColumnCount()]; //  left, center,  right
int type;
for( int i=0;i< meta.getColumnCount();i++){
	Column colmn=manager.getColumn(meta.getColumnId(i+1));
	totalLength += colmn.getLength();
	type= colmn.getType();
	columnAligns[i]= (( type== Column.DATE)? "left": (type== Column.NUMBER)? "right":"left");
}
// alway align first column ( always the object id) to left
columnAligns[0]= "left";

//String queryPath= contextPath+"/servlets/viewObject?table=";//Hawke
String queryPath= NDS_PATH+"/oto/object/object.jsp?input=false&table=";//Hawke
int pkId= qRequest.getMainTable().getPrimaryKey().getId();

int serialno=startIndex -1, currentId; 
boolean whiteBg= false;
    
Object tmpAKValue;
String akData;
//int currentO=0;
int cltId=-1;
//int levid=-1;
int parentcid=-1;
boolean isParent=false;
boolean isFold=false;
int levvalue=-1;
String clt=null;
String orders=null;
String Parentcolumn=null;
//String levcolumn=null;
Column cl=null;
Table table=result.getQueryRequest().getMainTable();
JSONObject porper=table.getJSONProps();
if(porper !=null&&porper.has("fold")){isFold=porper.optBoolean("fold");}
//if(porper !=null&&porper.has("correlation")){clt=porper.optString("correlation");}else{isFold=false;}
if(porper !=null&&porper.has("orders")){orders=porper.optString("orders");}else{isFold=false;}
if(porper !=null&&porper.has("parentcolumn")){Parentcolumn=porper.optString("parentcolumn");}else{isFold=false;}
//if(porper !=null&&porper.has("levcolumn")){levcolumn=porper.optString("levcolumn");}else{isFold=false;}
/*if(nds.util.Validator.isNotNull(clt)){
	cl=table.getColumn(clt);
	if(cl.getReferenceTable()!=null){
		ColumnLink cll= new ColumnLink(table.getName()+"."+ cl.getName()+";"+cl.getReferenceTable().getAlternateKey().getName());
		cltId=meta.findPositionInSelection(cll);
	}else{
		cltId=meta.findPositionInSelection(cl);
	}
}*/
if(nds.util.Validator.isNotNull(orders)){
	cl=table.getColumn(orders);
	if(cl.getReferenceTable()!=null){
		ColumnLink cll= new ColumnLink(table.getName()+"."+ cl.getName()+";"+cl.getReferenceTable().getAlternateKey().getName());
		cltId=meta.findPositionInSelection(cll);
	}else{
		cltId=meta.findPositionInSelection(cl);
	}
	if(cltId<=-1){isFold=false;}
}else{
	isFold=false;
}
if(nds.util.Validator.isNotNull(Parentcolumn)){
	cl=table.getColumn(Parentcolumn);
	parentcid=meta.findPositionInSelection(cl);
	if(parentcid<=-1){isFold=false;}
}else{
	isFold=false;
}
String values=null;

Object o=null;
ArrayList al=qRequest.getAllSelectionColumns();
JSONArray ja=null;
JSONObject joo=new JSONObject();
	

boolean isShow=true;
String[] stors=null;
while(result.next()){
	if(serialno%1==0) whiteBg = (whiteBg==false);
	serialno ++;
	levvalue=0;
	// first column is id
	String itemId = result.getObject(1).toString();
	if(cltId>-1){
		values=String.valueOf(result.getObject(cltId+1));
		if(nds.util.Validator.isNotNull(values)){
			stors=values.split("_");
			levvalue=stors.length-1;
		}
	}
	if(parentcid>-1){
		isParent="Y".equalsIgnoreCase(String.valueOf(result.getObject(parentcid+1)));
	}	
	/*if(levid>-1){
		levvalue=Tools.getInt(result.getObject(levid+1),-1);
	}*/
	//if(isFold&&nds.util.Validator.isNull(values)){currentO++;}
	%>

	<!--tr id='<!--%=itemId%>_templaterow' class='<!--%=(whiteBg?"even-row":"odd-row")%>'-->
	<tr id='<%=itemId%>_templaterow' <%=(isFold?"oa='"+values+"'":"")%>>
		<%
		String resPkId = null; 
		String tdAttributes;
		Column colmn;
		// get AK first
		/*tmpAKValue = result.getAKValue();
		if(tmpAKValue ==null)akData="";
		else akData = tmpAKValue.toString();*/
		
		for(int i=0;i< meta.getColumnCount();i++){
			tdAttributes="";
			String columnData=result.getString(i+1, true);
			String originColumnData= result.getString(i+1, false);
			Object originColumnDataObj=result.getObject(i+1);
			colmn=manager.getColumn(meta.getColumnId(i+1));

			porper=colmn.getJSONProps();
			if(porper!=null&&porper.has("tableshow")){
				isShow=porper.optBoolean("tableshow",true);
			}else{isShow=true;}
			
			
			if(colmn.getMoney() != null)
				columnData = StringUtils.displayMoney(originColumnData, colmn.getMoney());
			String url=null,tname = colmn.getTable().getDescription(locale);
			int objId= result.getObjectID(i+1);

			if(objId!=-1){
				url=queryPath+ colmn.getTable().getId() +"&id="+objId;
			}
			if( objId != -1){
				String aUrl = "'javascript:pc.fk("+colmn.getTable().getId()+","+objId+")'";
				//if( colmn.getLength()>QueryUtils.MAX_COLUMN_CHARS && columnData.length()>MAX_COLUMNLENGTH_WHEN_TOO_LONG ){
				if(columnData.length()>colmn.getLength()){
					columnData= "<span su=\""+columnData.length()+"\" u=\""+colmn.getLength()+"\" title=\""+columnData+"\">"+getStringOfLimitLength(columnData,colmn.getLength())+"..."+"</span>";
					//columnData= "<span title=\""+columnData+"\">"+getStringOfLimitLength(columnData,MAX_COLUMNLENGTH_WHEN_TOO_LONG)+"..."+"</span>";
					//columnData= "<a href="+aUrl+" title=\""+columnData+"\">"+getStringOfLimitLength(columnData,MAX_COLUMNLENGTH_WHEN_TOO_LONG)+"..."+"</a>";

				}else{
					//columnData="<a href="+aUrl+">"+ columnData+"</a>";
				}
				columnData="<a href="+aUrl+"><img border='0' src='/html/nds/images/out.png'/></a>&nbsp;"+columnData;
			}else{
				if(nds.util.Validator.isNotNull(columnData)&&columnData.indexOf("<ori>")>-1){
					columnData=columnData.replaceAll("<ori>.*(?=</ori>)</ori>", "");
				}
				//if( colmn.getLength()>QueryUtils.MAX_COLUMN_CHARS && columnData.length()>MAX_COLUMNLENGTH_WHEN_TOO_LONG){
				if(columnData.length()>colmn.getLength()){
					if( Tools.isHTMLAnchorTag(columnData)){
						// just return the columnData
					}else{
						columnData= "<span title=\""+columnData+"\">"+getStringOfLimitLength(columnData,colmn.getLength())+"...</span>";
						//columnData= "<span title=\""+columnData+"\">"+getStringOfLimitLength(columnData,MAX_COLUMNLENGTH_WHEN_TOO_LONG)+"...</span>";
					}
				}else if(colmn.getId() == pkId && meta.getColumnLink(i+1).length()==1){
					itemId = columnData;
					resPkId = columnData;
					tdAttributes="";

				
				
					if(isFold){
						columnData="";
						for(int k=1;k<levvalue;k++){
							columnData+="<div id='category-blank'></div>";
						}
						if(isParent){
							columnData +="<span"+(isFold?" oa='"+values+"_'":" ")+"class='fold-show' href='javascript:void(0);' onclick=\"fold(this,'"+values+"_')\"></span>";
							columnData +="<input class='cbx' type='checkbox' name='itemid' value='" + (itemId)+"' onclick=pc.unselectall(this)>";
							columnData +="<a  class='checkall'  class='numb' >"+ serialno+"</a>";
						}else{
							columnData +="<div id='category-b'></div>";
							columnData +="<input class='cbx' type='checkbox' name='itemid' value='" + (itemId)+"' onclick=pc.unselectall(this)>";
							columnData +="<a  class='checkall'  class='numb' >"+ serialno+"</a>";
						}
					}else{
						columnData ="<input class='cbx' type='checkbox' name='itemid' value='" + (itemId)+"' onclick=pc.unselectall(this)>";
						columnData +="<a  class='checkall'  class='numb' >"+ serialno+"</a>";
					}
				
				}else{
					if(colmn.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_BUTTON){
						nds.web.button.ButtonCommandUI uic= (nds.web.button.ButtonCommandUI)colmn.getUIConstructor();
						columnData= uic.constructHTML(request, colmn, Tools.getInt(result.getObject(1),-1));
					}else if(colmn.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_IMAGE){
						//System.out.print("columnData is"+columnData);
						String img_src=(columnData=="&nbsp;"?"/html/nds/oto/themes/01/images/upimg.jpg":columnData);
						columnData="<a id=\"imga_col"+colmn.getId()+"_"+itemId+"\" target=\"_blank\" href=\""+img_src+"\">";
						columnData+="<img src=\""+img_src+"\"  height=\"50px\" style=\"float: left;padding-left:0px\"></a>";
						if(colmn.getJSONProps()!=null&&img_src!=null&&!img_src.equals("&nbsp;")){
							JSONObject jor=colmn.getJSONProps();
							if(jor.has("imgshowlist")){
								JSONObject img_opt=null;
								JSONObject jo=colmn.getJSONProps().getJSONObject("imgshowlist");
								//System.out.print(jo);
								if(jo.has("rfcolumn")&&jo.optInt("rfcolumn",-1)>0){
									//System.out.print("rfcolumn->"+jo.optInt("rfcolumn"));
									Column lable_col=manager.getColumn(jo.optInt("rfcolumn"));
									int pos=meta.findPositionInSelection(lable_col);
									String rfcolumn_des= result.getString(pos+1,false);
									columnData+="<span title=\""+rfcolumn_des+"\" style=\"display: inline-block; text-align: left; margin-left: 10px\">"+rfcolumn_des+"</span>";
									}
								if(jo.optString("method").equals("jq")&&jo.has("option")){
									img_opt=jo.getJSONObject("option");
									columnData+="<script>try{jQuery(\"#imga_col"+colmn.getId()+"_"+itemId+"\").jqzoom("+img_opt+");}catch(e){};</script>";
								}else if(jo.optString("method").equals("sp")){
									columnData+="<script>try{jQuery(\"#imga_col"+colmn.getId()+"_"+itemId+"\").imgShowPop();}catch(e){};</script>";
								}else if(jo.optString("method").equals("box")){
									columnData+="<script>try{jQuery(\"#imga_col"+colmn.getId()+"_"+itemId+"\").imgbox();}catch(e){};</script>";
								}
										//columnData="<img src=\""+columnData+"\" width=\"50px\" height=\"50px\" style=\"float: left;padding-left:5px\">";
							}
						}
					}else if(colmn.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_CHECK){
						if("Y".equals(originColumnDataObj)){
							columnData="<span class='ckbox'/>";
							//<input type='checkbox' value='Y' class='cbx' onclick='return false' checked />
						}else{
							columnData="<span class='unckbox'/>";
						}
					}        
				} 
			}
			nds.web.alert.ColumnAlerter ca=(nds.web.alert.ColumnAlerter)colmn.getUIAlerter();
			if(ca!=null){
				String rowCss=ca.getRowCssClass(result, i+1, colmn);
				if(nds.util.Validator.isNotNull(rowCss ))tableAlertHolder.add(itemId, rowCss);
			}
			%>
			<td nowrap align="<%=columnAligns[i]%>" <%=tdAttributes%> height="40px" <%=!isShow?"style=\"display:none;\"":""%>>
				<%=columnData%>
			<%
			if( TableManager.getInstance().getColumn(colmn.getTable().getName(),"p_step")!=null ){
			   int p_step=Tools.getInt( QueryEngine.getInstance().doQueryOne("select p_step from  "+colmn.getTable().getName()+"  where id="+itemId),0);
			   String iscomplete=(String)QueryEngine.getInstance().doQueryOne("select iscomplete from  "+colmn.getTable().getName()+"  where id="+itemId);
				%>
			   <input id="<%=itemId%>_p_step" name="<%=itemId%>_p_step" type="hidden" value="<%=p_step%>">
			   <input id="<%=itemId%>_iscomplete" name="<%=itemId%>_iscomplete" type="hidden" value="<%=iscomplete%>">
				<%
			}
			%>	
			</td>
			<%
		}// for columns
		%>
	</tr>
	<%
}//end row iteration
%>
<script type="text/javascript">
	<%
	// change row class according to alert setting 
	for(Iterator it=tableAlertHolder.keySet().iterator();it.hasNext();){
		Object rowKey=it.next();
		%>
		$("<%=rowKey%>_templaterow").addClassName("<%=Tools.toString(tableAlertHolder.get(rowKey), " ")%>");
		<%	
	}%>
</script>



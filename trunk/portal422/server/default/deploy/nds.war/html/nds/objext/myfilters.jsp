<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%
	/**
	*  Create filter list for specified table 
	*  param 
	*    fixedcolumns
		In parameter String to specify which cubes should be shown
*                  There has one column named "ad_table_id" in the "c_filter" table, 
*				   This param just specified which table should be queried on.	
	*
	*/
	PairTable fixedColumns=PairTable.parseIntTable(request.getParameter("fixedcolumns"), null);
	TableManager manager=TableManager.getInstance();
	
	Table table= manager.getTable("c_filter");
	
	int colId=manager.getColumn("c_filter","ad_table_id").getId();	

	int mainTableId=Tools.getInt( fixedColumns.get(new Integer(colId)),-1);
	if(mainTableId==-1){
		// try query result, when moving to the second page, mainTableId will be lost as not exists in fixedColumns
		QueryRequestImpl query=(QueryRequestImpl) request.getAttribute("query");
		if(query!=null){
			nds.query.Expression expr=query.getParamExpression();
			if(expr!=null){
				String fixc= expr.findConditionOfColumnLink(new ColumnLink("C_FILTER.AD_TABLE_ID"));
				if(fixc!=null && fixc.length()>1 && fixc.substring(0,1).equals("=")){
					mainTableId=Tools.getInt(fixc.substring(1),-1);
				}
			}
			
		}
	}
	
	fixedColumns=new PairTable();
	fixedColumns.put(new Integer(colId), new Integer(mainTableId));
	fixedColumns.put(new Integer(table.getColumn("ownerid").getId()), new Integer(userWeb.getUserId()));
	
		
	request.setAttribute("table", ""+table.getId());
	request.setAttribute("resulthandler",NDS_PATH+"/objext/myfilters.jsp");
	request.setAttribute("next-screen",NDS_PATH+"/objext/myfilters.jsp?fixedcolumns="+java.net.URLEncoder.encode(fixedColumns.toURLQueryString(null)));
%>
<script>
	document.title="<%=PortletUtils.getMessage(pageContext, "my-filters",null)%>";
</script>
<liferay-util:box top="/html/nds/common/box_top.jsp" bottom="/html/nds/common/box_bottom.jsp">
	<liferay-util:param name="box_title" value="<%= LanguageUtil.get(pageContext, \"my-filters\") %>" />
	<liferay-util:param name="box_width" value="<%= Integer.toString(DEFAULT_TAB_WIDTH) %>" />
	<liferay-util:param name="box_body_class" value="gamma" />
<%

Hashtable urls=new Hashtable();
// following is for updating each record
String modifyLink=NDS_PATH+"/object/object.jsp?table="+table.getId();
urls.put(new Integer(0), modifyLink);
request.setAttribute("urls", urls);


String directory;
directory=table.getSecurityDirectory();
int perm= WebUtils.getDirectoryPermission(directory, request);
boolean isWriteEnabled= ( ((perm & 3 )==3));

if(isWriteEnabled){
	ButtonFactory commandFactory= ButtonFactory.getInstance(pageContext,locale);
	Button btnAdd=commandFactory.getButton("Add");
	Button btnDelete=commandFactory.getButton("Delete");
%>
<table width="98%" border="0" cellspacing="6" cellpadding="0" align="center" >
 <tr><td width="100%" align="left" >
  <%=btnAdd.toHTML()%> <%=btnDelete.toHTML()%>
<Script language="javascript">
 function doDelete(){
	doCommand('ListDelete');
 }
 function doAdd(){
  window.location="<%=NDS_PATH+ "/object/object.jsp?table="+table.getId()+"&fixedcolumns="+java.net.URLEncoder.encode(fixedColumns.toURLQueryString(null))%>";
 } 
</script>
</td></tr>	
</table>	
<%
}//end isWriteEnabled
%> 	

<jsp:include page="<%=NDS_PATH+ \"/objext/inc_list.jsp\"  %>" flush="true" />
</liferay-util:box>
<script>
try{document.attachEvent( "oncontextmenu", showContextMenu );
document.attachEvent( "onkeyup", rememberKeyCode );}catch(ex){}
</script>

<%@ include file="/html/nds/footer_info.jsp" %>

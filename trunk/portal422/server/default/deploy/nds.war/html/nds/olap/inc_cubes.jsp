<liferay-util:box top="/html/nds/common/box_top.jsp" bottom="/html/nds/common/box_bottom.jsp">
	<liferay-util:param name="box_title" value="<%= LanguageUtil.get(pageContext, \"select-query\") %>" />
	<liferay-util:param name="box_width" value="<%= Integer.toString(DEFAULT_TAB_WIDTH) %>" />
	<liferay-util:param name="box_body_class" value="gamma" />
<%

Hashtable urls=new Hashtable();
// following is for updating each record
String modifyLink=NDS_PATH+"/olap/olap.jsp?";
urls.put(new Integer(0), modifyLink);
request.setAttribute("urls", urls);


String directory;
directory=table.getSecurityDirectory();
int perm= WebUtils.getDirectoryPermission(directory, request);
boolean isWriteEnabled= ( ((perm & 3 )==3));
PairTable ptCubes= userWeb.getCubes(mainTableId);// key:Integer (cubeId), value :String (cube name) 
if(isWriteEnabled && ptCubes.size()>0){
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
<%
 if(ptCubes.size()==1){
%>   
  window.location="<%=NDS_PATH+ "/olap/olap.jsp?cube=" + ptCubes.getKey(0)%>";
<%}else{
%>
  window.location="<%=NDS_PATH+ "/objext/selectcube.jsp?table=" +mainTableId%>";
<%}%>
}
</script>
</td></tr>	
</table>	
<%
}//end isWriteEnabled
%> 	

<jsp:include page="<%=NDS_PATH+ \"/objext/inc_list.jsp\"  %>" flush="true" />
</liferay-util:box>

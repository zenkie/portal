
<%
if("deletequery".equals(request.getParameter("command"))){
	//remove queries
	String[] ids=request.getParameterValues("queryid");
	if(ids!=null)for(int i=0;i<ids.length;i++){
%>
	<jp:destroyQuery id="<%="query"+ids[i]%>"/>	
<%
		session.removeAttribute("query"+ids[i]);
		session.removeAttribute("query"+ids[i]+".drillthroughtable");
		session.removeAttribute("table"+ids[i]);
		session.removeAttribute("navi"+ids[i]);
		session.removeAttribute("mdxedit"+ids[i]);
		session.removeAttribute("sortform"+ids[i]);
		session.removeAttribute("print"+ids[i]);
		session.removeAttribute("printform"+ids[i]);
		session.removeAttribute("chartform"+ids[i]);
		session.removeAttribute("chart"+ids[i]);
		session.removeAttribute("toolbar"+ids[i]);
		OLAPQuery.destroy(session, Tools.getInt(ids[i],-1));
	}

}
Collection col=OLAPQuery.getQueryIds(session);
if(col.size()>0){
Button btnDeleteQuery=ButtonFactory.getInstance(pageContext,locale).newButtonInstance("DeleteQuery",pageContext);
%>
<liferay-util:box top="/html/nds/common/box_top.jsp" bottom="/html/nds/common/box_bottom.jsp">
	<liferay-util:param name="box_title" value="<%= LanguageUtil.get(pageContext, \"query-inuse\") %>" />
	<liferay-util:param name="box_width" value="<%= Integer.toString(DEFAULT_TAB_WIDTH) %>" />
	<liferay-util:param name="box_body_class" value="gamma" />
<table width="98%" border="0" cellspacing="6" cellpadding="0" align="center" >
 <tr><td width="100%" align="left" >
  <%=btnDeleteQuery.toHTML()%>
  <span id="tag_close_window"></span>
<Script language="javascript">
 // check show close window button or not
 if(  self==top){
 	document.getElementById("tag_close_window").innerHTML=
 	 "<input type='button' name='Cancle' value='<%= PortletUtils.getMessage(pageContext, "close-window" ,null)%>' onclick='javascript:window.close();' >";
 }
 function doDeleteQuery(){
	submitForm(quries);
 }
</script>
</td></tr>
<tr><td>
<table width="98%" border="0" cellspacing="6" cellpadding="0" align="center" >
<form name="quries" method="post" action="cubes.jsp">
<input type="hidden" name="command" value="deletequery">
<input type="hidden" name="fixedcolumns" value="<%=(fixedColumns!=null?fixedColumns.toURLQueryString(null):"")%>">
 <%
    Iterator it= col.iterator();
    int i=0;
 	for(i=0;i< col.size();i++){
 		if(i%2==0){out.print("<tr>");}
 %>
<td width="50%" align="left" ><%=OLAPQuery.getInstance(session, ((Integer)it.next()).intValue()).toHTML("queryid", NDS_PATH+"/olap/olap.jsp?")%></td>

<%	if(i%2==1){out.print("</tr>");}
	}
	if(i%2==0){out.print("</tr>");}
%>
</form>
</table>
</td></tr></table>
</liferay-util:box>
<%}//end col.size()>0
%>


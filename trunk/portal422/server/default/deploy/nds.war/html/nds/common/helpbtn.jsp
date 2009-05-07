<%
if (request.getAttribute("page_help")!=null){
%>
<input class="cbutton" type='button' id="btn_help" name='btn_help' accessKey="H" value='<%=PortletUtils.getMessage(pageContext, "help",null)%>(H)' onclick="popup_window('<%=((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("wiki.help.path","/wiki")+"/Wiki.jsp?page="+request.getAttribute("page_help")%>','ndshelp')">
<%
}else if(request.getAttribute("table_help")!=null){
%>
<input class="cbutton" type='button' id="btn_help" name='btn_help' accessKey="H" value='<%=PortletUtils.getMessage(pageContext, "help",null)%>(H)' onclick="popup_window('<%=NDS_PATH+"/help/index.jsp?table="+request.getAttribute("table_help")%>','ndshelp')">
<%
}
%> 




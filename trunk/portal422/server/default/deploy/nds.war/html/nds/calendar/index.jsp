<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>

<%

TableManager manager=TableManager.getInstance();
Table table=null;

int tableId= ParamUtils.getIntAttributeOrParameter(request,"table", -1);

if( tableId == -1){
    // try table as String
    String tableName= ParamUtils.getParameter(request,"table");
    table= manager.getTable(tableName);
    
}else{
    table= manager.getTable(tableId);
}
if( table ==null){
	response.sendRedirect(NDS_PATH+"/objext/blank.jsp");
	return;	
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">

<title><%=(table==null?"":table.getDescription(locale))%></title>
</head>

<frameset  cols="*" rows="40,*"  border="0" frameborder="1" FRAMESPACING="0" TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">
      <FRAME name="fraCalToolbar" src="<%=NDS_PATH%>/calendar/toolbar.jsp?<%=request.getQueryString()%>" scrolling="no" border="0" frameborder="no" TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" noresize></FRAME>
	  <frame name="listCalFrame" src="<%=NDS_PATH%>/objext/blank.jsp"  TOPMARGIN="0" LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" FRAMEBORDER="0" BORDER="1"></FRAME>
</frameset>
    
<noframes><body>Error: need browser support frameset
</body></noframes>

</html>


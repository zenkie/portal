<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<liferay-util:include page="/html/nds/header.jsp">
	<liferay-util:param name="show_top" value="false" />
</liferay-util:include>
<%!
	private nds.log.Logger logger= nds.log.LoggerManager.getInstance().getLogger("caledar_toolbar");
%>
<%	     
TableManager manager=TableManager.getInstance();
int tableId= ParamUtils.getIntAttributeOrParameter(request, "table", -1);
Table table;
if( tableId == -1) {
    String tableName=  request.getParameter("table") ;
    table= manager.getTable(tableName);
    if( table !=null) tableId= table.getId();
    else {
        out.println("Internal Error:object-not-set");
        return;
    }
}else{
    table= manager.getTable(tableId);
}
if(! (table instanceof CalendarTable)){
	out.println("Internal Error:Not calendar supported table");
	return;
}
CalendarTable ctable=(CalendarTable)table;
if(!ctable.isSupportCalendar()){
	out.println("Internal Error:Table defined as calendar table, but not really supported");
	return;
}
/**------check permission---**/
String directory;
directory=table.getSecurityDirectory();
WebUtils.checkDirectoryReadPermission(directory, request);
/**------check permission end---**/

String title= table.getDescription(locale);
%>
<script>
	function doView(viewType){
		if(viewType!=null) qform.viewtype.value=viewType;
		//qform.action="<%=NDS_PATH%>/calendar/view_"+qform.viewtype.value+".jsp";
		qform.submit();
	}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
<form name="qform" method="post" target="listCalFrame" action="<%=NDS_PATH%>/calendar/view.jsp">
 <input type="hidden" name="table" value="<%=ctable.getId()%>">
 <input type="hidden" name="viewtype" value="month">
 <input type="hidden" name="year" value="">
 <input type="hidden" name="month" value="">
 <input type="hidden" name="day" value="">
 <tr><td class='gamma' width="100%" align="left" >
  &nbsp;&nbsp; <font class="beta" size="2"><a class="beta" href="javascript:doView('day')"><%= PortletUtils.getMessage(pageContext, "day",null)%></a> - <a class="beta" href="javascript:doView('week')"><%= PortletUtils.getMessage(pageContext, "week",null)%></a> -<a class="beta" href="javascript:doView('month')"><%= PortletUtils.getMessage(pageContext, "month",null)%></a> - <a class="beta" href="javascript:doView('year')"><%= PortletUtils.getMessage(pageContext, "year",null)%></a></font>
  &nbsp;&nbsp; 
  <%
  Column fc=ctable.getFilterColumn();
  
  if(fc!=null){
  	String inputId="ft";
  	String url=null;
  	if(fc.getReferenceTable()!=null) url=request.getContextPath()+"/servlets/query?table="+fc.getReferenceTable().getId()+"&return_type=s&accepter_id=qform."+inputId;
  %>
  <%= PortletUtils.getMessage(pageContext, "please-select",null)%><%=fc.getDescription(locale)%>:
        <input id="<%=inputId%>" type="text" class="form-text"  size="30" maxlength="255" name="filter_column" onKeyPress="if (event.keyCode == 13) { doView(); return false;}">
        <%if(url!=null){%>
        <span id="cbt_<%=inputId%>"  onaction=popup_window("<%=url%>")><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/find.gif' alt='<%= PortletUtils.getMessage(pageContext, "open-new-page-to-search" ,null)%>'></span>
		<script>createButton(document.getElementById("cbt_<%=inputId%>"));</script>
		<%}%>
		<input type='button' value='<%= PortletUtils.getMessage(pageContext, "search",null)%>' 
		onclick="javascript:doView()" >
  <%}%>		
</td></tr>
<form>
</table>
<%@ include file="/html/nds/footer.jsp" %>

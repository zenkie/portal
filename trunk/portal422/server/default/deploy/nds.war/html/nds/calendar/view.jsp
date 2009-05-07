<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<liferay-util:include page="/html/nds/header.jsp">
	<liferay-util:param name="show_top" value="false" />
</liferay-util:include>

<%
TableManager manager=TableManager.getInstance();
String viewType= request.getParameter("viewtype");
int tableId= ParamUtils.getIntAttributeOrParameter(request, "table", -1);
CalendarTable table=(CalendarTable)manager.getTable(tableId);
if(!table.isSupportCalendar()){
	out.println("Internal Error:Table defined as calendar table, but not really supported");
	return;
}
/**------check permission---**/
String directory;
directory=table.getSecurityDirectory();
WebUtils.checkDirectoryReadPermission(directory, request);
/**------check permission end---**/
String url= "/html/nds/calendar/view_"+viewType+".jsp";
%>

<script>
document.bgColor="<%=colorScheme.getPortletBg()%>";
function view(viewType, month, day,year){
	window.parent.fraCalToolbar.qform.month.value=month;
	window.parent.fraCalToolbar.qform.day.value=day;
	window.parent.fraCalToolbar.qform.year.value=year;
	window.parent.fraCalToolbar.qform.viewtype.value=viewType;
	window.parent.fraCalToolbar.qform.submit();
}
function showObject(id){
	var url="<%=NDS_PATH%>/object/object.jsp?table=<%=tableId%>&input=true&id="+id;
	popup_window(url);
}
<%
if(table.isEventEditable()){
	PairTable fixedColumns=new PairTable();
	fixedColumns.put(new Integer(table.getAddActionTimeDestColumn().getId()), "REPLACEDATE");
	String creationLink=NDS_PATH+"/object/object.jsp?table="+ tableId+"&fixedcolumns="+java.net.URLEncoder.encode(fixedColumns.toURLQueryString(""),request.getCharacterEncoding())+
	"&next_screen="+java.net.URLEncoder.encode(StringUtils.escapeHTMLTags(NDS_PATH+"/object/object.jsp?table="+ tableId+"&fixedcolumns="+fixedColumns.toURLQueryString("")),request.getCharacterEncoding());
%>
function add(month,day,year){
	var re=/REPLACEDATE/gi;
	var dt=year+"/"+(month+1)+"/"+day;
	//alert("<%=creationLink%>".replace(re, dt));
	popup_window("<%=creationLink%>".replace(re, dt));
}
<%}%>
</script>
<jsp:include page="<%=url%>" flush="true"/>

<%@ include file="/html/nds/footer.jsp" %>

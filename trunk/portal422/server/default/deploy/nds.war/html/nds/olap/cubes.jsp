<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %>
<%@ page import="nds.olap.*" %>
<%
/** 
* param
*   fixedcolumns - In parameter String to specify which cubes should be shown
*                  There has one column named "ad_cube_id.ad_table_id" in the "ad_query" table, 
*				   This param just specified which table should be queried on.	
*/
PairTable fixedColumns=PairTable.parseIntTable(request.getParameter("fixedcolumns"), null);
TableManager manager=TableManager.getInstance();
Table table =manager.getTable("ad_query"); ; // ad_query
int tableId= table.getId();
int colId=manager.getColumn("ad_query","ad_cube_id;ad_table_id").getId();
int mainTableId=Tools.getInt( fixedColumns.get(new Integer(colId)),-1);
if(mainTableId==-1){
	// try query result, when moving to the second page, mainTableId will be lost as not exists in fixedColumns
	QueryRequestImpl query=(QueryRequestImpl) request.getAttribute("query");
	if(query!=null){
		nds.query.Expression expr=query.getParamExpression();
		if(expr!=null){
			String fixc= expr.findConditionOfColumnLink(new ColumnLink("AD_QUERY.AD_CUBE_ID;AD_TABLE_ID"));
			if(fixc!=null && fixc.length()>1 && fixc.substring(0,1).equals("=")){
				mainTableId=Tools.getInt(fixc.substring(1),-1);
			}
		}
		
	}
}
fixedColumns=new PairTable();
fixedColumns.put(new Integer(colId), new Integer(mainTableId));

	request.setAttribute("table", ""+TableManager.getInstance().getTable("AD_QUERY").getId());
	request.setAttribute("resulthandler",NDS_PATH+"/olap/cubes.jsp");
	// screen when delete some queries
	request.setAttribute("next-screen",NDS_PATH+"/olap/cubes.jsp?fixedcolumns="+java.net.URLEncoder.encode(fixedColumns.toURLQueryString(null)));
%>
<script>
	document.title="<%=PortletUtils.getMessage(pageContext, "select-query",null)%>";
</script>
<%@ include file="/html/nds/olap/inc_queries.jsp" %>
<%@ include file="/html/nds/olap/inc_cubes.jsp" %>
<script>
try{document.attachEvent( "oncontextmenu", showContextMenu );
document.attachEvent( "onkeyup", rememberKeyCode );}catch(ex){}
</script>

<%@ include file="/html/nds/footer_info.jsp" %>

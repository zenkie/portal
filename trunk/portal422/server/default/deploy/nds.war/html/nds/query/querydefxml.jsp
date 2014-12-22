<?xml version="1.0"?>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*,org.json.*"%>

<%    /**
     * Needed parameters:
     *  table - the main table id, will list all its columns, and show fk column as has children
     *  parent - the parent node name, children will append ";"+column.dbname as node information
     */

%>
<%
	UserWebImpl userWeb =null;
	userWeb= ((UserWebImpl)WebUtils.getSessionContextManager(session).getActor(nds.util.WebKeys.USER));	
	Locale locale =userWeb.getLocale();
	String NDS_PATH=nds.util.WebKeys.NDS_URI;

String creationLink, title;
TableManager manager=TableManager.getInstance();
String parent=  request.getParameter("parent"); 
String parentDesc="";
if(parent!=null){
  try{
 	parentDesc = new ColumnLink(parent).getDescription(locale)+".";
  }catch(Throwable tdf){}
}
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
ArrayList columns=table.getAllColumns();
%>
<tree>
<%
for(int i=0;i< columns.size();i++){ 
	Column col= (Column)columns.get(i);
	if(col.getUIConstructor()!=null) continue;
	if(col.getDisplaySetting().isUIController()) continue;
	String clink=( parent==null? table.getName()+"."+ col.getName():parent+";"+col.getName());
	String desc= col.getDescription(locale);
	Table rftTable= col.getReferenceTable(true);
		// add reflable desc
	if(col.getJSONProps()!=null){
	JSONObject jor=col.getJSONProps();
	if(jor.has("reflable")){
	JSONObject jo=col.getJSONProps().getJSONObject("reflable");
	 int lable_id=jo.optInt("ref_id",0);
		 int lable_tabid=jo.optInt("tabid",0);
		 Table reftable= TableManager.getInstance().getTable(lable_tabid);
		 QueryRequestImpl query=QueryEngine.getInstance().createRequest(userWeb.getSession());
		 query.setMainTable(lable_tabid);
		 query.addSelection(reftable.getAlternateKey().getId());
		 query.addParam( reftable.getPrimaryKey().getId(), ""+ lable_id);
	   QueryResult rs=QueryEngine.getInstance().doQuery(query); 
	   if(lable_id !=0 || (rs!=null && rs.getTotalRowCount()>0)){
		while(rs.next()) {
		   desc=rs.getObject(1).toString(); 
		}
		}
		}
	}
	if(rftTable!=null){
		String src= java.net.URLEncoder.encode("/html/nds/query/querydefxml.jsp?table="+rftTable.getId()+"&parent="+clink,request.getCharacterEncoding());
		//clink = clink+";"+ rftTable.getAlternateKey().getName();
		String akDesc= parentDesc+desc +"."+ rftTable.getAlternateKey().getDescription(locale);
		//for datenumber, will have addtional add action
		String treeAction="";
%> 	
	<tree text="<%=desc%>" src="<%=src%>" action="javascript:qd.setColumn('<%=clink%>','<%=parentDesc+desc%>')"/>
<%	}else{
		if(col.getSubTotalMethod()!=null){
%> <tree text="<%=desc%>" icon="<%=NDS_PATH%>/images/sum-column.gif" action="javascript:qd.setColumn('<%=clink%>','<%=parentDesc+desc%>')" />
<%	
		}else{	
%> <tree text="<%=desc%>" action="javascript:qd.setColumn('<%=clink%>','<%=parentDesc+desc%>')"/>
<%	
		}
	}
}%></tree>


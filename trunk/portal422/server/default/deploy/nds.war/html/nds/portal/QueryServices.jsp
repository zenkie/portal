<?xml version="1.0"?>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page language="java" pageEncoding="UTF-8" import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*,nds.test.*"%>

<%    /**
     * @param 
      		id - query
     */
     
String queryexp=  ParamUtils.getAttributeOrParameter(request, "query");
String NDS_PATH=nds.util.WebKeys.NDS_URI;
	UserWebImpl userWeb =null;
	try{
		userWeb= ((UserWebImpl)WebUtils.getSessionContextManager(session).getActor(nds.util.WebKeys.USER));	
	}catch(Exception userWebException){
		System.out.println("########## found userWeb=null##########"+userWebException);
	}

Locale locale =userWeb.getLocale();
int userId=userWeb.getUserId();
System.out.println(queryexp);
/*
Table table;
QueryEngine engine=QueryEngine.getInstance();

TableManager manager=TableManager.getInstance();

WebUtils.checkTableQueryPermission(table.getName(),request );
String vsql1="select t.is_patent from tradmarks t where t.id="+objectId;

*/
TableManager manager=TableManager.getInstance();
QueryRequestImpl query;
QueryResult result=null;
String tableId="ad_table";
RegexTest  rg=new RegexTest();
Table table,dataTable;
table= manager.getTable(tableId);
query=QueryEngine.getInstance().createRequest(userWeb.getSession());
query.setMainTable(table.getId());
query.addSelection(table.getColumn("description").getId());
query.addSelection(table.getColumn("name").getId());
if(rg.vd(queryexp)){
query.addParam(table.getColumn("description").getId(), queryexp);
}else{
query.addParam(table.getColumn("name").getId(), queryexp);
}

query.setRange(0, Integer.MAX_VALUE  );
Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
query.addParam(sexpr);
String sql= query.toSQL();
System.out.println(sql);
result= QueryEngine.getInstance().doQuery(query);
QueryResultMetaData meta=result.getMetaData();
System.out.println(result.getRowCount());
List b = new ArrayList(); 
List c = new ArrayList();
for(int j=0;j<result.getRowCount();j++){
    result.next();
    for(int k=1; k<=meta.getColumnCount();k++){
     if(k%2==1){b.add(result.getObject(k));}else{c.add(result.getObject(k));}
    }        
}
//org.json.JSONObject select_m=new org.json.JSONObject(attributeValues);
org.json.JSONObject jo=new org.json.JSONObject();
org.json.JSONArray  arr_key=new org.json.JSONArray(b);
org.json.JSONArray  arr_val=new org.json.JSONArray(c);
jo.put("query",queryexp);
jo.put("suggestions",arr_key);
jo.put("data",arr_val);
//System.out.println(jo.toString());
response.getWriter().print(jo);
  response.getWriter().flush();
  response.getWriter().close(); 
%>
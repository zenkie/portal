<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%
	/**------获取参数---**/
	String paramStr=request.getParameter("paramStr");
	String str1=request.getParameter("username");
	/**------获取参数 end---**/
	TableManager manager=TableManager.getInstance();
	String tableId="WX_APPENDGOODS";
	Table table;
	int temp=-1;//用来区别首页模板的风格
	table= manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);
	
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());  
	query.addParam(table.getColumn("SPEC_DESCRIPTION").getId(),paramStr);
	result= QueryEngine.getInstance().doQuery(query);
	Integer flag = 0;
	System.out.println("result.getRowCount()##################"+result.getRowCount());
	if(result.getRowCount()>0) flag=1;
%>
 <%=flag%>




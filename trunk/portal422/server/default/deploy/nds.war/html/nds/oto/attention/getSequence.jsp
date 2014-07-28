<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%
	TableManager manager=TableManager.getInstance();
	String tableName = request.getParameter("tableid");
	String tableId=tableName;
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	//Connection con=null;
	//con=QueryEngine.getInstance().getConnection();
	//int vipid = QueryEngine.getInstance().getSequence("wx_messageautoitem", con);
	int vipid = QueryEngine.getInstance().getSequence("wx_messageautoitem");
	System.out.println("##################"+vipid);
%>

<%=vipid%>

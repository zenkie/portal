<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,java.util.Iterator,java.sql.ResultSet,java.sql.Clob,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	String dialogURL=request.getParameter("redirect");
	 if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
		response.sendRedirect("/c/portal/login"+
			(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+
				java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
			return;
		}
		
	 if(!userWeb.isActive()){
		session.invalidate();
		com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
		response.sendRedirect("/login.jsp");
		return;
	 }
	String params=request.getParameter("params");
	
	JSONObject jo = new JSONObject(params);
	
	TableManager manager=TableManager.getInstance();
	String tableId=String.valueOf(jo.get("table"));
	Table table;
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
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	
	query.addSelection(table.getColumn("ID").getId());
	
	JSONObject addparamsObj = new JSONObject(String.valueOf(jo.get("params")));
	for (Iterator iter = addparamsObj.keys(); iter.hasNext();){
		String key = (String)iter.next();
		query.addParam(table.getColumn(key).getId(),String.valueOf(addparamsObj.get(key)));
	}
	System.out.println("query%%%"+query);
	result= QueryEngine.getInstance().doQuery(query);
	JSONObject jc = new JSONObject();
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		jc.put(String.valueOf(result.getObject(1)),result.getObject(1));
	}
	
%>
<%=jc%>
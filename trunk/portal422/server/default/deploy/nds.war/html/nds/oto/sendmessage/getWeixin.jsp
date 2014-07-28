<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	//得到公司的二维码和微信号
	TableManager manager1=TableManager.getInstance();
	String tableId1="WEB_CLIENT";
	
	Table table1 = manager1.getTable(tableId1);
	if(table1 ==null) throw new NDSException("Internal Error: message table not found."+ tableId1);
	
	/**------check permission---**/
	String directory1 = table1.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory1, request);
	/**------check permission end---**/
	
	QueryEngine engine1=QueryEngine.getInstance();
	QueryRequestImpl query1 = engine1.createRequest(userWeb.getSession());
	query1.setMainTable(table1.getId());
	query1.addSelection(table1.getColumn("WXNUM").getId());//微信号
	query1.addSelection(table1.getColumn("QRCODE").getId());//微信图像
	
	
	query1.setRange(0, Integer.MAX_VALUE);
	Expression sexpr1= userWeb.getSecurityFilter(table1.getName(), 1);// read permission
	query1.addParam(sexpr1);	
	QueryResult result1 = QueryEngine.getInstance().doQuery(query1);
	result1.next();
	String clientWXNUM = result1.getString(1);
	String clientQRCODE = result1.getString(2);
%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Clob,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*,org.json.JSONObject"%>
<%
String dialogURL=request.getParameter("redirect");
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
}

String id="0";
JSONObject jo=new JSONObject();
JSONObject tree=null;
String trees=null;
String searchmenu="select m.ID,m.MENUCONTENT from wx_menuset m WHERE m.ad_client_id=?";
int ad_client_id=userWeb.getAdClientId();
Object o=null;
//o=QueryEngine.getInstance().doQueryOne(searchmenu,new Object[]{ad_client_id});
List menus=QueryEngine.getInstance().doQueryList(searchmenu,new Object[]{ad_client_id});
if(menus!=null&&menus.size()>0){
	o=((List)menus.get(0)).get(1);
	if(o!=null){
		java.sql.Clob clob=(java.sql.Clob)o;
		Reader inStream = clob.getCharacterStream();
		char[] c = new char[(int) clob.length()];
		inStream.read(c);
		//trees是读出并需要返回的数据，类型是String
		trees = new String(c);
		inStream.close();
		jo=new JSONObject(trees);
	}
	id=String.valueOf(((List)menus.get(0)).get(0));
}
tree=new JSONObject();
tree.put("id",id);
tree.put("menu",jo);
%>
<%=tree%>
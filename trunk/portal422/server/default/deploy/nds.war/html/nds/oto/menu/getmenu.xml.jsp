<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Clob,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
String trees=null;
String searchmenu="select m.MENUCONTENT from wx_menuset m WHERE m.ad_client_id=?";
int ad_client_id=userWeb.getAdClientId();
Object o=QueryEngine.getInstance().doQueryOne(searchmenu,new Object[]{ad_client_id});
java.sql.Clob clob=(java.sql.Clob)o;
Reader inStream = clob.getCharacterStream();
char[] c = new char[(int) clob.length()];
inStream.read(c);
//trees是读出并需要返回的数据，类型是String
trees = new String(c);
inStream.close();
System.out.println("trees======================"+trees);
%>
<%=trees%>
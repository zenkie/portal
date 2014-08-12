<%@page language="Java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
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

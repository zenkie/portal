<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

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
String keyword=request.getParameter("keyword");
if(nds.util.Validator.isNull(keyword)){return;}
int ad_client_id=userWeb.getAdClientId();
if(ad_client_id<=0){return;}
List tuwen;
QueryEngine engine=QueryEngine.getInstance();
String sql="select mai.id,mai.title,mai.url,mai.fromid,mai.objid,maq.keyword"+
		   " from wx_messageautoq maq JOIN wx_messageautoitem mai ON maq.groupid=mai.groupid  AND maq.ad_client_id=mai.ad_client_id"+
		   " WHERE maq.keyword=? and maq.ad_client_id=?";
List allTuWen=engine.doQueryList(sql,new Object[]{keyword,ad_client_id});
if(allTuWen==null||allTuWen.size()<=0){return;}
JSONObject alltwjo=new JSONObject();
JSONObject twjo=null;
for(int i=0;i<allTuWen.size();i++){
	tuwen=(List)allTuWen.get(i);
	twjo=new JSONObject();
	twjo.put("fromid",String.valueOf(tuwen.get(3)));
	twjo.put("objid",String.valueOf(tuwen.get(4)));
	twjo.put("title1",String.valueOf(tuwen.get(1)));
	twjo.put("content1","");
	twjo.put("wx_media_id1","");
	twjo.put("url1",String.valueOf(tuwen.get(2)));
	twjo.put("gourl1","");
	twjo.put("groupid1","");
	twjo.put("imageSize",i==0?"bigImage":"smallImage");
	alltwjo.put(String.valueOf(tuwen.get(5)),twjo);
}
%>
<%=alltwjo.toString()%>

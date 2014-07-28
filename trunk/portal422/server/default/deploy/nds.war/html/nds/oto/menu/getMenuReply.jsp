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

JSONObject messagetype=new JSONObject();
messagetype.put("1","文本");
messagetype.put("2","图片");
messagetype.put("3","语音");
messagetype.put("4","视频");
messagetype.put("5","音乐");
messagetype.put("6","图文");
messagetype.put("7","链接");
int ad_client_id=userWeb.getAdClientId();
if(ad_client_id<=0){return;}
List tuwen;
QueryEngine engine=QueryEngine.getInstance();
String sql="select mai.id,mai.sort,mai.title,mai.url,mai.fromid,mai.objid,maq.keyword,maq.title,maq.content,maq.msgtype,maq.nytype,maq.url,maq.gourl,maq.hurl,1,maq.wx_media_id,maq.count,maq.ad_client_id,maq.groupid,maq.urlcontent,mai.content"+
		   " from wx_messageautoq maq LEFT JOIN wx_messageautoitem mai ON maq.groupid=mai.groupid  AND maq.ad_client_id=mai.ad_client_id"+
		   " WHERE maq.ad_client_id=? ORDER BY maq.keyword ASC,mai.sort";
List allMenuKeyword=engine.doQueryList(sql,new Object[]{ad_client_id});
JSONObject allMenuKeywordjo=new JSONObject();
allMenuKeywordjo.put("ad_client_id",ad_client_id);
JSONObject menujo=null;
JSONObject twjo=null;
java.sql.Clob clob=null;
Reader inStream=null;
char[] c=null;
String colbvalue="";
int csort=0;
int sort=0;
String keyword=null;//request.getParameter("keyword");
if(allMenuKeyword!=null&&allMenuKeyword.size()>0){
	for(int i=0;i<allMenuKeyword.size();i++){
		csort=0;
		tuwen=(List)allMenuKeyword.get(i);
		keyword=String.valueOf(tuwen.get(6));
		if(!allMenuKeywordjo.has(keyword)){
			menujo=new JSONObject();
			
			menujo.put("keyword",keyword);
			menujo.put("title",String.valueOf(tuwen.get(7)));
			clob=(java.sql.Clob)tuwen.get(8);
			if(clob==null){colbvalue="";}
			else{
				inStream = clob.getCharacterStream();
				c = new char[(int) clob.length()];
				inStream.read(c);
				colbvalue=new String(c);
				inStream.close();
			}
			menujo.put("content",colbvalue);
			menujo.put("msgtype",messagetype.optString(String.valueOf(tuwen.get(9))));
			menujo.put("nytype",String.valueOf(tuwen.get(10)));
			menujo.put("url",String.valueOf(tuwen.get(11)));
			menujo.put("gourl",String.valueOf(tuwen.get(12)));
			menujo.put("hurl",String.valueOf(tuwen.get(13)));
			menujo.put("num",String.valueOf(tuwen.get(14)));
			menujo.put("wx_media_id",String.valueOf(tuwen.get(15)));
			menujo.put("count",String.valueOf(tuwen.get(16)));
			menujo.put("ad_client_id",ad_client_id);
			menujo.put("pptype","Y");
			menujo.put("groupid",String.valueOf(tuwen.get(18)));
			/*clob=(java.sql.Clob)tuwen.get(19);
			if(clob==null){colbvalue="";}
			else{
				inStream = clob.getCharacterStream();
				c = new char[(int) clob.length()];
				inStream.read(c);
				colbvalue=new String(c);
				inStream.close();
			}
			menujo.put("urlcontent",colbvalue);*/
			menujo.put("urlcontent",String.valueOf(tuwen.get(19)));
			menujo.put("tuwen",new JSONObject());
			allMenuKeywordjo.put(keyword,menujo);
		}
		
		if("6".equalsIgnoreCase(String.valueOf(tuwen.get(9)))){
			twjo=new JSONObject();
			colbvalue="";
			twjo.put("objid",String.valueOf(tuwen.get(5)));
			twjo.put("fromid",String.valueOf(tuwen.get(4)));
			twjo.put("url1",String.valueOf(tuwen.get(3)));
			twjo.put("title1",String.valueOf(tuwen.get(2)));
			try{sort=java.lang.Integer.parseInt(String.valueOf(tuwen.get(1)));}
			catch(Exception e){sort=10;}
			twjo.put("sort",sort);
			clob=(java.sql.Clob)tuwen.get(20);
			if(clob==null){colbvalue="";}
			else{
				inStream = clob.getCharacterStream();
				c = new char[(int) clob.length()];
				inStream.read(c);
				colbvalue=new String(c);
				inStream.close();
			}
			twjo.put("content1",colbvalue);
			//twjo.put("content1","");
			twjo.put("wx_media_id1","");
			twjo.put("gourl1","");
			twjo.put("groupid1","");
			twjo.put("imageSize",sort==0?"bigImage":"smallImage");
			//allMenuKeywordjo.put(keyword,twjo);
			csort++;
			allMenuKeywordjo.optJSONObject(keyword).optJSONObject("tuwen").put(String.valueOf(tuwen.get(0)),twjo);
		}
	}
}
%>
<%=allMenuKeywordjo.toString()%>
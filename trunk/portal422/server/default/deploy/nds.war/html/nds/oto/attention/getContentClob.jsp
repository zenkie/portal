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
	/**------获取参数---**/
	String tid=request.getParameter("tid");
	String tableName=request.getParameter("tableName");
	/**------获取参数 end---**/
	String content=null;
	String searchmenu="select m.ORGINALCONTENT from "+tableName+" m WHERE m.ad_client_id=? and m.id = ?";
	int ad_client_id=userWeb.getAdClientId();
	Object o=QueryEngine.getInstance().doQueryOne(searchmenu,new Object[]{ad_client_id,tid});
	System.out.println("========"+o+"==="+searchmenu+",ac="+ad_client_id+",tid="+tid);
	if(o==null || o.equals("")){
		content = "";
		return;
	}
	java.sql.Clob clob=(java.sql.Clob)o;
	Reader inStream = clob.getCharacterStream();
	char[] c = new char[(int) clob.length()];
	inStream.read(c);
	//trees是读出并需要返回的数据，类型是String
	content = new String(c);

	//JSONObject jo = new JSONObject(content);
	inStream.close();
%>
<%=content%>


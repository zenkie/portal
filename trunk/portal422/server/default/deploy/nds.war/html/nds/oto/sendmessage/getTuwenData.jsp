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
	 
	String groupid=request.getParameter("groupid");//图文id
	TableManager manager=TableManager.getInstance();
	String tableId="WX_NOITFYITEM";
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory=table.getSecurityDirectory();
	QueryEngine engine=QueryEngine.getInstance();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());	
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("TITLE").getId());
	query.addSelection(table.getColumn("URL").getId());
	
	query.addParam(table.getColumn("GROUPID").getId()," = "+groupid);
	Column sortOrderNo = table.getColumn("SORT");
	int colOrder[];
	if(sortOrderNo!=null) 
		colOrder=new int[]{sortOrderNo.getId()};
	else
		colOrder= new int[]{table.getColumn("ID").getId()};
	query.setOrderBy(colOrder, true);	
	QueryResult result = QueryEngine.getInstance().doQuery(query);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="/html/nds/oto/sendmessage/css/tuwen.css">
</head>
<body>
<div id="menu" class="wap-preview">
<div class="content" style=" overflow-y: auto; overflow-x: hidden;">
<div class="msg-item multi-msg" style="margin: 4%;height:400px">
<%
		String id = "";
		String title="";
		String url="";
		for (int i=0;i<result.getRowCount();i++){
				result.next();
				id = result.getObject(1).toString();
				title = result.getObject(2).toString();
				url = result.getObject(3).toString();
				if(i == 0){
				%>				
				 <div class="appmsgItem sub-msg-opr-show" style="border-top: 1px solid #ccc;">
					<p class="msg-meta">
					  <span class="msg-date">
						&nbsp;
					  </span>
					</p>
					<div class="cover" style="height:100px">
					  <div class="msg-t h4" style="height: 50px;font-size: 12px;text-align: left;">
						<span id="spnTitle" class="i-title">
						  <%=title%>
						</span>
					  </div>
					  <img id="imgPic" class="i-img" style="display: block;" src="<%=url%>">
					</div>
				  </div>
				<%
				}else{
				%>
				<div class="rel sub-msg-item appmsgItem">
					<span class="thumb">
					  <img class="i-img" style="display:block;" src="<%=url%>">
					</span>
					<div class="msg-t h4" style="text-align: left;font-size: 12px;">
					  <span class="i-title">
						<%=title%>
					  </span>
					</div>
				 </div>
				<%
				}
		}
%>
</div>
</body>
</html>
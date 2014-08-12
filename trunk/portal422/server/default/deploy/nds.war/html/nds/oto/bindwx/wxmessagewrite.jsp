<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	TableManager manager=TableManager.getInstance();
	String tableId="WX_INTERFACESET";//微信接口配置
	Table table=manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);	
	/**------check permission---**/
	String directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());//读取该表的字段
	query.addSelection(table.getColumn("URL").getId());
	query.addSelection(table.getColumn("WXTOKEN").getId());
	query.setRange(0, Integer.MAX_VALUE);
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);
	QueryResult result= QueryEngine.getInstance().doQuery(query);
	result.next();
	String id = result.getObject(1).toString();//获取该记录的ID
	String url = result.getObject(2).toString();//获取手动绑定的URL
	String token = result.getObject(3).toString();//获取手动绑定的Token
	
	%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script type="text/javascript" src="/html/nds/oto/bindwx/js/check.js"></script>
<link href="/html/nds/oto/bindwx/css/main.css" rel="stylesheet" type="text/css">
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<title>微信公众号绑定</title>
</head>
<body>
<div class="site">
	<div class="edit">
		<div class="editTitle">
			<table>
				<tbody>
					<tr>
						<td>
							<input type="hidden" id="hidId" value="<%=id%>">
							<h3>配置步骤</h3>
							<p>
								请将<font style=" font-weight:bold;">URL</font>和<font style=" font-weight:bold;">TOKEN</font>复制到微信公众平台，步骤如下图:
							</p>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="editContent2">
			<table class="editTable">
				<tbody>
					<tr>
						<td><img alt="" src="./images/li.jpg"></td>
						<td>URL:</td>
						<td><span><%=url%></span></td>
					</tr>
					<tr>
						<td><img alt="" src="./images/li.jpg"></td>
						<td>TOKEN:</td>
						<td><span><%=token%></span></td>
					</tr>
					<tr style="height: 15px;">
					</tr>
					<tr>
						<td colspan="3">
							<img alt="" src="./images/lead.jpg" usemap="#Map"><map name="Map">
								<area shape="rect" coords="415,230,510,270" href="javascript:void(0)" onclick="window.open(&#39;http://mp.weixin.qq.com&#39;)">
							</map>
						</td>
					</tr>
					<tr>
						<td><img alt="" src="./images/li.jpg"></td>
						<td>URL:</td>
						<td><span><%=url%></span></td>
					</tr>
					<tr>
						<td><img alt="" src="./images/li.jpg"></td>
						<td>TOKEN:</td>
						<td><span><%=token%></span></td>
					</tr>
					<tr style="height: 15px;">
					</tr>
					<tr>
						<td colspan="3" align="center">
							<a href="javascript:void(0)" id="check1" onclick="check()" class="inputStyle">完成配置</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>
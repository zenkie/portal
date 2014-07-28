<%@ page language="java" import="nds.rest.*,org.json.*,java.net.*,java.io.*" pageEncoding="utf-8"%>
<%
String tableId = "WEB_CLIENT";//需要读取的表
Table table = manager.getTable(tableId);
if(table == null) throw new NDSException("Internal Error: message table not found."+ tableId);

/**------check permission---**/
String directory = table.getSecurityDirectory();
WebUtils.checkDirectoryReadPermission(directory, request);
/**------check permission end---**/

QueryRequestImpl query;
QueryResult result = null;
int clientId = userWeb.getAdClientId();//公司id
SessionContextManager scmanager = WebUtils.getSessionContextManager(session);
query=QueryEngine.getInstance().createRequest(userWeb.getSession());
query.setMainTable(table.getId());
query.addSelection(table.getColumn("ID").getId());
query.addSelection(table.getColumn("QRCODE").getId());

query.addParam(table.getColumn("AD_CLIENT_ID").getId(), ""+clientId);	//添加条件

query.setRange(0, Integer.MAX_VALUE  );
Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
query.addParam(sexpr);
result= QueryEngine.getInstance().doQuery(query);
result.next();
String ewm = (result.getObject(2)!=null)?result.getObject(2).toString():"/html/nds/oto/operateintro/images/ewm.jpg";//获取公司二维码
%>
<div id="page-company-logo">
	<!--%=userWeb.getClientDomainName()%-->
	<a href="http://www.burgeon.com.cn/">
      <!--div class="moniker"></div-->
      <h1 class="logo">dev by burgeon</h1>
  </a>
</div>
<div style="position: absolute;float: right;right: 194px;height: 50px;">
  <span><img src="<%=ewm%>" style="margin-left: 6px;width:85px;" title="" /></span>
</div>
<div id="page-niche-menu">
	<a title="注销" >
		<img alt="<%=user.getGreeting()%>" style="padding-right: 50px;padding-bottom: 1px;height: 47px;width: 47px;" src="/html/nds/oto/themes/01/images/nh.png" title="退出系统">
		
		<span style="float: left;font-size: 14px"><%= user.getGreeting() %></span>
		<a href="<%= themeDisplay.getURLSignOut() %>" style="float: right;width: 37px;border-left: 2px solid #003366;font-size: 14px">退出</a>
	</a>

<!--	<span style="font-weight: bold;float: left;"><%= user.getGreeting() %></span>
  <ul><li><a title="设置" class="ph_option" href="javascript:showObject('/html/nds/option/option.jsp',null,null)"></a></li></ul>
  <ul><li><a title="注销" class="ph_quit" href="<%= themeDisplay.getURLSignOut() %>"></a></li></ul>
 -->
</div>

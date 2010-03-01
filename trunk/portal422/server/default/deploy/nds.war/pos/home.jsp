<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta http-equiv="X-UA-Compatible" content="IE=7" /><!-- Use IE7 mode for IE8 -->
<title>在线店务 - 伯俊软件</title>
<%@ include file="top_meta.jsp" %>
</head>
<body>
<%
/**
POS用户的首页
*/
if(userWeb==null || userWeb.isGuest()){
	System.out.println("home.jsp:user web is guest");
	String redirect=java.net.URLEncoder.encode(request.getRequestURI()+"?"+request.getQueryString() ,"UTF-8");	
	response.sendRedirect("/c/portal/login?redirect="+redirect);
	//System.out.println("home.jsp:redirect to /login");
	return;
}
/*if(true){
	response.sendRedirect("/html/nds/portal/portal.jsp?ss=13");
	return;
}*/
TableManager manager=TableManager.getInstance();
QueryEngine engine=QueryEngine.getInstance();
List al=engine.doQueryList("select c.id,c.name from c_store c, users u where u.id="+userWeb.getUserId()+" and c.id=u.c_store_id");
if(al.size()==0){
%>
 您不属于任何店铺，请向管理员咨询。<a href="/html/nds/portal/portal.jsp">进入PORTAL管理界面</a>
</body><html>
<%
}
int storeId=Tools.getInt( ((List)al.get(0)).get(0),-1);
String storeName=(String )((List)al.get(0)).get(1);
int rptId;
userWeb.setUserOption("C_STORE_ID",storeName);// make sure user has this store as its default one in query
%>
<div id="bar">
	<div id="tl">在线店务 - <%=storeName%></div>
	<div id="navigation">您好，<%=userWeb.getUserDescription()%> | 
		<a class="ph" href="/c/portal/logout">注销</a>
	</div>
</div>
<div id="workarea">
<div id="left">
	<div id="menu" class="wd">
		<div class="title-bg">
			<div class="title"><img src="/html/nds/images/">菜单</div>
		</div>
		<div id="tree-list"></div>
		
	</div>
	<div id="news" class="wd">
		<div class="title-bg"><div class="title">新闻</div></div>
		<%
		request.setAttribute("nds.portal.listconfig", "news");
		%>
		<jsp:include page="/html/nds/portal/portletlist/view.jsp" flush="true"/>
	</div>
	<div id="weather" class="wd">
		<%@ include file="weather.jsp" %>
	</div>		
</div>
<!--mid-->
<div id="mid">
	<div id="note" class="wd">
		<div class="title-bg"><div class="title">通知</div></div>
		<%
		request.setAttribute("nds.portal.listconfig", "mynotice");
		%>
		<jsp:include page="/html/nds/portal/portletlist/view.jsp" flush="true"/>
	</div>
	<div id="rpt1" class="wdwhite">
		<div id="portal-content">
			<div id="content-note">
				<b>工作区域</b><br/>
				(请点击左侧菜单项)</div>
		</div>
	</div>
</div>
</div><!--workarea-->

<div id="bottom">
	(C)2008-2009 上海伯俊软件科技有限公司 版权所有
</div>
</body>
</html>

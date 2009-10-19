<%@ page language="java" import="java.util.*,nds.fair.*" pageEncoding="utf-8"%> 
<%
 String serveDeadLine="";
 try{
 	serveDeadLine=PortletUtils.getMessage(pageContext, "account-serve-deadline",null)+":"+
 	QueryEngine.getInstance().doQueryOne("select SERVE_DEADLINE from users where id="+ userWeb.getUserId());
 }catch(Throwable t){}
%>
<div id="bottom-adv"><%=serveDeadLine%>
	<span id="chatback"><%= PortletUtils.getMessage(pageContext, "chatback",null)%></span>
</div>
<!--Powered By Agile NEA V4.0.1105 -->
<div id="bottom-company-txt"> (C)2008-2009 上海伯俊软件科技有限公司 版权所有 </div>	


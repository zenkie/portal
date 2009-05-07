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
<div id="bottom-company-txt"> (C)2007-2008 </div>
<div id="bottom-company-img"></div>		


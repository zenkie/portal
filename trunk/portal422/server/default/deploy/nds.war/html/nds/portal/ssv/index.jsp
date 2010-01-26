<%@ page language="java" import="java.util.*,nds.velocity.*" pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%!
 /**
    SubSystem(ss) View for portal
 	#session timeout checker for client portal page, this is to set the interval for checking in minutes, nomally it should be 1/10 of session timeout time
	#value 0 (default) means not check timeout of session
 */ 
 private static int intervalForCheckTimeout=Tools.getInt(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.session.checkinterval","0"),0);
%>
<%
 
 if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
 	/*session.invalidate();
 	com.liferay.util.servlet.SessionErrors.add(request,PrincipalException.class.getName());
 	response.sendRedirect("/login.jsp");*/
 	response.sendRedirect("/c/portal/login");
 	return;
 }
 if(!userWeb.isActive()){
 	session.invalidate();
 	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
 	response.sendRedirect("/login.jsp");
 	return;
 }

String dialogURL=request.getParameter("redirect");
if(nds.util.Validator.isNull(dialogURL)){
	Boolean welcome=(Boolean)userWeb.getProperty("portal.welcome",Boolean.TRUE);
	if(welcome.booleanValue()){
		dialogURL= userWeb.getWelcomePage();
		//userWeb.setProperty("portal.welcome",Boolean.FALSE);
	}
}

%>
<html>
<head>
<%@ include file="top_meta.jsp" %>
<script>
<%
	// check whether to check timeout for portal page
	if(intervalForCheckTimeout>0){
%>	
	setInterval("checkTimeoutForPortal(<%=session.getMaxInactiveInterval()%>)", <%=intervalForCheckTimeout*60000%>);
<%
	}
	if(nds.util.Validator.isNotNull(dialogURL)) {
%>	
	popup_window("<%=dialogURL%>");
<%	}
%>	
</script>	
</head>
<body>

<%@ include file="body_meta.jsp"%>
<div id="ssv-top">
	<div id="ssv-top-banner">
		<div id="page-company-logo">
	<%=userWeb.getClientDomainName()%>
</div>
	</div>
	<div id="page-niche-menu">
	<span style="font-weight: bold"><%= user.getGreeting() %></span>|
	<%if(session.getAttribute("saasvendor")==null){
		//alisoft does not allow home page and logout, change password
	%>
	<a class="top-text" href="/"><%= PortletUtils.getMessage(pageContext, "home",null)%></a>&nbsp;|&nbsp;
	<%}%>
	<a class="top-text" href="javascript:showObject('/html/nds/option/option.jsp',null,null,{maxButton:false,closeButton:false})"><%= PortletUtils.getMessage(pageContext, "option_setting",null)%></a>&nbsp;|&nbsp;
	<a class="top-text" href="javascript:popup_window('/help/Wiki.jsp?page=Help')"><%= PortletUtils.getMessage(pageContext, "help",null)%></a>&nbsp;|&nbsp;
	<%if(session.getAttribute("saasvendor")==null){%>
	<a class="top-text" href="<%= themeDisplay.getURLSignOut() %>"><bean:message key="sign-out" /></a>
	<%}%>
</div>
	</div>
</div>
<div id="ssv-main">	
<table id="ssv-table" cellpadding="0" cellspacing="0">
	<tr>
	<td width="99%" class="topleft">
		<div id="ssv-content">
	<%
	// check navigation
	Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
	String linkFile= conf.getProperty("ssview.navigation");
	
	if(linkFile !=null){
	%>
		<jsp:include page="<%=linkFile%>" flush="true"/>
	<%}else{
	%>
	<%@ include file="navigation.jsp" %>
	<%}%>


		</div>	
	</td>
<td width="1%" norwap class="topleft">

<div id="ssv-help2">
<div  class="title-bg"><div class="title">帮助说明</div></div>
<div class="ssv-help">
<div id="ssv-help">	
	</div></div></div>		
    </td>
</tr></table>
</div>

<div id="ssv-bottom1">
<div id="ssv-bbs">
<div class="title-bg01"><div class="title01">系统交互</div></div>
	<div id="ssv-bbs-bg">
		<%@ include file="bbs.jsp" %>
		</div>
</div>	
<div id="ssv-bottom">
	<%@ include file="bottom.jsp" %>
</div>
</div>

</body>
</html>


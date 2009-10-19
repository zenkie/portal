<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%!
 /**
 	#session timeout checker for client portal page, this is to set the interval for checking in minutes, nomally it should be 1/10 of session timeout time
#value 0 (default) means not check timeout of session
	@param "ss" - ad_subsystem.id, if set, will show subsystem only
	@param "table" - table id or name for viewing, should direct to that table immediately
	@param "popup" - only when "false" will update current user's setting, disable popup portal next time, other values will do nothing
	@param redirect - if set, should be an URL, and we will popup that url as welcome window (overwrite default welcome window)
 */ 
 private static int intervalForCheckTimeout=Tools.getInt(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.session.checkinterval","0"),0);
 private static boolean defaultSsviewFirst="true".equals( ((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.ssview","false"));

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
if(nds.util.Validator.isNotNull(dialogURL)){
	response.sendRedirect(dialogURL);
 	return;
}
if(nds.util.Validator.isNull(dialogURL)){
	Boolean welcome=(Boolean)userWeb.getProperty("portal.welcome",Boolean.TRUE);
	if(welcome.booleanValue()){
		dialogURL= userWeb.getWelcomePage();
		//userWeb.setProperty("portal.welcome",Boolean.FALSE);
	}
}
String directTb=request.getParameter("table");
boolean isNotPopupPortal="false".equals(request.getParameter("popup"));//Tools.getYesNo(userWeb.getUserOption("POPUP_PORTAL","Y"), true);
if(isNotPopupPortal){
	//update current user's setting, no exception will be thrown
	userWeb.saveUserOption("POPUP_PORTAL","N",false);
}
TableManager manager=TableManager.getInstance();
Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();

boolean ssviewFirst=Tools.getYesNo(userWeb.getUserOption("SSVIEW",defaultSsviewFirst?"Y":"N"),false);
int ssId=Tools.getInt(request.getParameter("ss"),-1);
if(ssId==-1 && nds.util.Validator.isNull(directTb) && ssviewFirst){
	request.getRequestDispatcher("/html/nds/portal/ssv/index.jsp").forward(request, response);
	return;
}
%>
<html>
<head>
<%@ include file="top_meta.jsp" %>
<script>
<%
	if(nds.util.Validator.isNotNull(directTb)){
%>	
jQuery(document).ready(function(){pc.navigate('<%=directTb%>')});
<%	}else{
		if(nds.util.Validator.isNotNull(dialogURL)) {
%>
function loadWelcomePage(){
	pc.welcome("<%=dialogURL%>");
	//window.location.href="<%=dialogURL%>";
}
jQuery(document).ready(loadWelcomePage);
<%		}	
	}
	// check whether to check timeout for portal page
	if(intervalForCheckTimeout>0){
%>	
	setInterval("checkTimeoutForPortal(<%=session.getMaxInactiveInterval()%>)", <%=intervalForCheckTimeout*60000%>);
<%
	}
%>	
</script>	
</head>
<body>
<%@ include file="body_meta.jsp"%>
<div id="portal-top">
	<div id="page-top-banner">
		<%@ include file="top.jsp" %>
	</div>
		<div id="page-niche-menu-bg"><div id="page-niche-menu">
	<span style="font-weight: bold"><%= user.getGreeting() %>. </span>
	<%if(ssId!=-1){%>
	<%= PortletUtils.getMessage(pageContext, "current-subsystem",null)%>:<span style="font-weight: bold"><%=manager.getSubSystem(ssId).getName()%></span>(
	<a class="ph" href="javascript:void(0)" id="objdropbtn"><%= PortletUtils.getMessage(pageContext, "switch-subsystem",null)%></a>)
	<%}%>|
	<%if(session.getAttribute("saasvendor")==null){
		//alisoft does not allow home page and logout, change password
	%>
	<a class="ph" href="/"><%= PortletUtils.getMessage(pageContext, "home",null)%></a>|
	<%}%>
	<a class="ph" href="javascript:showObject('/html/nds/option/option.jsp',null,null,{maxButton:false,closeButton:false})"><%= PortletUtils.getMessage(pageContext, "option_setting",null)%></a>|
	<a class="ph" href="javascript:popup_window('/help/Wiki.jsp?page=Help')"><%= PortletUtils.getMessage(pageContext, "help",null)%></a>|
	<%if(session.getAttribute("saasvendor")==null){%>
	<a class="ph" href="<%= themeDisplay.getURLSignOut() %>"><bean:message key="sign-out" /></a>
	<%}%></div>
</div>
	<%
	// check navigation
	String linkFile= conf.getProperty("ui.treelink.navigation");
	if(linkFile !=null){
	%>
		<jsp:include page="<%=linkFile%>" flush="true"/>
	<%}else{
	%>
		<%@ include file="navigation.jsp" %>
	<%	
	  }
	%>
</div>
<div id="portal-main">		
		<table id="page-table" cellpadding="0" cellspacing="0">
	<tr>
		<td width="1%" norwap class="topleft">
		<%@ include file="list_menu.jsp" %>
    </td>
<td width="99%" class="topleft">
	<div id="portal-content"></div>	
	</td>
	</tr></table>
</div>
<div id="portal-bottom">
	<%@ include file="bottom.jsp" %>
</div>
</body>
</html>


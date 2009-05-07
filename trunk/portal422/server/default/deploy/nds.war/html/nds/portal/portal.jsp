<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%!
 /**
 	#session timeout checker for client portal page, this is to set the interval for checking in minutes, nomally it should be 1/10 of session timeout time
#value 0 (default) means not check timeout of session
	@param "table" - table id or name for viewing, should direct to that table immediately
	@param "popup" - only when "false" will update current user's setting, disable popup portal next time, other values will do nothing
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
Boolean welcome=(Boolean)userWeb.getProperty("portal.welcome",Boolean.TRUE);
String dialogURL=null;
if(welcome.booleanValue()){
	dialogURL= userWeb.getWelcomePage();
	userWeb.setProperty("portal.welcome",Boolean.FALSE);
}
String directTb=request.getParameter("table");
boolean isNotPopupPortal="false".equals(request.getParameter("popup"));//Tools.getYesNo(userWeb.getUserOption("POPUP_PORTAL","Y"), true);
if(isNotPopupPortal){
	//update current user's setting, no exception will be thrown
	userWeb.saveUserOption("POPUP_PORTAL","N",false);
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
		if(dialogURL!=null) {
%>
function loadWelcomePage(){
	pc.welcome("<%=dialogURL%>");
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
	<%
	// check navigation
	Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
	String linkFile= conf.getProperty("ui.treelink.navigation");
	if(linkFile !=null){
	%>
		<jsp:include page="<%=linkFile%>" flush="true"/>
	<%}else{
	%>
	<%@ include file="navigation.jsp" %>
	<%}%>
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


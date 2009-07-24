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
%>	
</script>	
</head>
<body>
<%@ include file="body_meta.jsp"%>
<div id="ssv-top">
	<div id="ssv-top-banner">
		<%@ include file="top.jsp" %>
	</div>
	<div id="ssv-top-heigth"></div>
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
	</td><td width="1%" norwap class="topleft">
		<div id="ssv-help">
		</div>
    </td>
</tr></table>	
</div>
<div id="ssv-bbs">
	<%@ include file="bbs.jsp" %>
</div>
<div id="ssv-bottom">
	<%@ include file="bottom.jsp" %>
</div>
</body>
</html>


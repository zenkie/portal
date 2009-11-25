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
		if(nds.util.Validator.isNotNull(dialogURL)){
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
<div id="portal-main" style="margin-left:3px">		
	<table id="page-table" cellpadding="0" cellspacing="0" >
	<tr><td width="1%" norwap class="topleft" >
		   <table cellspacing="0" cellpadding="0" border="0" width="100%">
			<tr><td id="a" style="vertical-align:top;width:200px" >
			<div style="margin:0;overflow:hidden;" >
			<%@ include file="list_menu.jsp" %>
			</div>
		   	</td><td id="b" style="vertical-align:top;width:10px;height:100%;" >
			<div id="leftToggler"  onclick="menu_toggle(this);" onmoussdeover="menu_hl(1);" onmousdeout="menu_hl(0);"  >
				</div></td>
			</tr></table></td>
		<td style="vertical-align:top;width:100%;">
	<div id="portal-content" style="width:100%"></div>	
	</td></tr>
	</table>
</div>
<script type="text/javascript">
var menustate=1;
var menuWidth=null;
function menu_hl(state){
   var url1="#C3D9FF";
   var url2="#C3D9FF";
   var url3="#678FC2";
   var url4="#678FC2";
   if(state==1){
	   
		$('b').style.backgroundColor=(menustate==1)?url1:url2;
	} else {
		$('b').style.backgroundColor=(menustate==1)?url3:url4;
	}
}
function menu_toggle(e){
   //var display =document.getElementById("a").style.display;
   e.blur();
   var url1="#C3D9FF url('/html/nds/themes/classic/01/images/arrow-left.gif') no-repeat scroll 1px 50%";
   var url2="#C3D9FF url('/html/nds/themes/classic/01/images/arrow-right.gif') no-repeat scroll 1px 50%";
   if(menustate==1){
		document.getElementById("a").style.display="none"; 
		menustate=-1;
		resize();
		document.getElementById('leftToggler').style.background=url2;

	}else{document.getElementById('leftToggler').style.background=url1;

		document.getElementById("a").style.display="block";
		document.getElementById("b").style.width="10px"; 
		menustate=1;
		resize();
	}
   $('portal-bottom').focus();
}
function resize(){
		//if(is_ie) return;
		
		var limitWidth=245;
		//if(!pc._resizable) limitWidth=15;
		//else limitWidth=245;
		var e=$("embed-lines");
		//if (menuWidth==null) menuWidth=e.style.width;
		if (menustate==-1)limitWidth=40;
		else limitWidth=240;

		if(e==null)return;
		if (!is_safari) {
				e.style.width= (document.body.clientWidth - limitWidth)+"px";
    }else {
        e.style.width= (document.body.offsetWidth - limitWidth)+"px";
    }
	}
</script>
<div id="portal-bottom">
	<%@ include file="bottom.jsp" %>
</div>

</body>
</html>


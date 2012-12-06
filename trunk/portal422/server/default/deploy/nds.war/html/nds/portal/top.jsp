<div id="page-company-logo">
	<!--%=userWeb.getClientDomainName()%-->
	<a href="http://devgrow.com/">
      <div class="moniker"></div>
      <h1 class="logo">DevGrow - Design, Develop, Grow.</h1>
  </a>
</div>
<div id="page-niche-menu">
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
	<%}%>
</div>

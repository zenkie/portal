<table cellpadding="0" cellspacing="0" width="100%">
<tr><td>
	<div class="smalltab" >
		 <ul class="gamma-tab">
			<li class="current"><%= PortletUtils.getMessage(pageContext, "feature-list",null)%>
		
			</li>
		</ul>
		<div id="rpt-list-content" >
				<%//((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("chatback","")
				%>
			<div id="tree-list"></div>
		</div>
	</div>
</td></tr>
<tr>
<td>
	<div id="dotred-ul">
<liferay-ui:tabs names="mynotice">
	<%
	request.setAttribute("nds.portal.listconfig", "mynotice");
	%>
	<jsp:include page="/html/nds/portal/portletlist/view.jsp" flush="true"/>

</liferay-ui:tabs>	
</div>
</td>
</tr>
</table>

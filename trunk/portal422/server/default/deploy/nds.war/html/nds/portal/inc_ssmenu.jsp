<div id="objdropmenu" class="obj-dock-list-container">
<ul class='obj-dock-list'>
<%
SubSystem ss;
String currentSubSystemMark;
List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
	if(ss.getId()==ssId){
		currentSubSystemMark=" style='background-image:url(/html/nds/images/check.gif)'";
	}else currentSubSystemMark="";
%>
<li><a href="javascript:pc.ssv(<%=ss.getId()%>)" <%=currentSubSystemMark%>><%=ss.getName()%></a></li>
<%	
}%>
<li><a href="javascript:window.location='/html/nds/portal/ssv/index.jsp'" style="background-image:url(/html/nds/images/showlist.gif)">
<%= PortletUtils.getMessage(pageContext, "subsystem-view",null)%></a></li>
</ul></div>
		



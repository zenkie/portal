<%
/**
Navigation of ss
 */
String portalHome="/html/nds/portal/portal.jsp?ss=";
TableManager manager=TableManager.getInstance();
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
SubSystem ss;
%>
<div class="ssv-v">
<%
List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
	<div class="ss"><a href="javascript:ssv.view(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div>
<%	
}
%>
</div>	
<hr/>
<div class="ssv-p">
<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_PERM);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
	<div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div>
<%	
}
%>
</div>	
<hr/>
<div class="ssv-l">
<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_LICENSE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
	<div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div>
<%	
}
%>
</div>	

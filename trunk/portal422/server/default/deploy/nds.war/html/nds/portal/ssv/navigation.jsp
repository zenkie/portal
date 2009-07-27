<%
/**
Navigation of ss
 */
String portalHome="/html/nds/portal/portal.jsp?ss=";
TableManager manager=TableManager.getInstance();
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
SubSystem ss;
%>
<div id="ssv-v">
<div class="ssv-p">???¡ê? ó</div>
<ul>
<%
List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.view(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>	
	
<div id="ssv-l">
<div class="ssv-p">??§°</div>
<ul>
	<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_PERM);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>

<div id="ssv-w">
<div class="ssv-p">¦Ä2?o
</div>
<ul>
	<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_LICENSE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>	

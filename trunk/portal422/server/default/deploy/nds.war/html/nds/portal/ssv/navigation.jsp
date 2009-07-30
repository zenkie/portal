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
<div class="ssv-p"><img src="/html/nds/portal/ssv/images/ssv-title01.gif" width="85" height="22"  /></div>
<ul>
<%
List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.view(<%=ss.getId()%>)" class="IMG"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>	
	
<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_PERM);
if(sss.size()>0){%>
<div id="ssv-l">
<div class="ssv-p"><img src="/html/nds/portal/ssv/images/ssv-title02.gif" width="85" height="22"  /></div>
<ul>
<%
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)" class="IMG01"><img src="<%=ss.getIconURL()%>"  border="0"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>
<%}%>
<div id="ssv-w">
<div class="ssv-p"><img src="/html/nds/portal/ssv/images/ssv-title03.gif" width="85" height="22"  /></div>
<ul>
	<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_LICENSE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)" class="IMG01"><img src="<%=ss.getIconURL()%>"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div>	

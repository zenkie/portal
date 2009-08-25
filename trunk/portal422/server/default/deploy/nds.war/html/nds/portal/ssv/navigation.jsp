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
<div class="showitem yellow clearfix">
<div class="span-auto pic">
<div class="title"></div>
<ul>
<%
List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.view(<%=ss.getId()%>)" class="IMG"><img src="<%=ss.getIconURL()%>" border="0"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div></div></div>	
	
<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_PERM);
if(sss.size()>0){%>
<div id="ssv-l">
<div class="showitem blue clearfix">
<div class="span-auto pic">
<div class="title"></div>
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
</div></div></div>
<%}%>
<div id="ssv-w">
<div class="showitem blue clearfix">
<div class="span-auto pic">
<div class="title"></div>
<ul>
	<%
sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_NO_LICENSE);
for(int i=0;i< sss.size();i++){
	ss=sss.get(i);
%>
<li><div class="ss"><a href="javascript:ssv.help(<%=ss.getId()%>)" class="IMG01"><img src="<%=ss.getIconURL()%>" border="0"/><div class="sst"><%=ss.getName()%></div></a></div></li>
<%	
}
%>
</ul>
</div></div></div>	

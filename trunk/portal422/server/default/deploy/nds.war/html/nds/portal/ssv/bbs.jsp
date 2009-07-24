<%
String bbsLocation= conf.getProperty("ssview.bbs");
if(bbsLocation!=null){
%>
<iframe src="<%=bbsLocation%>" border="0"/>
<%}%>	
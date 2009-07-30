<%
String bbsLocation= conf.getProperty("ssview.bbs");
if(bbsLocation!=null){
%>
<IFRAME width="99%" height="200px" marginwidth="0" marginheight="0" frameborder=0 src="<%=bbsLocation%>" ></IFRAME> 
<%}%>	
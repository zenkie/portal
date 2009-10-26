<%
String bbsFile= conf.getProperty("ssview.bbs");
System.out.print(bbsFile);
if(bbsFile!=null){
%>
<<<<<<< .mine
<IFRAME width="99%" height="43px" marginwidth="0" marginheight="0" frameborder=0 src="<%=bbsLocation%>" ></IFRAME> 
<%}%>=======
<IFRAME width="99%" height="43px" marginwidth="0" marginheight="0" frameborder=0 src="<%=bbsFile%>" ></IFRAME> 
<%}%>>>>>>>> .r269

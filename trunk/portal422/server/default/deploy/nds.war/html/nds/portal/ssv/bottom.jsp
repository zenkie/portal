<div id="bottom-adv">
</div>
<!--Powered By Agile NEA V4.1 -->
<%
// check navigation
String bottomFile= conf.getProperty("ssview.bottom");
if(bottomFile !=null){
%>
<jsp:include page="<%=bottomFile%>" flush="true"/>
<%}else{
%>
<div id="bottom-company-img"></div>	
<%}%>



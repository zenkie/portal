<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
   TableManager manager=TableManager.getInstance();
   int catId=Tools.getInt( request.getParameter("id"), -1);
   TableCategory cat=(TableCategory)manager.getTableCategory(catId);
   String desc=cat.getName();
   String func="pc.qrpt";
   String url=cat.getPageURL();
   if(url!=null){
%>
<jsp:include page="<%=url%>" flush="true" />
<%	}%>
<table><tr><td>
<script type="text/javascript">
 webFXTreeConfig.autoExpandAll=true;
 var tree=pc.createTree("<%=desc%>","/html/nds/portal/tablecategory.xml.jsp?id=<%=catId%>", <%=(url==null?"null":"\"javascript:pc.navigate('"+url+"')\"")%>);
</script>    
</td></tr></table>

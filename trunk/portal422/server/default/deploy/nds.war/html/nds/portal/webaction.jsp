<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
/**
 Show webaction as tree in TableCategory menu
*/
   TableManager manager=TableManager.getInstance();
   int actionId=Tools.getInt( request.getParameter("id"), -1);
   WebAction action=manager.getWebAction(actionId);
   String desc=action.getDescription();
%>   
<table><tr><td>
<script type="text/javascript">
 webFXTreeConfig.autoExpandAll=true;
 var tree=pc.createTree("<%=desc%>","/html/nds/portal/webaction_xml.jsp?id=<%=actionId%>", null);
</script>    
</td></tr></table>

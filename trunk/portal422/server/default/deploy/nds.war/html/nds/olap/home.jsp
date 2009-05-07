<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %>
<%@ page import="nds.olap.*" %>

<%
PairTable fixedColumns=null;
%>
<script>
	document.title="<%=PortletUtils.getMessage(pageContext, "select-query",null)%>";
</script>
<%@ include file="/html/nds/olap/inc_queries.jsp" %>
<script>
try{document.attachEvent( "oncontextmenu", showContextMenu );
document.attachEvent( "onkeyup", rememberKeyCode );}catch(ex){}
</script>

<%@ include file="/html/nds/footer_info.jsp" %>

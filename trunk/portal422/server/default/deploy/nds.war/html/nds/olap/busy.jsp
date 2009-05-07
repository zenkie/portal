<%@ include file="/html/nds/common/init.jsp" %>
<%@ taglib uri="http://java.sun.com/jstl/core_el" prefix="c2" %>
<html>
<head>
  <title><%= PortletUtils.getMessage(pageContext, "jpivot-is-busy",null)%></title>
  <meta http-equiv="refresh" content="1; URL=<c2:out value="${requestSynchronizer.resultURI}"/>">
</head>
<body bgcolor=white>
  <h2><%= PortletUtils.getMessage(pageContext, "jpivot-is-busy",null)%></h2>
  <%= PortletUtils.getMessage(pageContext, "please-wait-and-click",null)%>
  <a href="<c2:out value="${requestSynchronizer.resultURI}"/>">here</a>
</body>
</html>


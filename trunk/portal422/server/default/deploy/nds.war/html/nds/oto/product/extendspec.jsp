<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray" pageEncoding="UTF-8" %>
<%@ page import="nds.query.web.*,nds.control.web.*,nds.util.*"%>

<%
String dialogURL=request.getParameter("redirect");
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
}
String eid=request.getParameter("eid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>

<head>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/spacification.css">
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script language="javascript" src="/html/nds/oto/product/js/customspace.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
</head>
<body>
	<div id="custom_spaceitems"></div>
</body>

<script type="text/javascript">
	jQuery(document).ready(function(){	
		if(!extendspace){customspaces.main();}
		extendspace.eid="<%=eid%>";
		extendspace.init();
	});
</script>
</html>
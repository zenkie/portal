<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
/**------获取参数---**/
String dialogURL=request.getParameter("redirect");
 if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+
		(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+
			java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
		return;
	}
	
 if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
 }
/**------获取参数 end---**/


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>

<script type="text/javascript">
	function savenetworkurl(){
		var url=jQuery("#nextwork_url").val().trim();
		if(!url){
			alert("请输入网络图片地址");
			return;
		}
		art.dialog.data("networkurl",{"url":url});
		art.dialog.close();
	}
	
	function cancelnetworkurl(){
		art.dialog.data("networkurl",null);
		art.dialog.close();
	}
</script>
<head>
<style>
	.nextwork_url{
		width:250px;
	}
	#contentWrap{
		margin-top: 40px;
		text-align: center;
	}
</style>
</head>
<body style="width:auto;height:auto;">
	<div id="contentWrap">
		<div>
			<span><input id="nextwork_url" class="nextwork_url" type="text" value="" /></span>
			<span id="buttons" style="padding-left:10px;">
				<input type="button" value="保存" id="btn" class="btnGreenS" onclick="savenetworkurl()">
				<input type="button" value="关闭" id="btn" class="btnGreenS" onclick="cancelnetworkurl()">
			</span>
		</div>
	</div>
</body>
</html>

<%@ page language="java" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">	
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/menu/js/weixinbeswept.js"></script>
<style>
	.createmenucss{
		width:100px;
		font-size:19px;
		color:red;
		font-weight: bolder;
	}
	.ftd{
		width: 70px;
		vertical-align: top;
	}
	.std{
		
	}
</style>
</head>
<body>
	<table>
		<tbody>
			<tr>
				<td class="ftd"><span class="createmenucss">授权码:</span></td>
				<td class="std"><textarea id="authorization" name="props" rows="1" cols="100"></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td colspan="1" style="text-align:center;">
					<input type="button" onclick="wbs.createNativeOrder();" value="微信NATIVE下单" />
					<input type="button" onclick="wbs.createweixinbesweptorder();" value="微信被扫下单" />
					<input type="button" onclick="wbs.queryweixinbesweptorder();" value="微信被扫订单查询" />
					<input id="reverseorder" type="button" onclick="wbs.reverseWeixinbesweptorder();" value="微信被扫撤单" disabled="disabled" />
					<input type="button" onclick="wbs.refundWeixinbesweptorder();" value="微信被扫退款申请" />
					<input type="button" onclick="wbs.queryRefundWeixinbesweptorder();" value="微信被扫退款查询" />
				</td>
			</tr>
		</tbody>
	</table>
</body>
</html>
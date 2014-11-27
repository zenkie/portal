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
<link rel="shortcut icon" type="image/ico" href="/html/nds/oto/themes/01/images/end.gif" />
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/menu/createmenu.js"></script>
<style>
	.createmenucss{
		width:100px;
		font-size:19px;
		color:red;
		font-weight: bolder;
	}
	.ftd{
		width: 80px;
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
				<td class="ftd"><span class="createmenucss" style="width:200px;" >domin:</span></td>
				<td class="std"><input id="domin" type="text" value style="width:250px;" /></td>
				<td id="aaa"><a href="{'fromid'='dad','test'='dsa'd'}" >test</a><td>
			</tr>
			<tr>
				<td class="ftd"><span class="createmenucss">body:</span></td>
				<td class="std"><textarea id="menus" name="props" rows="26" cols="100"></textarea></td>
				<td><img id="codess" src="" />
			</tr>
			<tr>
				<td colspan="3" style="text-align:center;">
					<input type="button" onclick="cm.cratemenu();" value="创建菜单" />
					<input type="button" onclick="cm.createTwoDimensionalCode();" value="创建二维码" />
					<input type="button" onclick="cm.createweixinbesweptorder();" value="测试微信被扫" />
					<input type="button" onclick="cm.queryweixinbesweptorder();" value="微信被扫订单查询" />
					<input type="button" onclick="cm.reverseWeixinbesweptorder();" value="微信被扫冲正" />
					<input type="button" onclick="cm.refundWeixinbesweptorder();" value="微信被扫退款" />
					<input type="button" onclick="cm.queryRefundWeixinbesweptorder();" value="微信被扫退款查询" />
					<input type="button" onclick="cm.getOpenid();" value="获取主商户号OPENID" />
					<input type="button" onclick="cm.getOpenidAu();" value="获取主商户号" />
				</td>
			</tr>
		</tbody>
	</table>
</body>
</html>
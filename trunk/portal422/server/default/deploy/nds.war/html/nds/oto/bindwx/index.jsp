<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
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
	 //获取公司ID
	 int clientId = userWeb.getAdClientId();		 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script type="text/javascript" src="/html/nds/oto/bindwx/js/editDevInteface.js"></script>
<link href="/html/nds/oto/bindwx/css/main.css" rel="stylesheet" type="text/css">
<title>微信公众号绑定</title>
</head>
<body>
<div class="site">
    <div class="edit">
		<div class="editTitle">
			<table>
				<tbody>
					<tr><td><h3>微信公众号智能绑定</h3></td></tr>
				</tbody>
			</table>
		</div>
		<div class="editContent2">
			<table class="editTable">
				<tbody>
					<tr>
						<th>微信公众账号：</th>
						<td>
							<input type="text" name="wxAccount" id="wxAccount" placeholder="邮箱/微信号/QQ号">
						</td>
						<td>
							<em id="tipMsg">如无微信公众号请点击<a href="http://mp.weixin.qq.com/" target="_blank">申请</a></em>
						</td>
					</tr>
					<tr>
						<th>密码：</th>
						<td>
							<input type="password" name="wxPwd" id="wxPwd" value="">
						</td>
					</tr>  
					<tr id="wxImageCode" style="display:none" >
						<th>验 证 码：</th>
						<td>
							<input type="hidden" value="<%=clientId%>" id="clientId">
							<input type="text" name="wxImgCode" id="wxImgCode" value="">
							<img src="/servlets/binserv/Wxvcode?user=<%=clientId%>" id="ImageCode" alt="看不清,换一张">
						</td>
					</tr>
					<tr>
						<th></th>
						<td>
							<input type="button" name="wxbind" id="wxbind" value="智能绑定">
						</td>
						<td>
							<em>不想智能绑定？点此 <a href="javascript:window.top.location.href='/html/nds/oto/bindwx/wxmessagewrite.jsp'">手动绑定</a></em>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
    </div>
	<div class="footer">
		<p><a href="http://www.next99.cn/"><img style="vertical-align:middle">上海伯俊软件科技有限公司网站</a></p>
		<p>咨询热线：400-620-9800</p><p>E-mail：Marketing@burgeon.cn</p>
		<p>地址：上海市闵行区新源路1356弄汇力得电子商务产业园A栋3层</p>
		<p>Copyright (©) 2012-2013 上海伯俊软件科技有限公司 版权所有</p>
	</div>
</div>
</body>
</html>
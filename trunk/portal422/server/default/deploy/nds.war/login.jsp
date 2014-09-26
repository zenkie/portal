<%@ page language="java" import="java.util.*,nds.velocity.*,nds.weixin.ext.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
com.liferay.portal.util.CookieKeys.addSupportCookie(response);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<title>伯俊微信</title> 
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">jQuery.noConflict(); </script>
<link href="/public.css" rel="stylesheet" type="text/css" />
<script type=text/javascript>
function onReturn(event){
  if (!event) event = window.event;
  if (event && event.keyCode && event.keyCode == 13) submitForm();
}
function submitForm(){
	if(document.getElementById("login").value==""){ 
		alert("请输入会员用户名");
		return;
	}
	else if(document.getElementById("password1").value==""){
		alert("请输入密码");
		return;
	}
	else if(document.getElementById("verifyCode").value==""){
		alert("请输入验证码");
		return;
	}else if(document.getElementById("verifyCode").value.length!=4){
		alert("您的输入验证码的长度不对!");
		return;
	}
	document.fm1.submit();
	document.body.innerHTML=document.getElementById("progress").innerHTML;
}
</script>
</head>
<body class="wh100p">
	<div class="login_header">
	  <div class="warpper">
		<div class="topbar clearfix">
		  <h1><a href="javascript:;"><img src="/images/otoimages/logo318x90color.png" alt="星云微信移动平台"/></a></h1>
		  <div class="right_bar"> <a href="#"><span>第一次使用星云？</span></a><a href="/html/nds/oto/register/index.html">立即注册</a> </div>
		</div>
	  </div>
	</div>
    <div id="container" class="login_box clearfix">
    	<div id="content" class="login_main clearfix">
		    <div class="login_font"><img src="/images/otoimages/login_font.png"/></div>
			<div class="login_left"><img src="/images/otoimages/loginPhone.png"/></div>
<c:choose>
	<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
			<div id="login-box" class="login_right_in">
				<form action="/c/portal/login" method="post" name="fm1">
					<input type="hidden" value="already-registered" name="cmd"/>
					<input type="hidden" value="already-registered" name="tabs1"/>
					<li>
						<span class="login_text"><%= LanguageUtil.get(pageContext, "current-user")%>&nbsp;:&nbsp;</span>
						<span class="login_bold_text usernow"><%=userWeb.getUserDescription() %></span><br>
						<span class="login_text"><%= LanguageUtil.get(pageContext, "enter-view") %>&nbsp;:&nbsp;</span>
						<a class="login_bold_text userto" href="/html/nds/portal/index.jsp"><%= LanguageUtil.get(pageContext, "backmanager") %></a>
						<span class="login_text">&nbsp;,&nbsp;<%= LanguageUtil.get(pageContext, "or") %>&nbsp;:&nbsp;</span>
						<a class="login_bold_text userto" href="/c/portal/logout"><%= LanguageUtil.get(pageContext, "logout") %></a>
					</li>
				</form>
			</div>
		</div>
			</c:when>
	<c:otherwise>
			<div id="login-box" class="login_right">
			<c:if test="<%=true %>">
				<c:if test='<%= SessionMessages.contains(request, "user_added") %>'>
					<%
					String emailAddress = (String)SessionMessages.get(request, "user_added");
					String password = (String)SessionMessages.get(request, "user_added_password");
					%>
					<div class="portlet-msg-success">
						<c:choose>
							<c:when test="<%= Validator.isNull(password) %>"> <%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account-your-password-has-been-sent-to-x", emailAddress) %> </c:when>
							<c:otherwise> <%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account-your-password-is-x", new Object[] {password, emailAddress}) %> </c:otherwise>
						</c:choose>
					</div>
					<br />
					<%%>
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, AuthException.class.getName()) %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, "VERIFY_CODE_ERROR") %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-verify-code") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, CookieNotSupportedException.class.getName()) %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "authentication-failed-please-enable-browser-cookies") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, NoSuchUserException.class.getName()) %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, PrincipalException.class.getName()) %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "you-have-attempted-to-access-a-section-of-the-site-that-requires-authentication") %> <%= LanguageUtil.get(pageContext, "please-sign-in-to-continue") %> </div>
					<br />
				</c:if>
				<c:if test='<%= SessionErrors.contains(request, UserEmailAddressException.class.getName()) %>'>
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, UserPasswordException.class.getName()) %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
					<br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, "SLEEP_USER") %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "inactive-user-exception") %> </div>
					<br />
				</c:if> 
				<c:if test="<%= SessionErrors.contains(request, "INACTIVE_USER") %>">
					<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "inactive-user-exception") %> </div>
					<br />
				</c:if>                
			</c:if>
				<form action="/c/portal/login" method="post" name="fm1">
				<input type="hidden" value="already-registered" name="cmd"/>
				<input type="hidden" value="already-registered" name="tabs1"/>
			 <%
			 String  login ="";
			 if(company==null){
				  company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");
			 }
			 //login =LoginAction.getLogin(request, "login", company);
			%>
    			<input id="login" name="login" class="text_name" type="text" value="<%=login%>" placeholder="手机或邮箱">
    			<input id="password1" class="text_pwd" type="password" name="<%=SessionParameters.get(request,"password")%>" value="" placeholder="密码">
				<input id="verifyCode" name="verifyCode"  type="text" onKeyPress="onReturn(event)" class="text_code"  size="7"  placeholder="验证码"/>
    			<div class="code">
					<img src="/servlets/vms" width="95" height="35" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" />
					<a href="javascript:;" id="change_code">换一张</a>
    			</div>
    			<div class="forgt">
					<a href="/html/nds/oto/findpwd/index.html">忘记密码？</a>
    			</div>
				<input type="submit" class="btn_login" value="" onclick="submitForm()">
    		</div>
    	</div>
		</form>
	</c:otherwise>
</c:choose>
		<div id="footer" class="login_footer clearfix">
			<div class="logo"><a href="#"><img src="/images/otoimages/logo137x56.png"/></a></div>
			<div class="cen">
				<p><a style="padding-left:0;" href="#">返回首页</a>|<a href="#">客户案例</a>|<a href="#">联系我们</a></p>
				<p>公司地址：上海闵行区新源路1356弄汇力得电子商务产业园A栋3层<br/>公司官网：www.burgeon.cn<br/>热线咨询：400-620-9800</p>
			</div>
			<div class="codetwo"><img src="/images/otoimages/code.jpg"/></div>
		</div>
    </div>
</body>
</html>

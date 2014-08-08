<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/portal/init.jsp" %>
<%
com.liferay.portal.util.CookieKeys.addSupportCookie(response);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>burgeon NewBos--伯俊软件</title>
<link href="/style-portal.css" rel="stylesheet" type="text/css" />
<SCRIPT type=text/javascript>
	function selectTag(showContent,selfObj){
	// 2???
	var tag = document.getElementById("tags").getElementsByTagName("li");
	var taglength = tag.length;
	for(i=0; i<taglength; i++){
		tag[i].className = "";
	}
	selfObj.parentNode.className = "selectTag";
	// 2???
	for(i=0; j=document.getElementById("tagContent"+i); i++){
		j.style.display = "none";
	}
	document.getElementById(showContent).style.display = "block";	
}
 function changevalidate()
    {
     document.getElementById("imag1").src="/servlets/vms?"+Math.random();
    }

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
</SCRIPT>
</head>

<body style="background:#F4F3F2;">
<div id="login-main" class="main-login">
	<div class="login">
		<div class="login1"><img src="/images/login_03.png" /></div>
		<div class="login2">
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
				  <%
				%>
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, AuthException.class.getName()) %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
				  <br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, "VERIFY_CODE_ERROR") %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "error-verify-code") %> </div>
				  <br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, CookieNotSupportedException.class.getName()) %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "authentication-failed-please-enable-browser-cookies") %> </div>
				  <br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, NoSuchUserException.class.getName()) %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
				  <br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, PrincipalException.class.getName()) %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "you-have-attempted-to-access-a-section-of-the-site-that-requires-authentication") %> <%= LanguageUtil.get(pageContext, "please-sign-in-to-continue") %> </div>
				  <br />
				</c:if>
				<c:if test='<%= SessionErrors.contains(request, UserEmailAddressException.class.getName()) %>'>
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
				  <br />
				</c:if>
				<c:if test="<%= SessionErrors.contains(request, UserPasswordException.class.getName()) %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "error-username-or-password") %> </div>
				  <br />
				</c:if>
				 <c:if test="<%= SessionErrors.contains(request, "SLEEP_USER") %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "inactive-user-exception") %> </div>
				  <br />
				</c:if> 
				<c:if test="<%= SessionErrors.contains(request, "INACTIVE_USER") %>">
				  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "inactive-user-exception") %> </div>
				  <br />
				</c:if>                
			</c:if>
			<form action="/c/portal/login" method="post" name="fm1" id="fm1">
				<input type="hidden" value="already-registered" name="cmd"/>
				<input type="hidden" value="already-registered" name="tabs1"/>
				<%
				String  login ="";
				if(company==null){company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");}
				login =LoginAction.getLogin(request, "login", company);
				%>
				<ul>
					<li><input  id="login" name="login" type="text"  class="login_input_1" style="font-size: 18px;font-family: '微软雅黑';" value="<%=login %>" placeholder="用户名"/></li>
					<div class="clear"></div>
					<li><input  id="password1" name="<%= SessionParameters.get(request, "password")%>" class="login_input_2" value="" type="password" style="font-size: 18px;font-family: '微软雅黑';" placeholder="密码" /></li>
					<div class="clear"></div>
					<li class="yan_zhen">
						<lable>
							<span>验证码</span>
							<input id="verifyCode" name="verifyCode" type="text" onKeyPress="onReturn(event)" value="" />
						</lable>
						<b>
							<img id="chkimg" width="80" height="30" align="absmiddle" src="/servlets/vms" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" />
						</b>
					</li>
					<div class="clear"></div>
					<li><input type="button" class="login_button_1" value="登录" onclick="javascript:submitForm()"/></li>
				</ul>
			</form>
		</div><!--login2 end-->
		<div class="login3">
		  <ul>
			<li><a href="#"><span class="red"></span></a></li>
			<li><a href="#"><span class="purple"></span></a></li>
			<li><a href="#"><span class="green"></span></a></li>
			<li><a href="#"><span class="dark-blue"></span></a></li>
			<li><a href="#"><span class="light-blue"></span></a></li>
			<li><a href="#"><span class="orange"></span></a></li>
		  </ul>
		</div><!--login3  end-->
	</div><!--login  end-->
	<div class="main-login-bot" style="position:relative;">
		<span style="position: absolute;font-size: 12px;  font-family: &quot;微软雅黑&quot;;  font-weight: 700;  color: #828282;left: 250px;top: 5px;letter-spacing: 2px;">上海伯俊软件科技有限公司&nbsp;&nbsp;www.burgeon.cn</span>
	</div>
</div>
<%@ include file="/inc_progress.jsp" %>
</body>
</html>

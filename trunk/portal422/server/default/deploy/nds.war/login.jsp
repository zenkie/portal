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
<style>
.login {
width: 100%;
height: 437px;
background: url(/images/index-horse.jpg) no-repeat,url(/images/index-bg-horse.png) repeat;/* left #DEAD4A;*/
/*background: url(images/index.gif) no-repeat left #790000;*/
position: absolute;
top: 100px;
background-position: 199px 0px;
}
.bar {
position: absolute;
top: 347px;
display: block;
width: 100%;
height: 90px;
background: url("");
text-indent: -999em;
-moz-opacity: .6;
filter: alpha(opacity=60);
opacity: 0.6;
}
#login-U {
top:0;
}
.STYLE29 {
font-size: 16px;
color: #5C676D;
font-family: "微软雅黑";
font-weight: bold;
}
</style>
</head>

<body>
	<div class="title">
		<h4 class="Logo"><img src="/images/left.gif" alt="伯俊logo"></h4>
	</div>
	<div id="login-main" class="login">
		<div id="bottom">
			<div id="bottom-right"><span class="bottom-logo"></span>&copy;2011-2013上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></div>
		</div>
		<div class="bar"></div>
		<div id="login-user">
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
			<form action="/c/portal/login" method="post" name="fm1" id="fm1">
				<input type="hidden" value="already-registered" name="cmd"/>
				<input type="hidden" value="already-registered" name="tabs1"/>
				<%
				String  login ="";
				if(company==null){
					company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");
				}
				login =LoginAction.getLogin(request, "login", company);
				%>
				<div id="login-U">
					  <table width="250" cellspacing="0" height="80" border="0" style="margin-top:77px;">
<tr>
	 <td width="53" height="20"><span class="STYLE29">用户名:</span></td>
      <td width="175">
        <label>
          <input id="login" name="login" type="text" class="Warning-120" size="25" value="<%=login %>" />
        </label>
     </td>
    </tr>
<tr>
      <td height="30"><span class="STYLE29">密&nbsp;&nbsp;&nbsp;码:</span></td>
      <td >
        <label>
        	<input id="password1" name="<%= SessionParameters.get(request, "password")%>" type="password" value=""  size="25" class="Warning-120"/>
  
        </label>
    </td>
    </tr>
<tr>
      <td height="20"><span class="STYLE29">验证码:</span></td>
      <td>
        <label>
        	<input id="verifyCode" name="verifyCode" type="text" onKeyPress="onReturn(event)" class="Warning-60"  size="7" />
					<img src="/servlets/vms" width="64" height="16" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" />       
        </label>
     </td>
	 </tr>
<tr>
	 <td  height="22">
	 <div id="Layer_3"><a href="#" onclick="javascript:submitForm()"><!--img src="/images/button.png" width="103" height="36" border="0" /-->登  陆</a></div>
	 </td>
	 </tr>
	 </table>
				</div>
			</form>
		</div>
	</div>
	<%@ include file="/inc_progress.jsp" %>
</body>
</html>

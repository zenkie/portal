<%@ page language="java" import="java.util.*" pageEncoding="gb2312"%>
<%@ include file="/html/portal/init.jsp" %>
<%
com.liferay.portal.util.CookieKeys.addSupportCookie(response);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>burgeon bos--�������</title>
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
		alert("�������Ա�û���");
		return;
	}
	else if(document.getElementById("password1").value==""){
		alert("����������");
		return;
	}
	else if(document.getElementById("verifyCode").value==""){
		alert("��������֤��");
		return;
	}else if(document.getElementById("verifyCode").value.length!=4){
		alert("����������֤��ĳ��Ȳ���!");
		return;
	}
	document.fm1.submit();
	document.body.innerHTML=document.getElementById("progress").innerHTML;
}
</SCRIPT>
</head>

<body>
<div id="login-main">

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

<div id="Layer2" >
<form action="/c/portal/login" method="post" name="fm1" id="fm1">
      <input type="hidden" value="already-registered" name="cmd"/>
       <input type="hidden" value="already-registered" name="tabs1"/>
	<%
		  String  login ="";
		   if(company==null)
		    {
           company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");
		    }
		 login =LoginAction.getLogin(request, "login", company);
		%>

<div id="Layer_2">
  <table width="250" cellspacing="0" height="80" border="0" style="margin-top:150px;">
<tr>
	 <td width="53" height="20"><span class="STYLE29">�û���:</span></td>
      <td width="175">
        <label>
          <input id="login" name="login" type="text" class="Warning-130" size="19" value="<%=login %>" />
        </label>
     </td>
    </tr>
<tr>
      <td height="30"><span class="STYLE29">��&nbsp;&nbsp;&nbsp;��:</span></td>
      <td >
        <label>
        	<input id="password1" name="<%= SessionParameters.get(request, "password")%>" type="password" value=""  size="19" class="Warning-130"/>
  
        </label>
    </td>
    </tr>
<tr>
      <td height="20"><span class="STYLE29">��֤��:</span></td>
      <td>
        <label>
        	<input id="verifyCode" name="verifyCode" type="text" onKeyPress="onReturn(event)" class="Warning-60"  size="7" />
					<img src="/servlets/vms" width="64" height="16" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" />       
        </label>
     </td>
	 </tr>
<tr>
	 <td  height="22">
	 <div id="Layer_3"><a href="#" onclick="javascript:submitForm()"><img src="/images/user-btn.gif" width="65" height="22" border="0" /></a></div>
	 </td>
	 </tr>
</form>
</table>
</div>
</form>
</div>

</div>
<div id="bottom">
<div id="bottom-right">&copy;2011-2012�Ϻ���������Ƽ����޹�˾ ��Ȩ����</div>
<div id="bottom-left">�˽�����Ʒ����:<br><a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></br>
</div>
</div>
</div>

<%@ include file="/inc_progress.jsp" %>
</body>
</html>

<%@ page language="java" import="java.util.*,nds.velocity.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
   String defaultClientWebDomain=conf.getProperty("webclient.default.webdomain");
   int defaultClientID= Tools.getInt(conf.getProperty("webclient.default.clientid"), 37);
   WebClient myweb=new WebClient(37, "","burgeon",false);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>首页</title> 
<style type="text/css">
ul,li{list-style:none;}
body{padding:0;margin:0 auto;background:#EDF0F0;}
.login{width:100%;height:550px;background:url(images/index.jpg) no-repeat center;}
#bottom {
padding-bottom:0px;
padding-left:0px;
padding-right:0px;
padding-top:510px;
clear: both;
margin: 0 auto;
left: 955px;
top: 355px;
width:1020px;
}
#bottom-left {
padding-bottom:0px;
padding-top:10px;
color: #333333;
font-size: 12px;
text-align:center;
}
#bottom-right {
padding-bottom:0px;
padding-top:0px;
color: #999999;
font-size: 12px;
text-align:center;
}
a.bottom-text {
    color: #FF6600;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 12px;
    font-weight: bold;
    text-decoration: underline;
}
a.bottom-text:hover {
    color: #024770;
    font-family: Arial,Helvetica,sans-serif;
    font-size: 12px;
    font-weight: bold;
    text-decoration: underline;
}
#Layer2 {
position:absolute;
margin:10px auto;
width:265px;
height:300px;
left: 62%;
top: 115px;
background:url(images/login.jpg) no-repeat center;
}
#Layer_2 {
position:absolute;
margin:10px auto;
width:246px;
height:293px;
left: 9%;
top: 0%;
z-index:2;
}
#Layer_3 {
position:absolute;
margin:0px auto;
color:#333399;
width:65px;
height:24px;
left: 25%;
top: 81%;
}
.STYLE29 {font-size:15px;color:#006699;font-family:"微软雅黑";font-weight:bold }
#Layer3 {
position:absolute;
margin:10px auto;
width:265px;
height:300px;
left: 62%;
top: 115px;
background:url(images/login.jpg) no-repeat center;
}
#LAYER3{
position:absolute;
margin:10px auto;
width:108px;
height:90px;
left: 30%;
top: 55%;
z-index:2;
}
</style>
<SCRIPT type=text/javascript>
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

<body>
<div class="title"></div>
<div class="login">
<div id="bottom">
	<div id="bottom-right">&copy;2011-2012上海伯俊软件科技有限公司 版权所有</div>
	<div id="bottom-left">了解更多产品请点击:<br><a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></br>
	</div>
</div>
<div id="Layer3">
<div id="LAYER3"> 
  <form action="/loginproc.jsp" method="post" name="fm1">
     	   <input type="hidden" value="already-registered" name="cmd"/>
   <input type="hidden" value="already-registered" name="tabs1"/> 
	<c:choose>
	<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
		<li><div class="l"><%= LanguageUtil.get(pageContext, "current-user")%>:</div><div class="right_text"><%=userWeb.getUserDescription() %></div>
		</li>
		<li><div class="lx"><%= LanguageUtil.get(pageContext, "enter-view") %>:<a href="/html/nds/portal/portal.jsp"><%= LanguageUtil.get(pageContext, "backmanager") %></a>
	,<%= LanguageUtil.get(pageContext, "or") %>:<a href="/c/portal/logout"><%= LanguageUtil.get(pageContext, "logout") %></a></div><div></div></li>
	</c:when>
	<c:otherwise>
	 <%
 	 String  login ="";
	 if(company==null){
          company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");
	 }
     login =LoginAction.getLogin(request, "login", company);
	%> 
</div>
</div>
<div id="Layer2" >
<div id="Layer_2">
  <table width="250" cellspacing="0" height="80" border="0" style="margin-top:150px;">
<tr>
	 <td width="53" height="20"><span class="STYLE29">用户名:</span></td>
      <td width="175">
        <label>
          <input id="login" name="login" type="text" class="Warning-120" size="19" value="<%=login %>" />
        </label>
     </td>
    </tr>
<tr>
      <td height="30"><span class="STYLE29">密&nbsp;&nbsp;&nbsp;码:</span></td>
      <td >
        <label>
        	<input id="password1" name="<%= SessionParameters.get(request, "password")%>" type="password" value=""  size="19" class="Warning-120"/>
  
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
	 <div id="Layer_3"><a href="#" onclick="javascript:submitForm()"><img src="/images/user-btn.gif" width="65" height="22" border="0" /></a></div>
	 </td>
	 </tr>
</form>
</table>
</div>
</div>
</div>
</c:otherwise>
</c:choose> 
</body>
</html>

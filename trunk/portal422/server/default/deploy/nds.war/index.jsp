<%@ page language="java" import="java.util.*,nds.velocity.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
   String defaultClientWebDomain=conf.getProperty("webclient.default.webdomain");
   int defaultClientID= Tools.getInt(conf.getProperty("webclient.default.clientid"), 37);
  //  int clientId=userWeb.getAdClientId(); 
  //  String webDomain =userWeb.getClientDomain();
  //  java.net.URL url = new java.net.URL(request.getRequestURL().toString());
	 // String webDomain=url.getHost();
	 // int clientId=WebUtils.getAdClientId(webDomain);
   // WebClient myweb=new WebClient(clientId, "",webDomain,false);
    //在/list/data_list.jsp的97行 int adClientId=37
    WebClient myweb=new WebClient(37, "","burgeon",false);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>Burgeon Portal - 伯俊软件</title>
<link href="/style_portal.css" rel="stylesheet" type="text/css" />
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
<div id="container">
<div id="head">
<div id="head_left"><img src="/images/head_logo_left.gif" width="297" height="64" /></div>
<div id="head_right"><img src="/images/head_logo_right.gif" width="232" height="64" /></div>
<div id="head_pic"><img src="/images/head_pic.jpg" width="982" height="334" border="0" usemap="#Map" />
<map name="Map" id="Map"><area shape="rect" coords="6,273,239,328" href="" /><area shape="rect" coords="255,272,485,330" href="" /><area shape="rect" coords="501,273,730,329" href="" /><area shape="rect" coords="744,272,976,327" href="" /></map></div>
</div>

<div id="content">
<div id="content_bg">
<div class="content_left">
<div class="content_left_login_bg">
<form action="/c/portal/login" method="post" name="fm1">
     	   <input type="hidden" value="already-registered" name="cmd"/>
   <input type="hidden" value="already-registered" name="tabs1"/> 
<div id="content_left_login">
<ul>
	<c:choose>
	<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
		<li><div class="left_text"><%= LanguageUtil.get(pageContext, "current-user")%>:</div><div class="right_text"><%=userWeb.getUserDescription() %></div></li>
		<li><div class="left_textx"><%= LanguageUtil.get(pageContext, "enter-view") %>:<a href="/html/nds/portal"><%= LanguageUtil.get(pageContext, "backmanager") %></a>
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
<li>
<div class="left_text">用户名：</div>
<div class="right_text"><input id="login" name="login" type="text" class="Warning-120" size="23" value="<%=login %>" /></div>
</li>
<div class="clear"></div>
<li>
<div class="left_text">密&nbsp;&nbsp;&nbsp;&nbsp;码：</div>
<div class="right_text"><input id="password1" name="<%= SessionParameters.get(request, "password")%>" type="password" value=""  size="10" class="Warning-120"/></div>
</li>
<div class="clear"></div>
<li>
<div class="left_text">验证码：</div>
<div class="right_text"><input id="verifyCode" name="verifyCode" type="text" onKeyPress="onReturn(event)" class="Warning-601"  size="10" />
<img src="/servlets/vms" width="64" height="16" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" />
</div>
</li>
<div class="clear"></div>
<li>
<div class="right_text"><a href="#" onclick="javascript:submitForm()"><image  src="/images/content_dl.gif" width="81" height="25" border="0" /></a>
</div>
</li>
</c:otherwise>
</c:choose> 
</ul>
</div>
</form>
</div>
</div>

<div class="content_middle">
<h2>
<a target="_blank" href="/news.jsp?newsstr=latest">更多</a>
<img src="/images/content_ico_1.gif"/>
最新动态</h2>
<div id="content_middle_border">
<div class="imgtxt01">
<div class="it01img"><img src="images/content_pic01.jpg" width="138" height="101" /></div>
<%   
     List newslist= QueryEngine.getInstance().doQueryList("select id,subject,content from u_news where doctype='hotspot' and ad_client_id=37 and rownum=1");
      if(newslist.size()>0){
        Object contentobj=((List)newslist.get(0)).get(2);
     String content="";
     content=((java.sql.Clob)contentobj).getSubString(1, (int) ((java.sql.Clob)contentobj).length()); 
%>
<div class="it01txt">
<span class="it01bold"><%=((List)newslist.get(0)).get(1)%></span><br/>
<span class="it01text"><a class="content_text" href="/news.jsp?id=<%=((List)newslist.get(0)).get(0)%>"><%=myweb.truString(content,45)%></a></span></div>
<%}%>
</div>
<div class="mdlist">
<ul class="list_middle">
<%
	 List latest=myweb.getList("latest","latest");
	 for(int k=0;k<latest.size();k++){
%>
<li><a href="<%=((List)latest.get(k)).get(0)%>" class="middle_list"><%=((List)latest.get(k)).get(1)%></a></li>
<%}%>
  </ul>
</div>
  </div>
</div>
<div class="content_right">
<h2>
<a target="_blank" href="/news.jsp?newsstr=company">更多</a>
<img src="/images/content_ico_1.gif"/>
公司新闻
</h2>
<div id="content_right_border">
<div class="imgtxt02">
<div class="it02img"><img src="images/content_pic02.jpg" width="112" height="82" /></div>
<div class="it02txt">
<div class="mdlist">
<ul class="ico_y">
 <%
	 List companyportal=myweb.getList("company","company");
	 for(int i=0;i<companyportal.size();i++){
	%>
<li><a href="<%=((List)companyportal.get(i)).get(0)%>" class="middle_list"><%=((List)companyportal.get(i)).get(1)%></a></li>
<%}%>
  </ul>
</div></div>
</div>
</div>
<br/>
<h2>
<a target="_blank" href="/news.jsp?newsstr=industry">更多</a>
<img src="/images/content_ico_1.gif"/>
行业新闻
</h2>
<div id="content_right_border">
<div class="imgtxt02">
<div class="it02img"><img src="images/content_pic02.jpg" width="112" height="82" /></div>
<div class="it02txt">
<div class="mdlist">
<ul class="ico_y">
	<%
	 List industry=myweb.getList("industry","industry");
	 for(int j=0;j<industry.size();j++){
	%>
<li><a href="<%=((List)industry.get(j)).get(0)%>" class="middle_list"><%=((List)industry.get(j)).get(1)%></a></li>
<%}%>
  </ul>
</div></div>
</div>
</div>
</div>
</div>
</div>
<div id="bottom">
<div id="bottom_bg">
<div id="bottom_text">&copy;2008 上海伯俊软件科技有限公司 版权所有 保留所有权&nbsp;&nbsp;|&nbsp;&nbsp;公司简介&nbsp;&nbsp;|&nbsp;&nbsp;联系我们</div>
</div>
</div>
</div>
</body>
<%@ include file="/inc_progress.jsp" %>
</html>


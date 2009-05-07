<%@ page language="java" import="java.util.*,nds.velocity.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  // int clientId= userWeb.getAdClientId();
 //  String webDomain=userWeb.getClientDomain();
 
   WebClient myweb=new WebClient(37, "","burgeon",false);
   boolean flag=true;
   int id=Tools.getInt(request.getParameter("id"),-1);
   String newsstr="";
   if(id==-1){
      newsstr=(String)request.getParameter("newsstr");
      if(newsstr==null){
        	response.sendRedirect("/index.jsp");
       }
      flag=false;
     }  
      Map mainnews=null;
      String doctype="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>Burgeon Portal - 伯俊软件</title>
<link href="style_portal.css" rel="stylesheet" type="text/css" />
<script src="/html/js/sniffer.js" type="text/javascript"></script>
<script src="/html/js/ajax.js" type="text/javascript"></script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/js/top_css_ext.js"></script>
<script type="text/javascript" language="JavaScript1.5" src="/html/nds/js/ieemu.js"></script>
<script type="text/javascript" src="/html/nds/js/cb2.js"></script>
<script type="text/javascript" src="/servlets/dwr/interface/Controller.js"></script>
<script type="text/javascript" src="/servlets/dwr/engine.js"></script>
<script type="text/javascript" src="/servlets/dwr/util.js"></script>
<script language="javascript" src="/html/nds/js/jquery/jquery.js"></script>
<script>
jQuery.noConflict();
</script>		
<script type="text/javascript" src="/html/nds/js/portletcontrol.js"></script>
<script language="javascript" src="/html/nds/js/init_portletcontrol_zh_CN.js"></script>
<script type="text/javascript" src="/html/nds/js/selectableelements.js"></script>
<script type="text/javascript" src="/html/nds/js/selectabletablerows.js"></script>
<script type="text/javascript" src="/html/nds/js/calendar.js"></script>
</head>

<body>
<div id="container">
<div id="head">
<div id="head_left"><a href="/index.jsp"><img src="/images/head_logo_left.gif" width="297" height="64" /></a></div>
<div id="head_right"><img src="/images/head_logo_right.gif" width="232" height="64" /></div>
<div id="head_pic"><img src="/images/head_Newspic.jpg" width="982" height="212" /></div>
</div>

<div id="news_content">
<div id="news_left">
<div class="news_left_top"></div>
<div id="news_left_center">
<div id="news_center_left">
<ul>
      <li><a href="/news.jsp?newsstr=latest">最新动态</a></li>
      <li><a href="/news.jsp?newsstr=industry">行业新闻 </a></li>
      <li><a href="/news.jsp?newsstr=company">公司新闻 </a></li>
</ul>
</div>
</div>
<div class="news_left_bottom"></div>
</div>
<div id="news_right_bg">
<div id="news_right">
	<%if(flag==true){
	 mainnews=myweb.getObject("u_news",id,2);
	 doctype=(String)mainnews.get("doctype");
	}
	%>
	<% if(newsstr.equals("company")||doctype.equals("company")){%>
<div class="news_right_top"><img src="/images/news_right_title01.gif" width="90" height="27" /></div>
	<% }else if(newsstr.equals("latest")||doctype.equals("latest")){%>
		<div class="news_right_top"><img src="/images/news_right_title.gif" width="90" height="27" /></div>
		<% }else if(newsstr.equals("industry")||doctype.equals("industry")){%>
		<div class="news_right_top"><img src="/images/news_right_title02.gif" width="90" height="27" /></div>
	<%}%>
<div id="news_right_center" align="center">
<div id="news_center_right" align="center"> 
<% if(flag==false){   
   out.print(myweb.forwardToString("/list/view.jsp?compress=f&dataconf="+newsstr+"&uiconf="+newsstr+"_list",request,response));
%>
<%}else{
  String subject=(String)mainnews.get("subject"); 
  String datenum=(String)myweb.getDate(mainnews.get("publishdate"));
  String content=(String)mainnews.get("content");
  int cnt=Tools.getInt(mainnews.get("readcnt"),1);
%>
<div class="news_center_right_border">
<div class="news_center_right_title"><%=subject%></div>
<div class="news_center_right_text">发布于：<%=datenum%></div>
<% myweb.updateNewsCounter(id);
%>
<div class="news_center_right_text02">浏览次数：<%=cnt%>次</div>
</div>
<div class="news_center_right_text01"><%=content%></div>
<%}%>
</div>
</div>
<div class="news_right_bottom"></div>
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
</html>


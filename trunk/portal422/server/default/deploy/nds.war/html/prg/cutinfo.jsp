<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
  int cu= Tools.getInt(request.getParameter("cu"),-1);
  int cs=Tools.getInt(request.getParameter("cs"),-1);
  int un=Tools.getInt(request.getParameter("un"),-1);
  int pn= Tools.getInt(request.getParameter("pn"),-1);
  String cp=(String)request.getParameter("cp");
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  Date expdate=df.parse((String)request.getParameter("exp"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>注册成功</title>
<link rel="stylesheet" href="/html/nds/css/prg.css" type="text/css" />
</head>
<body>
<div width=100% margin:0 auto>	
<div class="title">
<h4 class="Logo"><img src="/images/newimages/home_logo.png" alt="伯俊logo" title="" /></h4>
</div>
<div class="main" style="text-align:center;">
<font color="#ffffff">
<h1>Portal注册产品信息</h1>
<h2>客户名称：<span><%=cp%></span></h2>
<table class="bordered">
<thead>
  <tr>
    <th>用户数</th>
    <th>当前用户数</th>
    <th>POS数</th>
    <th>当前POS数</th>
  </tr>
 </thead> 
  <tr>
    <td><%=un%></td>
    <td><%=cu%></td>
    <td><%=pn%></td>
    <td><%=cs%></td>
  </tr>
</table>
<font color="yellow">
	<h2>服务到期时间：<span><%=df.format(expdate)%></span></h2>
	<h2>距离服务到期还有：<span><%=(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000)>0?(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000):0%></span>天</h2>
</font>
</font>
<h1><a href="/html/nds/portal/portal.jsp"><font color="yellow">继续使用</font></a></h1>
<ul><font color="yellow">当前点数已超过证书授权，系统将于1小时时候自动关闭！</font></ul>
</div>
<div id="bottom">
<div id="bottom-right">&copy;2008-<%=Calendar.getInstance().get(Calendar.YEAR)%>上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></div>
</div>
</div>
</body>
</html>

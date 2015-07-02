<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
   SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  Date expdate= df.parse((String)request.getParameter("exp"));
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>登录失败</title>
    <link rel="stylesheet" href="/html/nds/css/prg.css" type="text/css" />
</head>
<body>
    <div class="title">
        <h4 class="Logo">
            <img src="/images/newimages/home_logo.png" alt="伯俊logo" title="" /></h4>
    </div>
    <div class="fail-panel">
        <h1>
            <div class="white">Portal产品测试注册时间已经截止</div>
        </h1>
        <div class="yellow">
            <h2>服务到期时间：<span><%=df.format(expdate)%></span></h2>
            <h2>距离服务到期还有：<span><%=(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000)>0?(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000):0%></span>天</h2>
        </div>
        <h1><font color="#ffffff">请重新注册!</font></h1>
        <h1><a href="/html/prg/vaildkey.jsp"><font color="yellow">注册</font></a></h1>
    </div>
    <div id="bottom">
        <div id="bottom-right">&copy;2008-<%=Calendar.getInstance().get(Calendar.YEAR)%>上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></div>
    </div>
</body>
</html>


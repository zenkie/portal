<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
  int usrnum= Tools.getInt(request.getParameter("user"),-1);
  int posnum= Tools.getInt(request.getParameter("pos"),-1);
  String cp=(String)request.getParameter("cp");
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
  Date expdate= df.parse((String)request.getParameter("exp"));
  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="/html/nds/css/prg.css" type="text/css" />
    <title>注册成功</title>
</head>
<body>
    <div>
        <div class="title">
            <h4 class="Logo">
                <img src="/images/newimages/home_logo.png" alt="伯俊logo"></h4>
        </div>
        <div class="main" style="margin-right: auto; margin-left: auto; text-align: center;">
            <div class="white">
                <h1>Portal注册产品信息</h1>
                <h2>客户名称：<span><%=cp%></span></h2>
                <h2>用户数：<span><%=usrnum%></span></h2>
                <h2>POS数：<span><%=posnum%></span></h2>
                <div class="expdate">
                    <div class="yellow">
                        <h2>服务到期时间：<span><%=df.format(expdate)%></span></h2>
                        <h2>距离服务到期还有：<span><%=(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000)>0?(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000):0%></span>天</h2>
                    </div>
                </div>
            </div>
            <h1><a href="/" class="white">登陆</a></h1>
        </div>
        <div id="bottom">
            <div id="bottom-right">&copy;2008-<%=java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)%>上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></div>
        </div>
    </div>
</body>
</html>


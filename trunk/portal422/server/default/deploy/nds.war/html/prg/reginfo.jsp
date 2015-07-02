<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.util.LicenseManager"%>
<%@ page import="nds.util.LicenseWrapper"%>
<%
	int un=0;
	int pn=0;
	int  cu=0;
	int  cs=0;
	String cp=null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	Connection conn=null;
	String mac=null;
	Object sc=null;
	Date expdate=new java.util.Date();
	java.text.SimpleDateFormat df=new java.text.SimpleDateFormat("yyyy-MM-dd");
	try{
	conn= nds.query.QueryEngine.getInstance().getConnection();
	pstmt= conn.prepareStatement("select mac from users where id=?");
	pstmt.setInt(1, 893);
	rs= pstmt.executeQuery();
	if(rs.next()){
		sc=rs.getObject(1);
		if(sc instanceof java.sql.Clob) {
			mac=((java.sql.Clob)sc).getSubString(1, (int) ((java.sql.Clob)sc).length());
	        }else{
	        mac=(String)sc;
	        }	
	}
	try{
	LicenseManager.validateLicense("bos20","5.0",mac,true);
	QueryEngine engine=QueryEngine.getInstance();
	Iterator b=LicenseManager.getLicenses();
	    while (b.hasNext()) {
	    	LicenseWrapper o = (LicenseWrapper)b.next();
	    	un=o.getNumUsers();
			pn=o.getNumPOS();
			cp=o.getName();
			expdate=o.getExpiresDate();
	    }
		cu=Tools.getInt(engine.doQueryOne("select count(*) from users t where t.isactive='Y' and t.IS_SYS_USER!='Y'"), -1);
		cs=Tools.getInt(engine.doQueryOne("select count(*) from c_store t where t.isactive='Y' and t.isretail='Y'"), -1);
	} catch (Exception e) {
	}
	}catch(Throwable t){

	}finally{
		try{if(rs!=null) rs.close();}catch(Throwable t){}
		try{if(pstmt!=null) pstmt.close();}catch(Throwable t){}
		try{if(conn!=null) conn.close();}catch(Throwable t){}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="/html/nds/css/prg.css" type="text/css" />
    <title>认证信息</title>
</head>
<body>
    <div>
        <div class="title">
            <h4 class="Logo">
                <img src="/images/newimages/home_logo.png" alt="伯俊logo"></h4>
        </div>
        <div class="main" style="text-align: center;">
            <div class="white">
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
                <div class="expdate">
                    <div class="yellow">
                        <h2>服务到期时间：<span><%=df.format(expdate)%></span></h2>
                        <h2>距离服务到期还有：<span><%=(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000)>0?(expdate.getTime()-System.currentTimeMillis())/(24*60*60*1000):0%></span>天</h2>
                    </div>
                </div>
            </div>
        </div>
        <div id="bottom">
            <div id="bottom-right">&copy;2008-<%=java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)%>上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a></div>
        </div>
    </div>
</body>
</html>

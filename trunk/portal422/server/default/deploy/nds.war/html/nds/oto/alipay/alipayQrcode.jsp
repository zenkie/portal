<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
String dialogURL=request.getParameter("redirect");
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
}
int id=Tools.getInt(request.getParameter("id"),0);
/*JSONArray inofja=null;
try{
	inofja=QueryEngine.getInstance().doQueryObjectArray("select ro.id,ro.rechargemoney,ro.rechargenumber,ro.description from wx_rechargeoptions ro", null);
	System.out.println(inofja.toString());
}catch(Exception e){
	System.out.println("get info error->"+e.getMessage());
}
String options="";
JSONObject tjo=null;
if(inofja!=null&&inofja.length()>0){
	for(int i=0;i<inofja.length();i++){
		tjo=inofja.optJSONObject(i);
		if(tjo!=null){
			options+="<option value=\""+tjo.optDouble("RECHARGEMONEY",0)+"\" text=\""+tjo.optInt("RECHARGENUMBER",0)+"\">"+tjo.optString("DESCRIPTION")+"</option>" ;
		}
	}
}*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/base.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/page.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/style.css">

<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/oto/js/prg/upload/jquery.uploadifive.min.js"></script>

<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js"></script>
<link type="text/css" href="/html/nds/oto/js/artDialog4/skins/default.css" rel="Stylesheet">
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/oto/alipay/js/alipayQrcode.js"></script>
<title>alipay</title>
<style>
		*{
			padding: 0; margin: 0;
		}
		body{
			font-family: "微软雅黑";
		}
		#header{
			height: 42px;
			padding: 4px 0;
			background: #eee url(../images/zfb.png) no-repeat 30px 0;
		}
		#content{
			
		}
		#main{
			position: absolute; top: 37%; left: 50%;
			width: 500px; height: 294px;
			margin: -125px 0 0 -250px;

			border-radius: 4px;
			overflow: hidden;
		}
		#main .title{
			font-size: 20px; color:#fff; text-align: center;
			background-color: #f90;
		}
		#main .info{
			height: 222px;/*calc(100% - 28px);*/
			//border: 1px solid #ccc;
			/*border-top: none;*/
			text-align: center;
		}
		#main .code{
			height: 30px; width: 80%;
			margin-top: 30px;
			/*border: 1px solid #888;
			border-radius: 6px;*/
			font-size: 19px;
			line-height:30px;
		}
		#main .loadingprint{
			height: 30px; width: 100%;
			/*margin-top: 30px;
			border: 1px solid #888;
			border-radius: 6px;
			background: url("/images/animated-overlay.gif");
			background-color:#F1E26E;
			filter: alpha(opacity=25);*/			
			/*margin-left: 75px;*/
		}
		#main .loading{
			height: 30px; width: 80%;
			margin-top: 30px;
			border: 1px solid #888;
			border-radius: 6px;
			background: url("/images/animated-overlay.gif");
			background-color:#F1E26E;
			filter: alpha(opacity=25);
			opacity: 0.5;
			margin-left: 55px;
		}		
		#main .success{
			height: 30px;
			margin-top: 30px;
		}
		#main .btn{
			margin-top: 42px;
			//border-radius: 3px;
		}
		#main .btn button{
			width: 70px; height: 25px;
			margin: 0 10px;
			cursor:pointer;
			border:none;
			outline: none; 
			font-size:13px;
		}
		#header button{
			width: 88px; height: 30px;
			margin: 0 20px;
			cursor:pointer;
			float: right;
		}		
		#createPay{
			width: 88px; height: 30px;
			margin: 0 10px;
		}
		.fee{
			//color: #f00;
			font-size: 13px;
			//font-weight: bold;
			font-family: 微软雅黑;
			margin-left: -73px; 
		}
		.cfee{
			/*color: #f00;*/
			font-size: 13px;
			//font-weight: bold;
			width: 130px;
			height: 20px;
			padding-left: 2px;
		}
		#quickMark{
			margin-top: 55px;
			margin-bottom: -25px;
			width: 150px;
		}
		#header button{
			width: 88px; height: 30px;
			margin: 0 20px;
			cursor:pointer;
			float: right;
		}
		.alibtn{
			background-color: #A7C238;
			color: #fff;
			display: inline-block;
			/*position: relative;
			margin: 10px;*/
			padding: 0 20px;
			text-align: center;
			text-decoration: none;
			border-radius: 5px;
		}
		.alibtn:hover {
			background: #b5cf4a;
		}
		.alibtn:active {
			background: #9cb146;
		}	
		.alipay_tip1{
			margin-top: 95px;
			text-align: -webkit-auto;
			width: 345px;
			margin-left: 82px;
			font-size: 12px;
			color: #898989;
		}
		.alipay_tip2{
			margin-top: 0px;
			text-align: -webkit-auto;
			width: 345px;
			margin-left: 82px;
			font-size: 12px;
			color: #898989;
		}
</style>	
</head>
<body height="670px">
	<input type="button" value="支付请求" style="width:50px;display:none;" onclick="al.sendpay();"/>
	<input type="button" value="交易查询" style="width:50px;display:none;" onclick="al.querytrade();"/>
	<input type="button" value="交易撤销" style="width:50px;display:none;" onclick="al.tradecancel();"/>
	<div id="content">
		<div id="main">
			<div id="title" class="title">二维码支付</div>
			<div class="info">
				<div id="createOrder">
					<div style="padding-top: 40px;height:10px;padding-bottom: 30px;">	

						<div id="ismakeout" class="fee" style="margin-left: -155px;">是否开票：
							<input name="makeout" type="radio" value="Y" />是
							<input name="makeout" type="radio" value="N" checked="checked" style="margin-left: 22px;" />否
						</div>
						
						<div style="display:none;">单号：</div><div id="orderNo" style="display:none;">148</div>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<div class="fee" style="margin-left: -77px;">充值金额：
							<input id="recharemoney" type="text" class="cfee" onkeyup="return al.enterpress(event)"  />&nbsp;&nbsp;元
						</div>
						</br>
						<div class="fee" style="position: absolute;left: 173px;top: 115px;">
							短信条数：
							<span id="recharenumber"></span>
							<span>&nbsp;&nbsp;&nbsp;条</span>
						
						</div>
						<div class="btn">
							<button style="position: absolute;left: 88px;"  id="createPay" class="alibtn" onclick="javascript:al.createRechareRecode();">下&nbsp&nbsp单</button>
							
							
							<button style="position: absolute;left: 246px;" class="alibtn" onclick="javascript:al.closeDialog();">关&nbsp&nbsp闭</button>
							
						</div>
						<div class="alipay_tip1">1. &nbsp充值金额小于1000元时，按照0.1元/条计算短信条数；大于等于1000元时，按照0.08元/条计算。
						</div>
						<div class="alipay_tip2">2. &nbsp发票每月末统一寄出，按照公司信息中联系人姓名、联系人电话，公司地址进行快递。
						</div>
					</div>
				</div>
				<div id="printQuickMark" style="display:none;">
					<div id="page1" class="loadingprint"><img style="position: absolute;left: 174px;" id="quickMark" src=""/></div>
					<div class="btn" style="margin-top: 206px;">
						<button style="position: absolute;left: 139px;"  id="search" class="alibtn" onclick="al.querytrade();">查询</button>
						<!--<button id="print" class="btn" onclick="al.tradecancel();">撤单</button>-->
						<button style="position: absolute;left: 275px;" id="canclePay" class="alibtn" onclick="al.closeDialog()">关闭</button>
					</div>
				</div>
				<div id="waitPay" style="display:none;">
					<div style="padding-top: 30px;height:21px;"><span>等待支付......</span></div>
					<div class="loading"></div>
					<div class="btn">
						<!--<button class="btn" onclick="al.tradecancel();">撤单</button>-->
						<button id="reprint" class="btn" onclick="al.returnPrevious();" style="display:none;">返回上级</button>
						<!--<button id="canclePay" class="btn" onclick="al.closeDialog()">关闭</button>-->
					</div>
				</div>
				<div id="paySuccess" style="display:none;">
					<div style="padding-top: 30px;height:21px;"><span></span></div>
					<div class="success">支付成功</div>
					<div class="btn">
						<button class="btn" onclick="al.reghargesummess();">完成</button>
						<button id="closePay" class="btn" onclick="al.closeDialog()">关闭</button>
					</div>
				</div>
				<div id="waitCancle" style="display:none;">
					<div style="padding-top: 30px;height:21px;"><span>等待撤消</span></div>
					<div class="loading"></div>
					<div class="btn">
						<button id="closeWaitRefund" class="btn" onclick="al.closeDialog()">关闭</button>
					</div>
				</div>
				<div id="cancleSuccess" style="display:none;">
					<div style="padding-top: 30px;height:21px;"><span></span></div>
					<div class="success">撤消成功</div>
					<div class="btn">
						<button id="closeRefund" class="btn" onclick="al.closeDialog()">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>

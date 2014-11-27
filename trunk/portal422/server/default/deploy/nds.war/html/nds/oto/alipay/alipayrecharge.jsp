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
int compayid=userWeb.getAdClientId();
List smsinfo=null;
try{
	smsinfo=QueryEngine.getInstance().doQueryList("select si.id,si.smsmoney,si.canusenumber-getsendsmscount(si.ad_client_id) \"canusenumber\",getsendsmscount(si.ad_client_id) \"usednumber\",si.smsprice from wx_smsinfo si where si.ad_client_id=?",new Object[] {compayid});	
}catch(Exception e){
	System.out.println("get smsinfo error->"+e.getMessage());
	return;
}

JSONObject smsinfojo=new JSONObject();
if(smsinfo!=null&&smsinfo.size()>0){
	try{
		smsinfojo.put("money",((List)smsinfo.get(0)).get(1));
		smsinfojo.put("canuse",((List)smsinfo.get(0)).get(2));
		smsinfojo.put("used",((List)smsinfo.get(0)).get(3));
		smsinfojo.put("price",((List)smsinfo.get(0)).get(4));
	}catch(Exception e){
		System.out.println("init smsinfojo error->"+e.getMessage());
		return;
	}
}else{
	try{
		smsinfojo.put("money",0);
		smsinfojo.put("canuse",0);
		smsinfojo.put("used",0);
		smsinfojo.put("price",0.05);
	}catch(Exception e){
		System.out.println("init smsinfojo error->"+e.getMessage());
		return;
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<link type="text/css" href="/html/nds/oto/rqcode/css/wxreplay.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/qrcodes.css" rel="Stylesheet">

<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/oto/js/upload/jquery.uploadify.min.js"></script>

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
<script language="javascript" src="/html/nds/oto/alipay/js/alipayrecharge.js"></script>
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
			position: absolute; top: 50%; left: 50%;
			width: 500px; height: 250px;
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
			border: 1px solid #ccc;
			/*border-top: none;
			text-align: center;*/
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
			opacity: 0.5;
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
			margin-top: 22px;
			text-align: center;
		}
		#main .btn button{
			width: 88px; height: 30px;
			margin: 0 10px;
			cursor:pointer;
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
			color: #f00;
			font-size: 24px;
			font-weight: bold;
		}
		#quickMark{
			margin-top: 20px;
			margin-bottom: -25px;
			width: 120px;
		}
		#header button{
			width: 88px; height: 30px;
			margin: 0 20px;
			cursor:pointer;
			float: right;
		}
		#createOrder .smsinfo{
			margin:5px 0;
			padding-left: 189px;
			font-size: 20px;
			font-weight: bolder;
		}
</style>
<script type="text/javascript" language="javascript">
	jQuery(document).ready(
		function init(){
			companysmsinfo.main();
			csi.smsinfo=<%=smsinfojo%>;
			csi.initsmsinfo();
		}
	);
</script>	
</head>
<body height="670px">
	<input type="button" value="支付请求" style="width:50px;display:none;" onclick="al.sendpay();"/>
	<input type="button" value="交易查询" style="width:50px;display:none;" onclick="al.querytrade();"/>
	<input type="button" value="交易撤销" style="width:50px;display:none;" onclick="al.tradecancel();"/>
	<div id="content">
		<div id="main">
			<div id="title" class="title">短信充值</div>
			<div class="info">
				<div id="createOrder">
					<div style="padding-top: 20px;">
						<div class="smsinfo"><span>余额：</span><span id="money">148</span></div>
						<div class="smsinfo"><span>可用短信数：</span><span id="canusenumber"></span></div>
						<div class="smsinfo"><span>已用短信数：</span><span id="usednumber"></span></div>
						<div class="smsinfo" style="display:none;"><span>短信单价：</span><span id="price"></span></div>
					</div>
					<div class="btn">
						<button id="createPay" onclick="javascript:csi.recharge();">充值</button>
						<button onclick="javascript:al.closeDialog();">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>

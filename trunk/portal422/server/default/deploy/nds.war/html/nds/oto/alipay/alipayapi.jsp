<%
/* *
 *功能：手机网页支付接入页
 *版本：3.3
 *日期：2012-08-14
 *说明：
 *以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 *该代码仅供学习和研究支付宝接口使用，只是提供一个参考。

 *************************注意*****************
 *如果您在接口集成过程中遇到问题，可以按照下面的途径来解决
 *1、商户服务中心（https://b.alipay.com/support/helperApply.htm?action=consultationApply），提交申请集成协助，我们会有专业的技术工程师主动联系您协助解决
 *2、商户帮助中心（http://help.alipay.com/support/232511-16307/0-16307.htm?sh=Y&info_type=9）
 *3、支付宝论坛（http://club.alipay.com/read-htm-tid-8681712.html）
 *如果不想使用扩展功能请把扩展功能参数赋空值。
 **********************************************
 */
 %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.schema.*" %>
<%@ page import="com.alipay.config.*"%>
<%@ page import="com.alipay.util.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="nds.weixin.ext.*"%>

<%
WeUtils wu=null;
AlipayConfig aliconfig=new AlipayConfig();
java.net.URL url=null;
	try{
		url = new java.net.URL(request.getRequestURL().toString());
		System.out.print("alipay url->"+url);
		WeUtilsManager Wemanage =WeUtilsManager.getInstance();
		wu =Wemanage.getByDomain(url.getHost());
		System.out.print("alipay url->"+url.getHost());
	}catch(Exception t){
		System.out.print("get path error->"+t.getMessage());
		t.printStackTrace();
	}
	if(wu==null){
		System.out.println("not found WeUtils");
		out.println("not found WeUtils");
		return;
	}
	List al=QueryEngine.getInstance().doQueryList("select t.paymail,t.partner,t.alikey from WX_PAY t where t.ad_client_id="+wu.getAd_client_id()+" and t.pcode='alipay'");
	if (al.size() > 0) {
	String paymail = (String) ((List) al.get(0)).get(0);
	String partner = (String) ((List) al.get(0)).get(1);
	String alikey = (String) ((List) al.get(0)).get(2);
	if(nds.util.Validator.isNull(paymail)||nds.util.Validator.isNull(partner)||nds.util.Validator.isNull(alikey)){
		out.println("请正确设置支付宝支付方式中的参数");
		return;
	}
	aliconfig=new AlipayConfig();
	aliconfig.setKey(alikey);
	aliconfig.setPaymail(paymail);
	aliconfig.setPartner(partner);}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>支付宝手机网页支付</title>
	</head>
	<%
		//支付宝网关地址
		String ALIPAY_GATEWAY_NEW = "http://wappaygw.alipay.com/service/rest.htm?";

		////////////////////////////////////调用授权接口alipay.wap.trade.create.direct获取授权码token//////////////////////////////////////
		
		//返回格式
		String format = "xml";
		//必填，不需要修改
		
		//返回格式
		String v = "2.0";
		//必填，不需要修改
		
		//请求号
		String req_id = UtilDate.getOrderNum();
		//必填，须保证每次请求都是唯一
		
		//req_data详细信息
		
		//服务器异步通知页面路径
		String notify_url = "http://"+url.getHost()+"/html/nds/oto/alipay/notify_url.jsp";
		//需http://格式的完整路径，不能加?id=123这类自定义参数

		//页面跳转同步通知页面路径
		String call_back_url = "http://"+url.getHost()+"/html/nds/oto/alipay/call_back_url.jsp";
		//需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/

		//操作中断返回地址
		String merchant_url = "http://"+url.getHost()+"/mall.jsp";
		//用户付款中途退出返回商户的地址。需http://格式的完整路径，不允许加?id=123这类自定义参数
		//System.out.print(request.getParameter("WIDseller_email"));
		//卖家支付宝帐户
		String seller_email = aliconfig.getPaymail();//new String(request.getParameter("WIDseller_email").getBytes("ISO-8859-1"),"UTF-8");
		//必填
		System.out.print(seller_email);

		//商户订单号
		String out_trade_no = new String(request.getParameter("WIDout_trade_no").getBytes("ISO-8859-1"),"UTF-8");
		System.out.print(out_trade_no);
		//商户网站订单系统中唯一订单号，必填

		//订单名称
		String subject = request.getParameter("WIDsubject");//new String(request.getParameter("WIDsubject").getBytes("ISO-8859-1"),"UTF-8");
		//必填
		System.out.print(subject);

		//付款金额
		String total_fee = new String(request.getParameter("WIDtotal_fee").getBytes("ISO-8859-1"),"UTF-8");
		System.out.print(total_fee);

		//必填
		
		//请求业务参数详细
		String req_dataToken = "<direct_trade_create_req><notify_url>" + notify_url + "</notify_url><call_back_url>" + call_back_url + "</call_back_url><seller_account_name>" + seller_email + "</seller_account_name><out_trade_no>" + out_trade_no + "</out_trade_no><subject>" + subject + "</subject><total_fee>" + total_fee + "</total_fee><merchant_url>" + merchant_url + "</merchant_url></direct_trade_create_req>";
		//必填
		
		//////////////////////////////////////////////////////////////////////////////////
		
		//把请求参数打包成数组
		Map<String, String> sParaTempToken = new HashMap<String, String>();
		sParaTempToken.put("service", "alipay.wap.trade.create.direct");
		sParaTempToken.put("partner", aliconfig.getPartner());
		System.out.print(aliconfig.getPartner());
		System.out.print(aliconfig.getKey());

		sParaTempToken.put("_input_charset", aliconfig.input_charset);
		sParaTempToken.put("sec_id", aliconfig.sign_type);
		System.out.print("sec_id->"+aliconfig.sign_type);

		sParaTempToken.put("format", format);
		System.out.print("format->"+format);

		sParaTempToken.put("v", v);
		System.out.print("v->"+v);

		sParaTempToken.put("req_id", req_id);
		System.out.print("req_id->"+req_id);

		sParaTempToken.put("req_data", req_dataToken);
		System.out.print("req_data->"+req_dataToken);


		AlipaySubmit alisubimt=new AlipaySubmit();
		alisubimt.setAlipayConfig(aliconfig);

		//建立请求
		String sHtmlTextToken = alisubimt.buildRequest(ALIPAY_GATEWAY_NEW,"", "",sParaTempToken);
		//URLDECODE返回的信息
		sHtmlTextToken = URLDecoder.decode(sHtmlTextToken,aliconfig.input_charset);
		System.out.print("sHtmlTextToken->"+sHtmlTextToken);

		//获取token
		String request_token = alisubimt.getRequestToken(sHtmlTextToken);
		System.out.print("request_token->"+request_token);
		
		////////////////////////////////////根据授权码token调用交易接口alipay.wap.auth.authAndExecute//////////////////////////////////////
		
		//业务详细
		String req_data = "<auth_and_execute_req><request_token>" + request_token + "</request_token></auth_and_execute_req>";
		//必填
		
		//把请求参数打包成数组
		Map<String, String> sParaTemp = new HashMap<String, String>();
		sParaTemp.put("service", "alipay.wap.auth.authAndExecute");
		sParaTemp.put("partner", aliconfig.getPartner());
		sParaTemp.put("_input_charset", aliconfig.input_charset);
		sParaTemp.put("sec_id", aliconfig.sign_type);
		sParaTemp.put("format", format);
		sParaTemp.put("v", v);
		sParaTemp.put("req_data", req_data);
		
		//建立请求
		String sHtmlText = alisubimt.buildRequest(ALIPAY_GATEWAY_NEW, sParaTemp, "get", "确认");
		System.out.print("sHtmlText->"+sHtmlText);
		out.println(sHtmlText);
	%>
	<body>
	</body>
</html>

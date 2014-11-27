<%
/* *
 功能：支付宝服务器异步通知页面
 版本：3.3
 日期：2012-08-17
 说明：
 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。

 //***********页面功能说明***********
 创建该页面文件时，请留心该页面文件中无任何HTML代码及空格。
 该页面不能在本机电脑测试，请到服务器上做测试。请确保外部可以访问该页面。
 该页面调试工具请使用写文本函数logResult，该函数在com.alipay.util文件夹的AlipayNotify.java类文件中
 如果没有收到该页面返回的 success 信息，支付宝会在24小时内按一定的时间策略重发通知
 //********************************
 * */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.schema.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.alipay.util.*"%>
<%@ page import="com.alipay.config.*"%>
<%@ page import="org.dom4j.Document"%>
<%@ page import="org.dom4j.DocumentHelper"%>
<%@ page import="nds.weixin.ext.*"%>
<%@ page import="nds.control.web.ClientControllerWebImpl,nds.control.event.DefaultWebEvent"%>
<%@ page import="java.io.InputStream,java.io.BufferedInputStream,java.io.ByteArrayOutputStream,java.text.SimpleDateFormat"%>
<%
//根据请求获取config
WeUtils wu=null;
AlipayConfig aliconfig=new AlipayConfig();
java.net.URL url=null;
	try{
		url = new java.net.URL(request.getRequestURL().toString());
		//System.out.print(url);
		WeUtilsManager Wemanage =WeUtilsManager.getInstance();
		wu =Wemanage.getByDomain(url.getHost());
		//System.out.print(url.getHost());

	}catch(Exception t){
		System.out.print("get path error->"+t.getMessage());
		out.println("get path error");
		t.printStackTrace();
		return;
	}
	if(wu==null){
		System.out.println("not found WeUtils");
		out.println("not found WeUtils");
		return;
	}
	List al=QueryEngine.getInstance().doQueryList("select t.paymail,t.partner,t.alikey from WX_PAY t where t.ad_client_id="+wu.getAd_client_id()+" and t.pcode='alipay'");
	if(al==null||al.size()<=0){
		System.out.println("get pay info error");
		out.println("get pay info error");
		return;
	}
	String paymail = (String) ((List) al.get(0)).get(0);
	String partner = (String) ((List) al.get(0)).get(1);
	String alikey = (String) ((List) al.get(0)).get(2);
	aliconfig=new AlipayConfig();
	aliconfig.setKey(alikey);
	aliconfig.setPaymail(paymail);
	aliconfig.setPartner(partner);

	AlipayNotify alinotify=new AlipayNotify();
	alinotify.setAlipayConfig(aliconfig);

	//获取支付宝POST过来反馈信息
	Map<String,String> params = new HashMap<String,String>();
	Map requestParams = request.getParameterMap();
	for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
		String name = (String) iter.next();
		String[] values = (String[]) requestParams.get(name);
		String valueStr = "";
		for (int i = 0; i < values.length; i++) {
			valueStr = (i == values.length - 1) ? valueStr + values[i]: valueStr + values[i] + ",";
		}
		//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
		//valueStr = new String(valueStr.getBytes("ISO-8859-1"), "UTF-8");
		params.put(name, valueStr);
	}
	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
	
	//解密（如果是RSA签名需要解密，如果是MD5签名则下面一行清注释掉）
	Map<String,String> decrypt_params=null;
	if("0001".equalsIgnoreCase(aliconfig.sign_type)){decrypt_params = alinotify.decrypt(params);}
	else if("md5".equalsIgnoreCase(aliconfig.sign_type)){decrypt_params=params;}

	//XML解析notify_data数据
	Document doc_notify_data = DocumentHelper.parseText(decrypt_params.get("notify_data"));
	
	//商户订单号
	String out_trade_no = doc_notify_data.selectSingleNode( "//notify/out_trade_no" ).getText();

	//支付宝交易号
	String trade_no = doc_notify_data.selectSingleNode( "//notify/trade_no" ).getText();

	//交易状态
	String trade_status = doc_notify_data.selectSingleNode( "//notify/trade_status" ).getText();

	//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//

	if(alinotify.verifyNotify(params)){//验证成功
		//////////////////////////////////////////////////////////////////////////////////////////
		//请在这里加上商户的业务逻辑程序代码

		
		//——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
		/*
		service->alipay.wap.trade.create.direct
		sign->7882d5a64dc29e45f44fa30ffe2c7717
		sec_id->MD5
		v->1.0
		notify_data->
		<notify>
			<partner>2088101568358171</partner>
			<payment_type>1</payment_type>
			<subject>红袖女装正品2014设计师夏装新款 简约...</subject>
			<trade_no>2014092331191831</trade_no>
			<buyer_email>13764109307</buyer_email>
			<gmt_create>2014-09-23 19:44:35</gmt_create>
			<notify_type>trade_status_sync</notify_type>
			<quantity>1</quantity>
			<out_trade_no>SA140923000004</out_trade_no>
			<notify_time>2014-09-23 19:49:28</notify_time>
			<seller_id>2088101568358171</seller_id>
			<out_channel_type>BALANCE</out_channel_type>
			<trade_status>TRADE_SUCCESS</trade_status>
			<is_total_fee_adjust>N</is_total_fee_adjust>
			<total_fee>0.01</total_fee>
			<gmt_payment>2014-09-23 19:49:28</gmt_payment>
			<seller_email>alipay-test09@alipay.com</seller_email>
			<price>0.01</price>
			<buyer_id>2088702683188319</buyer_id>
			<out_channel_amount>0.01</out_channel_amount>
			<notify_id>79d0473e529a7dfa32bc027ecd1c63ed3q</notify_id>
			<use_coupon>N</use_coupon>
		</notify>
		*/
		
		String payment_type=doc_notify_data.selectSingleNode( "//notify/payment_type" ).getText();
		String trade_state=doc_notify_data.selectSingleNode( "//notify/trade_status" ).getText();
		String banktype="alipay";
		String bankorderno="";
		String tf=doc_notify_data.selectSingleNode( "//notify/total_fee" ).getText();
		double total_fee=0.00;
		try{total_fee=Double.parseDouble(tf);}
		catch(Exception e){}
		String notify_id=doc_notify_data.selectSingleNode( "//notify/notify_id" ).getText();
		String transaction_id=doc_notify_data.selectSingleNode( "//notify/trade_no" ).getText();
		String time_end=doc_notify_data.selectSingleNode( "//notify/gmt_payment" ).getText();
		
		Date paydate=null;  
		SimpleDateFormat stoda=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat datost=new SimpleDateFormat("yyyyMMddHHmmss");  
		try{
			paydate=stoda.parse(time_end); 
			time_end=datost.format(paydate);
		}catch(Exception e){
			paydate=new Date();
			time_end=datost.format(paydate);
		}
		String openno=null;
		String isSubscribe="Y";
		
		if("TRADE_FINISHED".equalsIgnoreCase(trade_status)||"TRADE_SUCCESS".equalsIgnoreCase(trade_status)){
			//判断是否有作过处理
			List orderinfo=null;
			try {
				orderinfo=QueryEngine.getInstance().doQueryList("select nvl(o.tot_amt,0),o.sale_status,v.wechatno,v.issubscribe,o.id from wx_order o join wx_vip_inqury v on o.wx_vip_id=v.wx_vip_id where o.docno=? and o.ad_client_id=?", new Object[] {out_trade_no,wu.getAd_client_id()});
				if(orderinfo==null||orderinfo.size()<=0){
					System.out.println("not found order->"+out_trade_no+":"+wu.getAd_client_id());
					out.print("not found order");
					return;
				}
				String ostatus=String.valueOf(((List)orderinfo.get(0)).get(1));
				if("3".equals(ostatus)){
					System.out.println("alipay order already dispose->"+out_trade_no+":"+wu.getAd_client_id());
					out.print("success");
					return;
				}else if("2".equals(ostatus)){
					//判断金额是否相等
					double totfee=Double.parseDouble(String.valueOf(((List) orderinfo.get(0)).get(0)));
					if(totfee>total_fee){
						System.out.println("not completely payment order money is->"+totfee+",but pay:"+total_fee);
						out.print("not completely payment");
						return;
					}
					openno=String.valueOf(((List)orderinfo.get(0)).get(2));
					isSubscribe=String.valueOf(((List)orderinfo.get(0)).get(3));
				}else{
					System.out.println("alipay order sale_status error->status:"+ostatus+":"+out_trade_no+":"+wu.getAd_client_id());
					out.println("alipay order sale_status error");
					return;
				}
			}catch(Exception e){
				System.out.println("alipay get order info error->"+e.getMessage());
				out.print("alipay get order info error");
				return;
			}
			
			//添加支付记录
			String sql="insert into wx_payrecode(id,ad_client_id,ad_org_id,platform,trademode,status,banktype,bankorderno,totalfee,notifyno,transactionno,orderno,paytime,openid,issubscribe,ownerid,creationdate,modifierid,modifieddate,isactive)"
					  +" select get_sequences('wx_payrecode'),w.ad_client_id,w.ad_org_id,'alipay',?,?,?,?,?,?,?,?,?,?,?,w.ownerid,sysdate,w.modifierid,sysdate,'Y' from web_client w where w.ad_client_id=? and rownum=1";
			try{
				QueryEngine.getInstance().executeUpdate("update wx_order t set t.isstock='N',t.sale_status=3,t.paytime=sysdate,t.paymoney=? where t.docno=? and t.ad_client_id=?",new Object[] {total_fee,out_trade_no,wu.getAd_client_id()});
				QueryEngine.getInstance().executeUpdate(sql,new Object[] {payment_type,trade_state,"alipay",bankorderno,total_fee,notify_id,transaction_id,out_trade_no,time_end,openno,isSubscribe,wu.getAd_client_id()});
			}catch(Exception e){
				e.printStackTrace();
				System.out.println("update order or insert payrqcode error->"+e.getMessage());
				out.print("update order or insert payrqcode error failed");
			}

			//异步扣减库存
			try{
				System.out.println("call nds.weixin.ext.DeductstockCommand deductstock order["+out_trade_no+"||"+wu.getAd_client_id()+"]");
				ClientControllerWebImpl controller=(ClientControllerWebImpl)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.WEB_CONTROLLER);
				DefaultWebEvent event=new DefaultWebEvent("CommandEvent");
				event.setParameter("orderid", String.valueOf(((List)orderinfo.get(0)).get(4)));
				event.setParameter("orderno", out_trade_no);
				event.setParameter("adclientid", String.valueOf(wu.getAd_client_id()));
				event.setParameter("command", "nds.weixin.ext.DeductstockCommand");
				controller.handleEventBackground(event);
			}catch(Exception e){
				System.out.println("call nds.weixin.ext.DeductstockCommand deductstock order["+out_trade_no+"||"+wu.getAd_client_id()+"] error->"+e.getMessage());
			}
		}
		
		
		if(trade_status.equals("TRADE_FINISHED")){
			//判断该笔订单是否在商户网站中已经做过处理
			//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			//如果有做过处理，不执行商户的业务程序
				
			//注意：
			//该种交易状态只在两种情况下出现
			//1、开通了普通即时到账，买家付款成功后。
			//2、开通了高级即时到账，从该笔交易成功时间算起，过了签约时的可退款时限（如：三个月以内可退款、一年以内可退款等）后。
			System.out.println("alipay status is TRADE_FINISHED");
			out.print("success");	//请不要修改或删除
		} else if (trade_status.equals("TRADE_SUCCESS")){
			//判断该笔订单是否在商户网站中已经做过处理
			//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			//如果有做过处理，不执行商户的业务程序
				
			//注意：
			//该种交易状态只在一种情况下出现——开通了高级即时到账，买家付款成功后。
			System.out.println("alipay status is TRADE_SUCCESS");
			out.print("success");	//请不要修改或删除
		}else{
			System.out.println("alipay status fail->"+trade_status);
			out.print("alipay status fail->"+trade_status);
		}

		//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
		//////////////////////////////////////////////////////////////////////////////////////////
	}else{//验证失败
		System.out.println("verify alipay fail");
		out.print("verify alipay fail");
	}
%>

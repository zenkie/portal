<%@ page language="java" import="java.util.*,nds.velocity.*,nds.weixin.ext.*" pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  //Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
   //String defaultClientWebDomain=conf.getProperty("webclient.default.webdomain");
   //int defaultClientID= Tools.getInt(conf.getProperty("webclient.default.clientid"), 37);
   //WebClient myweb=new WebClient(37, "","burgeon",false);
   //System.out.print("aaaaaaaaaaaaaaaaaa");
   // UserWebImpl userWeb =null;
   String folderName=null;
   WeUtils wu=null;
	try{
		java.net.URL url = new java.net.URL(request.getRequestURL().toString());
		System.out.print("path->"+request.getContextPath());
		WeUtilsManager Wemanage =WeUtilsManager.getInstance();
		//WeUtils wu=Wemanage.getByAdClientId(userWeb.getAdClientId());
		folderName=Wemanage.getAdClientTemplateFolder(url.getHost());
		 wu =Wemanage.getByDomain(url.getHost());
	}catch(Exception t){
		System.out.print("get path error->"+t.getMessage());
		t.printStackTrace();
	}
	System.out.print("folderName->"+folderName);
	if(folderName!=null){
	//System.out.print("sceond path");
	String url="/html/nds/oto/website/"+ folderName+"/index.vml";
	System.out.print("url->"+url);
	
	/*int vipid=0;
	String code=request.getParameter("code");
	System.out.println("code1->"+code);
	//IAuthorization iaziaz=(IAuthorization)Class.forName("nds.weixin.ext.UserAuthorization").newInstance();
	nds.io.PluginController pc=(nds.io.PluginController) WebUtils.getServletContextManager().getActor(nds.util.WebKeys.PLUGIN_CONTROLLER);
	IAuthorization iaz=pc.findPluginShellwx("nds.weixin.ext.UserAuthorization");
	          
	//nds.weixin.ext.UserAuthorization iaz=new nds.weixin.ext.UserAuthorization();
	vipid=iaz.getVip(wu,code);
	System.out.println("vipid-->"+vipid);*/
	//System.out.print("code !"+request.getParameter("code"));
		response.setContentType("text/html; charset=UTF-8");
       // ServletContext sc = getServletContext();
        RequestDispatcher rd = null;
        rd = request.getRequestDispatcher(url);
        rd.forward(request, response);

		//response.sendRedirect(url);
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>伯俊微信</title>
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<link href="/public.css" type="text/css" rel="stylesheet"/>
<link href="/slider.css" type="text/css" rel="stylesheet"/>

<script src="/js/jquery-1.9.1.min.js" type="text/javascript"></script>

<script src="/js/common.js" type="text/javascript"></script>
<script src="/js/jquery.plugin.min.js" type="text/javascript"></script>
<script src="/js/turnscroll.js" type="text/javascript"></script>
<script src="/js/onlineService.js" type="text/javascript"></script>
</head>
<body>
<div class="header_top">
  <div class="warpper header">
    <div class="topbar clearfix">
		<h1><a href="index.html"><img src="/images/otoimages/logo.png" alt="星云微信移动平台"/></a></h1>
	<c:choose>
		<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
		<div id="login-box" class="right_bar">
			<form action="/loginproc.jsp" method="post" name="fm1">
				<input type="hidden" value="already-registered" name="cmd"/>
				<input type="hidden" value="already-registered" name="tabs1"/>
				<%= LanguageUtil.get(pageContext, "current-user")%>：
				<a class="login_bold_text" href="/html/nds/portal/index.jsp"><%=userWeb.getUserDescription() %></a>&nbsp;|&nbsp;<a class="login_bold_text userto" href="/c/portal/logout"><%= LanguageUtil.get(pageContext, "logout") %></a>
			</form>
		</div>
		</c:when>
		<c:otherwise>
		<div class="right_bar">
			<a href="login.jsp">登录</a> | <a href="/html/nds/oto/register/index.html">注册</a>
		</div>
		</c:otherwise>
	</c:choose>
    </div>
    <div class="menu">
      <ul>
        <li><a href="index.html" class="ok">首页</a><span class="line"></span></li>
        <li><a href="javascript:void(0)" title="1">微应用</a><span class="line"></span></li>
        <li><a href="javascript:void(0)" title="2">成功案例</a><span class="line"></span></li>
        <li><a href="javascript:void(0)" title="3">联系我们</a></li>
        <li class="right_favorite"><a href="#"></a></li>
      </ul>
    </div>
  </div>
</div>
<div class="content_xy clearfix"  id="mainRow">
	<div id="banner">
	  <div class="slide-banner">
		<div class="banner-bg" style="display: block; background-image: url(/images/otoimages/bannerbg1150x380_001.jpg);"></div>
		<div class="banner-content"> <a id="__AD_shouye_banner_0" class="banner" data-bg="/images/otoimages/bannerbg1150x380_001.jpg" href="/html/nds/oto/register/index.html" target="_blank">
		  <div class="banner-img" style="left:0"><img src="/images/otoimages/banner1150x380_001_1.png" alt=""></div>
		  <div class="banner-img" style="left:0"><img src="/images/otoimages/banner1150x380_001_2.png" alt=""></div></a> 
		  <a id="__AD_shouye_banner_1" class="banner" data-bg="/images/otoimages/bannerbg1150x380_002.jpg" href="#" target="_blank">
		  <div class="banner-img"><img src="/images/otoimages/banner1150x380_002_1.png" alt=""></div>
		  <div class="banner-img"><img src="/images/otoimages/banner1150x380_002_2.png" alt=""></div>
		  <div class="banner-img"><img style="display:none" /></div>
		  </a> </div>
		<ul class="banner-nav">
		  <li class="active"></li>
		  <li></li>
		</ul>
		<div class="banner-bar-bg">
		  <div class="banner-bar"></div>
		</div>
	  </div>
	</div>

	<!--Slider star-->
	<h2 class="maodian" id="index_1">这是微应用</h2>
	<div class="slider_box">
		  <div class="picLI" id="j-focusPic">
			<div class="picbox j-slider">
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_001.jpg" /></a></span>
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_002.jpg" /></a></span>
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_003.jpg" /></a></span>
				  <!--span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_004.jpg" /></a></span-->
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_005.jpg" /></a></span>
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_006.jpg" /></a></span>
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_007.jpg" /></a></span>
				  <!--span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_008.jpg" /></a></span>
				  <span class="j-item"><a href="#"><img width="1150" height="500" src="/images/otoimages/sider_009.jpg" /></a></span-->
			</div>
		  </div>
	  <div class="infobtn" id="j-focusBtns">
			<div class="prev on-1"><a href="javascript:void(0)"></a></div>
			<div class="smalpic j-container">
			  <div class="smallbox j-slider" style="left: 0px;">
				  <a class="j-item on" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_01.png"/></div></a>
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_02.png"/></div></a>
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_03.png"/></div></a>
				  <!--a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_04.png"/></div></a-->
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_05.png"/></div></a>
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_06.png"/></div></a>
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_07.png"/></div></a>
				  <!--a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_08.png"/></div></a>
				  <a class="j-item" href="#"><div class="imgsmall"><img src="/images/otoimages/icons/sider_icon_09.png"/></div></a-->
			  </div>
			</div>
			<div class="next"><a href="javascript:void(0)"></a></div>
		</div>
	</div>
	<div class="clearfix"></div>

	<!--Brand star-->
	<h2 class="maodian" id="index_2">这是成功案例</h2>
	<div class="brand_funcList" id="funbox">
		 <ul class="brandshow clearfix">
			 <li><img src="/images/otoimages/brand-logo(1).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(2).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(3).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(4).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(5).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(6).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(7).png" width="260" height="110"/></li>
			 <li><img src="/images/otoimages/brand-logo(8).png" width="260" height="110"/></li>
		 </ul>
		 <!--弹出层 star-->
		 <div class="tc_detail clearfix">
			 <div class="topdiv">
				 <div class="fl">
					 <a href="javascript:;" class="slider_prev">&lt;</a>
					 <a href="javascript:;" class="slider_next">&gt;</a>
				 </div>
				 <a href="javascript:;" class="btn_close"></a>
			 </div>
			 <div class="wrap_slider detailList" id="magazine">
				 <div class="turn-page" page="1">
					 <div class="con_fl">
						 <div class="title"><div class="img"><img src="/images/otoimages/brand-logo(1).png" width="260" height="110"></div><span>奥康</span></div>
						 <h3>快速帮用户打造超炫微信移动网站</h3>
						 <p>国内知名品牌奥康，其官方微信呈现以星云移动平台为构建平台，上线仅仅两个月，便成功发展线上会员15w，精准的将线上流量导入线下实体，达到线下实体使用优惠券14w张。微信申领会员卡，能够帮助企业建立新一代的移动会员管理系统，轻松实现线上线下会员卡绑定，会员可自行在手机上随时查看自己的积分和消费记录，企业可通过清晰记录会员的消费行为从而进行数据分析，还可根据用户特征进行精细分类，从而实现各种模式的精准营销。</p>
					 </div>
					 <div class="con_fr">
					   <img src="/images/otoimages/imglbarand785x605-001.jpg" width="785" height="605">
					 </div>
				 </div>
				 <div class="turn-page" page="2">
					 <div class="con_fl">
						 <div class="title"><div class="img"><img src="/images/otoimages/brand-logo(2).png" width="260" height="110"></div><span>玖姿</span></div>
						 <h3>时尚、精致与实用美学的完美平衡</h3>
						 <p>玖姿将西方时装的精致优雅和浪漫热情与东方气息完美融合，缔造出自信、优雅、女人味的经典。</p>
	<p>玖姿追求时尚、精致与实用美学的完美平衡，通过对国际流行趋势与女装市场的严谨研究，整合国际、国内尖端时尚资源，融汇贯通，倾心专注，精彩演绎现代都市女性的自信、优雅、女人味。</p>
	<p>玖姿秉承"优雅、大气、经典、时尚"的设计理念，运用优质上等的面料、精致的细节装饰、优雅的色彩和图案，加上时尚的设计和巧妙的剪裁，勾勒出女性的线条美感，妆点现代都市女性的多彩生活。</p>
					 </div>
					 <div class="con_fr">
					   <img src="/images/otoimages/imglbarand785x605-001.jpg" width="785" height="605">
					 </div>
				 </div>
				 <div class="turn-page" page="3">
					 <div class="con_fl">
						 <div class="title"><div class="img"><img src="/images/otoimages/brand-logo(3).png" width="260" height="110"></div><span>伊露丝</span></div>
						 <h3>满足消费者对纯粹、健康和安全的创新产品的欲望</h3>
						 <p>伊露丝Eors是德国著名延时喷剂、润滑液品牌。伊露丝主要推出延时喷剂、按摩精油、人体润滑液等商品。Eors为德国品牌，主要提供高品质润滑液、男用助勃延时喷剂，均为德国原装生产，是极高品质的代表。在过去的十五年里，Eors为成千上万人提供安全及可靠的高品质产品、润滑液、按摩乳液和其他情趣用品，满足消费者对纯粹、健康和安全的创新产品的欲望。伊露丝官方授权美色商城专卖店，专卖伊露丝延时喷剂、按摩精油、人体润滑液等商品。</p>
					 </div>
					 <div class="con_fr">
					   <img src="/images/otoimages/imglbarand785x605-001.jpg" width="785" height="605">
					 </div>
				 </div>
			 </div>
		 </div>
	</div>
</div>
<!--footer star-------->
<h2 class="maodian" id="index_3">联系我们</h2>
<div class="wapper—footer">
  <div class="footer-con">
    <h1><a href="#"><img src="/images/otoimages/logo140x60.png"/></a></h1>
    <div class="cen"> <strong>好消息！</strong>
      <p>奥康上线一个月，线上会员突破<em>30000</em><br/>
        完成单笔交易<em>25931</em><br/>
        数字还在不断的更新...</p>
    </div>
    <div class="right"><strong>上海伯俊软件科技有限公司</strong>
      <p>上海闵行区新源路1356弄汇力得电子商务产业园A栋3层<br/>
        www.burgeon.cn<br/>
        400-620-9800</p>
      <a href="#" class="go">Follow Me+</a> </div>
  </div>
  <div class="copyright">
    <div class="l">© 上海伯俊软件科技有限公司  版权所有 <a href="#">站长统计</a></div>
    <div class="r"><a href="#">Home</a><a href="#">About Us</a><a href="#">Portfolio</a></div>
  </div>
</div>
<script src="/js/jquery.slider.js" type="text/javascript" ></script>
<!-- 在线咨询客服 -->
<div id="service_box">
    <div class="inner_btn"></div>
    <div class="inner_info">
		<div class="inner_list">
			<a href="http://wpa.qq.com/msgrd?v=3&uin=800068141&site=qq&menu=yes" onclick="window.open('http://b.qq.com/webc.htm?new=0&sid=800068141&o=www.next99.cn&q=7&ref='+document.location, '_blank', 'height=544, width=644,toolbar=no,scrollbars=no,menubar=no,status=no')" target="_blank">
				<span><img src="/images/otoimages/qq-175x175.jpg"/></span>
				<span class="span_t">QQ在线咨询</span>
				<span class="qq_num">400-620-9800</span>
			</a>
		</div>
    </div>
</div>
</body>
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
	Locale currentLocale = new Locale("zh","CN");
	session.setAttribute("org.apache.struts.action.LOCALE",currentLocale);
	Object obj=request.getSession().getAttribute("j_username");
		if(obj !=null && (obj instanceof String)){
		/**
		*  由于 lportal 的限制，名称一律设置为小写
		*  参见：com.liferay.portal.ejb.UserManagerImpl#_authenticate
		*  登录的时候由系统强行设置登录名为小写后验证
		*  // there's also a same handle method in nds.control.web.SessionContextManager
		*/
		String domainName=( (String )obj).toLowerCase(); //like email address
		
		String uName, adclientName ;
		int p=domainName.lastIndexOf("@");
		if ( p>0){
			uName= domainName.substring(0,p );
			adclientName= domainName.substring(p+1);
			nds.security.User ausr= SecurityUtils.getUser(uName,adclientName);
			 
			if(ausr.getId().intValue() !=-1){
				nds.control.util.ValueHolder holder=new nds.control.util.ValueHolder();
				holder.put("user", ausr);
				holder.put("remote_address", session.getAttribute("IP_ADDRESS"));
				SessionContextManager manager= (SessionContextManager)session.getAttribute(nds.util.WebKeys.SESSION_CONTEXT_MANAGER);
				if(manager!=null){
					// sometimes (webservice) manager may not exists in session though USER_ID set in attribute
					userWeb=((UserWebImpl) manager.getActor(nds.util.WebKeys.USER));
					
					userWeb.performUpdate(holder,session);
					// reload locale again if locale set into attribute first

					locale=(Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
					if(locale==null)locale= TableManager.getInstance().getDefaultLocale();
					userWeb.setLocale(locale);
				}
			} 
		} 
	}
	
	String step = request.getParameter("step")!=null ? request.getParameter("step") : "";
	
	String search="select t.loginuser from WEB_CLIENT t where t.ad_client_id = ?";//查找用户名称
	int ad_client_id=userWeb.getAdClientId();
	Object name=QueryEngine.getInstance().doQueryOne(search,new Object[]{ad_client_id});
	
	String searchWebClientId = "select w.id from web_client w where w.ad_client_id = ?";
	Object webClientId=QueryEngine.getInstance().doQueryOne(searchWebClientId,new Object[]{ad_client_id});
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script type="text/javascript" src="/html/nds/oto/register/js/editDevInteface.js"></script>
<script src="/html/nds/oto/register/js/register.js" type="text/javascript"></script>
<script src="/html/nds/oto/register/js/jsAddress.js" type="text/javascript"></script>
<link href="/html/nds/oto/register/css/public.css" type="text/css" rel="stylesheet"/>
<link rel="Shortcut Icon" href="/html/nds/oto/images/portal.ico"/>
<title>注册</title>
</head>
<body>
<div class="header_top">
	<div class="warpper header">
		<div class="topbar clearfix">
			<h1><a href="/"><img src="/html/nds/oto/register/images/logo318x90white.png" alt="星云微信移动平台" /></a></h1>
		</div>
	</div>
</div>
<div class="warpper">
	<div class="register_box">
		<h2>欢迎注册星云移动平台~</h2>
		 <div class="payStep">
            <ul class="payOrderSteps clearfix">
                <li>注册账户</li>
                <li class="now"><span></span>填写公司信息</li>
                <li>一键绑定微信号</li>
                <li><span></span>开始惊喜体验</li>
            </ul>
        </div>
		<div class="register_main clearfix" id="companyInfo">
			<input type="hidden" id="inputNum" value="5">
			<input type="hidden" id="inputName" value="subRegister">
			<input type="hidden" id="step" value="<%=step%>">
			<table width="100%" border="0">
				<tr>
					<th>昵称：</th>
					<td>
						<input name="NICKNAME" id="NICKNAME" type="text" placeholder="互联网怎么能没有昵称呢？" class="text" verify="Empty">
						<span class="notice red">*</span>
						<span class="notice hint" hintInfo="昵称不为空!" notiInfo=""></span>
					</td>
				</tr>
				<tr>
					<th>真实姓名：</th>
					<td>
						<input name="USERNAME" id="USERNAME" type="text" placeholder="乃司徒米球" class="text" verify="Empty">
						<span class="notice red">*</span>
						<span class="notice hint"  hintInfo="真实姓名不为空!" notiInfo=""></span>
					</td>
				</tr>	
				<tr>
					<th>企业名称：</th>
					<td>
						<input name="COMPANY" id="COMPANY" type="text" placeholder="请输入企业名称" class="text" verify="Empty">
						<span class="notice red">*</span>
						<span class="notice hint" hintInfo="企业名称不为空!" notiInfo="既然萍水相逢，何不自报家门？">既然萍水相逢，何不自报家门？</span>
					</td>
				</tr>
				<tr>
					<th>主营业务：</th>
					<td>
						<select name="BUSINESS" id="BUSINESS" class="selectW1" verify="Business">
							<option value="-1">请选择主营业务</option>
							<option value="女装">女装</option>
							<option value="男装">男装</option>
							<option value="美妆护肤">美妆护肤</option>
							<option value="男鞋">男鞋</option>
							<option value="箱包">箱包</option>
							<option value="母婴玩具">母婴玩具</option>
							<option value="食品特产">食品特产</option>
							<option value="家居家纺">家居家纺</option>
							<option value="创意礼品">创意礼品</option>
							<option value="3C数码">3C数码</option>
							<option value="女鞋">女鞋</option>
							<option value="男女内衣">男女内衣</option>
							<option value="运动户外">运动户外</option>
							<option value="童装童鞋">童装童鞋</option>
							<option value="珠宝首饰">珠宝首饰</option>
							<option value="日用百货">日用百货</option>
							<option value="汽车配件">汽车配件</option>
							<option value="医药保健">医药保健</option>
							<option value="生活服务">生活服务</option>
							<option value="媒体服务">媒体服务</option>
							<option value="装修建材">装修建材</option>
							<option value="服装配饰">服装配饰</option>
							<option value="家用电器">家用电器</option>
							<option value="综合其他">综合其他</option>
						</select>
						<span class="notice red">*</span>
						<span class="notice hint" hintInfo="请选择主营业务!" notiInfo=""></span>
					</td>
				</tr>
				<tr>
					<th>联系地址：</th>
					<td>
						<select id="province" class="selectW2"></select>
						<select id="city" class="selectW2"></select>
						<select id="regionId" class="selectW2"></select>
						<span class="notice red">*</span>
						<span class="notice hint" hintInfo="请正确选择省市区！" notiInfo=""></span>
					</td>
				</tr>
				<tr>
					<th>详细地址：</th>
					<td>
						<input id="addInfo" type="text" placeholder="请输入详细地址" class="text" verify="Address">
						<span class="notice red">*</span>
						<span class="notice hint" hintInfo="详细地址不为空!" notiInfo=""></span>
					</td>
				</tr>	
			</table>
			<input type="button" value="还差一步" disabled="disabled" class="btn_common disabled" id="subRegister"/>
		</div>
		<div id="bindwx" class="register_main clearfix" style="display:none;">
			<input type="hidden" value="<%=ad_client_id%>" id="clientId">
			<input type="hidden" value="<%=webClientId%>" id="editId">
			<table width="100%" border="0">
				<tr>
					<th>微信公众号：</th>
					<td>
						<input id="wxAccount" type="text" placeholder="请使用已注册的公众微信号" class="text">
						<span class="notice"><a class="link_blue" href="https://mp.weixin.qq.com/" target="_blank">我还没有公众号</a></span>
					</td>
				</tr>
				<tr>
					<th>密码：</th>
					<td>
						<input id="wxPwd" type="password" placeholder="登录微信公众平台使用的密码" class="text">
						<span class="notice"></span>
					</td>
				</tr>
				<tr id="wxImageCode" style="display:none;">
					<th>验证码：</th>
					<td>
						<input id="wxImgCode" type="text" placeholder="请输入验证码" class="text">
						<img style="float:left;padding-left: 20px;" src="/servlets/binserv/Wxvcode?user=<%=ad_client_id%>" width="120" height="40" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" alt="看不清,换一张">
						<span class="notice"></span>
					</td>
				</tr>
				<tr>
					<th>注册码：</th>
					<td><input name="regcode" id="regcode" type="text" placeholder="暂时没有金钥匙？请选择免费体验三天" class="text disabled" disabled="disabled">
					<span class="notice" style="display:none;"><a class="link_blue" href="javascript:void(0);">怎样获取注册码？</a></span></td>
                </tr>
                <tr>
					<th>&nbsp;</th>
					<td>
						<label><input type="checkbox" class="check" checked="checked" disabled="disabled"/>免费体验</label>						
					</td>
                </tr>
			</table>
			<input id="wxbind" type="button" value="智能绑定" class="btn_common" />
			<span class="notice" style="margin-top: 45px;padding-left: 60px;display:none;"><a id="helpBind" class="link_blue" href="javascript:void(0);">什么是智能绑定？</a></span>
		</div>
		<div id="experience" class="register_main clearfix" style="display:none;">
            <div class="reg_tips">
				<h3 id="welcomeContent">客户，恭喜完成账号注册!</h3>
				<p>您有三天的免费试用时间，相信具有聪明才智风流倜傥婀娜多姿的您，<br/>在客服的协助下一定可以搭建好自己的平台~<br/>请，随时联系客服~ </p>
				<input type="button" value="开始体验" class="btn_common" onclick="location.href='/html/nds/portal/index.jsp'" />
            </div>
        </div>
	</div>
	<div class="reg_footer clearfix">
		<div class="fl">
			<a href="#">关于星云</a>|
			<a href="#">服务协议</a>|
			<a href="#">运营规范</a>|
			<a href="#">在线客服</a>|
			<a href="#">联系邮箱</a>
		</div>
		<div class="fr">&copy;2008-2013上海伯俊软件科技有限公司 版权所有 保留所有权&nbsp;&nbsp;&nbsp;了解更多产品请点击：
			<a href="#">www.burgeon.com.cn</a>
		</div>
	</div>
</div>
<script type="text/javascript">
//地址初始化
addressInit("province", "city", "regionId");	
</script>
</body>
</html>

<%@ page language="java" import="java.util.*,nds.velocity.*,nds.weixin.ext.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
  //Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
   //String defaultClientWebDomain=conf.getProperty("webclient.default.webdomain");
   //int defaultClientID= Tools.getInt(conf.getProperty("webclient.default.clientid"), 37);
   //WebClient myweb=new WebClient(37, "","burgeon",false);
   //System.out.print("aaaaaaaaaaaaaaaaaa");
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
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<title>伯俊微信</title>
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">jQuery.noConflict(); </script>
<link href="/reset.css" rel="stylesheet" type="text/css" />
<link href="/chat.css" rel="stylesheet" type="text/css" />
<script type=text/javascript>
function onReturn(event){
  if (!event) event = window.event;
  if (event && event.keyCode && event.keyCode == 13) submitForm();
}
function submitForm(){
	if(document.getElementById("login").value==""){ 
		alert("请输入会员用户名");
		return;
	}
	else if(document.getElementById("password1").value==""){
		alert("请输入密码");
		return;
	}
	else if(document.getElementById("verifyCode").value==""){
		alert("请输入验证码");
		return;
	}else if(document.getElementById("verifyCode").value.length!=4){
		alert("您的输入验证码的长度不对!");
		return;
	}
	document.fm1.submit();
	document.body.innerHTML=document.getElementById("progress").innerHTML;
}
</script>
</head>
<body class="wh100p">
    <div id="container" class="wh100p">
    	<div id="content" class="pa w100p">
    		<div id="login-box" class="pa flex flex-column justify-cen plr20 vm">
	
				  <form action="/loginproc.jsp" method="post" name="fm1">
				   <input type="hidden" value="already-registered" name="cmd"/>
				   <input type="hidden" value="already-registered" name="tabs1"/> 
					<c:choose>
					<c:when test="<%= (userWeb!=null&&!userWeb.isGuest()) %>">
						<li><div class="l"><%= LanguageUtil.get(pageContext, "current-user")%>:</div><div class="right_text"><%=userWeb.getUserDescription() %></div>
						</li>
						<li><div class="lx"><%= LanguageUtil.get(pageContext, "enter-view") %>:<a href="/html/nds/portal/index.jsp"><%= LanguageUtil.get(pageContext, "backmanager") %></a>
					,<%= LanguageUtil.get(pageContext, "or") %>:<a href="/c/portal/logout"><%= LanguageUtil.get(pageContext, "logout") %></a></div></li>
					</form>
					</div>
					</div>
			
	</c:when>
	<c:otherwise>
	 <%
 	 String  login ="";
	 if(company==null){
          company = com.liferay.portal.service.CompanyLocalServiceUtil.getCompany("liferay.com");
	 }
     login =LoginAction.getLogin(request, "login", company);
	%> 

    				<div class="head tc"><img src="./images/wm-login-p.png"></div>
    				<div class="inputs">
    					<input id="login" name="login" class="w100p bdn mt10" type="text" value="<%=login%>" placeholder="用户名">

    					<input id="password1" class="w100p bdn mt10" type="password" name="<%= SessionParameters.get(request, "password")%>" value="" placeholder="密码">
    				</div>
    				<div class="verifi mtb10 cl">
							<input id="verifyCode" name="verifyCode"  type="text" onKeyPress="onReturn(event)" class="verifi-l fl bdn"  size="7" />    			
    					<div class="verifi-r fr">
							<img src="/servlets/vms" width="64" height="30" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()" /> 
						</div>
    				</div>
    				<div class="links cl">
    					<a href="/register.jsp" class="fl">现在注册>></a>
    					<a href="" class="fr">忘记密码？</a>
    				</div>
    				<div class="login"><div class="login-a" href="#" onclick="javascript:submitForm()"></div></div>
    				<div class="rwm">
    					<img height="90" width="90" src="./images/ewm.jpg" class="vm">
    					<span class="inline-b ti8">扫描二维码关注我们</span>
    				</div>
    		</div>
    	</div>
    	</form>
		</c:otherwise>
</c:choose>
    	<footer id="footer" class="pa b0 w100p">
    		<span class="links font-color">
    			<a href="#">地址：上海市闵行区新源路1356弄汇力得电子商务产业园A栋3层</a>
    			<a href="#">咨询热线：400-620-9800</a>
    			<a href="#">E-mail：Marketing@burgeon.cn</a>
    		</span>
    		<a href="javascript:;" class="statement">Copyright (©) 2012-2013 上海伯俊软件科技有限公司 版权所有</a>
    	</footer>
    </div>
	
	<div class="chatEWMContainer">
		<div>
			<span>微信咨询请关注星云小贴士或者扫码</span>
			<img src="./images/xingyun.jpg" height="100" width="100" />
		</div>
		<div style="margin-top: 20px;">
			<span>手机端展示效果请关注伯俊软件或者扫码</span>
			<img src="./images/burgeon.jpg" height="100" width="100" />
		</div>
	</div>
	<!-- WPA Button Begin -->
		<script charset="utf-8" type="text/javascript" src="http://wpa.b.qq.com/cgi/wpa.php?key=XzgwMDA2ODE0MV8xNjQ4MTFfODAwMDY4MTQxXw"></script>
	<!-- WPA Button End -->
	<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery.fn.wait = function (func, times, interval) {
		var _times = times || -1, //100次 
		_interval = interval || 20, //20毫秒每次 
		_self = this, 
		_selector = this.selector, //选择器 
		_iIntervalID; //定时器id 
		if( this.length ){ //如果已经获取到了，就直接执行函数 
		func && func.call(this); 
		} else { 
		_iIntervalID = setInterval(function() { 
		if(!_times) { //是0就退出 
		clearInterval(_iIntervalID); 
		} 
		_times <= 0 || _times--; //如果是正数就 -- 

		_self = jQuery(_selector); //再次选择 
		if( _self.length ) { //判断是否取到 
		func && func.call(_self); 
		clearInterval(_iIntervalID); 
		} 
		}, _interval); 
		} 
		return this; 
		}
		
		jQuery("iframe:last").wait(function() {
			jQuery("iframe:last").css("height","184px");
			jQuery("iframe:last").contents().find(".main").css("background-image","url(./images/service.jpg)");
			jQuery("iframe:last").contents().find(".main").css("width","135px");
			jQuery("iframe:last").contents().find(".main").css("height","184px");
			jQuery("iframe:last").contents().find(".content").css("background","none");
			jQuery("iframe:last").css("top","36%");
			jQuery("iframe:last").css("right","140px");
		});
	});
	</script>
</body>
</html>

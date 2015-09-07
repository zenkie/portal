<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page language="java" pageEncoding="utf-8"%>
<%@ page import="nds.util.FileUtils"%>
<%!
 /**
 	#session timeout checker for client portal page, this is to set the interval for checking in minutes, nomally it should be 1/10 of session timeout time
	#value 0 (default) means not check timeout of session
	@param "ss" - ad_subsystem.id, if set, will show subsystem only
	@param "table" - table id or name for viewing, should direct to that table immediately
	@param "popup" - only when "false" will update current user's setting, disable popup portal next time, other values will do nothing
	@param redirect - if set, should be an URL, and we will popup that url as welcome window (overwrite default welcome window)
 */ 
 private static int intervalForCheckTimeout=Tools.getInt(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.session.checkinterval","0"),0);
 private static boolean defaultSsviewFirst="true".equals( ((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.ssview","false"));
 private static boolean defaultboshome="true".equals( ((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("boshome","false"));
%>

<%
 String dialogURL=request.getParameter("redirect");
 if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
 	/*session.invalidate();
 	com.liferay.util.servlet.SessionErrors.add(request,PrincipalException.class.getName());
 	response.sendRedirect("/login.jsp");*/
 	//System.out.println("portal.jsp:redirect to login");
 	response.sendRedirect("/c/portal/login"+
 		(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+
 			java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
 	return;
 }
 if(!userWeb.isActive()){
 	session.invalidate();
 	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
 	response.sendRedirect("/login.jsp");
 	return;
 }

if(nds.util.Validator.isNotNull(dialogURL)){
	response.sendRedirect(dialogURL);
 	return;
}
if(nds.util.Validator.isNull(dialogURL)){
	Boolean welcome=(Boolean)userWeb.getProperty("portal.welcome",Boolean.TRUE);
	if(welcome.booleanValue()){
		dialogURL= userWeb.getWelcomePage();
		//userWeb.setProperty("portal.welcome",Boolean.FALSE);
	}
}
String directTb=request.getParameter("table");
boolean isNotPopupPortal="false".equals(request.getParameter("popup"));//Tools.getYesNo(userWeb.getUserOption("POPUP_PORTAL","Y"), true);
if(isNotPopupPortal){
	//update current user's setting, no exception will be thrown
	userWeb.saveUserOption("POPUP_PORTAL","N",false);
}
TableManager manager=TableManager.getInstance();
Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();

boolean ssviewFirst=Tools.getYesNo(userWeb.getUserOption("SSVIEW",defaultSsviewFirst?"Y":"N"),false);

int  msgref_time=Integer.parseInt(userWeb.getUserOption("REFTIME","300"));



int ssId=Tools.getInt(request.getParameter("ss"),-1);
System.out.println("ssid->"+ssId);
/*
if(ssId==-1 && nds.util.Validator.isNull(directTb)&&defaultboshome){
	List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
	SubSystem ss=sss.get(0);
	ssId=ss.getId();
}
*/

boolean fav_show=Tools.getYesNo(userWeb.getUserOption("FAV_SHOW",defaultSsviewFirst?"Y":"N"),true);
nds.util.License.LicenseType ltype=nds.control.web.WebUtils.getLtype();
String mms=nds.control.web.WebUtils.getMms();
String cp=nds.control.web.WebUtils.getCompany();

%>
<!DOCTYPE html>
<html>
<head>
<title>Portal2.0 <%=""+cp+""%></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<%@ include file="../top_meta.jsp" %>
	<script type="text/javascript" src="/html/nds/js/newjs/pos.sliderMenu.js"></script>
<script>
<%
	if(nds.util.Validator.isNotNull(directTb)){
%>	
jQuery(document).ready(function(){pc.navigate('<%=directTb%>')});
<%	}else{
		if(nds.util.Validator.isNotNull(dialogURL)){
%>
function loadWelcomePage(){
	pc.welcome("<%=dialogURL%>");
	//window.location.href="<%=dialogURL%>";
}
jQuery(document).ready(loadWelcomePage);
<%		}	
	}
	// check whether to check timeout for portal page
	if(intervalForCheckTimeout>0){
%>	
	setInterval("checkTimeoutForPortal(<%=session.getMaxInactiveInterval()%>)", <%=intervalForCheckTimeout*60000%>);
<%
	}
%>
jQuery(document).ready(function(){
/*
横动调跟随变化标题坐标
*/
	<%if(mms != null && mms.length() != 0) {out.print(mms);}%>
	jQuery('#roll').hide();
	jQuery("#portal-content").scroll(function() {
		if(jQuery("#portal-content").scrollTop() >= 200){
			jQuery('#roll').fadeIn(400);
			//jQuery('#page-nav-commands').css("position","absolute");
		}
		else
		{
			jQuery('#roll').fadeOut(200);
			jQuery('#page-nav-commands').css("position","relative");
		}
	});

  jQuery('#roll_top').click(function(){jQuery("#portal-content").animate({scrollTop: '0px'}, 500);});
  jQuery('#roll_bottom').click(function(){jQuery("#portal-content").animate({scrollTop:jQuery('#list-legend').offset().top}, 500);});
  //jQuery('#flyout-ribbon').FlyoutRibbon();
  pc.resize();
});

jQuery(function(){
	var onAutocompleteSelect =function(value, data){
		pc.navigate(data);
	}; 
	var options = {
		serviceUrl: '/html/nds/portal/QueryServices.jsp',//获取数据的后台页面
		width: 255,//提示框的宽度
		delimiter: /(,|;)\s*/,//分隔符
		onSelect: onAutocompleteSelect,//选中之后的回调函数
		deferRequestBy: 0, //单位微秒
		params: {country: 'Yes' },//参数
		noCache: false //是否启用缓存 默认是开启缓存的
		//minChars:2
	};
	a1 = jQuery("#pojam").autocomplete(options);
	a1.enable();
	mu.update_mail_nums();

});


<%if(msgref_time>0){%>
jQuery(document).ready(function(){

setInterval("pc.msgrefrsh()",<%=msgref_time%>*1000);			

});
<%}%>
</script>	
</head>
<%if(ltype.toString().equals("Evaluation")){%>
<body style="background:url('/servlets/binserv/Image?image=apt') !important">
<%}else{%>
<body>
<%}%>
<%@ include file="../body_meta.jsp"%>
<div id="container" class="<%=ssId!=-1?"cl":""%>">
	<!--首页头部-->
	<div id="portal_top" class="<%=ssId!=-1?"sub_top":"top"%>">
		<!--头部左侧Logo-->
		<div id="portal_top_left" class="<%=ssId!=-1?"sub_top_left":"top_left"%>">
			<img src=<%if(ssId==-1){%>"/images/newimages/home_logo.png"<%}else{%>"/images/newimages/sub_logo.png"<%}%> />
		</div>
		<!--头部左侧结束-->
		<!--头部右侧 用户信息与图标菜单-->
		<div class="top_right">
			<span style=" vertical-align:middle;"><%= user.getGreeting() %></span>
			<label id="index_menu" style="display:<%=ssId==-1?"none":"black"%>">
				<span id="changeMenu" title="切换菜单" class="portal-top-icon icon-toggle"></span>
			</label>
			<label id="index_i" onclick="javascript:">
				<span title="主页" class="portal-top-icon icon-home" onclick="javascript:location.href='/html/nds/portal/ssv/index.jsp?ss=-1'"></span>
			</label>
			<label>
				<span title="设置" class="portal-top-icon2 icon-setting" onclick="javascript:showObject('/html/nds/option/option.jsp',null,null)"></span>
			</label>
			<label>
				<span id="shou_cang" cid="collects" title="收藏夹" class="portal-top-icon icon-favorite"></span>
			</label>
			<label>
				<a href="#">
					<span id="mail_xiao_xi" cid="systemMails" url="/html/nds/portal/portletlist/view_list.jsp" title="系统消息" class="portal-top-icon icon-sysinfo"></span>
					<b id="mail_nums"></b>
				</a>
			</label>
			<label style="display:none;">
				<span id="news" cid="dynamicNews" url="" title="新闻动态" class="portal-top-icon icon-dongtai"></span>
			</label>
			<label>
				<a href="<%= themeDisplay.getURLSignOut() %>">
					<span title="注销" class="portal-top-icon icon-exit"></span>
				</a>
			</label>
			<%if(ssId!=-1){%>
				<!--子系统快捷切换-悬浮面板-->
				<fieldset id="change_menu">
								<%
								String allPage="<li>1</li>";
								ssv=new nds.query.web.SubSystemView();
								SubSystem ss;
								boolean isF = true;//是否分页
								List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
								for(int ii=0;ii< sss.size();ii++){
									if(isF){
									%>
									<div class="change_content">
										<ul>
									<%
										isF = false;
									}									
									ss=sss.get(ii);
									%>
									<li>
										<a href="javascript:pc.ssv(<%=ss.getId()%>)">
											<!--span class="iconfont icon-subsys—<%=ss.getId()%>"></span-->
											<p class="bghidden"><img class="icon-img" src="<%=ss.getIconURL()%>" /></p>
											<p ><%=ss.getName()%></p>
										</a>
									</li>
									<%
										if(ii%24==23){
										if(ii != (sss.size()-1)){
											allPage+="<li>"+(ii/24+2)+"</li>";
										}											
											isF=true;
									%>
											</ul>
										</div>
									<%
										}else if(ii == (sss.size()-1)){
									%>
										</ul>
									<%
										}
									%>
								<%}%>
						
				</fieldset>
				<!--子系统快捷切换悬-浮面板结束-->
			<%}%>
		</div>
		<!--头部右侧--结束-->
		<!--收藏夹悬浮面板-->
		<div id="div_shou_cang" style="display:none;">
			<div id="change_show_cang_warp" style="display:none;"></div>
			<div class="show_cang-top"></div>
			<div id="content_show_cang"></div>
		</div>
			<!--收藏夹悬浮面板结束-->
	</div>
	<div><%@ include file="../navigation.jsp" %></div>
	<!--首页正文-->
	<div id="portal_middle" class="content cl">
			<!--首页正文-左侧-菜单区域-->
			<div id="portal_middle_left" class="content_left %>" style="width:222px;">
				<div id="portal_middle_left_fmenu" class="nav_left" style="display:<%=ssId==-1?"none":"block"%>"></div>
				<div class="nav_right <%=ssId==-1?"index_nav_right":""%>">
					<div class="out_scroll_btn_bar" style="display:none;">
						<div class="arrow_up"></div>
						<div class="arrow_center"><b style="left: 0px; top: 0px;"></b></div>
						<div class="arrow_down"></div>
					</div>
					<div id="portal_middle_left_smenu" class="nav_right-con <%=ssId==-1?"index_middleleft_smenu":"middle_left_smenu"%>">
						<%if(ssId==-1){%>
							<%@ include file="../collect.new.jsp" %>
						<%}%>
					</div>
				</div>
			</div>
			<!--首页正文-左侧-菜单区域--结束-->
			<!--首页正文-右侧内容-->
			<div id="portal_middle_right" class="content_right" style="<%=ssId==-1?"border:none;height:100%":""%>">
					<div id="portal_middle_right_menu" style="display:<%=ssId!=-1?"block":"none"%>;"></div>
					<!--右侧正文-搜索区域-->
					<div id="portal_middle_right_search" class="<%=ssId!=-1?"":"title"%>"  style="display:<%=ssId!=-1?"block":"none"%>;height:38px;">
						<div id="portal_middle_right_search_title" class="<%=ssId!=-1?"content_right-title":"title-left"%>" style="margin-left: 10px;">子系统</div>
							<div id="portal_middle_right_search_input" class="<%=ssId!=-1?"search-1":"search"%>" >
								<form name="lab" method="post" onsubmit="pc.navigate('ad_table')"><input id="pojam" type="text" class="search-button" autocomplete="off" placeholder="搜索菜单或关键字"/></form>
							</div>
					</div>
					<!--右侧正文-内容区域-->
					<div id="portal-content" class="<%=ssId!=-1?"":"index-portal-content"%>" style="margin-left:0px;" width="auto">
						<div class="content-loading center">
							<div class="dot-loading one"></div>
							<div class="dot-loading two"></div>
							<div class="dot-loading three"></div>
						</div>
					</div>
			</div>
			<!--首页正文-右侧内容--结束-->
	</div>
	<!--首页正文--结束-->
	<!--首页底部-->
	<div id="portal-bottom" class="bottom">
		<iframe id="print_iframe" name="print_iframe" width="1" height="1" src="<%= contextPath %>/html/common/null.html"></iframe>
			<%@ include file="../bottom.jsp" %>
	</div>
	<!--首页底部--结束-->
	<div id="cmdmsg" style="display:none;" ondblclick="$('cmdmsg').hide()"></div>
	<div id="jpId"></div>
	<div id="jp_container" class="jp-audio"></div>
	<div id="roll" style="display:none; "><div title="" id="roll_top"></div><div title="" id="roll_bottom"></div></div>
</div>
	<!--消息列表-悬浮面板-->
<div id="top_alert_box" class="allselect_tab" style="margin-left: -300px;display:none;">
		<dl>
			<dd id="collects">	
				<!--paco 2013-8-19 add note -->
				<script type="text/javascript">
					//nav
					jQuery(function(){
						jQuery.post("/html/nds/portal/tablecategoryout.jsp?id=4667&&onlyfa='Y'",
							function(data){
							var result=data;
							//alert(data);
							jQuery("#collects").html(result.xml);
							});	
					}); 
				</script>
			</dd>
			<dd id="systemMessages"></dd>
			<dd id="systemMails"></dd>
			<dd id="dynamicNews"></dd>
		</dl>
</div>
	<!--消息列表-悬浮面板--结束-->
			 <div id="tabs-2" style="display:none;">
		<!--liferay-ui:tabs names="mynotice"-->
			<%
			request.setAttribute("nds.portal.listconfig", "mynotice");
			%>
			<jsp:include page="/html/nds/portal/portletlist/view_list.jsp" flush="true"/>

		<!--/liferay-ui:tabs-->	
		</div>
</body>
<script type="text/javascript">

function loadIndex(){
	sidebar();
	<%if(ssId==-1){%>
		var oSlider = new Slider({
			container: '#big_frame',
			listItem: '.menu_show_main',
			btnItem:'ol'
		});
		oSlider.init();

		var oAllSelect = new AllSelect({
			container: '.allselect_tab'
		});
		oAllSelect.init();

		var aNearElementsSize = [
			jQuery('.top').outerHeight(), 
			jQuery('.bottom').outerHeight(), 
			jQuery('.title').outerHeight(), 
			jQuery('#big_frame').outerHeight() + 12, 
			jQuery('.index_main-title').outerHeight() + 20, 
			jQuery('.table01').eq(0).outerHeight() + 40
		];

		function setViewSize() {
			getViewSize('#data_tab_inner', aNearElementsSize);
		};
		setViewSize();

		jQuery(window).resize(function() {
			setViewSize();
		});

	<%}else{%>
		//alert(jQuery(".change").data("events")["click"]);
		//if(jQuery(".change").data("events")["click"]=="undefined"){
			jQuery("#changeMenu").click(function(e) {
				e.preventDefault();
				jQuery("fieldset#change_menu").show();
				
				jQuery(".change").toggleClass("menu-open");
			});
		//};

		jQuery("fieldset#change_menu").mouseup(function() {
			return false
		});
		
		// jQuery("fieldset#change_menu").mouseleave(function(){
			// jQuery("fieldset#change_menu").hide();
		// });

		
		jQuery(document).mouseup(function(e) {
			if (jQuery(e.target).parent("a.change").length == 0) {
				jQuery(".change").removeClass("menu-open");
				jQuery("fieldset#change_menu").hide();
			};
		});

		var oAllSelect = new AllSelect({
			container: '.content_right'
		});
		oAllSelect.init();

		var oConBox = jQuery('.content');
		var oNavRightCon = jQuery('.nav_right-con').eq(0);

		var setViewSize = function(){
			//oConBox.height(jQuery(window).height() - 66);
			oNavRightCon.height(jQuery(window).height() - 109);
		};
		setViewSize();
		jQuery(window).resize(function() {
			setViewSize();
		});

		/*jQuery('#close_window').click(function(){
			if (!confirm('你真的要关闭当前窗口吗')) return;
			window.opener = null;
			window.open('', '_self');
			window.close();
		});*/
	<%}%>
};
jQuery(function(){
	var hei = jQuery('#portal_middle_right').height()-2 - getViewableHeight("#portal_middle_right_menu") -getViewableHeight('#portal_middle_right_search');
	jQuery('#portal-content').height(hei);
});
function getViewableHeight(id){
	var target =jQuery(id);
	if(target.is(":visible")){
		return target.height();
	}else{
		return 0;
	}
}
//commjs_registCustomerScrollBar("#portal-content");
</script>
<%
 if(!fav_show){
%>
 <input id="fav_show" value=1 type="hidden"/>
<%}%>
</html>


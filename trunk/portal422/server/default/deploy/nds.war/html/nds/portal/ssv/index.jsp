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

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>NewBos</title>
	<!--meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"-->
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9;" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<!--script language = javascript>max.Click();</script-->
	<!--script type="text/javascript" src="/flash/FABridge.js"></script>
	<script type="text/javascript" src="/flash/playErrorSound.js"></script-->
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
	jQuery('#roll').hide();
	jQuery("#portal-content").scroll(function() {
		if(jQuery("#portal-content").scrollTop() >= 200){
			jQuery('#roll').fadeIn(400);
			jQuery('#page-nav-commands').css("position","absolute");
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
		width: 150,//提示框的宽度
		delimiter: /(,|;)\s*/,//分隔符
		onSelect: onAutocompleteSelect,//选中之后的回调函数
		deferRequestBy: 0, //单位微秒
		params: {country: 'Yes' },//参数
		noCache: false //是否启用缓存 默认是开启缓存的
		//minChars:2
	};
	a1 = jQuery("#pojam").autocomplete(options);
	a1.enable();
});


jQuery(document).ready(function(){

setInterval("pc.msgrefrsh()",<%=msgref_time%>*1000);			

});
</script>	
</head>
<body>
<%@ include file="../body_meta.jsp"%>

<div id="container" class="<%=ssId!=-1?"cl":""%>">
	<div id="portal_top" class="<%=ssId!=-1?"sub_top":"top"%>">
		<div id="portal_top_left" class="<%=ssId!=-1?"sub_top_left":"top_left"%>">
			<img src=<%if(ssId==-1){%>"/images/newimages/home_logo.png"<%}else{%>"/images/newimages/sub_logo.png"<%}%> />
		</div>
		<div class="top_right">
			<span style=" vertical-align:super;"><%= user.getGreeting() %></span>
			<label id="index_menu" style="display:<%=ssId==-1?"none":"black"%>">
				<input id="changeMenu" type="button" title="切换菜单" class="top-button top-button-hover" style=" background: url(/images/newimages/home_top_1.png) no-repeat left top;" />
				<!--<a href="#" class="change" onfocus="this.blur()" title="切换菜单"><img src="/images/newimages/home_top_1.png"/></a>-->
			</label>
			<label id="index_i" onclick="javascript:">
				<input type="button" title="主页" class="top-button top-button-hover" onclick="javascript:location.href='/html/nds/portal/ssv/index.jsp?ss=-1'" style=" background: url(/images/newimages/home_top_2.png) no-repeat left top;" />
				<!--<a href="/html/nds/portal/ssv/index.jsp?ss=-1"><img src="/images/newimages/home_top_2.png" title="主页"/></a>-->
			</label>
			<label>
				<input type="button" title="设置" class="top-button top-button-hover" onclick="javascript:showObject('/html/nds/option/option.jsp',null,null)" style=" background: url(/images/newimages/home_top_3.png) no-repeat left top;" />
				<!--<a href="#">
					<img title="设置" onclick="javascript:showObject('/html/nds/option/option.jsp',null,null)" src="/images/newimages/home_top_3.png" />
				</a>-->
			</label>
		
			<label>
				<input type="button" id="shou_cang" cid="collects" title="收藏夹" class="top-button top-button-hover" style=" background: url(/images/newimages/home_top_4.png) no-repeat left top;" />
				<!--<a href="#">
					<img id="shou_cang" cid="collects" url="" title="收藏夹" src="/images/newimages/home_top_4.png" />
				</a>-->
			</label>

			<label>
				<a href="#">
					<input type="button" id="mail_xiao_xi" cid="systemMails" url="/html/nds/portal/portletlist/view_list.jsp" title="系统消息" class="top-button top-button-hover" style=" background: url(/images/newimages/home_top_6.png) no-repeat left top;" />
					<!--<img id="mail_xiao_xi" cid="systemMails" title="系统邮件" src="/images/newimages/home_top_6.png"/>-->
					<b id="mail_nums"></b>
				</a>
			</label>
			<label style="display:none;">
				<input type="button" id="news" cid="dynamicNews" url="" title="新闻动态" class="top-button top-button-hover" style=" background: url(/images/newimages/home_top_7.png) no-repeat left top;" />
				<!--<a href="#">
					<img id="news" cid="dynamicNews" title="新闻动态" src="/images/newimages/home_top_7.png" />
				</a>-->
			</label>
			<label>
				<!--input type="button" title="注销" class="top-button top-button-hover" onclick="<%= themeDisplay.getURLSignOut() %>" style=" background: url(/images/newimages/home_top_8.png) no-repeat left top;" /-->
				<a href="<%= themeDisplay.getURLSignOut() %>">
					<img title="注销" id="close_window" src="/images/newimages/home_top_8.png" />
				</a>
			</label>
		
			<%if(ssId!=-1){%>
				<fieldset id="change_menu">
					<div id="change_warp"></div>
					<div class="change_menu-top"></div>
					<div class="change_menu-mid">
						<div class="change_menu-mid_main">							
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
											<p ><img class="icon-img" src="<%=ss.getIconURL()%>" /></p>
											<p class="bghidden"><img class="icon-img" src="<%=FileUtils.getFileNameNoEx(ss.getIconURL())%>bg.<%=FileUtils.getExtension(ss.getIconURL())%>" /></p>
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
									</div>
									<%
										}
									%>
								<%}%>
						</div>
						<div class="change_menu-mid_main-num"><ul><%=allPage%></ul></div>
					</div>
					<div class="change_menu-bot"></div>
				</fieldset>
			<%}%>
			<div id="div_shou_cang" style="display:none;">
				<div id="change_show_cang_warp" style="display:none;"></div>
				<div class="show_cang-top"></div>
				<div id="content_show_cang"></div>
			</div>
		</div>
	</div>
	<div><%@ include file="../navigation.jsp" %></div>
	<div id="portal_middle" class="<%=ssId!=-1?"content cl":""%>">
		<div id="portal_middle_left" class="content_left" style="<%=ssId!=-1?"wdith:222px;":"display:none;"%>">
			<div id="portal_middle_left_fmenu" class="nav_left"></div>
			<div class="nav_right">
				<div class="out_scroll_btn_bar" style="dispaly:none;">
					<div class="arrow_up"></div>
					<div class="arrow_center"><b style="left: 0px; top: 0px;"></b></div>
					<div class="arrow_down"></div>
				</div>
				<div id="portal_middle_left_smenu" class="nav_right-con" style="padding-right: 12px;width: 173px;"></div>
			</div>
		</div>
		<div id="portal_middle_right" class="<%=ssId!=-1?"content_right":""%>">
			<div id="portal_middle_right_menu" style="display:<%=ssId!=-1?"block":"none"%>;"></div>
			<div id="portal_middle_right_search" class="<%=ssId!=-1?"":"title"%>" style="height:38px;">
				<div id="portal_middle_right_search_title" class="<%=ssId!=-1?"content_right-title":"title-left"%>" style="margin-left: 10px;">子系统</div>
				
					<div id="portal_middle_right_search_input" class="<%=ssId!=-1?"search-1":"search"%>" title="<%=directTb%>">		
						<form name="lab" method="post" onsubmit="pc.navigate(\"ad_table\")"><input id="pojam" type="text" class="search-button" autocomplete="off" placeholder="搜索菜单或关键字"/></form>
					</div>
					<div style="margin:0;overflow:hidden;" ><%@ include file="../list_menu.jsp" %></div>
			</div>
			<div id="portal-content" style="margin-left:0px" width="auto"></div>
		</div>
	</div>
	<div id="portal-bottom" class="bottom">
		<iframe id="print_iframe" name="print_iframe" width="1" height="1" src="<%= contextPath %>/html/common/null.html"></iframe>
		<%@ include file="../bottom.jsp" %>
	</div>
	<div id="cmdmsg" style="display:none;" ondblclick="$('cmdmsg').hide()"></div>
	<div id="jpId"></div>
	<div id="jp_container" class="jp-audio"></div>
	<div id="roll" style="display:none; "><div title="" id="roll_top"></div><div title="" id="roll_bottom"></div></div>
</div>
<div id="top_alert_box" class="allselect_tab" style="margin-left: -300px;display:none;">
	<dl>
        <!--dt>
			<a href="javascript:;" style="display:none;"><img src="/images/newimages/tanchu/Trash.png" alt="" /></a>
            <span>收藏夹</span>
		</dt-->
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
</script>
<%
 if(!fav_show){
%>
 <input id="fav_show" value=1 type="hidden"/>
<%}%>
</html>


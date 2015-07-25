<%@ page language="java" import="java.util.*,nds.velocity.*,org.json.JSONArray,org.json.JSONObject" pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@include file="/html/nds/common/init.jsp"%>
<%! 
 private static int intervalForCheckTimeout=Tools.getInt(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("portal.session.checkinterval","0"),0);
%>
<%
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){ 	
	response.sendRedirect("/c/portal/login");
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
return;
}

String dialogURL=request.getParameter("redirect");
if(nds.util.Validator.isNull(dialogURL)){
	Boolean welcome=(Boolean)userWeb.getProperty("portal.welcome",Boolean.TRUE);
	if(welcome.booleanValue()){
		dialogURL= userWeb.getWelcomePage();
		//userWeb.setProperty("portal.welcome",Boolean.FALSE);
	}
}
	WebClient myweb=new WebClient(37, "","burgeon",false);
	//下面是查找公司新闻的几个栏目
    String	other_str=(String)QueryEngine.getInstance().doQueryOne("select description  from AD_LIMITVALUE t where t.ad_limitvalue_group_id=(select id from AD_LIMITVALUE_GROUP t2 where t2.name='PORTAL_NEWS')   and t.value='other'");
    String	industry_str=(String)QueryEngine.getInstance().doQueryOne("select description  from AD_LIMITVALUE t where t.ad_limitvalue_group_id=(select id from AD_LIMITVALUE_GROUP t2 where t2.name='PORTAL_NEWS')   and t.value='industry'");
    String	latest_str=(String)QueryEngine.getInstance().doQueryOne("select description  from AD_LIMITVALUE t where t.ad_limitvalue_group_id=(select id from AD_LIMITVALUE_GROUP t2 where t2.name='PORTAL_NEWS')   and t.value='latest'");
    String	company_str=(String)QueryEngine.getInstance().doQueryOne("select description  from AD_LIMITVALUE t where t.ad_limitvalue_group_id=(select id from AD_LIMITVALUE_GROUP t2 where t2.name='PORTAL_NEWS')   and t.value='company'");
    //通过表来获得跳转的子系统ssid号
     int	V_AUDITBILL_id=Tools.getInt(QueryEngine.getInstance().doQueryOne("select a.ad_subsystem_id from ad_tablecategory a,ad_table b where a.id=b.ad_tablecategory_id and b.name='V_AUDITBILL'"),-1);
	 int	U_NOTE_id=Tools.getInt(QueryEngine.getInstance().doQueryOne("select a.ad_subsystem_id from ad_tablecategory a,ad_table b where a.id=b.ad_tablecategory_id and b.name='U_NOTE'"),-1);
	//下载工具
	List al=(List)QueryEngine.getInstance().doQueryList("select name,dw_link,dw_img from dw_tools");
%>
<%
nds.util.License.LicenseType ltype=nds.control.web.WebUtils.getLtype();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <script language="JavaScript" src="/html/nds/portal/ssv/js/oacontrol.js"></script>
    <script>
        <%
            // check whether to check timeout for portal page
            if(intervalForCheckTimeout>0){
                %>
                    setInterval("checkTimeoutForPortal(<%=session.getMaxInactiveInterval()%>)", <%=intervalForCheckTimeout*60000%>);
                <%}
        if(nds.util.Validator.isNotNull(dialogURL)) {
            %>	
                popup_window("<%=dialogURL%>");
            <%}
        %>	
</script>
</head>
<%if(ltype.toString().equals("Evaluation")){%>
<body style="background: url('/servlets/binserv/Image?image=apt') !important">
    <%}else{%>
    <body>
        <%}%>
			<!--paco 2013-8-19 add note '收藏夹'
			<script type="text/javascript">
				//nav
				jQuery(function(){
					jQuery.post("/html/nds/portal/tablecategoryout.jsp?id=4667&&onlyfa='Y'",
						function(data){
						var result=data;
						//alert(data);
						jQuery("#tree-list").html(result.xml);
						jQuery("#tree-list").css("padding","0");
						jQuery("#tab_accordion").accordion({ header: "h3",autoHeight:true,navigation:false,active:0})
						});	
				}); 
			</script>-->
        <%
			/**
			Navigation of ss
			 */
			TableManager manager=TableManager.getInstance();
			String portalHome="/html/nds/portal/portal.jsp?ss=";
			nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
			SubSystem ss;
		%>
		<div class="index-right-content">
            <div class="index-right-content-wrap">
				<!--子系统面板-->
				<div class="subSystem">
					<h3><span class="iconfont icon-mokuaiguanli"></span>子系统</h3>
					<div class="icon-wrap sub-system">
						<ul class="icon">
							<%
								List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
							%>
							<%
								for(int ii=0;ii< sss.size();ii++){
									ss=sss.get(ii);
							%>
					
							<li onclick="javascript:pc.ssv(<%=ss.getId()%>)">
								<!--span class="iconfont icon-subsys—<%=ss.getId()%>" class="main_icon"></span-->
								<a href="javascript:ssv.view(44)"><img class="icon-img" style="margin: 0 auto;
  margin-bottom: 3px;" src="<%=ss.getIconURL()%>" style="display:block" />
									<p><%=ss.getName()%></p>
								</a>
							</li>
							<%}%>
				
						</ul>
					</div>
				</div>
				<!--子系统面板--结束-->
				<!--待审批单据-->
				<div class="receipt">
					<h3><span class="iconfont icon-xinwengonggao"></span>待审批单据</h3>
					<div id="audit_cox">
					  <jsp:include page="inc_audit.jsp" flush="true"/><!--动态包含-->
					</div>
				</div>
				<!--系统消息列表-->
				<div class="sysMessageList">
					<div class="danju border-top-none">
						<h3>
						<span class="iconfont icon-xinxi2" style="color:#2b2b2b; margin:0 10px;"></span>
						系统消息
						<a href="/html/nds/portal/ssv/index.jsp?ss=82&table=u_note">+</a>
						</h3>
					</div>
					<div class="information" id="sysMessageList">
						<div style="height:50px;">
						<div class="loading-bouble-wrap"><div class="loading-boule"></div></div>
						</div>
					</div>
				</div>
				<!--系统消息列表--结束-->
			</div>
        </div>
			<!--右侧新闻动态-->
		<div class="newslist Main_interface_cont_right delay-half">
				<div class="Main_interface_cont_right-wrap">
					<h3><span class="iconfont icon-xinwengonggao"></span>新闻动态</h3>
					<div class="all_news currentActive">
						<div class="all_news_left">
							<h2><%=latest_str%>：</h2><!--最新动态-->
							<span><a class="box-tool" href="javascript:void(0);">-</a></span>
						</div>
						<ul class="">
							 <% List latest=myweb.getList("latest","latest");
									for(int k=0;k<latest.size();k++){
							 %> 											
							<li>&nbsp;<a href="<%=((List)latest.get(k)).get(0)%>" class="width-text" target="_blank"><%=((List)latest.get(k)).get(1)%></a></li> 
							<%}%>
							<li><a class="more" href="/news.jsp?newsstr=latest" target="_blank">>>更多</a></li>
						</ul>
					</div>
					<div class="all_news">
						<div class="all_news_left">
							<h2 class=""><%=industry_str%>：</h2><!--行业新闻-->
							<span><a  class="box-tool" href="javascript:void(0);">+</a></span>
						</div>
						<ul class=""> 
								<% List companyportal=myweb.getList("industry","industry");
									for(int iii=0;iii<companyportal.size();iii++){
								%>
								<li>&nbsp;<a href="<%=((List)companyportal.get(iii)).get(0)%>" class="width-text" target="_blank"><%=((List)companyportal.get(iii)).get(1)%></a></li>
								<%}%>
							<li><a class="more" href="/news.jsp?newsstr=industry" target="_blank">>>更多</a></li>
						</ul>
					</div>
					<div class="all_news">
						<div class="all_news_left">
							<h2 class="add"><%=company_str%>：</h2><!--公司新闻-->
							<span><a class="box-tool"  href="javascript:void(0);">+</a></span>
						</div>
						<ul class="">
							<% List companyportal1=myweb.getList("company","company");
									for(int j=0;j<companyportal1.size();j++){
							%>
								<li>&nbsp;<a href="<%=((List)companyportal1.get(j)).get(0)%>" class="width-text" target="_blank"><%=((List)companyportal1.get(j)).get(1)%></a></li>
							<%}%>
							<li><a class="more" href="/news.jsp?newsstr=company" target="_blank">>>更多</a></li>
						</ul>
					</div>
					<div class="all_news">
						<div class="all_news_left">
							<h2 class="add"><%=other_str%>：</h2><!--其他-->
							<span><a class="box-tool" href="javascript:void(0);">+</a></span>
						</div>
						<ul class="">
							<%   List companyportal2=myweb.getList("other","latest");
									for(int jj=0;jj<companyportal2.size();jj++){
							%>
								<li>&nbsp;<a href="<%=((List)companyportal2.get(jj)).get(0)%>" class="width-text" target="_blank"><%=((List)companyportal2.get(jj)).get(1)%></a></li>
							<%}%>
							<li><a class="more" href="/news.jsp?newsstr=other" target="_blank">>>更多</a></li>
						</ul>
					</div>
				</div>
		</div>
			<!--右侧新闻动态--结束-->
        <input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
		<script type="text/javascript">
			//初始化页面
			function initPortalBody(){
				im.build('sysMessageList');
				jQuery(".newslist").on("click",".all_news_left",toggleNewsBlock);
			}
			//切换新闻列表栏
			function toggleNewsBlock(){
				var selfElement = jQuery(this);
				var p = selfElement.parent();
				var isOpen = p.is(".currentActive");
				var currentActive = jQuery(".newslist").find(".currentActive");
				if(!isOpen){
					currentActive.removeClass("currentActive");
					currentActive.find(".box-tool").html("+");
					p.find(".box-tool").html("-");
					p.addClass("currentActive");
				}
			}
			window.jQuery(initPortalBody);
		</script>
    </body>
</html>

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
%>
<%!	
 	private final static int MAX_SUBJECT_LENGTH_NARROW_1024=30;
 	private final static int MAX_SUBJECT_LENGTH_WIDE_1024=50;
 	private final static int MAX_SUBJECT_LENGTH_MAX_1024=100;
 	private final static int MAX_SUBJECT_LENGTH_NARROW_800=24;
 	private final static int MAX_SUBJECT_LENGTH_WIDE_800=40;
 	private final static int MAX_SUBJECT_LENGTH_MAX_800=80;	
%>
<%
String curTime=String.valueOf(System.currentTimeMillis());
java.text.DateFormat df =((java.text.SimpleDateFormat)QueryUtils.dateFormatter.get());// new java.text.SimpleDateFormat("MM-dd HH");
//df.setTimeZone(timeZone);

//TableManager manager=TableManager.getInstance();
int startIndex= 0;
if(startIndex<0) startIndex=0;
boolean isOut= "Y".equals( QueryEngine.getInstance().doQueryOne("select is_out from users where id="+ userWeb.getUserId()));
boolean showAssignment=false;
 QueryResult result;
 int oid, recordId,tableId;
 String recordDocNo, brief,processName; 
 String  creationDate=null;
 int recordCount,i, maxTitleLength; 
 int serialno,relativeIdx=-1;
 Table table;
 //int phaseInstanceTableId=manager.getTable("au_phaseinstance").getId();
 int pageRecordCount;
 String className,assigneeName=null;
 int assigneeId=-1;
FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(TableManager.getInstance().getTable("users"), "assignee",null); 
fkQueryModel.setQueryindex(-1);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@ include file="/html/nds/portal/ssv/top_meta.jsp" %>

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
		   <script type="text/javascript">
		
		  //nav
   jQuery(function(){
   jQuery(".all_news .news").css('opacity','0.1');
    jQuery(".all_news .news").hide(100).animate({opacity: '0.1'}, '50');
	jQuery(".all_news .news:first").show(100).animate({opacity: '1'}, '50');
    jQuery(".title2").click(function(){
	if(jQuery(this).next().css('opacity','0.1')){
		jQuery(".all_news .news").not(jQuery(this).next()).hide(100).animate({opacity: '1'}, '50');
  	    jQuery(this).next().slideDown(100).animate({opacity: '1'}, '50');
    }
     });
	jQuery(".title2 h2").click(function(){
			jQuery(".title2  h2").not(jQuery(this).next()).removeClass("minus");
			jQuery(this).toggleClass("minus","switch");
		});
	    jQuery.post("/html/nds/portal/tablecategoryout.jsp?id=4667&&onlyfa='Y'",
			   function(data){
			     var result=data;
			      //alert(data);
			     jQuery("#fa_mu").html(result.xml);
			     jQuery("#fa_mu").css("padding","0");
			    jQuery("#tab_accordion").accordion({ header: "h3",autoHeight:false,navigation:true,active:1})
			    });	
		
    }); 

		  </script>
		  
</head>
<body>
		
<div class="header"></div><!--end header-->
<div class="head">
	<div id="head_logo"></div>
	  <div class="welcom"><!--欢迎您的到来 顶部-->
       <span class="lines"><span style="font-weight: bold"><%=user.getGreeting()%>&nbsp;&nbsp;│</span></span> 
       <%if(session.getAttribute("saasvendor")==null){
		     
			 %>
			  <a class="top-text" href="/"><%=PortletUtils.getMessage(pageContext, "home",null)%></a>&nbsp;&nbsp;|&nbsp;
			<%}%>                              
		<%if(session.getAttribute("saasvendor")==null){%>
			<a class="top-text" href="<%= themeDisplay.getURLSignOut() %>"><bean:message key="sign-out" /></a>
			<%}%>
   
    </div>
</div><!--end head-->
<%
/**
Navigation of ss
 */
String portalHome="/html/nds/portal/portal.jsp?ss=";
TableManager manager=TableManager.getInstance();
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
SubSystem ss;
%>

<div class="main"> 
	<div class="main_add">
    	<div id="fa_mu" class="main_box">
    	<script type="text/javascript">

    		</script>
        </div><!--end main_box-->
    </div><!--end main_add-->
    
    
    <div class="main_gap">&nbsp;</div>
	<div class="main_left">
    	<div class="main_box main_box2">
        	<div class="title">
            	<div class="title_left">&nbsp;</div>
                <h1>子系统</h1>
                <div class="title_right">&nbsp;</div>
            </div><!--end title-->
            <ul class="ico">
               <%
								List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
								for(int ii=0;ii< sss.size();ii++){
									ss=sss.get(ii);
								%>								
								<li><a href="javascript:ssv.view(<%=ss.getId()%>)" class="classId_<%=ss.getId()%>"><%=ss.getName()%></a></li>
								<%	
								}
								%>
            
            	
            </ul><!--end ico-->
        </div><!--end main_box-->
    <div id="cmdmsg" style="display:none;" ondblclick="$('cmdmsg').hide()"></div>
    
</div>
<div class="copyright">
 <div class="copy_text">(C) 2008-2009   上海伯俊软件科技有限公司   版权所有</div>  </div>
<!--end copyright-->


	
	

</body>
</html>



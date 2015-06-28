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
/*
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
 //int pageRecordCount;
 String className,assigneeName=null;
 int assigneeId=-1;
FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(TableManager.getInstance().getTable("users"), "assignee",null); 
fkQueryModel.setQueryindex(-1);
*/
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
jQuery(document).ready(function(){
  pc.navigate('/html/nds/portal/ssv/inc_audit.jsp','audit_cox');
 });
</script>		  
</head>
<%if(ltype.toString().equals("Evaluation")){%>
<body style="background:url('/servlets/binserv/Image?image=apt') !important">
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
<div class="menu_show" id="big_frame">
	<div class="menu_show_arrow prev"></div>
	<div class="menu_show_arrow1 next"></div>	  
	<%
	String sign="begin";
	int ooi=0;
	List<SubSystem> sss =ssv.getSubSystems(request, nds.query.web.SubSystemView.PERMISSION_VIEWABLE);
	if(sss.size()>1){ooi=(sss.size()-1)/9+1;}
	else{ooi=0;}
	%>
	<div class="menu_show_main">
		<%
		for(int ii=0;ii< sss.size();ii++){
			ss=sss.get(ii);
			if(ii%9==0&&"end".equals(sign)){
				sign="begin";
				%>
				</li></ul>
			<%}
			if(ii%9==0&&"begin".equals(sign)){
				sign="end";
				%>
				<ul class="big_list"><li>
			<%}%>
			<span class="span-box" onclick="javascript:pc.ssv(<%=ss.getId()%>)">
				<a href="#" class="classId_<%=ss.getId()%>">
					<p><img class="icon-img" src="<%=ss.getIconURL()%>" /></p>
					<p><%=ss.getName()%></p>
				</a>
			</span>
		<%}%>
		<%/*
		int ou=sss.size()%9;
		int lu=9-ou;
		if(ou>0){
			for(int ii=0;ii<lu;ii++){
				%>
				<span class="span-box bg_none"></span>
				<%
			}
		}
		*/%>
		</li></ul>
	</div>
	<ol style="z-index:100">
		<li class="active"></li>
		<%if(ooi>1){
			for(int ix=1;ix<ooi;ix++){
			%>
				<li></li>
			<%
			}
		}%>
	</ol>
</div>
<div class="index_main cl">
	<div class="index_main-title">
		<span class="span-16 span-wryh span-bold">待审批单据</span>
		<span class="more">
			<a href="/html/nds/portal/ssv/index.jsp?ss=<%=V_AUDITBILL_id%>&table=V_AUDITBILL"><img src="/html/nds/portal/ssv/images/login_63.gif" /></a>
		</span>
	</div>
	<div id="audit_cox"></div>
</div>
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
</body>
</html>


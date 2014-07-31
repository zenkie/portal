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
<body>
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
			<span class="span-box">
				<a href="javascript:pc.ssv(<%=ss.getId()%>)" class="classId_<%=ss.getId()%>">
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
<div id="portal-content" class="index_main cl">
	<div class="index_main-title">
		<span class="span-16 span-wryh span-bold">待审批单据</span>
		<span class="more">
			<a href="/html/nds/portal/ssv/index.jsp?ss=<%=V_AUDITBILL_id%>&table=V_AUDITBILL"><img src="/html/nds/portal/ssv/images/login_63.gif" /></a>
		</span>
	</div>
	<form id="form1" method="POST">
		<div class="index_main-table" style="min-width:1200px;">
			<table width="100%" class="table01 nohover" style="border: 2px #EAEAEA solid;">
				<tr height="40">
					<td width="100%">
						<input id="command" name="command" type="hidden" value="ExecuteAudit">
						<input id="auditActionType" type="hidden" name="auditAction" value="auditAction">
						<input type='hidden' name='arrayItemSelecter' value='selectedItemIdx'>
						<% 
						// maiximized one
						recordCount=15;
						maxTitleLength=MAX_SUBJECT_LENGTH_MAX_1024;
						result= AuditUtils.findWaitingInstances(request, recordCount, startIndex, showAssignment);
						pageRecordCount=result.getRowCount();
						%>
						<div style="width:40%; float:left;">
							<span style="float:left; margin-left:20px;">批复&nbsp;&nbsp;
								<input name="comments" id="comments" type="text" class="input-140" />
							</span>
							<span style="float:left; margin-left:20px;">
								<input onclick="javascript:oa.submitAuditForm('accept')" type="button" class="button-blue" value="批准" />
							</span>
							<span style="float:left; margin-left:20px;">
								<input onclick="javascript:pc.submitAuditForm('reject')" type="button" class="button-blue" value="驳回" />
							</span>
						</div>
						<div style="width:60%; float:left;">
							<span style="float:left; margin-left:20px;">代理人&nbsp;&nbsp;
								<input name="assignee" id="assignee" type="text" class="input-140" />
								<span id="user" onaction="<%=fkQueryModel.getButtonClickEventScript()%>">
									<img class="login_78" align=absmiddle src="/html/nds/portal/ssv/images/pfind.gif" >
								</span>
								<script>createButton(document.getElementById("user"));</script>   
							</span>
							<span style="float:left; margin-left:20px;">
								<input onclick="pc.submitAuditForm('assign')" type="button" class="button-blue" value="转派" />
							</span>
							<span style="float:left; margin-left:20px;">
								<input onclick="javascript:oa.showdlg2('/html/nds/portal/ssv/setup.jsp')" type="button" class="button-blue" value="设置" />
							</span>
						</div>
					</td>
				</tr>
			</table>
			<%@include file="/html/nds/portal/ssv/inc_audits_msgs.jsp"%>
            <div class="allselect_tab" style="position:relative;">
				<div style="min-width:1200px;overflow: hidden;">
                    <table id="order_table_head" class="table01" style="margin-top:-2px;background-color: #EAEAEA;border-collapse: separate;width:100%;">
						<thead>
							<tr height="30" bgcolor="#F7F7F7">
								<td width="6%" align="center" style="text-indent:0px;">
									<input id="chk_select_all" name="chk_select_all" value=1 onclick='javascript:oa.checkAll("form1",<%=pageRecordCount%>)' type="checkbox" />
								</td>
								<td width="18%">单据号</td>
								<td width="12%"><%= manager.getTable("au_process").getDescription(locale)%></td>
								<td width="32%">描述</td>
								<td width="32%">创建时间</td>
							</tr>
						</thead>
					</table>
				</div>
				<div id="data_tab_inner" style="width:100%; min-height:100px; min-width:1200px; overflow:auto; position:relative; z-index:22">
					<table id="order_table_body" class="table01" style="margin-top: -36px; min-width:1200px; width:100%;background-color: #EAEAEA;border-collapse: separate;">
						<thead>
							<tr height="30" bgcolor="#F7F7F7">
								<td width="6%" align="center" style="text-indent:0px;">
									<input id="chk_select_all" name="chk_select_all" value=1 onclick='javascript:oa.checkAll("form1",<%=pageRecordCount%>)' type="checkbox" />
								</td>
								<td width="18%">单据号</td>
								<td width="12%"><%= manager.getTable("au_process").getDescription(locale)%></td>
								<td width="32%">描述</td>
								<td width="32%">创建时间</td>
							</tr>
						</thead>
						<tbody>
							<%//没有数据时候显示：
								if(pageRecordCount==0){
							%> 
							<tr height="30" style="line-height: 30px;background-color: white;"><td align="center" colspan="5" valign="top">没有数据</td></tr> 
							<%}
							int userTableId= manager.getTable("users").getId();
							while(result.next()){
								oid=((java.math.BigDecimal)result.getObject(1)).intValue(); // au_phaseinstance.id
								processName= (String)result.getObject(2);
								tableId=((java.math.BigDecimal)result.getObject(3)).intValue();
								table= manager.getTable(tableId);
								if( table ==null){
									//special condition when table is not active set by admin
									continue;
								}
								/* yfzhu marked up following line since real table must not show view's records */
								//if(table.getRealTableName()!=null) tableId=manager.getTable(table.getRealTableName()).getId();
								recordDocNo= (String)result.getObject(4);
								recordId=Tools.getInt(result.getObject(5),-1) ; 

								if(Validator.isNull(recordDocNo)){
									recordDocNo="[null]";
								}
								brief=StringUtils.shortenInBytes( (String)result.getObject(6), maxTitleLength);
								if(!showAssignment){
									if(result.getObject(7) !=null){ 
										creationDate= df.format((java.util.Date)result.getObject(7));
									}else{
										creationDate=StringUtils.NBSP;
									}
								}else{
									//loading assignee information
									List pl=(List)QueryEngine.getInstance().doQueryList("select u.id,u.name from users u, au_pi_user p where p.au_pi_id="+oid+" and p.ad_user_id="+ userWeb.getUserId()+" and p.assignee_id=u.id(+)").get(0);
									assigneeId= Tools.getInt( pl.get(0),-1);
									assigneeName= (String)pl.get(1);
								}
								relativeIdx++;
								className= (relativeIdx%2==1?"gamma":"gamma");
							%>
								<tr id="<%=oid%>_templaterow" class="<%=oid%2==0?"even-row":"odd-row"%>" height="30">
									<td width="6%" align="center" valign="middle">
										<span class="checkbox">
										<input  type="checkbox" id='chk_obj_<%=oid%>' name='itemid' value='<%=oid%>' onclick="oa.unselectall()"/>
										</span>
									</td>
									<td width="18%" align="center" valign="middle"><a href="javascript:oa.auditObj(<%=oid%>)"><%=recordDocNo%></a></td>
									<td width="12%" align="center" valign="middle"><a href="javascript:oa.auditObj(<%=oid%>)"><%=processName%></a></td>
									<td width="32%" align="center" valign="middle"><%=brief%></td>
									<td width="32%" align="center" valign="middle">
										<%if(showAssignment){%>
											<a href="javascript:popup_window('/html/nds/object/object.jsp?table=<%=userTableId%>&id=<%=assigneeId%>')"><%=assigneeName%></a>
										<%}else{%>
										<%=creationDate%>
										<%}%>
									</td>
								</tr>
							<%
							}
							int totalCount=AuditUtils.getTotalCount(request,showAssignment);
							String url="/html/nds/audit/view.jsp?showassign="+Boolean.toString(showAssignment);
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>	
</div>
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
</body>
<script type="text/javascript">
	jQuery(window).ready(function() {
		setScroll();
		jQuery(window).resize(setScroll);
	});
	function setScroll(){
		var width=0;
		var pageCount=<%=pageRecordCount%>;
		if(pageCount > 0){
			var tableHead=jQuery("#order_table_head").find("tr:first td");
			if(!tableHead){return;}
			jQuery("#order_table_body").find("thead tr:first td").each(function(i){
				width=jQuery(this).width();
				jQuery(this).css({"width":width+"px","min-width":width+"px","max-width":width+"px"});
				jQuery(tableHead[i]).css({"width":width+"px","min-width":width+"px","max-width":width+"px"});
			});
			var dBody=$("data_tab_inner");
			if(dBody){
				dBody.onscroll=function(){
					jQuery("#order_table_head").css({"margin-left":"-"+this.scrollLeft+"px"});
				}
			}
		}
	}
</script>
</html>

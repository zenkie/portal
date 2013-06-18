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

		  </script>
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
								<li><a href="javascript:pc.ssv(<%=ss.getId()%>)" class="classId_<%=ss.getId()%>"><%=ss.getName()%></a></li>
								<%	
								}
								%>
            
            	
            </ul><!--end ico-->
        </div><!--end main_box-->

		 <!--------------待审批单据------------------->
        <div class="main_box main_box3">
       	  <div class="title">
   	      <div class="title_left">&nbsp;</div>
                <h1>待审批单据</h1>
                <div class="title_right">&nbsp;</div>
				<span class="more"><a href="/html/nds/portal/portal.jsp?ss=<%=V_AUDITBILL_id%>&table=V_AUDITBILL">
						<img src="/html/nds/portal/ssv/images/login_63.gif" /></a></span>
            </div><!--end title-->
           <form id="form1" method="POST">
            <ul class="audit">
	            	<input id="command" name="command" type="hidden" value="ExecuteAudit">
	            	<input id="auditActionType" type="hidden" name="auditAction" value="auditAction">
								<input type='hidden' name='arrayItemSelecter' value='selectedItemIdx'>
								<% 
									// maiximized one
									recordCount=5;
									maxTitleLength=MAX_SUBJECT_LENGTH_MAX_1024;
								 	result= AuditUtils.findWaitingInstances(request, recordCount, startIndex, showAssignment);
								 	pageRecordCount=result.getRowCount();
								%>
            	<li>
            		<span>批复：</span>
	            		<input  type="text" class="pus_input" maxlength="255" name="comments" id="comments"/>
	            		<a   onclick="javascript:oa.submitAuditForm('accept')"  class="button">批 准</a>
	            		<a  href="" onclick="javascript:pc.submitAuditForm('reject')"  class="button">驳 回</a>
            		</span>
            	</li>
              <li class="set_up"><span>代理人：</span>
              <input  type="text" class="aus_input" name="assignee"  id="assignee"/>
              <!--<i class="search"><input name="" type="image" src="images/search.gif" /></i>-->
			  <span id="user" onaction="<%=fkQueryModel.getButtonClickEventScript()%>">
				  <img class="login_78" align=absmiddle src="/html/nds/portal/ssv/images/pfind.gif" ></span>
	              	 <script>
										   createButton(document.getElementById("user"));
									 </script>   
              
              
              <a class="button" href="" onclick="pc.submitAuditForm('assign')">转 派</a>
              <a href="javascript:oa.showdlg2('/html/nds/portal/ssv/setup.jsp')" class="button">设 置</a>
              </li>
            </ul><!--end audit-->
            <%@include file="/html/nds/portal/ssv/inc_audits_msgs.jsp"%>
            
            <ul class="docno">
            	<li class="checkbox"><input class='cbx' type="checkbox" id="chk_select_all" name="chk_select_all" value=1 onclick='javascript:oa.checkAll("form1",<%=pageRecordCount%>)'></li>
                <li class="docno_con">单据号</li>
                <li class="docno_con"><%= manager.getTable("au_process").getDescription(locale)%></li>
                <li class="docno_con">描 述</li>
                <li class="docno_con">创建日期</li>
            </ul><!--end docno-->
            
            <div class="data">
            	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                <tbody>
                
                <%//没有数据时候显示：
											   if(pageRecordCount==0){
											%> 
													<tr>
																<td align="center" colspan="5" valign="top">
																	没有数据
																</td>
													</tr> 
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
								
								
                  <tr id="<%=oid%>_templaterow">
                    <td width="8%" height="24" align="center" valign="middle">
                    <span class="checkbox">
                      <input  type="checkbox" id='chk_obj_<%=oid%>' name='itemid' value='<%=oid%>' onclick="oa.unselectall()"/>
                    </span></td>
                    <td width="23%" height="24" align="center" valign="middle"><a href="javascript:oa.auditObj(<%=oid%>)"><%=recordDocNo%></a></td>
                    <td width="23%" height="24" align="center" valign="middle"><a href="javascript:oa.auditObj(<%=oid%>)"><%=processName%></a></td>
                    <td width="23%" height="24" align="center" valign="middle"><%=brief%></td>
                    <td width="23%" height="24" align="center" valign="middle">
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

         </div><!--end data-->
      </form>
      </div><!--end main_box-->
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
		<div class="main_box" style="display:none;">
       	  <div class="title">
   	      <div class="title_left">&nbsp;</div>
                <h1>新闻公告</h1>
                <div class="title_right">&nbsp;</div>
            </div><!--end title-->
            <!--ul class="news">
            	<li><a href="#">上善若水。</a></li>
                <li><a href="#">水善利万物而不争，处众人之所恶，故几于道。</a></li>
                <li><a href="#">居善地，心善渊，与善仁，言善信，政善治，事善能，动善时。</a></li>
                <li><a href="#">夫唯不争，故无尤。</a></li>
            </ul--><!--end audit-->
            <div class="clear"></div>
		</div>
    <div id="cmdmsg" style="display:none;" ondblclick="$('cmdmsg').hide()"></div>
    
</div>

    <div class="main_right">
    	<div class="main_box">
        	<div class="title">
            	<div class="title_left">&nbsp;</div>
                <h1>常用下载</h1>
                <div class="title_right">&nbsp;</div>
            </div><!--end title-->
        </div><!--end main_box-->
		<div id="loadbox">
			<ul>
				<%
				String name="";
				String dw_link="";
				String dw_img=null;
				if(al.size()>0){
				for(int j=0;j<al.size();j++){
					name=(String)((List)(al.get(j))).get(0);
					dw_link=(String)((List)(al.get(j))).get(1);
					dw_img=(String)((List)(al.get(j))).get(2);
				%>
				<li><a href="<%=dw_link%>"><img src="<%=dw_img==null?"/html/nds/portal/ssv/images/dw.png":dw_img%>"><%=name%></a></li>
				<% }
				}
				%>
			</ul>
		</div>
    </div><!--end main_right-->
</body>
</html>



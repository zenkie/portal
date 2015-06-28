<%@ page language="java" pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*"%>
<%!
	/**
	* Parameters: 
	*   startidx --  start index for query
	*   order    --  order column(int) if not set will set to creationdate of u_note
	*   asc      --  1 for ascending, else for descending, default to desc
	*/
	
	
	/**
	*  max length to be display for the news' subject,
	*  if greater than that, will append ".."
	*/
 	private final static int MAX_SUBJECT_LENGTH_NARROW_1024=30;
 	private final static int MAX_SUBJECT_LENGTH_WIDE_1024=50;
 	private final static int MAX_SUBJECT_LENGTH_MAX_1024=100;
 	private final static int MAX_SUBJECT_LENGTH_NARROW_800=24;
 	private final static int MAX_SUBJECT_LENGTH_WIDE_800=40;
 	private final static int MAX_SUBJECT_LENGTH_MAX_800=80;
	
%>

<%
String curTime=String.valueOf(System.currentTimeMillis());
DateFormat df =((java.text.SimpleDateFormat)QueryUtils.dateFormatter.get());// new java.text.SimpleDateFormat("MM-dd HH");
//df.setTimeZone(timeZone);

TableManager manager=TableManager.getInstance();
int startIndex= ParamUtil.get(request, "startidx", 0);
if(startIndex<0) startIndex=0;
boolean isOut= "Y".equals( QueryEngine.getInstance().doQueryOne("select is_out from users where id="+ userWeb.getUserId()));
boolean showAssignment=ParamUtil.get(request,"showassign",false);
 QueryResult result;
 int oid, recordId,tableId;
 String recordDocNo, brief,processName; 
 String  creationDate=null;
 int recordCount,i, maxTitleLength; 
 int serialno,relativeIdx=-1;
 Table table;
 int phaseInstanceTableId=manager.getTable("au_phaseinstance").getId();
 int pageRecordCount;
 String className,assigneeName=null;
 int assigneeId=-1;
 Date crdate=new Date();
FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(TableManager.getInstance().getTable("users"), "assignee",null); 
fkQueryModel.setQueryindex(-1);
%>
<form action="/control/command" method="post" id="form1">
		<div class="index_main-table" style="min-width:1200px;">
			<table width="100%" class="table01 nohover" style="border: 2px #EAEAEA solid;">
				<tr height="40">
					<td width="100%">
						<input id="command" name="command" type="hidden" value="ExecuteAudit">
						<input id="auditActionType" type="hidden" name="auditAction" value="auditAction">
						<input type='hidden' name='arrayItemSelecter' value='selectedItemIdx'>
						<% 
						// maiximized one
						recordCount=6;
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
								<input onclick="javascript:oa.submitAuditForm('reject')" type="button" class="button-blue" value="驳回" />
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
            <div class="allselect_tab" style="position:relative;" id="audit_cox">
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
							int rowcut=1;
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
								<tr id="<%=oid%>_templaterow" class="<%=rowcut%2==0?"even-row":"odd-row"%>" height="30">
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
							rowcut++;
							}
							int totalCount=AuditUtils.getTotalCount(request,showAssignment);
							String url="/html/nds/portal/ssv/inc_audit.jsp?showassign="+Boolean.toString(showAssignment);
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
<div id="audit-nav">
<a href="javascript:pc.navigate('/html/nds/portal/ssv/inc_audit.jsp?showassign=<%=Boolean.toString(!showAssignment)%>','audit_cox')" styleClass="bg">[<%= LanguageUtil.get(pageContext, showAssignment?"show-my-work-list":"show-assign",null)%>]</a>&nbsp;
<% for(i=0 ;i< ((totalCount/recordCount)>15?15:(totalCount/recordCount));i++){ %>
  <!--a href="javascript:pc.navigate('<%=url+"&startidx="+(i*recordCount)%>','audit_cox')">
 	[<%=(i*recordCount)+1%>],&nbsp;
 </a-->
<%}%>
&nbsp;
<a href="javascript:pc.navigate('<%=url+"&startidx="+(startIndex)%>','audit_cox')">
 	[<%= LanguageUtil.get(pageContext, "refresh")%>]
 </a>&nbsp;
  <a href="javascript:pc.navigate('<%=url+"&startidx="+(0)%>','audit_cox')" >
 [<%= LanguageUtil.get(pageContext, "first-page")%>]
 </a>&nbsp;
  <a href="javascript:pc.navigate('<%=url+"&startidx="+(startIndex-recordCount)%>','audit_cox')" >
 [<%= LanguageUtil.get(pageContext, "previous-page")%>]
 </a>&nbsp;
 <%if(pageRecordCount<recordCount){%>
  <a style="cursor:pointer">
 [<%= LanguageUtil.get(pageContext, "next-page")%>]
 <%}else{%>
   <a href="javascript:pc.navigate('<%=url+"&startidx="+(startIndex+recordCount)%>','audit_cox')" >
 [<%= LanguageUtil.get(pageContext, "next-page")%>]
 <%}%>
 </a>&nbsp;
 <a href="javascript:pc.navigate('<%=url+"&startidx="+(totalCount-recordCount)%>','audit_cox')" >
 	[<%= LanguageUtil.get(pageContext, "last-page")%>]
 </a>&nbsp; <%=(startIndex+1)%>-<%=(startIndex+pageRecordCount)%>/<%=totalCount%>
 
</div>
</form>
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
<script type="text/javascript">
 //var selTb= new SelectableTableRows(document.getElementById("inc_table"), false);
</script>

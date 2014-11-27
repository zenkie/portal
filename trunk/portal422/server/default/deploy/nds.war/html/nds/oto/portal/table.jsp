<%@page errorPage="/html/nds/error.jsp"%>
<%@ taglib uri='/WEB-INF/tld/filecache.tld' prefix='filecache' %>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" pageEncoding="utf-8"%>
<%!
/**
 Allow switch view in list scroll page
*/
private static boolean listEditable=Tools.getYesNo(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("list.editable","Y"),true);
private static boolean listUiconf=Tools.getYesNo(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("list.uiconf","N"),true);
private static boolean listHelp="true".equals( ((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("list.help","false"));
%>

<%
 /**
	 List table, how query page and list box, param
	 1. table -- table id or name
	  		fixedcolumns - columns that willl be fixed during query
 */
String tn= request.getParameter("table");
//System.out.println(tn);
Table table;
int tableId=nds.util.Tools.getInt(tn,-1);
 //int tableId=10010;
if(tableId==-1){
	table=TableManager.getInstance().getTable(tn);
	tableId= table.getId();
}else{
	table= TableManager.getInstance().getTable(tableId);
}
//TableManager manager=TableManager.getInstance();
PairTable fixedColumns=new PairTable();
/**------check permission---**/
int perm= WebUtils.getDirectoryPermission(table.getSecurityDirectory(), request);
String search_show=userWeb.getUserOption("SEARCH_SHOW","N");
boolean isWriteEnabled= ( ((perm & 3 )==3));
boolean isSubmitEnabled= ( ((perm & 5 )==5));
boolean canVoid= table.isActionEnabled(Table.VOID) && isWriteEnabled ;
boolean canExport= ( ((perm & 17 )==17));
boolean canDelete= table.isActionEnabled(Table.DELETE) && isWriteEnabled ;
boolean canAdd= table.isActionEnabled(Table.ADD) && isWriteEnabled ;
boolean canModify=listEditable&& table.isActionEnabled(Table.MODIFY) && isWriteEnabled ;
boolean canSubmit= table.isActionEnabled(Table.SUBMIT) && isSubmitEnabled ;

boolean hasCommand=  canDelete || canSubmit || canVoid; 
WebUtils.checkDirectoryReadPermission(table.getSecurityDirectory(), request);// -- This is commented by Tony
boolean isStatusValid= table.isActionEnabled(Table.SUBMIT);
boolean isModify=canModify;
/**------check permission end---**/
//load list query configuration, 2010-2-25
//System.out.print("aaaaaaaa");
nds.web.config.QueryListConfig qlc=userWeb.getDefaultQueryListConf(tableId,true);
//PairTable fixedCol=null;
//request.getParameter("fixedcolumns")
fixedColumns= PairTable.parseIntTable(request.getParameter("fixedcolumns"),null);
//ArrayList<ColumnLink> cls=new ArrayList<ColumnLink>();
/*
if(fixedCol!=null){
for( Iterator it=fixedCol.keys();it.hasNext();){
	        	Integer key=(Integer) it.next();
	            Column col=TableManager.getInstance().getColumn( key.intValue());
	            ColumnLink cl=new ColumnLink( col.getTable().getName()+"."+ col.getName());
				//fixedExpr= new Expression(cl,"="+ fixedColumns.get(key),null);
				cls.add(cl);
				}
//System.out.print("sddsfdsf");
qlc.setConditions(cls);
}
*/
/** -- add support for webaction of listbutton --**/
  Connection actionEnvConnection=null;
  List<WebAction> waListButtons=new ArrayList<WebAction>(), waListMenuItems=new ArrayList<WebAction>();
  try{
  	actionEnvConnection=QueryEngine.getInstance().getConnection();
	HashMap actionEnv=new HashMap();
	actionEnv.put("httpservletrequest", request);
	actionEnv.put("userweb", userWeb);
	actionEnv.put("connection", actionEnvConnection);
		
  	List<WebAction> was=table.getWebActions(WebAction.DisplayTypeEnum.ListButton);
  	for(int wasi=0;wasi<was.size();wasi++){
  		WebAction wa=was.get(wasi);
  		if(wa.canDisplay(actionEnv)){
  			waListButtons.add(wa);
  		}
  	}
  	was=table.getWebActions(WebAction.DisplayTypeEnum.ListMenuItem);
  	for(int wasi=0;wasi<was.size();wasi++){
  		WebAction wa=was.get(wasi);
  		if(wa.canDisplay(actionEnv)){
  			waListMenuItems.add(wa);
  		}
  	}
  }finally{
  	if(actionEnvConnection!=null)try{actionEnvConnection.close();}catch(Throwable ace){}
  }
  int[] selectRanges;
%>
<!--div id="breadcrumb" style="width:99%">
<%
StringBuffer sb=new StringBuffer();
TableManager tmgr=TableManager.getInstance();
for(Iterator it=userWeb.getVisitTables();it.hasNext();){
	Table tr=tmgr.getTable( Tools.getInt( it.next(),-1));
	if(tr!=null) sb.append("&nbsp;&#9642; <a href=\"javascript:pc.navigate('").append(tr.getId())
		.append("')\">").append(tr.getDescription(locale)).append("</a>");
		
}
%>
&nbsp;&nbsp;<%=PortletUtils.getMessage(pageContext, "my-recent-visit",null)%>:&nbsp;<%=sb.toString()%>
</div-->
	<%
	JSONObject jopro=table.getJSONProps()==null?new JSONObject():table.getJSONProps();
	//String contexturl="/html/nds/oto/viewtmp/viewtmp.jsp";
	String leftstyle="style='width:100%'";
	if(jopro.has("splitab")){
	JSONObject jop=jopro.optJSONObject("splitab");
	 String rightwidth=jop.optString("rightwidth");
	 String leftwidth=jop.optString("leftwidth");
	 String contexturl=jop.optString("contexturl");
	 leftstyle="style='width:"+leftwidth+"'";
	 contexturl+="&rightpct="+rightwidth;
	 System.out.print(contexturl);
	 if(contexturl!=null){
	 %>
		<jsp:include page="<%=contexturl%>" flush="true" />
	<%}}%>



	<div id="page-table-query" <%=leftstyle%> >
	<!--<div id="page-table-query-tab" style="border: 1px solid #CCC;width:85%;overflow: hidden;">-->
	<div id="page-table-query-tab" style="width:99%;overflow: hidden;">

		<h4 id="table_title" class="table_title"><%=table.getDescription(locale)%></h4>
		<div id="tab1"  class="ui-tabs-panel">
			<div id="query-content">
			<%@ include file="table_query.jsp" %>
			</div>
		</div>
  </div>
</div>

<div id="page-nav-commands" style="float:left;">
</div>

 <div class="table-buttons2">       	
<!--
&nbsp;<a href="javascript:pc.queryList()"><img src="/html/nds/images/findpage.png"/><%=PortletUtils.getMessage(pageContext, "object.search",null)%></a>
-->
	
<%
if(userWeb.isAdmin()){
%>

<!--input type="button" class="cbutton"  title="<%=qlc.getName()%>" value="<%=PortletUtils.getMessage(pageContext, "query-list-config",null)%>" onclick="javascript:pc.switchConfig()"/-->
<!--
<a href="javascript:pc.switchConfig()"><img src="/html/nds/images/cog.png"/><%=PortletUtils.getMessage(pageContext, "query-list-config",null)%></a>
-->
<%
}else{
	if(nds.web.config.QueryListConfigManager.getInstance().getQueryListConfigs(tableId,false).size()>0){
%>
<!--input type="button" class="cbutton" title="<%=qlc.getName()%>" value="<%=PortletUtils.getMessage(pageContext, "switch-config",null)%>" onclick="javascript:pc.switchConfig()"/-->
<!--
<a href="javascript:pc.switchConfig()"><img src="/html/nds/images/cog.png"/><%=PortletUtils.getMessage(pageContext, "switch-config",null)%></a>
-->
<%		
	}
}
int listViewPermissionType= (canModify && (WebUtils.getTableUIConfig(table).getDefaultAction()==nds.web.config.ObjectUIConfig.ACTION_EDIT)?3:1);
if(!listUiconf)listViewPermissionType=1;
//System.out.print(listViewPermissionType);
//System.out.println(WebUtils.getTableUIConfig(table).getDefaultAction());
//System.out.println(nds.web.config.ObjectUIConfig.ACTION_EDIT);
if(listHelp){%>
	<!--
	<a href="javascript:popup_window('/html/nds/help/index.jsp?table=<%=tableId%>')"><img src="/html/nds/images/help.png"/><%=PortletUtils.getMessage(pageContext, "help",null)%></a>
	-->
<%}%>	
<!--
	<a href="javascript:mu.add_mufavorite('<%=table.getDescription(locale)%>','<%=tableId%>')"><img src="/html/nds/images/mufa.png"/><%=PortletUtils.getMessage(pageContext, "mufavorite",null)%></a>
-->
<%
// these are list buttons of webaction
for(int wasi=0;wasi<waListButtons.size();wasi++){
	out.println(waListButtons.get(wasi).toHREF(locale,null));
}
%>	 
	</div>
	  <div id="result-scroll" >
 <%@ include file="/html/nds/oto/portal/inc_result_scroll.jsp" %>
</div>
	<div id="page-table-content" <%=leftstyle%>>
	<%@ include file="table_list.js.jsp" %>
	<%@ include file="table_list.jsp" %>
  </div>
<script type="text/javascript">
 
jQuery("#hide_bar").mousedown(function(event){
      pc.menu_toggle(this);
      event.stopPropagation();
  });

var new_high=document.documentElement.clientWidth;

jQuery("#embed-lines").css("height","100%");
var param_count=jQuery("#list_query_form :input[name=param_count]").val();
if(param_count==0){
    	jQuery("#tab1").hide();
   }
<%
// these are list menuitems of webaction
StringBuffer waListMenuItemStr=new StringBuffer();
for(int wasi=0;wasi<waListMenuItems.size();wasi++){
	waListMenuItemStr.append(waListMenuItems.get(wasi).toHTML(locale,null));
}
if(waListMenuItems.size()>0){
	//System.out.println(StringUtils.replace(waListMenuItemStr.toString(), "\"", "\\\""));
%>

pc.addListMenuItems("<%=StringUtils.replace(waListMenuItemStr.toString(), "\"", "\\\"")%>");
<%}
//log visit in the end so this table will not show as last visited one on the breadcrumb
userWeb.registerVisit(tableId);
%>
</script>  

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.fckeditor.net" prefix="FCK" %>
<%! 
    /** 
     * Things needed in this page:
     *  1.  table     main table that queried on(can be id or name)
     *  2.  id        id of object to be displayed, -1 means not found
     *  3.  auditid   用于审核人审核单据所定义工作流的id;
     *  4.  fixedcolumns 在列表（关联对象）界面中创建单对象的时候，会有此参数
     *  5.  input	  if false, must be view page, else will determined by user permission
     */
    String urlOfThisPage;
%>
<%
String tableName=request.getParameter("table");
int objectId=Tools.getInt(request.getParameter("id"),-1);
int auditid=Tools.getInt(request.getParameter("auditid"),-1);
PairTable fixedColumns= PairTable.parseIntTable(request.getParameter("fixedcolumns"),null );
boolean isInput=false;
String namespace="";
int status=0;
org.json.JSONArray dcqjsonarraylist=new org.json.JSONArray();
org.json.JSONObject dcqjsonObject=null;
TableManager manager=TableManager.getInstance();
QueryEngine engine=QueryEngine.getInstance();
Table table=null;
int tableId= Tools.getInt(tableName,-1);
if(tableId==-1){
	table=manager.getTable(tableName);
	if(table!=null){
		tableId= table.getId();
	}
}else{
	table=manager.getTable(tableId);
	
}
ObjectUIConfig uiConfig=WebUtils.getTableUIConfig(table);

if(table!=null){
	tableName= table.getName();
	request.setAttribute("mastertable", String.valueOf(tableId));
	request.setAttribute("masterid", String.valueOf(objectId));
	// Forbid none menuobject from opening
	//if(!table.isMenuObject()) throw new NDSException("@forbid-none-menuobject@");
}
request.setAttribute("table_help", new Integer(tableId));

int selectedTabId=-1;

%>
<html>
<head>
<%@ include file="top_meta.jsp" %>
</head>
<body id="obj-body">
<%@ include file="body_meta.jsp"%>

<!--<div id="obj-content">-->
<%

if(table!=null){
	String object_page_url=NDS_PATH+"/object/object.jsp?table="+
		 tableId+ "&id="+ objectId+ "&select_tab="+ selectedTabId+(isInput?"":"&input=false");
	if(fixedColumns!=null)
		 object_page_url +="&fixedcolumns="+ fixedColumns.toURLQueryString("");
	request.setAttribute("object_page_url", object_page_url);	 
	
	int columnsPerRow =uiConfig.getColsPerRow();
	int widthPerColumn= (int)(100/(columnsPerRow*2));
	boolean seperateObjectByBlank=true;
	int actionType;
	QueryResult result=null;
	QueryRequestImpl query;
	ArrayList columns;
	boolean bReplaceVariable;
	Properties objprefs;
	String lastComment;
	Object[] lastCommentInfo;
	TableQueryModel model;
	FKObjectQueryModel fkQueryModel;
	String data=null;// result item data for display
	String dataWithoutNBSP=null;
	Object dataDB= null; // raw db data 
	String dataValue = null;//Hawke: data's value in select option
	int coid=-1;  // object id if result item will have a URL
	int tabIndex=0; 
	String fixedColumnMark; boolean isFixedColumn;
	DisplaySetting ds;
	int colIdx=-1; // colIdx max to columnsPerRow(equal), each row has (columnsPerRow x 2) <td>;
	Table refTable;
	Column column;
	String inputName;
	String column_acc_Id;
	String type;
	int inputSize;
	nds.util.PairTable values;
	String modifyPageUrl;
	List otherviews;
	String viewIdString;
	int columnIndex;
	Table itemTable;
	Column itemMasterPKColumn;
	PairTable itemFixedColumns;
	ArrayList rfts;
	RefByTable rft;
	int totalTabs;
	boolean itemTableFoundInRFTs;
	ArrayList validCommands=new ArrayList();//element: String
	ButtonFactory commandFactory= ButtonFactory.getInstance(pageContext,locale);
	Button btn;
	/**------check permission---**/
	// for status
	String directory;
	directory=table.getSecurityDirectory();
	int perm= userWeb.getPermission(directory);
	try{
	if( manager.getColumn(table.getName(), "status")!=null )
		status= QueryEngine.getInstance().getSheetStatus(table.getRealTableName(),objectId);
	}catch(Exception e){
		
	}
	boolean hasWritePermission=false;
	boolean isWriteEnabled= ( ((perm & 3 )==3)) ;
	boolean isSubmitEnabled= ( ((perm & 5 )==5)) ;
	
	boolean canDelete= table.isActionEnabled(Table.DELETE) && isWriteEnabled && status !=2;
	boolean canAdd= table.isActionEnabled(Table.ADD) && isWriteEnabled ;
	boolean canModify= table.isActionEnabled(Table.MODIFY) && isWriteEnabled && status !=2;
	boolean canSubmit= table.isActionEnabled(Table.SUBMIT) && isSubmitEnabled && status !=2;
	boolean canEdit= canModify || canAdd;
	/**------check permission end---**/
	
	String includePage=null;
	String msgError=null;
	if(objectId !=-1){
			hasWritePermission=(canDelete || canModify ||canSubmit) && 
				userWeb.hasObjectPermission(table.getName(),objectId,nds.security.Directory.WRITE);
		 	if(isInput==true && hasWritePermission){
		 		includePage="object_modify.jsp";
		 	}else if(userWeb.hasObjectPermission(table.getName(),objectId,nds.security.Directory.READ)){
		 		includePage="object_view.jsp";
		 	}else{
		 		msgError=PortletUtils.getMessage(pageContext, "no-permission-or-not-exists",null);
		 	}
	}else{
		  	// object id==-1
		  	if( (perm&nds.security.Directory.WRITE)==0){
		  		msgError=PortletUtils.getMessage(pageContext, "object-not-exists",null);
		  	}else{
		  		includePage="object_modify.jsp";
		  	}
	}//end if(objectId !=-1)
	
	if(msgError!=null){
	%>
		<div class="msg-error"><%=msgError%></div>
	<%}else{
	%>
<script>
var masterObject={
	hiddenInputs:{
		id:<%=objectId %>,table:<%=tableId %>,namespace:"<%= namespace%>", tablename:"<%= table.getName()%>",
			directory:"<%= directory%>",fixedcolumns:"<%= fixedColumns.toURLQueryString("")%>",
			copyfromid:null
	},
	table:<%=table.toJSONObject(locale)%>,
	<%
	 ArrayList inputColumns=table.getColumns(new int[]{1,3}, false);// Columns input for Add/Modify 
	 JSONArray inputColumnsJson=new JSONArray();
	 for(int i=0;i<inputColumns.size();i++){
	 	inputColumnsJson.put( ((Column)inputColumns.get(i)).toJSONObject(locale));
	 } 
	%>
	columns:<%=inputColumnsJson.toString()%>
};
</script>	
	<%
		boolean bDoModify="object_modify.jsp".equals(includePage);
		if(bDoModify){
	%>
<%@ include file="object_modify.jsp"%>
		<%}else{%>
<%
//String object_page_url=(String) request.getAttribute("object_page_url");
actionType= Column.QUERY_OBJECT;
 
query=QueryEngine.getInstance().createRequest(userWeb.getSession());
query.setMainTable(tableId);
query.addAllShowableColumnsToSelection(actionType);
query.addParam( table.getPrimaryKey().getId(), ""+ objectId );
result=QueryEngine.getInstance().doQuery(query);
try{
if( manager.getColumn(table.getName(), "status")!=null )
	status= QueryEngine.getInstance().getSheetStatus(table.getRealTableName(),objectId);
}catch(Exception e){
}
if(result.getTotalRowCount()==0){
%>
	<div class="msg-error"><%=PortletUtils.getMessage(pageContext, "object-not-exists",null)%></div>
<%}else{
columns=table.getShowableColumns(actionType);
%>
<div id="obj-top">
<div class="buttons">
	<%= LanguageUtil.get(pageContext, "audit-comments",null)%>:<input id="comments" class="form-text" type="text" value="" name="comments" maxlength="255" size="20"/>&nbsp;
	<%if(!userWeb.isGuest()&&userWeb.hasObjectPermission(table.getName(),objectId,nds.security.Directory.AUDIT)){%>
	<span id="buttons"><!--BUTTONS_BEGIN-->
	<%
	 validCommands.add(commandFactory.newButtonInstance("Accept", PortletUtils.getMessage(pageContext, "object.accept",null),"oc.audit('accept',"+auditid+")","A"));
	 validCommands.add(commandFactory.newButtonInstance("Reject", PortletUtils.getMessage(pageContext, "object.reject",null),"oc.audit('reject',"+auditid+")","R"));
   otherviews= Collections.EMPTY_LIST;
  //item table should not show other views
  if(manager.getParentTable(table)==null) otherviews=userWeb.constructViews(table,objectId);
%>
<%@ include file="inc_command.jsp" %>
			<!--BUTTONS_END--></span>
	<%}%><span id="closebtn"></span>
	</div>
	<div id="message" class="nt"  style="visibility:hidden;">
	</div>
</div>
<div class="<%=uiConfig.getCssClass()%>" id="<%=uiConfig.getCssClass()%>">
<form name="<%=namespace%>fm" method="post" action="<%=contextPath %>/control/command" onSubmit="return false;">
<input type="hidden" name="id" value="<%=objectId %>">
<input type="hidden" name="table" value="<%=tableId %>">
	<%if(uiConfig.isShowComments()){%>
	<!--<div class="comments">
		 include file="inc_object_comments.jsp" 
	</div>-->
	<%}%>
	
<%
	//if true, will show data without variable, else show variable directly. This is used for template setting page
	//@see inc_template.jsp/inc_batchupdate.jsp
	bReplaceVariable= false;
	objprefs= userWeb.getPreferenceValues("template."+table.getName().toLowerCase(),false,bReplaceVariable);

	model= new TableQueryModel(tableId, actionType,isInput,true,locale);
	if(result!=null)result.next();
	columnIndex=0;
	
%>	
	<div class="obj" id="obj_inputs_1"><!--OBJ_INPUTS1_BEGIN-->
		<%@ include file="inc_single_object.jsp" %><!--OBJ_INPUTS1_END-->
	</div>
	<% if( !Boolean.FALSE.equals(request.getAttribute("showtabs"))){%>
		<%@ include file="inc_tabs.jsp" %>
	<%}%>
	<%if(columnIndex!=columns.size()){%>
	<div class="obj" id="obj_inputs_2"><!--OBJ_INPUTS2_BEGIN-->
		<%@ include file="inc_single_object.jsp" %><!--OBJ_INPUTS2_END-->
	</div>
	<%}// end if(columnIndex!=columns.size())
	%>	
</form>	
</div>

<%}// end (result.getTotalRowCount()!=0)
%>

		<%
		}
	}
}//end (table!=null && objectId!=-1)
 else{
	%>
		<div class="msg-error">
			<%= LanguageUtil.get(pageContext, "parameter-error") %>
		</div>
<%}
%>
<!--</div>end obj-content-->
<%
if(status==2){
%>
<div id="statusimg">
	<img src="<%=NDS_PATH+"/images/submitted-small" + ("CN".equals(locale.getCountry())? "_zh_CN":"")+".gif"%>" width="74" height="58">
</div>
<%}%>
<div id="obj-bottom">
	<%@ include file="bottom.jsp" %>
</div>
</body>
</html>
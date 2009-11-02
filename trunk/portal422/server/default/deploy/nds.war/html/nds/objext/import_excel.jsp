<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.excel.*"%>
<%
    /**
     * Things needed in this page:
     *  table* - (int) table id
     *  objectid - (int) if table is sheetItem, then sheet's id will be set here
        mainobjecttableid - sheet table' tableId, may exists in param or attribute
        fixedcolumns - fixed colums of the import
     */
%><html>
<head>
<%@ include file="/html/common/themes/top_meta.jsp" %>
<%@ include file="/html/common/themes/top_meta-ext.jsp" %>
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico">
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script language="javascript" src="/html/nds/js/jquery-1.3.2.min.js"></script>
<script language="javascript" src="/html/nds/js/swfobject.js"></script>
<script language="javascript" src="/html/nds/js/jquery.uploadify.v2.0.3.min.js"></script>
<script language="javascript" src="/html/nds/js/import_excel.js"></script>
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/portal.css" media="screen" />
<link type="text/css" rel="StyleSheet" href="/html/nds/css/importexcel.css" media="screen" />
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/nds_portal.css" media="screen" />
<link type="text/css" rel="StyleSheet" href="<%=userWeb.getThemePath()%>/css/custom-ext.css" media="screen" />
<link rel="stylesheet" type="text/css" href="/html/nds/css/importexcel_prt.css" media="print" /> 
<title>Import</title>
</head>
<body id="maintab-body">
<%
	TableManager tableManager=TableManager.getInstance();
	int tableId= ParamUtils.getIntAttributeOrParameter(request, "table", -1);
	int objectId= ParamUtils.getIntAttributeOrParameter(request, "objectid", -1);
	PairTable fixedColumns=PairTable.parseIntTable(request.getParameter("fixedcolumns"), null);	
	Table table;
	if( tableId == -1) {
    	String tableName=  request.getParameter("table") ;
    	table= tableManager.getTable(tableName);
    	if( table !=null) tableId= table.getId();
    	else {
        	out.println(PortletUtils.getMessage(pageContext, "object-type-not-set",null));
        	return;
    	}
	}else{
    	table= tableManager.getTable(tableId);
	}
	String tabName= PortletUtils.getMessage(pageContext, "import",null)+" - "+ table.getDescription(locale);
%>
<fieldset id="setting">
  <legend><%=tabName%></legend>
  <div id="tab1">
<%
	// make sure the file has been created
	ExcelTemplateManager etm=new ExcelTemplateManager();
	Configurations conf=(Configurations)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.CONFIGURATIONS);
	String downloadPath=conf.getProperty("web.root", "/aic/beaSp2/wls61/config/mizuno/applications/nds")+"/download";
	etm.init(downloadPath);
	etm.getTemplate(tableId);
/**------check permission---**/
String directory= table.getSecurityDirectory();
WebUtils.checkDirectoryWritePermission(directory, request);
/**------check permission end---**/

%>

<form id="form1" name="form1" method="post" enctype="multipart/form-data">
<input type="hidden" name="table" value="<%=tableId %>">
<input type="hidden" name="objectid" value="<%=objectId %>">
<input type="hidden" name="next-screen" value="<%=NDS_PATH%>/info.jsp">
<input type="hidden" name="best_effort" value="true">
<input type="hidden" name="nds.control.ejb.UserTransaction" value="N">
<input type='hidden' name="mainobjecttableid" value="<%= ParamUtils.getIntAttributeOrParameter(request, "mainobjecttableid",-1)%>">
<input type='hidden' name="fixedcolumns" value="<%= fixedColumns.toURLQueryString("")%>">  

<table cellspacing="0" cellpadding="0" border="0" class="documentation">
<tbody>
<tr>
<td valign="top" width="70"><strong><%=PortletUtils.getMessage(pageContext, "import-select-format",null)%></strong></td>
<td valign="top">
<input type="radio" name="file_format" value="xls" id="file_format_xls" onclick="impxls.updateFormat()"> XLS <br>
<div class="fmt-comment" id="fmt-xls"><%=PortletUtils.getMessage(pageContext, "import-excel-1",null)%> (<%=PortletUtils.getMessage(pageContext, "click-to-download",null)%> <a href="<%=NDS_PATH +"/download/"+table.getName()+".xls"%>"><img src="<%=NDS_PATH%>/images/down.gif" width="9" height="17" border="0"> <%=PortletUtils.getMessage(pageContext, "template",null)%></a>). <%=PortletUtils.getMessage(pageContext, "import-excel-2",null)%> <br>
         <font color='red'><%=PortletUtils.getMessage(pageContext, "attention",null)%> :</font><%=PortletUtils.getMessage(pageContext, "import-excel-3",null)%> </div>
<input type="radio" name="file_format" value="txt" id="file_format_txt" onclick="impxls.updateFormat()"> <%=PortletUtils.getMessage(pageContext, "import-txt",null)%> <br>
<div class="fmt-comment" id="fmt-txt"><%=PortletUtils.getMessage(pageContext, "import-txt-comments",null)%></div>
<input type="radio" name="file_format" value="pandian" id="file_format_pd" onclick="impxls.updateFormat()"> <%=PortletUtils.getMessage(pageContext, "import-pandian",null)%> <br>
<div class="fmt-comment" id="fmt-pd"><%=PortletUtils.getMessage(pageContext, "import-pandian-comments",null)%></div>
</td>
</tr>
<tr>
<td valign="top" height="29"><strong><%=PortletUtils.getMessage(pageContext, "import-param",null)%></strong></td>
<td valign="top" height="29" >
<div id="txt-param">
<%=PortletUtils.getMessage(pageContext, "import-txt-1",null)%>:
<div class="txt-columns">
<%
ArrayList asc=table.getShowableColumns(Column.ADD);
// filter not modifiable columns
ArrayList columns=new ArrayList();
for( int i=0;i< asc.size();i++){
    Column col= (Column) asc.get(i);
    if( col.isModifiable(Column.ADD)) columns.add(col);
}
boolean hasQtyColumn=false;
%>
<table class="cols">
<tr id="coldesc" >
<%
for(int i=0;i<columns.size();i++){
	Column col=(Column)columns.get(i);
%>
<td nowrap>	
	<span class="col" title='<%=nds.query.web.TableQueryModel.getInputBoxIndicator(col,null,locale)%>'>
		<%=col.getDescription(locale)+(col.isNullable()?"":"<font color='red'>*</font>")%>	</span>
</td>		
<%	
	if(col.getName().contains("QTY") && col.getType()== Column.NUMBER){
		hasQtyColumn=true;	 
	}
}
%>
</tr>
</table>
</div>
<input type="radio" name="txt_type" value="token" id="txt_type_token" onclick="impxls.updateTxtType()"> 
<%=PortletUtils.getMessage(pageContext, "import-txt-sep",null)%>:<br>
<div class="indent" id="txt-token">
	<input type="checkbox" id="token_tab" value="\t"><%=PortletUtils.getMessage(pageContext, "import-txt-tab",null)%>
	<input type="checkbox" id="token_comma" value=","><%=PortletUtils.getMessage(pageContext, "import-txt-comma",null)%>
	<input type="checkbox" id="token_semi" value=";"><%=PortletUtils.getMessage(pageContext, "import-txt-semi",null)%>
	<input type="checkbox" id="token_space" value=" "><%=PortletUtils.getMessage(pageContext, "import-txt-space",null)%>
	<input type="checkbox" id="token_others" value=""><%=PortletUtils.getMessage(pageContext, "import-txt-other",null)%>:<input type="text" id="token_other" value="" size="5"></div>
<input type="radio" name="txt_type" value="fix" id="txt_type_fix" onclick="impxls.updateTxtType()">
<%=PortletUtils.getMessage(pageContext, "import-txt-fix",null)%><br>
<div class="indent" id="txt-fix"><%=PortletUtils.getMessage(pageContext, "import-txt-fix-input",null)%><br>
<table class="cols">
<tr id="coldesc" >
<%
for(int i=0;i<columns.size();i++){
	Column col=(Column)columns.get(i);
%>
<td nowrap>	
	<%=col.getDescription(locale)+(col.isNullable()?"":"<font color='red'>*</font>")%>
</td>		
<%	
	if(col.getName().contains("QTY") && col.getType()== Column.NUMBER){
		hasQtyColumn=true;	 
	}
}
%>
</tr>
<tr>
<%
for(int i=0;i<columns.size();i++){
	Column col=(Column)columns.get(i);
%>
<td>	
	<input type="text" name="collen" value="" size="5">
</td>		
<%	
}
%>
</tr>
</table>
</div>
</div>
<%=PortletUtils.getMessage(pageContext, "start-line",null)%> :<input id="startRow" class="inputline" type="text" name="startRow" value='2' size="4" >
<%if(hasQtyColumn){%>
<%=PortletUtils.getMessage(pageContext, "multiply-qty-column",null)%> :<input id="multiply_num" class="inputline" type="text" name="multiply_num" value='1' size="4" >
<%}
%>
<input type='checkbox' id="bgrun" name="bgrun" value="true"><%=PortletUtils.getMessage(pageContext, "run-at-background",null)%>
<%
List udxColumns=tableManager.getUniqueIndexColumns(table);
if(udxColumns.size()>0){
%>
<input type='checkbox' id="update_on_unique_constraints" name="update_on_unique_constraints" value="true">
<%=PortletUtils.getMessage(pageContext, "update-on-unique-constraints",null)%>:(
<%
	StringBuffer ucDesc=new StringBuffer();
	for(int j=0;j<udxColumns.size();j++){
		if(((Column)udxColumns.get(j)).getName().equals("AD_CLIENT_ID")) continue;
		ucDesc.append(((Column)udxColumns.get(j)).getDescription(locale)).append(",");
	}
	ucDesc.deleteCharAt(ucDesc.length()-1);
%>
	<%=ucDesc%>)
<%	
}//end udxColumns.size()
%>
</td>
</tr>
<tr>
<td valign="top"><strong><%=PortletUtils.getMessage(pageContext, "import-select-file",null)%></strong><br>
	(Max: <%=Tools.getInt( conf.getProperty("import.excel.maxsize", "1"),1)%>MB)
	</td>
<td valign="top"><div id="flashcontent"><input id="fileInput1" name="excel" size="35" type="file"/></div></td>
</tr>
</tbody>
</table>	
</form>


    </div>
</fieldset>
<div id="btn">
<input class="command2_button" type='button' id="btnImport" name='ImportExcel' value='<%=PortletUtils.getMessage(pageContext, "import-file",null)%>' onclick="javascript:impxls.beginImport();" >
<input class="command2_button" type='button' id="btnPrint" name='print' value='<%=PortletUtils.getMessage(pageContext, "print",null)%>' onclick="javascript:window.print();" >
<span id="tag_close_window"></span>
<Script language="javascript">
 // check show close window button or not
 if(  self==top){
 	document.getElementById("tag_close_window").innerHTML=
 	 "<input class='command_button' type='button' name='Cancle' value='<%= PortletUtils.getMessage(pageContext, "close-window" ,null)%>' onclick='javascript:window.close();' >";
 }
 

	var upinit={"sizeLimit": <%=(1024*1024 * Tools.getInt( conf.getProperty("import.excel.maxsize", "1"),1))%>,
		'buttonText'	: '...',
		'fileDesc'      : '<%= PortletUtils.getMessage(pageContext, "import-file-desc" ,null)%>'
		};
	var para={"table":<%=table.getId()%>, "objectid":<%=objectId%>,
		"formRequest":"/html/nds/msg.jsp",
		"next-screen":"/html/nds/text.jsp",
		"best_effort":"true","nds.control.ejb.UserTransaction":"N",
		"mainobjecttableid":"<%= ParamUtils.getIntAttributeOrParameter(request, "mainobjecttableid",-1)%>",
		"fixedcolumns":"<%= fixedColumns.toURLQueryString("")%>",
		"JSESSIONID":"<%=session.getId()%>"
		};
	jQuery(document).ready(function(){
		impxls.initForm(upinit,para);
	});
	
</script>
</div>
<fieldset id="output">
  <legend><%=PortletUtils.getMessage(pageContext, "import-result",null)%></legend>
<div id="whole">
</div>
</fieldset>
</body>
</html>


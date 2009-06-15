<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%@ page import="nds.excel.*"%>
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
<script>
	document.title="<%=tabName%>";
</script>
<div id="maintab">
	<ul><li><a href="#tab1"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">
<%
    /**
     * Things needed in this page:
     *  table* - (int) table id
     *  objectid - (int) if table is sheetItem, then sheet's id will be set here
        mainobjecttableid - sheet table' tableId, may exists in param or attribute
        fixedcolumns - fixed colums of the import
     */
%>
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

<br>

<table border="0" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#999999" width="90%">
  <tr>
    <td rowspan=2>&nbsp;</td>
          <td>
          </td>
          <td rowspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td colspan=3>
		<table border="0" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#999999" width="100%">
          <tr>
            <td> <table border="0" cellspacing="0" cellpadding="0" align="center" width="90%"><tr><td>
              <br>
         <p><%=PortletUtils.getMessage(pageContext, "import-excel-1",null)%> (<%=PortletUtils.getMessage(pageContext, "click-to-download",null)%> <a href="<%=NDS_PATH +"/download/"+table.getName()+".xls"%>"><img src="<%=NDS_PATH%>/images/down.gif" width="9" height="17" border="0"> <%=PortletUtils.getMessage(pageContext, "template",null)%></a>). <%=PortletUtils.getMessage(pageContext, "import-excel-2",null)%> <br>
         <font color='red'><%=PortletUtils.getMessage(pageContext, "attention",null)%> :</font><%=PortletUtils.getMessage(pageContext, "import-excel-3",null)%> 
         
<form name="sheet_import_form" method="post" enctype="multipart/form-data" 
action="<%=request.getContextPath() %>/control/importexcel">
<!-- action="<%=request.getContextPath() %>/objext/test.jsp"> -->
<input type="hidden" name="table" value="<%=tableId %>">
<input type="hidden" name="objectid" value="<%=objectId %>">
<input type="hidden" name="next-screen" value="<%=NDS_PATH%>/info.jsp">
<input type="hidden" name="best_effort" value="true">
<input type="hidden" name="nds.control.ejb.UserTransaction" value="N">
<input type='hidden' name="mainobjecttableid" value="<%= ParamUtils.getIntAttributeOrParameter(request, "mainobjecttableid",-1)%>">
<input type='hidden' name="fixedcolumns" value="<%= fixedColumns.toURLQueryString("")%>">  
Excel <%=PortletUtils.getMessage(pageContext, "filename",null)%> :<input type="file" name="excel" size="35" ><p>
<%=PortletUtils.getMessage(pageContext, "start-line",null)%> :<input class="inputline" type="text" name="startRow" value='2' size="10" > 
<input type='checkbox' name="bgrun" value="true"><%=PortletUtils.getMessage(pageContext, "run-at-background",null)%>
<%
List udxColumns=tableManager.getUniqueIndexColumns(table);
if(udxColumns.size()>0){
%>
<input type='checkbox' name="update_on_unique_constraints" value="true">
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
<p>      
<input class="command2_button" type='button' name='ImportExcel' value='<%=PortletUtils.getMessage(pageContext, "import",null)%>' onclick="javascript:sheet_import_form.submit();" >
<span id="tag_close_window"></span>
<Script language="javascript">
 // check show close window button or not
 if(  self==top){
 	document.getElementById("tag_close_window").innerHTML=
 	 "<input class='command_button' type='button' name='Cancle' value='<%= PortletUtils.getMessage(pageContext, "close-window" ,null)%>' onclick='javascript:window.close();' >";
 }
</script>

</form></td></tr></table>
 </td></tr></table>
 <br>
 </td></tr></table>

		
    </div>
</div>
<%@ include file="/html/nds/footer_info.jsp" %>

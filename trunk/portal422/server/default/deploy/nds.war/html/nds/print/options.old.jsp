<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%
/**
  We have two types of print template: one is from ad_report, the other is from ad_cxtab (reportytpe='S' FOR single object, 'L' for List)
*/

	String tabName=PortletUtils.getMessage(pageContext, "print-options",null);
%>
<script language="javascript" src="/html/nds/js/print_option.js"></script>
<script>
	document.title="<%=tabName%>";
</script>
<div id="maintab">
	<ul><li><a href="#tab1"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">
<%
 /**
 * Select print template, and export type(pdf,excel,html,html-by-page), action- background, forground (if allowed)
 * Param 
 *    query -  in request attribute "QueryRequest" (for list object)
 *    table -  in request parameter (id) int       (for single object)
 *    id    -  in request parameter object id int  (for single object)
 *    if table not exists, query must exists, and vice vesa.
 */
%>
 
<%
    QueryRequestImpl qRequest =(QueryRequestImpl) request.getAttribute("query");
    int tableId= Tools.getInt(request.getParameter("table"), -1);
    int objectId= Tools.getInt(request.getParameter("id"), -1);
    
    String reportType=null; // "L" for list, "O" for Object
    if(qRequest == null && (tableId==-1 || objectId==-1)){
        out.println("Internal Error: can not find query object or table id in httpservletrequest!");
  	    return;
    }
    
    Table table=null;
    String actionPath=contextPath+"/servlets/QueryInputHandler";
    if (qRequest!=null){
    	table= qRequest.getMainTable();
    	reportType="L";
    	objectId=-1;// -1 means object view
    	tableId= table.getId();
    }else{
    	table=TableManager.getInstance().getTable(tableId);
    	reportType="O";
    }
    
        SimpleDateFormat sdf = new SimpleDateFormat("MMddHHmm");
        String destFile= "rpt"+sdf.format(new Date());
    
    
%>
<br>
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#cccccc" align="center">
<form name= "form1" method="post" action="<%=actionPath %>" >
	<input type='hidden' name='reportid' value=''>
	<input type='hidden' name='reporttype' value='<%=reportType%>'>
	<input type='hidden' name='destfile' value='<%=destFile%>'>
	<input type='hidden' name='filetype' value=''>
	<input type='hidden' name='isjreport' value='N'>
        <tr>
          <td>
	<table align="center" width="95%" border="0" cellpadding="0" cellspacing="0" bordercolordark="#FFFFFF" bordercolorlight="#999999">
<%	
	// order: id, name, description, previewurl,allow_fg 
	QueryResult rt=userWeb.getReportTemplates(table, reportType);
	//Loading templates from ad_cxtab 
	List al= QueryEngine.getInstance().doQueryList("select id, name, description from ad_cxtab where ad_table_id="+tableId +" and reporttype="+ (objectId==-1?"'L'":"'P'")+ " order by orderno, id");
	
	Object id,name; String previewurl, allow_fg,description;
			
              if(rt.getRowCount() == 0 && al.size()==0){

              %>
              <tr>
                      <td align="center" colspan="2">
                      <%= PortletUtils.getMessage(pageContext, "no-template",null)%>
                      <p>
                      <input type="button" onclick="checkTemplate(<%=tableId%>)" value="<%=PortletUtils.getMessage(pageContext, "create-template-by-master",null)%>">
                      <p>
                      </td>
              </tr>
              <%
              }

for(int i=0;i< al.size();i++){
		List advTemplate=(List) al.get(i);
		id= advTemplate.get(0);
		name=advTemplate.get(1);
		description=(String)advTemplate.get(2);
%>
            <tr>
              <td  align="left" width="400" ><img src="<%=NDS_PATH%>/images/jprint.gif" border=0 width=32 height=32>
               &nbsp;<b><a href="javascript:editJReport(<%=id%>)"><%=name%></a></b>&nbsp;&nbsp;
               <p>
              <%if(nds.util.Validator.isNotNull(description)){%>
              <i><%=description%></i>
              <%}%>
<br>

<table align='left' cellpadding="4" cellspacing="4"><tr>
<td><input type="button" onclick="exportJPDF(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-pdf",null)%>"></td>
<td><input type="button" onclick="exportJExcel(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-excel",null)%>"></td>
<td><input type="button" onclick="exportJCSV(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-csv",null)%>"></td>
<td><input type="button" onclick="displayJPDF(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "display-pdf",null)%>"></td>
<td><input type="button" onclick="displayJHTML(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "display-html",null)%>"></td>
</tr></table>

</td>
	<td  width="150" valign='top'>
	&nbsp;
	</td>
	</tr>
	<tr>
	<td colspan=2 align='left'>
		<hr width="70%" size=1>
</tr>
<%       
    }//end for

	while(rt.next()){
		id= rt.getObject(1);
		name=rt.getObject(2);
		description=(String)rt.getObject(3);
		previewurl=(String)rt.getObject(4);
		allow_fg=(String)rt.getObject(5);
		
%>
            <tr>
              <td  align="left" width="400" ><img src="<%=NDS_PATH%>/images/report_template.gif" border=0 width=32 height=32>
               &nbsp;<b><a href="javascript:editReport(<%=id%>)"><%=name%></a></b>&nbsp;&nbsp;
               [<a href="javascript:checkTemplate(<%=tableId%>)"><%=PortletUtils.getMessage(pageContext, "check-update",null)%></a>]
               <p>
              <%if(nds.util.Validator.isNotNull(description)){%>
              <i><%=description%></i>
              <%}%>
<br>

<table align='left' cellpadding="4" cellspacing="4">
<tr>
<td><input type="button" onclick="exportPDF(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-pdf",null)%>"></td>
<td><input type="button" onclick="exportExcel(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-excel",null)%>"></td>
<td><input type="button" onclick="exportCSV(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "export-csv",null)%>"></td>
<%if("Y".equals(allow_fg)){%>
<td><input type="button" onclick="displayPDF(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "display-pdf",null)%>"></td>
<td><input type="button" onclick="displayHTML(<%=id%>)" value="<%=PortletUtils.getMessage(pageContext, "display-html",null)%>"></td>
<%}%> 
</tr></table>

</td>
	<td  width="150" valign='top'>
	<% if(nds.util.Validator.isNotNull(previewurl)){%>
	<a href="<%=previewurl%>"><img src="<%=previewurl%>" border=0 width=150></a>
	<%}%>
	</td>
	</tr>
	<tr>
	<td colspan=2 align='left'>
		<hr width="70%" size=1>
	</tr>
<%       
    }//end while
%>
             </table>
              </td>
            </tr>
	<%if( qRequest!=null){
//			System.out.println(QueryUtils.toHTMLControlForm(qRequest));
	%>            
		<%=QueryUtils.toHTMLControlForm(qRequest)%>
	<%}else{%>
		<input type='hidden' name='table' value='<%=tableId%>'>
		<input type='hidden' name='id' value='<%=objectId%>'>
		<input type='hidden' name='resulthandler' value=''> 
	<%}%>
	
</form>
</table>
    </div>
</div>
<%@ include file="/html/nds/footer_info.jsp" %>

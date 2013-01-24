<%@page errorPage="/html/nds/error.jsp"%>
<%
	request.setAttribute("page_help", "_sheet_upload_jsp");
%>
<%@ include file="/html/nds/header.jsp" %>
<%
	request.setAttribute("tab_content", "/objext/inc_upload.jsp");
	String tabName=PortletUtils.getMessage(pageContext, "upload",null);
	
%>
<script>
	document.title="<%=tabName%>";
</script>
<div id="tabs">
	<ul><li><a href="#tab1"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">
<%
    /**
     * Things needed in this page:
     *  table* - (int) table id
     *  column* - (int) column id
     *  objectid* - (int) record id
     */
%>
<%
    
	TableManager tableManager=TableManager.getInstance();
	int tableId= ParamUtils.getIntAttributeOrParameter(request, "table", -1);
	int columnId =ParamUtils.getIntAttributeOrParameter(request, "column", -1);
	int objectId= ParamUtils.getIntAttributeOrParameter(request, "objectid", -1);
	Table table;
	if( tableId == -1) {
        	out.println(PortletUtils.getMessage(pageContext, "object-type-not-set",null));
        	return;
	}else{
    	table= tableManager.getTable(tableId);
	}
	Column col=tableManager.getColumn(columnId);
	AttachmentManager attm=(AttachmentManager)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.ATTACHMENT_MANAGER);
	Attachment att= new Attachment( userWeb.getClientDomain()+"/" + table.getRealTableName()+"/"+col.getName(),  ""+objectId );
	List atts= attm.getVersionHistory(att);
	
/**------check permission---**/
if(!userWeb.hasObjectPermission(table.getName(),objectId,  nds.security.Directory.READ)){
   	throw new NDSException(PortletUtils.getMessage(pageContext, "no-permission",null));
}
/**------check permission end---**/

%>

<br>
<table border="0" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#999999" width="100%">
          <tr>
            <td> <table border="0" cellspacing="5" cellpadding="0" align="center" width="90%"><tr>
              <br>
         <td><b><%=PortletUtils.getMessage(pageContext, "referred-by",null)%>:</b></td>
         <td> <a href="<%=NDS_PATH+"/object/object.jsp?table="+tableId+"&id="+objectId%>"><%=NDS_PATH+"/object/object.jsp?table="+tableId+"&id="+objectId%></a>
         [<%=table.getDescription(locale)+"-"+ col.getDescription(locale)%>]
         </td>
         </tr>
         <td><b><%=PortletUtils.getMessage(pageContext, "file-history",null)%>:</b></td><td>
         	<table border="1" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#999999" width="100%">
              <tr bgcolor="#EBF5FD">
                <td width="10%" align="center">
                  <span><%=PortletUtils.getMessage(pageContext, "file-version",null)%></span>
                </td>
                <td width="10%" align="center">
                  <span><%=PortletUtils.getMessage(pageContext, "name",null)%></span>
                </td>
                <td width="40%" align="center">
                  <span><%=PortletUtils.getMessage(pageContext, "file-date",null)%></span>
                </td>
                <td width="30%" align="center">
                  <span><%=PortletUtils.getMessage(pageContext, "file-author",null)%></span>
                </td>
                <td width="20%" align="center">
                  <span><%=PortletUtils.getMessage(pageContext, "file-size",null)%></span>
                </td>
              </tr>
              <%
              	for(Iterator it= atts.iterator(); it.hasNext();){
              		att= (Attachment) it.next();
              %>
              	<tr> 
              		<td><a href="<%=request.getContextPath()+"/servlets/binserv/Attach?table="+tableId+"&column="+columnId+"&objectid="+ objectId +"&version="+att.getVersion() %>"><%=att.getVersion()%></a></td>
              		<td><%=att.getOrigFileName()%></td>
              		<td><%=((java.text.SimpleDateFormat)QueryUtils.dateTimeSecondsFormatter.get()).format(att.getLastModified())%></td>
              		<td><%=att.getAuthor()%></td>
              		<td><%=Tools.formatSize(att.getSize())%></td>
              	</tr>
              <%	}
              %>
         	</table>
         </td></tr>
<% if(atts.size()>0){%>
<tr><td><b><%=PortletUtils.getMessage(pageContext, "file-ext",null)%>:</b></td>
<td align='left'><%=( (Attachment)atts.get(0)).getExtension()%></td></tr>
<%}%>
<tr><td></td><td>
<form name="sheet_upload_form2" method="post"
action="<%=request.getContextPath() %>/control/command">
<input type='hidden' name="directory" value='<%=table.getSecurityDirectory()%>'>
<input type='hidden' name="command" value='DeleteAttachments'>
<input type="hidden" name="next-screen" value="<%=NDS_PATH+"/objext/upload.jsp?table="+tableId+"&column="+columnId+"&objectid="+ objectId %>">
<input type="hidden" name="table" value="<%=tableId %>">
<input type="hidden" name="column" value="<%=columnId %>">
<input type="hidden" name="objectid" value="<%=objectId %>">
<input type="button" name="deleteall" value="<%=PortletUtils.getMessage(pageContext, "delete-all-versions",null)%>" onclick="javascript:sheet_upload_form2.submit()">
</form>
</td></tr>

<tr><td colspan=2>
<br><%=PortletUtils.getMessage(pageContext, "upload-guide",null)%>
<Script language="javascript">
     function checkUpload(form){
		var bUploadFile=form.upload1.checked;
		form.resetbt.click();
		if(bUploadFile==0){
			form.fileurl.disabled=0;
			form.uploadfile.disabled=1;
			//form.copytoroot.disabled=1;
			//form.copytoroot.checked=0;
			form.uploadfile.blur();
			form.upload2.checked=1;
			form.fileurl.focus();
		}else{
			form.uploadfile.disabled=0;
			//form.copytoroot.disabled=0;
			form.fileurl.blur();
			form.fileurl.disabled=1;
			//form.upload1.checked=1;
			form.uploadfile.focus();
		}
		
    }
    function uploadform(form){
    	if(form.uploadfile.value=="" && form.fileurl.value==""){
    		alert("<%=PortletUtils.getMessage(pageContext, "must-input-upload-info",null)%>");
    		return false;
    	}
    	submitForm(form);
    }
  
 </script>
    
<form name="sheet_upload_form" method="post" enctype="multipart/form-data" 
action="<%=request.getContextPath() %>/control/upload">
<input type='hidden' name="directory" value='<%=table.getSecurityDirectory()%>'>
<input type="hidden" name="table" value="<%=tableId %>">
<input type="hidden" name="column" value="<%=columnId %>">
<input type="hidden" name="objectid" value="<%=objectId %>">
<input type="radio" id="upload1" CHECKED name="upload" value="true" onclick="javascript:checkUpload(sheet_upload_form)">
<%=PortletUtils.getMessage(pageContext, "file",null)%>
:&nbsp;&nbsp;<input type="file" name="uploadfile" size="50" > 
<!--<input type='checkbox' name="copytoroot" value="N">
<%=PortletUtils.getMessage(pageContext, "copy-file-to-root",null)%>--><br><br>
<input type="radio" id="upload2" name="upload" value="false" onclick="javascript:checkUpload(sheet_upload_form)">
<%=PortletUtils.getMessage(pageContext, "fileurl",null)%>:&nbsp;&nbsp;
<input type="text" name="fileurl" maxlength="300" size="50" >
<p>
	<div class="buttons">  
<!--input type='button' name='UploadFile' value='<%=PortletUtils.getMessage(pageContext, "upload-update",null)%>' onclick='javascript:uploadform(sheet_upload_form)'-->
<a id='UploadFile' name='UploadFile' href='javascript:uploadform(sheet_upload_form);'>
<img src="/html/nds/images/tb_import.gif"/><%=PortletUtils.getMessage(pageContext, "upload-update",null)%></a>
<!--input type='reset' name='resetbt'-->
<%@ include file="/html/nds/common/helpbtn.jsp"%>
<span id="closebtn"></span>
</div>
<Script language="javascript">
if( window.self==window.top){
	$("closebtn").innerHTML="<a id='btn_help' name='Close' href='javascript:window.close();'>"+
				"<img src=\"/html/nds/images/close.png\"/>"+gMessageHolder.CLOSE_DIALOG+"</a>";
}else{
		$("closebtn").innerHTML="<a id='btn_help' name='Close' href='javascript:art.dialog.close();'>"+
				"<img src=\"/html/nds/images/close.png\"/>"+gMessageHolder.CLOSE_DIALOG+"</a>";
	}
</script>

</form>
</td></tr></table>
 </td></tr></table>
<script>
checkUpload(sheet_upload_form);
</script>

    </div>
</div>
		

<%@ include file="/html/nds/footer_info.jsp" %>

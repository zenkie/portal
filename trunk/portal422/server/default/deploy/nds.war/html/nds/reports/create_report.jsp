<%@ page language="java"  pageEncoding="utf-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%
	String tabName= PortletUtils.getMessage(pageContext, "export",null);
%>
<script>
	document.title="<%=PortletUtils.getMessage(pageContext, "export",null)%>";
</script>
<div class="export-container">
	<ul><li><a href="javascript:void(0)"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">
<%
    ReportUtils ru = new ReportUtils(request);
    QueryRequestImpl qRequest =(QueryRequestImpl) request.getAttribute("query");
    if(qRequest!=null){
    	userWeb.checkPermission(qRequest.getMainTable().getSecurityDirectory(), nds.security.Directory.EXPORT);
    }
    if((ru.getQuota() - ru.getSpaceUsed()) <= 0){
    //空间已经用完
        nds.control.util.ValueHolder vh = new nds.control.util.ValueHolder();
        vh.put("message",PortletUtils.getMessage(pageContext, "warn-insufficient-disk-space",null));
        request.setAttribute(nds.util.WebKeys.VALUE_HOLDER,vh);
        pageContext.getServletContext().getRequestDispatcher(NDS_PATH+"/reports/index.jsp").forward(request,response);
        return;
    }
    String sql = request.getParameter("sql");
    String columnNames = request.getParameter("columnNames");
    String fname = request.getParameter("fname");
%>
<script language="JavaScript" src="/html/nds/js/formkey.js"></script>
<script language="javascript">
    function checkSelected(optionControl, desc){
      for(i=0; i<optionControl.options.length; i++) {
        if (optionControl.options[i].selected) {
            if( optionControl.options[i].value =='0'){
                alert("<%= PortletUtils.getMessage(pageContext, "please-select",null)%> "+desc+" !");
                optionControl.focus();
                return false;
            }
        }
      }
      return true;
    }
    function checkNotNull(control,desc){
      if(isWhitespace(control.value)){
        alert(desc+" <%= PortletUtils.getMessage(pageContext, "can-not-be-null",null)%>!");
        control.focus();
        return false;
      }
      return true;
    }
    function changeControlValue(control, value){
        control.value = value;
    }
    function createReport(form){
        changeControlValue(form.resulthandler,"<%=NDS_PATH%>/reports/report_generator.jsp");
        submitForm(form);
    }
    function checkOptions(form){
      if(!checkNotNull(form.fname,"file name"))
          return false;
      if(form.extension.value == 'txt')
          if(!checkNotNull(form.txt,"split code"))
              return false;
      createReport(form);
    }
</script>
<font style="background-color: #3980f4"></font>
<%
    String fileName = "";
    if(qRequest == null){
        if(sql == null)
        {
            out.println("Internal Error: can not find resultSet object or any SQL!");
  	    return;
        }else{
            if(fname != null)
                fileName = fname;
        }
    }else{
        fileName = qRequest.getMainTable().getName();
    }
    SimpleDateFormat sdf = new SimpleDateFormat("MMddHHmm");
    String actionPath = (qRequest == null)?NDS_PATH+"/reports/report_generator.jsp":contextPath+"/servlets/QueryInputHandler";
%>
<form name= "form1" class="export-form" method="post" action="<%=actionPath %>" >
		<input type="hidden" name="next-screen" value="<%=NDS_PATH%>/reports/index.jsp">
		<div class="export-item">
			<span class="export-span"><%= PortletUtils.getMessage(pageContext, "file-name",null)%>:</span>
			<input type="text" class="text" name="fname" size ="48" value="<%=fileName + sdf.format(new Date())%>">
		</div>
		<div class="export-item">
			<span class="export-span"><%= PortletUtils.getMessage(pageContext, "file-type",null)%>:</span>
              <script language="javascript">
                  function checkExtension()
                  {
                      with(document.form1){
                          if(extension.value == 'txt')
                          {
                              txt.disabled = false;
                              txt.focus();
                          }else
                              txt.disabled = true;
                      }
                  }
              </script>
              <select name="extension" onChange="javascript:checkExtension()">
               <option value="xls" selected>Excel</option>
               <option value="xlsx" selected>(2007)Excel</option>
               <option value="csv" ><%= PortletUtils.getMessage(pageContext, "csv-ext",null)%></option>
               <option value="txt"><%= PortletUtils.getMessage(pageContext, "txt-ext",null)%></option>
              </select>
              <input type="text" class="text" name="txt" disabled size="17">
              <input type="hidden" name="page" value="no">
              <input type="hidden" name="ak" value="yes">
              <input type="hidden" name="pk" value="no">
		</div>
		<div class="export-item">
			  <span class="export-span">显示表头:</span><input type="checkbox" class="vertical-middle" name="column" value="yes" checked>
		</div>
            <%/* begin obsolete
            if(qRequest != null)
            {
            %> 
				<div class="export-item"> 
					<span class="export-span"><%= PortletUtils.getMessage(pageContext, "data-this-page",null)%>:</span>
					<input type="radio" class="radio" name="page" value="yes"><%= PortletUtils.getMessage(pageContext, "check-yes",null)%>,
					<input type="radio" class="radio" name="page" value = "no" checked><%= PortletUtils.getMessage(pageContext, "check-no",null)%>
					<input type="hidden" name="ak" value="yes">
				</div>
				<div class="export-item">
					<span class="export-span"><%= PortletUtils.getMessage(pageContext, "including-id",null)%>:</span>
					<input type="radio" class="radio" name="pk" value="yes"><%= PortletUtils.getMessage(pageContext, "check-yes",null)%>,
					<input type="radio" class="radio" name="pk" value = "no" checked><%= PortletUtils.getMessage(pageContext, "check-no",null)%>
				</div>
            <%
            }
            %>
				<div class="export-item">
					<span class="export-span"><%= PortletUtils.getMessage(pageContext, "including-column-name",null)%>:</span>
					<input type="radio" class="radio" name="column" checked value="yes"><%= PortletUtils.getMessage(pageContext, "check-yes",null)%>,
					<input type="radio" class="radio" name="column" value = "no"><%= PortletUtils.getMessage(pageContext, "check-no",null)%>
				</div>
          <%end obsolete*/%>
				<div class="export-item align-center">
				  &nbsp;
				  <input type="hidden" name="command" value="ReportCreate">
				  <input type="button" value="<%= PortletUtils.getMessage(pageContext, "export",null)%>" onclick="checkOptions(document.form1)"> 
				  &nbsp;&nbsp;&nbsp; <a href="javascript:art.dialog.open('<%=NDS_PATH%>/reports/index.jsp',{width:940,height:500})"><%= PortletUtils.getMessage(pageContext, "view-export-folder",null)%></a>
				</div>  
          
      <%
        if(qRequest != null)
            out.print(QueryUtils.toHTMLControlForm(qRequest));
        if(sql != null && columnNames != null)
        {
      %>
      <input type="hidden" name="columnNames" value="<%=columnNames%>">
      <input type="hidden" name="sql" value="<%=sql%>">
      <%
        }
      %>
</form>
    </div>
</div>		

<%@ include file="/html/nds/footer_info.jsp" %>

<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %>
<%
	String tabName=PortletUtils.getMessage(pageContext, "select-view",null);
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
     *  table* - (String) format: "tableId1_tableId2_"
     *  id* - (int) record id
     */
%>
<%
    
	TableManager manager=TableManager.getInstance();
	String tableNames = request.getParameter("table");
	int objectId= ParamUtils.getIntAttributeOrParameter(request, "id", -1);
%>
  

<br>
<table border="0" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#999999" width="100%">
<form name="selectview">
     <tr>
      <td> <table border="0" cellspacing="5" cellpadding="0" align="center" width="90%"><tr>
        <td align='center'><br><%=PortletUtils.getMessage(pageContext, "option-views",null)%>:&nbsp;&nbsp;
<select name="view" tabIndex="3"  >
<%		
	
	Table table;
    StringTokenizer st=new StringTokenizer(tableNames, "_");
    while(st.hasMoreTokens()){
       table= manager.getTable(Tools.getInt(st.nextToken(),-1));
       if( table !=null){
%>
	 <option value="<%=table.getId()%>" selected="selected"><%=table.getDescription(locale)%></option>      		
<%       }
    }
%>

</select>          
		</td></tr>
		<tr><td align='center'><br>
			<input  type='button' name='gotoview' value='<%=PortletUtils.getMessage(pageContext, "enter-view",null)%>' onclick="window.location='<%=NDS_PATH+ "/object/object.jsp?input=true&id=" + objectId+"&table="%>'+selectview.view.value;" >
		</td></tr>
		</table>
 	  </td>
 	</tr>
</form> 	
</table>
    </div>
</div>


<%@ include file="/html/nds/footer_info.jsp" %>

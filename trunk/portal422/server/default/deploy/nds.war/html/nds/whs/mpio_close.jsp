<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/header.jsp" %> 
<%
    /**
     * parameter:
     *      1.  objectid  - mpio id
            2.  columnid  - from which column the button triggeded this request
     */
int objectId= Tools.getInt(request.getParameter("objectid"),-1);     
int columnId= Tools.getInt(request.getParameter("columnid"),-1);


TableManager manager=TableManager.getInstance();
Table table= manager.getColumn(columnId).getTable();
int tableId= table.getId();


if(!userWeb.hasObjectPermission(table.getName(),objectId,nds.security.Directory.WRITE)) 
	throw new NDSException("@no-permission@");

// check is invoice created for each inout item, for those created, create cr invoice to clear
// for those not created, do nothing
int qty=Tools.getInt(QueryEngine.getInstance().doQueryOne("select count(*) from c_order where id in (select distinct c_order_id from c_orderflow where m_a_inout_id="+objectId+") and c_doctype_id in (select a.id from c_doctype a where a.C_INVOICE_DOCTYPE_ID in (select b.id from c_doctype b where b.INVOICERULE ='I'))"),0);
if(qty==0){
   // no one create invoice, just close mpio
   ArrayList params=new ArrayList();
   params.add(new Integer(objectId));
   params.add(""); // means no invoice create, this is invoice_doctype_name
   SPResult rs= QueryEngine.getInstance().executeStoredProcedure("M_INOUT_CLOSE_PLAN", params, true);
   ValueHolder vh=new ValueHolder();
   vh.put("message",rs.getMessage());
   response.sendRedirect(NDS_PATH+"/info.jsp?"+vh.toQueryString( vh,request.getCharacterEncoding(),locale ));
   return;
}
	
	String tabName= PortletUtils.getMessage(pageContext, "close-mpio",null));
%>

<script>
	document.title="<%=tabName%>";
</script>
<div id="maintab">
	<ul><li><a href="#tab1"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">

<script language="JavaScript" src="<%=NDS_PATH%>/js/formkey.js"></script>
<script>
	function checkOptions(form){

		if( isWhitespace(form.invoicetype.value)){
			alert("<%= PortletUtils.getMessage(pageContext, "please-enter-a-valid-doctype",null)%>");
			return false;
		}
		submitForm(form); 
	}
</script>
<p>
<form name="mpioform" method="post" action="<%=contextPath%>/control/command" >
<br>
<table align="center" border="0" cellpadding="1" cellspacing="1" width="80%">
<input type="hidden" name="formRequest" value="<%=NDS_PATH+"/whs/mpio_close.jsp?objectid="+objectId +"&columnid="+columnId%>">
<input type="hidden" name="command" value="CloseMPIO">
<input type="hidden" name="objectid" value="<%=objectId%>">
<input type="hidden" name="columnid" value="<%=columnId%>">
	<tr><td colspan="2"><%= PortletUtils.getMessage(pageContext, "mpio-close-with-credit-memo",null)%><br><br></td></tr>
    <tr><td height="18" width="30%" nowrap align="right"><%= PortletUtils.getMessage(pageContext, "select-invoice-type",null)%>:</td>
    <td height="18" width="70%" align="left">
<%
     String column_acc_Id="invoicetype";
     String url=request.getContextPath()+"/servlets/query?table="+manager.getTable("C_V_INVOICE_DOCTYPE").getId()+"&return_type=s&accepter_id=mpioform."+column_acc_Id;
%>
    <input type="text"  name="<%=column_acc_Id%>"  value="">
    <span id="cbt_query" onaction=popup_window("<%=url%>","<%="T"+System.currentTimeMillis() %>")><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/find.gif' alt='<%= PortletUtils.getMessage(pageContext, "open-new-page-to-search" ,null)%>'></span>
    <script>createButton(document.getElementById("cbt_query"));</script>
    </td>
    </tr>
    <tr><td width="30%"></td>
    <td align="left"> <br>
<input  type='button' name='closempio' value='<%=PortletUtils.getMessage(pageContext, "object.submit",null)%>' onclick="javascript:checkOptions(document.mpioform);" > &nbsp;&nbsp;
<span id="tag_close_window"></span>
<Script language="javascript">
 // check show close window button or not
 if(  self==top){
 	document.getElementById("tag_close_window").innerHTML=
 	 "<input type='button' name='Cancle' value='<%= PortletUtils.getMessage(pageContext, "close-window" ,null)%>' onclick='javascript:window.close();' >";
 }
</script>
    	</td>
    	<td>
    	</td>
    </tr>
 </table>
 
 </form>
		
    </div>
</div>
<%@ include file="/html/nds/footer_info.jsp" %>

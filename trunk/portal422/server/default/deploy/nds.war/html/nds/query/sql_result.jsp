<%@page contentType= "text/html; charset=GBK"%>
<%@page import="nds.query.*,java.util.*"%>
<%@ taglib uri='/WEB-INF/tld/struts-tiles.tld' prefix='tiles' %>
<%@	page errorPage="../error.jsp"%>
<%
	String result= (String) request.getAttribute("result");
    String accepter_id= request.getParameter("accepter_id");
    if("".equals(accepter_id))accepter_id=null;
    String title="²éÑ¯Ìõ¼þÓï¾ä";
	
%>
<tiles:insert page='/header.jsp'>
  <tiles:put name='title' value='<%=title%>' direct='true'/>
</tiles:insert>
<br>
 <Script language="javascript">
<%/* 	 function close_popup(return_string){
    if(typeof(window.opener.name)!='unknown'){
        window.opener.document.<%=accepter_id%>.value="<%=result%>";
	window.close();
    }else{
	self.close();
    }
    return true;
  }*/
%>  
  function close_popup(return_string){
  	if(window.opener!=null){
	    if(typeof(window.opener.name)!='unknown'){
	        window.opener.document.getElementById("<%=accepter_id%>").value="<%=result%>";
			window.close();
	    }else{
			self.close();
	    }
	}else if(window.parent!=null){
		try{
			window.parent.document.getElementById("<%=accepter_id%>").value="<%=result%>";
			var ifm=window.parent.document.getElementById("popup-iframe-0");
			if(ifm){
	    		window.parent.setTimeout("Alerts.killAlert(document.getElementById('popup-iframe-0'))",1);
    		}			
		}catch(e){
			alert(e.messsage);	
		}	
	}
    return true;
  }
</script>
<table border="0" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#FFCC00" width="100%">
  <tr>
    <td rowspan=2>&nbsp;</td>
          <td>
<tiles:insert page='/title.jsp'>
  <tiles:put name='title' value='<%= title %>' direct='true'/>

</tiles:insert>
          </td>
          <td rowspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td>
      <table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#cccccc" background="../images/Nds_table_bg_2.gif">
        <tr>
          <td>
            <br><br>
	        <table width="98%" border="1" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#999999" align="center">
    	      <tr bgcolor="#FFFFFF">
        	  <td align=left><%=result%></td>
        	  </tr>
        	</table>
            <p>
			<table width='90%' border=0><tr><td align='left'>
				<a href='#' onclick='close_popup()'><img src='../images/return_sql.gif' width=100 height=20 border=0 alt='Return the value and back'></a>            
			</td></tr></table>
          </td>
        </tr>
      </table>
      <br>
    </td>
  </tr>
</table>

<br><br>
<tiles:insert page='/footer.jsp'>
</tiles:insert>



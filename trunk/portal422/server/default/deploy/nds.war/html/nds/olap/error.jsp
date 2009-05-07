<%@ include file="/html/nds/common/init.jsp" %>
<%
try{
	Throwable exception = (Throwable) request.getAttribute("javax.servlet.jsp.jspException");
	if(!response.containsHeader("nds.code"))response.setHeader("nds.code", "412"); // SC_PRECONDITION_FAILED 
	Throwable exec= (Throwable)request.getAttribute("error");
	if( exec !=null)	request.removeAttribute("error");
	ByteArrayOutputStream outs=null;
    if( exception ==null){
        if(exec !=null) exception =exec;
    }
	if( exception !=null)response.setHeader("nds.exception", exception.getLocalizedMessage()  );
%>
<html>
<head>

	<%@ include file="/html/common/top_meta.jsp" %>

	<%@ include file="/html/common/top_meta-ext.jsp" %>

	<title><%= PortletUtils.getMessage(pageContext, "exception",null)%></title>



	<%@ include file="/html/common/top_css-ext.jsp" %>

	<script language="JavaScript" src="<%= contextPath %>/html/js/sniffer.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/init.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/menu.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/rollovers.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/util.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/validation.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/js/sniffer.js"></script>

	<script language="JavaScript" src="<%= contextPath %>/html/nds/js/common.js"></script>
	<script language="JavaScript" src="<%= contextPath %>/html/nds/js/print.js"></script>
	<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/nds_portal.css">
	<%@ include file="/html/common/top_js-ext.jsp" %>

</head>

<%
String bodyBackground =colorScheme.getPortletBg();//colorScheme.getPortletBg() ;// GetterUtil.get(request.getParameter("body_background"), colorScheme.getPortletBg());
String bodyMargins = request.getParameter("body_margins");
String bodyPadding = request.getParameter("body_padding");
%>

<c:if test="<%= bodyMargins == null %>">
	<body class="body_class" bgcolor="<%= bodyBackground %>"  onresize="onResizeWindow();" onload="onResizeWindow();">
</c:if>

<c:if test="<%= bodyMargins != null %>">
	<body class="body_class" bgcolor="<%= bodyBackground %>" leftmargin="<%= bodyMargins %>" marginheight="<%= bodyMargins %>" marginwidth="<%= bodyMargins %>" rightmargin="<%= bodyMargins %>" topmargin="<%= bodyMargins %>"   onresize="onResizeWindow();" onload="onResizeWindow();">
</c:if>

<c:if test="<%= bodyPadding != null %>">
	<table bgcolor="<%= colorScheme.getPortletBg() %>" border="0" cellpadding="<%= bodyPadding %>" cellspacing="0">
	<tr>
		<td>
</c:if>

<%

boolean showTop = ParamUtil.get(request, "show_top", false);
%>

<c:if test="<%= showTop %>">
	<%@ include file="/html/common/top_bar.jsp" %>
</c:if>

<script language="javascript">

var NS4=(document.layers)?true:false
var IE4=(document.all)?true:false

function errMsg(){
    var obj = null, req = null;
    if(NS4){

    }else{
        obj = document.getElementById(['errorMsg']).style;
        if(obj.display == 'none')
            obj.display = 'block';
        else
            obj.display = 'none';
    }
}
with(document){
	write("<style type=text/css>")
	if(NS4){
		write(".exec {visibility:visible;}")
	}else{
                write(".exec {display:block;}")
        }
	write("</style>")
}
</script>
<table border="1" cellspacing="0" cellpadding="0" align="center" bordercolordark="#FFFFFF" bordercolorlight="#cccccc" width="100%">
<tr  class="TitleStyleClass"   style="background-color: #eeeeee; color: #000000;"  >
    <td align="left" true valign="middle" width="100%">
      <%= PortletUtils.getMessage(pageContext, "exception",null)%>
    </td>
</tr>
<tr><td>
<p>


<%	
MessagesHolder mh = MessagesHolder.getInstance();

if( exception !=null ){

	String msg =mh.translateMessage( (exception instanceof NDSException)?((NDSException)exception).getSimpleMessage():
                             exception.getMessage(),locale);
	out.println("<img src="+NDS_PATH+"/images/error.gif border=\"0\">"+msg);
	if(nds.control.web.WebUtils.isSystemDebugMode()){	
%>
<hr><b><a href="#" onClick="javascript:errMsg();return(false)"><%= PortletUtils.getMessage(pageContext, "debug-info",null)%></a></b>
<DIV id="errorMsg" class="exec" style="display:none;"><pre>
<%
      Throwable e = exception;
      while (e != null) {
        e.printStackTrace(new PrintWriter(out));
        Throwable prev = e;
        e = e.getCause();
        if (e == prev)
          break;
      }
%>        </pre>
	<div id="reqMsg" class="exec">
		<hr>
        <p><pre><%=nds.util.Tools.toString(request)%></pre></p>
	</div>  
</DIV>

<%
	} // end if debug mode
}//end if( exception !=null )
%>
</td></tr></table>


</body>
</html>
<%
}catch(Throwable ere){
	ere.printStackTrace();
}

%>

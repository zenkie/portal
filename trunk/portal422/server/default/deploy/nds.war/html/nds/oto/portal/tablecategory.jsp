<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%
if(userWeb==null || userWeb.isGuest()){
	String redirect=java.net.URLEncoder.encode(request.getRequestURI()+"?"+request.getQueryString() ,"UTF-8");
	response.sendRedirect("/login.jsp?redirect="+redirect);
	return;
}
//if((userWeb.getPermission("M_PRODUCT_ALIAS_LIST")& nds.security.Directory.READ )!= nds.security.Directory.READ )
//	throw new NDSException("@no-permission@");
	
   TableManager manager=TableManager.getInstance();
   int catId=Tools.getInt( request.getParameter("id"), -1);
   TableCategory cat=(TableCategory)manager.getTableCategory(catId);
   String desc=cat.getName();
   String func="pc.qrpt";
   String url=cat.getPageURL();
   String istree=userWeb.getUserOption("ISTREE","Y");
   if(url!=null){
%>
<jsp:include page="<%=url%>" flush="true" />
<%	}%>
<table><tr><td>
<script type="text/javascript">
var istree="<%=istree%>";
if(istree=="Y"){
	webFXTreeConfig.autoExpandAll=false;
	var tree=pc.createTree("<%=desc%>","/html/nds/portal/tablecategory.xml.jsp?id=<%=catId%>", <%=(url==null?"null":"\"javascript:pc.navigate('"+url+"')\"")%>,false);
}else{
	jQuery.post("/html/nds/oto/portal/tablecategoryout.jsp?id=<%=catId%>",function(data){
		var result=data;
		jQuery("#tree-list").html(result.xml);
		jQuery("#tree-list").css("padding","0");
		jQuery(".aside-md").height(jQuery(".topleft").height());
		var accordion = jQuery("#nav").accordion();
		window.accordion = accordion;
		if(!pc.menu_switch_model){//根据菜单模式切换菜单样式
			window.accordion.setAccordion();
			jQuery(".aside-md").toggleClass("nav-xs");
			jQuery("footer>a").toggleClass("active");
			pc.resize();
		}
	});
	<%=(url==null?"null":"javascript:pc.navigate('"+url+"');")%>
}
</script>    
</td></tr></table>

<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<%
/**
	@param cxtab - if set, will directly loading that cxtab search form
*/
   String cxtab= request.getParameter("cxtab");
   int cxtabCategoryTableId=TableManager.getInstance().getTable("ad_cxtab_category").getId();
   int cxtabTableId=TableManager.getInstance().getTable("ad_cxtab").getId();
   String func="pc.qrpt";
%>	
<div id="page-table-query">
	<div id="page-table-query-tab">
		<ul><li><a href="#tab1"><span><%=PortletUtils.getMessage(pageContext, "rpt-filter-setting",null)%></span></a></li></ul>
		<div id="tab1">
			<div id="rpt-search">
			<div id="rpt-search-note"><%= PortletUtils.getMessage(pageContext, "pls-select-rpt-template",null)%></div>
			</div>
		</div>
  </div>
</div> <!--
<div id="rpt-search-content">
	<div id="rpt-search-tab">
		<ul><li><a href="#tab1"><span><%=PortletUtils.getMessage(pageContext, "rpt-filter-setting",null)%></span></a></li></ul>
		<div id="tab1">
			<div id="rpt-search">
				<div id="rpt-search-note"><%= PortletUtils.getMessage(pageContext, "pls-select-rpt-template",null)%></div>
			</div>
		</div>
	</div>
</div>-->
<script type="text/javascript">
//jQuery('#rpt-search-tab ul').tabs();
jQuery('#page-table-query-tab ul').tabs();
webFXTreeConfig.autoExpandAll=false;
pc.createTree("<%= PortletUtils.getMessage(pageContext, "report-center",null)%>", "/html/nds/common/tree2.xml.jsp?tbstruct=<%=cxtabCategoryTableId%>&tbdata=<%=cxtabTableId%>&fnc=<%=func%>");
<%
  if(nds.util.Validator.isNotNull(cxtab)){
%>
	pc.qrpt("<%=cxtab%>");
<%}%>
</script>



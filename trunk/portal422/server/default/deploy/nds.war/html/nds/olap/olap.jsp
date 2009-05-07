<%@ include file="/html/nds/common/init.jsp" %>
<%@ taglib uri="http://java.sun.com/jstl/core_el" prefix="c2" %>
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %>
<%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %>
<%@ page import="nds.olap.*" %>

<%
/**
  param 
	 cube - cube id when create new one, this is needed
	 id   - when query a mdx, this is for ad_query table.
	 olapquery - olapQuery id, if set, will use infomation that previously loaded
	 clearcache - if ="true", will clear cache first
  only when one of above parameter found in servletrequest object, will the system initialize a	new sequence for 
  the object
*/
String query=null;
String queryParam=null;
nds.olap.OLAPEngine olapServer= nds.olap.OLAPEngine.getInstance();

int olapQueryId= nds.util.Tools.getInt( request.getParameter("olapquery"),-1);
OLAPQuery olapQuery=null;
boolean isNew=false;
if(olapQueryId!=-1){
	olapQuery=OLAPQuery.getInstance(session, olapQueryId);
	
}else{
	// create a new one
	olapQuery=OLAPQuery.createInstance(session);
	olapQuery.setAdCubeId(nds.util.Tools.getInt( request.getParameter("cube"),-1));
	olapQuery.setAdQueryId(nds.util.Tools.getInt( request.getParameter("id"),-1));
	if(olapQuery.getAdCubeId()==-1){
		//load from ad_query
		nds.model.AdQuery queryObj=olapServer.loadQuery(olapQuery.getAdQueryId()); 
		query=queryObj.getQuery();
		queryParam=queryObj.getQueryParam();
		olapQuery.setAdCubeId(queryObj.getAdCubeId().intValue());
		olapQuery.setAdQueryDesc(queryObj.getName());
	}
	olapQuery.setAdCubeDesc( olapServer.loadCube(olapQuery.getAdCubeId()).getName());
	olapQueryId=olapQuery.getId();
	isNew=true;
	try{
		olapQuery.setRole(olapServer.getRoleOnCube(userWeb.getUserId(),olapQuery.getAdCubeId()));
		// check permission
		if(olapQuery.getAdQueryId()!=-1 && 
			!userWeb.hasObjectPermission("AD_Query",olapQuery.getAdQueryId(),nds.security.Directory.READ))
			throw new NDSException(PortletUtils.getMessage(pageContext, "no-permission",null));
		
	}catch(Exception e){
		OLAPQuery.destroy(session,olapQueryId);
		throw e;
	}
}
if( "true".equals(request.getParameter("clearcache"))){
	olapServer.clearCache(olapQuery.getAdCubeId(), userWeb.getUserName());
	if(query==null){
		query=OLAPUtils.getMDXQuery( request, response, olapQuery.getId());
	}
	isNew=true;
}	
String nds_query_param="olapquery="+olapQueryId;
request.setAttribute("page_help", "OLAP");

String query01="query"+olapQuery.getId();
String table01="table"+olapQuery.getId();
String navi01="navi"+olapQuery.getId();
String mdxedit01="mdxedit"+olapQuery.getId();
String sortform01="sortform"+olapQuery.getId();
String print01="print"+olapQuery.getId();
String printform01="printform"+olapQuery.getId();
String chart01="chart"+olapQuery.getId();
String chartform01="chartform"+olapQuery.getId();
String toolbar01="toolbar"+olapQuery.getId();

// url to add to chart component
String controllerURL="olap.jsp?"+nds_query_param;
//System.out.println("query="+ query01);
%> 
<liferay-util:include page="/html/nds/header.jsp">
	<liferay-util:param name="html_title" value="OLAP" />
	<liferay-util:param name="show_top" value="true" />
	<liferay-util:param name="enable_context_menu" value="true" />	
	<liferay-util:param name="table_width" value="100%" />
</liferay-util:include>
  <link rel="stylesheet" type="text/css" href="/jpivot/table/mdxtable.css">
  <link rel="stylesheet" type="text/css" href="/jpivot/navi/mdxnavi.css">
  <link rel="stylesheet" type="text/css" href="/wcf/form/xform.css">
  <link rel="stylesheet" type="text/css" href="/wcf/table/xtable.css">
  <link rel="stylesheet" type="text/css" href="/wcf/tree/xtree.css">
<script>
document.bgColor="<%=colorScheme.getPortletBg()%>";
function savecube(){
	location="<%=NDS_PATH+"/olap/save.jsp?olapquery="+olapQueryId%>";
}
function home(){
	location="<%=NDS_PATH+"/olap/home.jsp"%>";
}
function reloadcube(){
	if (!confirm("<%= PortletUtils.getMessage(pageContext, "do-you-confirm-reload-cube",null)%>")) {
		location="<%=NDS_PATH+"/olap/olap.jsp?olapquery="+olapQueryId%>";
    }else{
		olapform.clearcache.value="true";
		olapform.submit();
	}
	
}
</script>

<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%">
<form name="olapform" action="olap.jsp" method="post">
<input type="hidden" name="olapquery" value="<%=olapQueryId%>">
<input type="hidden" name="clearcache" value="false">
<tr><td>
<%-- include query and title, so this jsp may be used with different queries --%>
<%if(isNew){
nds.olap.OLAPEngine.SchemaConfig cfg=olapServer.getConfig(olapQuery.getAdCubeId());
if(query==null)query=cfg.getDefaultMdxQuery();
%>
<jp:mondrianQuery id="<%=query01%>" role="<%=olapQuery.getRole()%>" dataSource="<%=cfg.getDataSource()%>" dynLocale="<%=locale.toString()%>" dynResolver="mondrian.i18n.LocalizingDynamicSchemaProcessor" catalogUri="<%=cfg.getSchemaUrl()%>">
<%=query%>
</jp:mondrianQuery>
<%}%>
<%-- define table, navigator and forms --%>
<jp:table id="<%=table01%>" query="<%="#{"+query01+"}"%>"/>
<jp:chart id="<%=chart01%>" query="<%="#{"+query01+"}"%>" visible="false" controllerURL="<%=controllerURL%>"/>
<%
  if(queryParam!=null){
  	OLAPUtils.setQueryParam(request,response,olapQuery.getId(),queryParam,null);
  }
  //OLAPUtils.checkChartComponentFont(request,response,chart01);
%>
<jp:navigator id="<%=navi01%>" query="<%="#{"+query01+"}"%>" visible="false"/>
<wcf:form id="<%=mdxedit01%>" xmlUri="/WEB-INF/jpivot/table/mdxedit.xml" model="<%="#{"+query01+"}"%>" visible="false"/>
<wcf:form id="<%=sortform01%>" xmlUri="/WEB-INF/jpivot/table/sortform.xml" model="<%="#{"+table01+"}"%>" visible="false"/>

<jp:print id="<%=print01%>"/>
<wcf:form id="<%=printform01%>" xmlUri="/WEB-INF/jpivot/print/printpropertiesform.xml" model="<%="#{"+print01+"}"%>" visible="false"/>

<wcf:form id="<%=chartform01%>" xmlUri="/WEB-INF/jpivot/chart/chartpropertiesform.xml" model="<%="#{"+chart01+"}"%>" visible="false"/>
<wcf:table id="<%=query01+".drillthroughtable"%>" visible="false" selmode="none" editable="true"/>
<%-- define a toolbar --%>
<wcf:toolbar id="<%=toolbar01%>" bundle="com.tonbeller.jpivot.toolbar.resources">
  <wcf:scriptbutton id="cubeNaviButton" tooltip="toolb.cube" img="cube" model="<%="#{"+navi01+".visible}"%>"/>
  <wcf:scriptbutton id="mdxEditButton" tooltip="toolb.mdx.edit" img="mdx-edit" model="<%="#{"+mdxedit01+".visible}"%>"/>
  <wcf:scriptbutton id="sortConfigButton" tooltip="toolb.table.config" img="sort-asc" model="<%="#{"+sortform01+".visible}"%>"/>
  <wcf:separator/>
  <wcf:scriptbutton id="levelStyle" tooltip="toolb.level.style" img="level-style" model="<%="#{"+table01+".extensions.axisStyle.levelStyle}"%>"/>
  <wcf:scriptbutton id="hideSpans" tooltip="toolb.hide.spans" img="hide-spans" model="<%="#{"+table01+".extensions.axisStyle.hideSpans}"%>"/>
  <wcf:scriptbutton id="propertiesButton" tooltip="toolb.properties"  img="properties" model="<%="#{"+table01+".rowAxisBuilder.axisConfig.propertyConfig.showProperties}"%>"/>
  <wcf:scriptbutton id="nonEmpty" tooltip="toolb.non.empty" img="non-empty" model="<%="#{"+table01+".extensions.nonEmpty.buttonPressed}"%>"/>
  <wcf:scriptbutton id="swapAxes" tooltip="toolb.swap.axes"  img="swap-axes" model="<%="#{"+table01+".extensions.swapAxes.buttonPressed}"%>"/>
  <wcf:separator/>
  <wcf:scriptbutton model="<%="#{"+table01+".extensions.drillMember.enabled}"%>"	 tooltip="toolb.navi.member" radioGroup="navi" id="drillMember"   img="navi-member"/>
  <wcf:scriptbutton model="<%="#{"+table01+".extensions.drillPosition.enabled}"%>" tooltip="toolb.navi.position" radioGroup="navi" id="drillPosition" img="navi-position"/>
  <wcf:scriptbutton model="<%="#{"+table01+".extensions.drillReplace.enabled}"%>"	 tooltip="toolb.navi.replace" radioGroup="navi" id="drillReplace"  img="navi-replace"/>
  <wcf:scriptbutton model="<%="#{"+table01+".extensions.drillThrough.enabled}"%>"  tooltip="toolb.navi.drillthru" id="drillThrough01"  img="navi-through"/>
  <wcf:separator/>
  <wcf:scriptbutton id="tableButton01" tooltip="toolb.table" img="table" model="<%="#{"+table01+".visible}"%>"/>
  <wcf:scriptbutton id="chartButton01" tooltip="toolb.chart" img="chart" model="<%="#{"+chart01+".visible}"%>"/>
  <wcf:scriptbutton id="chartPropertiesButton01" tooltip="toolb.chart.config" img="chart-config" model="<%="#{"+chartform01+".visible}"%>"/>
  <wcf:separator/>
  <wcf:imgbutton id="reload" tooltip="toolb.reload" img="reload" href="javascript:reloadcube()"/>
  <wcf:separator/>
  <wcf:scriptbutton id="printPropertiesButton01" tooltip="toolb.print.config" img="print-config" model="<%="#{"+printform01+".visible}"%>"/>
  <wcf:imgbutton id="printpdf" tooltip="toolb.print" img="print" href="<%="/Print?cube="+olapQueryId+"&type=1"%>"/>
  <wcf:imgbutton id="printxls" tooltip="toolb.excel" img="excel" href="<%="/Print?cube="+olapQueryId+"&type=0"%>"/>
  <wcf:imgbutton id="savemdx" tooltip="toolb.save" img="save" href="javascript:savecube()"/>
  <wcf:separator/>
  <wcf:imgbutton id="home" tooltip="toolb.reset.query" img="reset-query" href="javascript:home()"/>
</wcf:toolbar> 
 
<%-- render toolbar --%>
<wcf:render ref="<%=toolbar01%>" xslUri="/WEB-INF/jpivot/toolbar/htoolbar.xsl" xslCache="true"/>
<p>

<%-- render navigator --%>
<wcf:render ref="<%=navi01%>" xslUri="/WEB-INF/jpivot/navi/navigator.xsl" xslCache="true">
	<wcf:renderParam name="nds_query" value="<%=nds_query_param%>"/>
</wcf:render>
<%-- edit mdx --%>
  <wcf:render ref="<%=mdxedit01%>" xslUri="/WEB-INF/wcf/wcf.xsl" xslCache="true"/>
<%-- sort properties --%>
<wcf:render ref="<%=sortform01%>" xslUri="/WEB-INF/wcf/wcf.xsl" xslCache="true"/>

<%-- chart properties --%>
<wcf:render ref="<%=chartform01%>" xslUri="/WEB-INF/wcf/wcf.xsl" xslCache="true"/>

<%-- print properties --%>
<wcf:render ref="<%=printform01%>" xslUri="/WEB-INF/wcf/wcf.xsl" xslCache="true"/>
<!-- render the table -->
<p>
<wcf:render ref="<%=table01%>" xslUri="/WEB-INF/jpivot/table/mdxtable.xsl" xslCache="true"/>
<p>
<%=PortletUtils.getMessage(pageContext, "slicer",null)%>:
<wcf:render ref="<%=table01%>" xslUri="/WEB-INF/jpivot/table/mdxslicer.xsl" xslCache="true"/>

<p>
<!-- drill through table -->
<wcf:render ref="<%=query01+".drillthroughtable"%>" xslUri="/WEB-INF/wcf/wcf.xsl" xslCache="true"/>

<p>
<!-- render chart -->
<wcf:render ref="<%=chart01%>" xslUri="/WEB-INF/jpivot/chart/chart.xsl" xslCache="true"/>

</td></tr>
</form>
</table>
<pre>
<%
//out.print(nds.util.Tools.toString(request));
 /*StringBuffer buf=new StringBuffer();
  java.util.Enumeration enum=session.getAttributeNames();
  buf.append("Following is from session:\n\r------Attributes--------\r\n");
         while( enum.hasMoreElements()) {
             String att= (String)enum.nextElement();
             buf.append(att+" = "+ session.getAttribute(att)+"\r\n");
         }
 out.print(buf.toString()); */
 //Thread.dumpStack();
%>

</pre>
<script>
/*document.attachEvent( "oncontextmenu", showContextMenu );
document.attachEvent( "onkeyup", rememberKeyCode );*/
</script>

<%@ include file="/html/nds/footer_info.jsp" %>

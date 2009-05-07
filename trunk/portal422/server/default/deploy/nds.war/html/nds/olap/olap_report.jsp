<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jstl/sql" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jstl/xml" %>
<%@ taglib prefix="display" uri="http://displaytag.sourceforge.net" %>
<%@ taglib prefix="bean" uri="/WEB-INF/tld/struts-bean.tld" %>
<%@ taglib prefix="html" uri="/WEB-INF/tld/struts-html.tld" %>
<%@ taglib prefix="logic" uri="/WEB-INF/tld/struts-logic.tld" %>
<%@ taglib prefix="nested" uri="/WEB-INF/tld/struts-nested.tld" %>
<%@ taglib prefix="tiles" uri="/WEB-INF/tld/struts-tiles.tld" %>

<%@ taglib prefix="portlet" uri="/WEB-INF/tld/liferay-portlet.tld" %>
<%@ taglib prefix="liferay" uri="/WEB-INF/tld/liferay-util.tld" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="nds.log.*,nds.olap.*,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ taglib uri="http://java.sun.com/jstl/core_el" prefix="c2" %>
<%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %>
<%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %>
<%!
private static Logger logger= LoggerManager.getInstance().getLogger("create_cache");
%>
<%
/**
  Create html string, and set back, note this page should only be called from localhost
  
  param 
	 userid - who executed this page
	 query   - when query a mdx, this is id of the ad_query table.
	file    - file name without path infor, in portal env, it will be portlet name, such as ndsgraph2
*/
Locale locale= (Locale)session.getAttribute(org.apache.struts.Globals.LOCALE_KEY);
int olapQueryId= -1;

try{
if(!"127.0.0.1".equals(request.getRemoteAddr())) throw new NDSException("Illegal remote host.");
int userId= Tools.getInt(request.getParameter("userid"),-1);
nds.security.User user=nds.control.util.SecurityUtils.getUser(userId);

if(locale==null)locale= nds.portlet.util.UserUtils.getLocale(user.getName(),user.getClientDomain());
String query=null;
String queryParam=null;
nds.olap.OLAPEngine olapServer= nds.olap.OLAPEngine.getInstance();

OLAPQuery olapQuery=null;
boolean isNew=false;
	// create a new one
	olapQuery=OLAPQuery.createInstance(session);
	olapQuery.setAdQueryId(nds.util.Tools.getInt( request.getParameter("query"),-1));
		//load from ad_query
		nds.model.AdQuery queryObj=olapServer.loadQuery(olapQuery.getAdQueryId()); 
		query=queryObj.getQuery();
		queryParam=queryObj.getQueryParam();
		olapQuery.setAdCubeId(queryObj.getAdCubeId().intValue());
		olapQuery.setAdQueryDesc(queryObj.getName());
	olapQuery.setAdCubeDesc( olapServer.loadCube(olapQuery.getAdCubeId()).getName());
	olapQueryId=olapQuery.getId();
	isNew=true;
	try{
		olapQuery.setRole(olapServer.getRoleOnCube(userId,olapQuery.getAdCubeId()));
		// check permission
		if(olapQuery.getAdQueryId()!=-1 && 
			!nds.control.util.SecurityUtils.hasObjectPermission(userId,user.getName(),"AD_Query",olapQuery.getAdQueryId(),nds.security.Directory.READ, QueryUtils.createQuerySession(userId,session.getId(),locale)))
			throw new NDSException("@no-permission@");
		
	}catch(Exception e){
		OLAPQuery.destroy(session,olapQueryId);
		throw e;
	}

	olapServer.clearCache(olapQuery.getAdCubeId(), user.getName());
	if(query==null){
		query=OLAPUtils.getMDXQuery( request, response, olapQuery.getId());
	}
	isNew=true;

String nds_query_param="olapquery="+olapQueryId;
String uniqueTableId="tb"+System.currentTimeMillis();
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
com.liferay.portal.model.Skin skin=nds.portlet.util.UserUtils.getSkin(user.getName(),user.getClientDomain());
%>
<%@ include file="/html/nds/olap/olap_report.css.jsp" %>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td align="center">
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
  	OLAPUtils.setQueryParam(request,response,olapQuery.getId(),queryParam,OLAPUtils.getCacheQueryFixedPropery());
  }
%>
<wcf:render id="<%=uniqueTableId%>" ref="<%=table01%>" xslUri="/WEB-INF/jpivot/table/mdxtable_report.xsl" xslCache="false"/>
</td></tr><tr><td align="center">
<wcf:render ref="<%=chart01%>" xslUri="/WEB-INF/jpivot/chart/chart.xsl" xslCache="false"/>
</td></tr>
</table>
<script>
	if(document.getElementById("<%=uniqueTableId%>")!=null){
		document.getElementById("<%=uniqueTableId%>").borderColorDark="<%=colorScheme.getPortletBg()%>";
		document.getElementById("<%=uniqueTableId%>").borderColorLight="<%=colorScheme.getPortletBg()%>";
		document.getElementById("<%=uniqueTableId%>out").bgColor="<%=colorScheme.getPortletTitleBg()%>";
	}
</script>
<%
  OLAPUtils.moveChartFileToUserHome(request,response,olapQuery.getId(),user.getName(),user.getClientDomain(), request.getParameter("file"));
	
}catch(Throwable t){
logger.error("Find error", t);
out.print("Error:"+ t.toString());
}finally{
	// clear this query object
	if(olapQueryId!=-1){	
%>
	<jp:destroyQuery id="<%="query"+olapQueryId%>"/>	
<%
		session.removeAttribute("query"+olapQueryId);
		session.removeAttribute("table"+olapQueryId);
		session.removeAttribute("chart"+olapQueryId);
		OLAPQuery.destroy(session, olapQueryId);
	}
	try {
		session.invalidate();
	}catch (Exception e) {}	
}
%>


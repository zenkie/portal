<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.control.event.DefaultWebEvent" %>
<%@ page import="nds.olap.*" %>
<%
    /**
     * Things needed in this page:
     *  olapquery   -  olapQuery id,
     */
	OLAPQuery olapQuery =OLAPQuery.getInstance(session, nds.util.Tools.getInt( request.getParameter("olapquery"),-1));
	
    // query is what user currently working on
    String query=OLAPUtils.getMDXQuery( request, response, olapQuery.getId());
    String queryparam=OLAPUtils.getQueryParam( request, response, olapQuery.getId());
	if(query==null) query="";

	DefaultWebEvent e=new DefaultWebEvent("mdxquery");
	
	TableManager manager=TableManager.getInstance();
	Table table=manager.getTable("ad_query");
	
	e.setParameter("query",new String[]{ query});
	e.setParameter("queryparam",new String[]{ queryparam});
	String[] sidx= new String[]{"0"};
    e.setParameter("selectedItemIdx",sidx);
    e.setParameter(DefaultWebEvent.SELECTER_NAME,"selectedItemIdx" );
    
    // this event will be retrieved and show on screen if set to attribute named DEFAULT_WEB_EVENT
    request.setAttribute(nds.util.WebKeys.DEFAULT_WEB_EVENT, e);
	String nextScreen=nds.util.WebKeys.NDS_URI+"/object/object.jsp?id="+olapQuery.getAdQueryId()+"&mainobjecttableid="+table.getId()+"&table="+table.getId()+"&action=input&fixedcolumns="+manager.getColumn("ad_query","ad_cube_id").getId()+"%3D"+olapQuery.getAdCubeId();
    WebUtils.getServletContext().getRequestDispatcher(nextScreen).forward(request,response);
%>


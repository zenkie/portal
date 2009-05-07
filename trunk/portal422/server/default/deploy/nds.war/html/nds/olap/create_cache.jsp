<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="nds.log.*,nds.olap.*,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%!
private static Logger logger= LoggerManager.getInstance().getLogger("create_cache");
%>
<%
/** 
  Create html file to user's home directory on server, note this page should only be called from localhost
  param 
	 userid  - who executed this page
	 query   - when query a mdx, this is for ad_query table.
	 file    - file name without path infor, in portal env, it will be portlet name, such as ndsgraph2
*/
Locale locale=TableManager.getInstance().getDefaultLocale();
session.setAttribute("com.tonbeller.wcf.controller.RequestFilter.isnew","false");
int olapQueryId= -1;

try{
	if(!"127.0.0.1".equals(request.getRemoteAddr())) throw new NDSException("Illegal remote host.");
	int userId= Tools.getInt(request.getParameter("userid"),-1);
	nds.security.User user=nds.control.util.SecurityUtils.getUser(userId);
	locale= nds.portlet.util.UserUtils.getLocale(user.getName(),user.getClientDomain());
	session.setAttribute(org.apache.struts.Globals.LOCALE_KEY,locale);
	response.sendRedirect("/html/nds/olap/olap_report.jsp?userid="+userId+"&query="+request.getParameter("query")+"&file="+request.getParameter("file"));
	//pageContext.forward("/html/nds/olap/olap_report.jsp");
	//request.getRequestDispatcher("/html/nds/olap/olap_report.jsp").forward(request, response);
}catch(Throwable t){
	logger.error("Find error", t);
	out.print("Error:"+ t.toString());
}
%>

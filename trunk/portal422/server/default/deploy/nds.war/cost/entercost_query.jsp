<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<script language="javascript" src="/cost/cost.js"></script>

<%   /**
     * ȷ���û��Ǿ����̣��Ҵ��ڵ�ǰ��Ч�Ķ�����
     */
String NDS_PATH=nds.util.WebKeys.NDS_URI;
UserWebImpl userWeb =null;
try{
	userWeb= ((UserWebImpl)WebUtils.getSessionContextManager(session).getActor(nds.util.WebKeys.USER));	
}catch(Exception userWebException){
	System.out.println("########## found userWeb=null##########"+userWebException);
}
boolean hasValidFairs=true;
if(hasValidFairs ){
if(request.getHeader("User-Agent").toString().indexOf("Firefox")!=-1){
%>
<tree icon="/html/nds/images/outhome.gif"  text="<%= PortletUtils.getMessage(pageContext, "price-adjust-module",null)%>" action="javascript:showObject('/cost/cost_adjust.jsp',957,523)"/>
<%
}else{
%>
<tree icon="/html/nds/images/outhome.gif"  text="<%= PortletUtils.getMessage(pageContext, "price-adjust-module",null)%>" action="javascript:showObject('/cost/cost_adjust.jsp',958,520)"/>
<%
}
%>
<%}%>
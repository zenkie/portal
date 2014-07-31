<%@ page errorPage="/html/nds/error.jsp" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.web.config.*" %>

<%
	/**
	* List Portlet, read parameter from request.attribute, as following:
	  "nds.portal.listconfig" - String for config name to identify instance of ListDataConfig and ListUIConfig
	*/
//String configName=(String) request.getAttribute("nds.portal.listconfig");
String configName="mynotice";
if(nds.util.Validator.isNull(configName)){
   out.println("Internal error: \"nds.portal.listconfig\" not found in request attribute");
   return;
}
PortletConfigManager pcManager=(PortletConfigManager)WebUtils.getServletContextManager().getActor(nds.util.WebKeys.PORTLETCONFIG_MANAGER);
ListDataConfig dataConfig= (ListDataConfig)pcManager.getPortletConfig(configName,nds.web.config.PortletConfig.TYPE_LIST_DATA);
ListUIConfig uiConfig= (ListUIConfig)pcManager.getPortletConfig(configName,nds.web.config.PortletConfig.TYPE_LIST_UI);
String namespace= configName.replaceAll(" ","");
TableManager manager=TableManager.getInstance();
QueryEngine engine=QueryEngine.getInstance();
int tableId=dataConfig.getTableId();
Table table;
table= manager.getTable(tableId);
%>
<%@ include file="c_ul_list.jsp" %>


<%/**
 ���ļ�����ʹ��ant task ����javascript, css �ļ��ĺϲ���ѹ���������Ա��ļ����е��޸���Ҫ���¶�Ӧ��ant build �ļ�
*/
%>
<%@ include file="/html/common/themes/top_meta.jsp" %>
<%@ include file="/html/common/themes/top_meta-ext.jsp" %>
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico" />
<%if(GetterUtil.getBoolean(PropsUtil.get(PropsUtil.JAVASCRIPT_FAST_LOAD)) ){ %>
<script language="javascript" src="/html/nds/js/portal_aio_<%=locale.toString()%>_min.js"></script>
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/portal_aio_min.css">
<%}else{%>
<script language="javascript" src="/html/nds/js/top_css_ext.js"></script>
<script language="javascript1.5" src="/html/nds/js/ieemu.js"></script>
<script language="javascript" src="/html/nds/js/cb2.js"></script>
<script language="javascript" src="/html/nds/js/xp_progress.js"></script>
<script language="javascript" src="/html/nds/js/helptip.js"></script>
<script language="javascript" src="/html/nds/js/common.js"></script>
<script language="javascript" src="/html/nds/js/print.js"></script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script language="javascript" src="/html/nds/js/jquery1.2.3/jquery.js"></script>
<script language="javascript" src="/html/nds/js/jquery1.2.3/hover_intent.js"></script>
<script language="javascript" src="/html/nds/js/jquery1.2.3/ui.tabs.js"></script>
<script>
	jQuery.noConflict();
</script>		
<script language="javascript" src="/html/js/sniffer.js"></script>
<script language="javascript" src="/html/js/ajax.js"></script>
<script language="javascript" src="/html/js/util.js"></script>
<script language="javascript" src="/html/js/portal.js"></script>
<script language="javascript" src="/html/nds/js/xloadtree111/xtree.js"></script>
<script language="javascript" src="/html/nds/js/xloadtree111/xmlextras.js"></script>
<script language="javascript" src="/html/nds/js/xloadtree111/xloadtree.js"></script>
<script language="javascript" src="/html/nds/js/formkey.js"></script>
<script language="javascript" src="/html/nds/js/selectableelements.js"></script>
<script language="javascript" src="/html/nds/js/selectabletablerows.js"></script>
<script language="javascript" src="/html/js/dragdrop/coordinates.js"></script>
<script language="javascript" src="/html/js/dragdrop/drag.js"></script>
<script language="javascript" src="/html/nds/js/calendar.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/js/application.js"></script>
<script language="javascript" src="/html/nds/js/alerts.js"></script>
<script language="javascript" src="/html/nds/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/js/portletcontrol.js"></script>
<script language="javascript" src="/html/nds/js/init_portalcontrol_<%=locale.toString()%>.js"></script>
<script language="javascript" src="/html/nds/js/portalcontrol.js"></script>
<script language="javascript" src="/html/nds/js/object_query.js"></script>
<script language="javascript" src="/html/nds/js/categorymenu.js"></script>
<script language="javascript" src="/html/nds/js/dockmenu.js"></script>
<script language="javascript" src="/html/nds/js/outline.js"></script>
<link type="text/css" rel="stylesheet" href="/html/nds/js/xloadtree111/xtree.css" />
<link type="text/css" rel="StyleSheet" href="/html/nds/css/portlet.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/object.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/portal_header.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/css/cb2.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/nds_portal.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/dockmenu.css">
<link type="text/css" rel="StyleSheet" href="<%=userWeb.getThemePath()%>/css/custom-ext.css" />
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/ui.tabs.css">
<%}//end JAVASCRIPT_FAST_LOAD
%>
<title><%=userWeb.getClientDomainName()%></title>


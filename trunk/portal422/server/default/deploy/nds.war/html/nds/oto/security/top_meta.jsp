<%@ include file="/html/common/init.jsp" %>
<%/**
 本文件内容使用ant task 进行javascript, css 文件的合并和压缩操作，对本文件进行的修改需要更新对应的ant build 文件
*/
%>
<%@ include file="/html/common/themes/top_meta.jsp" %>
<%@ include file="/html/common/themes/top_meta-ext.jsp" %>
<link rel="Shortcut Icon" href="/html/nds/images/portal.ico" />
<%if(GetterUtil.getBoolean(PropsUtil.get(PropsUtil.JAVASCRIPT_FAST_LOAD)) ){ %>
<script language="javascript" src="/html/nds/oto/js/object_aio_<%=locale.toString()%>_min.js"></script>
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/object_aio_min.css">
<%}else{%>
<script language="javascript" src="/html/nds/oto/js/top_css_ext.js"></script>
<script language="javascript" language="javascript1.5" src="/html/nds/oto/js/ieemu.js"></script>
<script language="javascript" src="/html/nds/oto/js/cb2.js"></script>
<script language="javascript" src="/html/nds/oto/js/xp_progress.js"></script>
<script language="javascript" src="<%=NDS_PATH%>/js/helptip.js"></script>
<%/*
if(BrowserSniffer.is_mozilla(request)){%>
	<script language="javascript" src="/html/nds/oto/js/xmenu.js"></script>
	<script language="javascript" src="/html/nds/oto/js/cssexpr.js"></script>
	<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/xmenu.css"  />
	<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/xmenu.windows.css" />
<%}else{%>	
	<link type="text/css" rel="StyleSheet" href="/html/nds/oto/js/menu4/skins/officexp/officexp.css" />
	<script language="javascript" src="/html/nds/oto/js/menu4/poslib.js"></script>
	<script language="javascript" src="/html/nds/oto/js/menu4/scrollbutton.js"></script>
	<script language="javascript" src="/html/nds/oto/js/menu4/menu4.js"></script>
	<%if ( ParamUtil.get(request, "enable_context_menu", false)==false){%>
	<script language="javascript" src="/html/nds/oto/js/initctxmenu_<%=locale.toString()%>.js"></script>
	<%}else{%>
	<script>
	 //disable context menu control in top_css_ext.js 
	  document.detachEvent( "oncontextmenu",noContextMenu );
	</script>
	<%}
}*/
%>
	<script language="javascript" src="/html/nds/oto/js/common.js"></script>
	<script language="javascript" src="/html/nds/oto/js/print.js"></script>
	<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
	<!--script language="javascript" src="/html/nds/js/jquery1.2.3/jquery.js"></script-->
	<!--script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.min.js"></script-->
	<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
	<!--script language="javascript" src="/html/nds/js/jquery1.2.3/hover_intent.js"></script>
	<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery.ui.tabs.js"></script-->
	<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
	<!--script language="javascript" src="/html/nds/js/jquery1.2.3/ui.tabs.js"></script-->
	<script language="javascript" src="/html/prg/upload/jquery.uploadify.min.js"></script>
<script>
	jQuery.noConflict();
</script>
	<script language="javascript" src="/html/nds/oto/js/sniffer.js"></script>
	<script language="javascript" src="/html/nds/oto/js/ajax.js"></script>
	<script language="javascript" src="/html/nds/oto/js/util.js"></script>
	<script language="javascript" src="/html/nds/oto/js/portal.js"></script>
<!--
<script type="text/javascript" src="/html/nds/js/xloadtree111/xtree.js"></script>
<script type="text/javascript" src="/html/nds/js/xloadtree111/xmlextras.js"></script>
<script type="text/javascript" src="/html/nds/js/xloadtree111/xloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/html/nds/js/xloadtree111/xtree.css" />
-->
<script language="javascript" src="/html/nds/oto/js/objdropmenu.js"></script>
<script language="javascript" src="/html/nds/oto/js/formkey.js"></script>
<!--script type="text/javascript" src="/html/nds/js/selectableelements.js"></script>
<script type="text/javascript" src="/html/nds/js/selectabletablerows.js"></script-->
<!--script language="javascript" src="/html/js/dragdrop/coordinates.js"></script>
<script language="javascript" src="/html/js/dragdrop/drag.js"></script-->
<!--script language="javascript" src="/html/js/dragdrop/dragdrop.js"></script-->
<!--script language="javascript" src="/html/nds/js/calendar.js"></script-->
<script language="javascript" src="/html/nds/oto/js/jdate/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<!--script language="javascript" src="/html/nds/js/alerts.js"></script-->
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/oto/js/init_objcontrol_<%=locale.toString()%>.js"></script>
<script language="javascript" src="/html/nds/oto/js/objcontrol.js"></script>
<script language="javascript" src="/html/nds/oto/js/obj_ext.js"></script>
<script language="javascript" src="/html/nds/oto/js/gridcontrol.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/object_query.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-ui-1.8.21.custom.min.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/jplay/jquery.jplayer.min.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/jqzoom/jquery.jqzoom-core.js"></script>
<script language="javascript" src="/html/nds/oto/js/potips/jquery.poshytip.js"></script>
<script language="javascript" src="/html/nds/oto/js/ckedit/ckeditor/ckeditor.js"></script>

<!--script language="javascript" src="/html/nds/js/artdialog/artDialog.js"></script-->
<!--link type="text/css" rel="stylesheet" href="/html/nds/js/artdialog/skin/chrome.css" /-->
<!--link type="text/css" rel="StyleSheet" href="/html/nds/oto/themes/01/css/jquery-ui-1.7.3.custom.css" /-->
<!--link type="text/css" rel="stylesheet" href="/html/nds/css/nds_header.css"-->
<!--<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/objdropmenu.css">-->
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/themes/01/css/cb2.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/nds_portal.css">
<!--<link type="text/css" rel="StyleSheet" href="/html/nds/oto/themes/01/css/custom-ext.css" />-->
<!--link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/ui.tabs.css"-->
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/aple_menu.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/object.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/js/jqzoom/css/jquery.jqzoom.css"/>
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/js/potips/tip-yellowsimple/tip-yellowsimple.css">
<!--link type="text/css" rel="stylesheet" href="/html/nds/js/artdialog4/skins/chrome.css" /-->
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/js/jdate/My97DatePicker/skin/WdatePicker.css"/>
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/js/prg/upload/uploadify.css">

<script language="javascript" src="/html/nds/oto/js/customfold.js"></script>
<!--script language="javascript" src="/html/nds/oto/js/spacification.js"></script-->
<script language="javascript" src="/html/nds/oto/js/customtree.js"></script>
<script language="javascript" src="/html/nds/oto/js/webrootupload.js"></script>
<%}%>
<!--script type="text/javascript" src="/flash/FABridge.js"></script>
<script type="text/javascript" src="/flash/playErrorSound.js"></script-->

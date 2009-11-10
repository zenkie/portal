<%@ page language="java"  pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" %>
<%@page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.fckeditor.net" prefix="FCK" %>
<%
    int m_box_id=Integer.parseInt(request.getParameter("id"));
    if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
        response.sendRedirect("/c/portal/login");
        return;
    }
    if(!userWeb.isActive()){
        session.invalidate();
        com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
        response.sendRedirect("/login.jsp");
        return;
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link href="zh.css" rel="stylesheet" type="text/css" />
    <link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/object_aio_min.css">
    <script language="javascript" language="javascript1.5" src="/html/nds/js/ieemu.js"></script>
    <script language="javascript" src="/html/nds/js/prototype.js"></script>
    <script language="javascript" src="/html/nds/js/print.js"></script>
    <script language="javascript" src="/html/nds/js/cb2.js"></script>
    <script language="javascript" src="/html/nds/js/jquery1.2.3/jquery.js"></script>
    <script language="javascript" src="/html/nds/js/jquery1.2.3/hover_intent.js"></script>
    <script>
        jQuery.noConflict();
    </script>
    <script language="javascript" src="/html/js/sniffer.js"></script>
    <script language="javascript" src="/html/js/ajax.js"></script>
    <script language="javascript" src="/html/js/util.js"></script>
    <script language="javascript" src="/html/js/portal.js"></script>
    <script language="javascript" src="/html/nds/js/objdropmenu.js"></script>
    <script language="javascript" src="/html/nds/js/top_css_ext.js"></script>
    <script language="javascript" src="/html/nds/js/formkey.js"></script>
    <script type="text/javascript" src="/html/nds/js/selectableelements.js"></script>
    <script type="text/javascript" src="/html/nds/js/selectabletablerows.js"></script>
    <script language="javascript" src="/html/js/dragdrop/coordinates.js"></script>
    <script language="javascript" src="/html/js/dragdrop/drag.js"></script>
    <script language="javascript" src="/html/js/dragdrop/dragdrop.js"></script>
    <script language="javascript" src="/html/nds/js/calendar.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
    <script language="javascript" src="/html/nds/js/application.js"></script>
    <script language="javascript" src="/html/nds/js/alerts.js"></script>
    <script language="javascript" src="/box/oc.js"></script>
    <script language="javascript" src="/html/nds/js/dw_scroller.js"></script>
    <script type="text/javascript" src="/html/nds/js/init_object_query_zh_CN.js"></script>
    <script language="javascript" src="/html/nds/js/init_objcontrol_zh_CN.js"></script>
    <script language="javascript" src="/html/nds/js/obj_ext.js"></script>
    <script type="text/javascript" src="/box/ztools.js"></script>
    <script type="text/javascript" src="/box/box.js"></script>
    <title>检货装箱单</title>
</head>
<body class="body-bg">
<script language="javascript">
    jQuery(document).ready(function(){box.load()});
    jQuery(document).ready(function(){box.loadBox();});
</script>

<input id="m_box_id" type="hidden" value="<%=m_box_id%>" >
<div id="zh-container">
<div id="zh-btn">
<input name="" type="image" src="images/btn-bc.gif" width="58" height="20"  onclick="box.toSave();"/>
<input name="" type="image" src="images/btn-sc.gif" width="58" height="20" onclick="box.del();"/>
<input name="" type="image" src="images/btn-td.gif" width="78" height="20" onclick="box.doSaveSettings();"/>
<input name="" type="image" src="images/btn-dy.gif" width="78" height="20" onclick="box.getBoxNoId();"/>
<input name="" type="image" src="images/btn-zx.gif" width="78" height="20" onclick="box.toSave('T');"/>
<input name="" type="image" src="images/btn-ck.gif" width="78" height="20" onclick="popup_window('/html/nds/object/object.jsp?table=14928&id=<%=m_box_id%>&fixedcolumns=','_blank')"/>
<input name="" type="image" src="images/btn-jh.gif" width="101" height="20" onclick="box.doPrint();"/>
<input name="" type="image" src="images/btn-gb.gif" width="58" height="20" onclick="box.closePop()"/>
<input type="hidden" id="status" value=""/>
<input type="hidden" id="customer" value="jz">
</div>
<div id="zh-main">
<table width="977" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="8" height="395" valign="top"><img src="images/main-left-bg01.gif" width="8" height="395" /></td>
    <td width="961" valign="top" background="images/main-center-bg01.gif">
	<div id="zh-table">
	<table width="940" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>
    <td class="zh-desc" width="80" valign="top" nowrap="" align="right"><div class="desc-txt">单号：</div></td>
    <td class="zh-value" width="130" valign="top" nowrap="" align="left"><input class="ipt-4-2" readonly="" id="docon" name="" type="text" style="border:0"/></td>
    <td class="zh-desc" width="80" valign="top" nowrap="" align="right"><div class="desc-txt">单据类型：</div></td>
    <td class="zh-value" width="130" valign="top" nowrap="" align="left"><input readonly="" class="ipt-4-2" id="tableType" name="" type="text" style="border:0"/></td>
    <td class="zh-desc" valign="top" nowrap="" align="right" width="80"><div class="desc-txt">备注：</div></td>
    <td align="left" valign="top" nowrap="" class="zh-value" width="540"><input class="ipt-4-440" name="" type="text" /></td>
  </tr>
   <tr>
       <td colspan="6" width="500">&nbsp;</td>
   </tr>
</table>
			</div>
			<div class="zh-height"></div>
			<div id="zh-table">
			<div id="zh-from-left">
			<div id="zh_left_lb" style="display:none;">
			<div id="zh-left-lb-title" class="zh-left-lb-title">分类标识</div>
			<div id="zh-lb">
			<ul id="destination">
			</ul>
			</div>
			</div>
			</div>
            <DIV STYLE="margin-left:40px">
			<div id="zh-from-left01">
			<div  class="zh-left-lb-title">箱号</div>
                <div id="zh-xh" style="overflow-y:auto;overflow-x:hidden;">
                </div>
                 <div class="zh-xh-height"><input type="button" value="增加" onclick="box.addBox($('selCategory').value);"  class="cbutton"/><input type ="button" value="删除" onclick="box.delBox($('selCategory').value)"  class="cbutton"/></div>
			</div>
            <div class="zh-from-left02">
                <table width="99%"  border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#8db6d9" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF" bgcolor="#8db6d9" class="modify_table" style="table-layout:fixed;">
                    <col width="40">
                    <col width="142">
                    <col width="142">
                    <col width="130">
                    <col width="130">
                    <col width="auto">
                    <tr>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">序号</div></th>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">款号</div></th>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">成品名</div></th>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">色号</div></th>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">尺寸</div></th>
                        <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">扫描数量</div></th>
                    </tr>
                </table>
            </div>
            <div id ="showContent">
			</div>
            </div>
            </div> 
			</td>
    <td width="8" valign="top"><img src="images/main-right-bg.gif01" width="8" height="395" /></td>
  </tr>
</table>
 <input type="hidden" id="isSaved">
</div>
<div class="zh-height"></div>
<div id="zh-cz-bg"><input type="hidden" id="isRecoil" value="normal"/>
<div id="zh-cz-height"><table width="600" border="0" cellspacing="1" cellpadding="0" align="center">
  <tr>
    <td class="zh-desc" width="80" valign="top" nowrap="" align="right"><div class="desc-txt">商品：</div></td>
    <td class="zh-value" width="180" valign="top" nowrap="" align="left"><input id="barcode" class="ipt-4-2" name="" type="text" onkeydown="cstable.handlerMe(event);"/></td>
    <td class="zh-desc" width="100" valign="top" nowrap="" align="right"><div class="desc-txt" >数量：</div></td>
    <td class="zh-value" width="180" valign="top" nowrap="" align="left"><input id="pdt_count" type="text" class="ipt-4-2" value="1" onblur="box.checkIsNum(event)" /></td>
    <td width="180"><nobr><input name="isRecoil" type="radio" value="normal" checked onclick="$('isRecoil').value='normal';"/>扫描&nbsp;<input name="isRecoil" type="radio" value="recoil" onclick="$('isRecoil').value='recoil';" />反冲</nobr></td>
   </tr>
</table></div>
</div>
</div>
<iframe id="print_iframe" name="print_iframe" width="1" height="1" src="/html/common/null.html"></iframe>
<div id="forCode" style="cursor:default;display:none;border: 1px solid rgb(0, 0, 0);background-color:white;width:200px; max-height:460px;z-index:99;" tabindex='0'></div>
<div id="dialouge" class="pop-up-outer" align="center" style="position:absolute;top:18%;left:18%;z-index:101;background-color:#FFFFFF;display:none;opacity:1;WIDTH:650px;;height:auto;">
        <table class="pop-up-header" cellspacing="0" cellpadding="0" border="0">
            <tr><td id="pop-up-title-0" class="pop-up-title" width="99%" align="left"></td>
                <td class="pop-up-close" width="1%">
                    <a onclick="cstable.removeMask();" title="Close" href="javascript:void(0)">
                        <img border="0" src="/html/nds/images/close.gif"/></a>
                </td></tr>
        </table>
        <div id="stock_table" style="OVERFLOW: auto;width:100%;width:auto; max-height:300px;text-align:left;">
        </div>
        <div style="float:left;margin-left:8px;margin-top:5px;margin-bottom:5px;">
            <input id="but_J" class="command2_button" type="button" accesskey="J" value="保存(J)" name="createinstances" onclick="cstable.saveData();"/>
            <input id="but_Q" class="command2_button" type="button" accesskey="Q" value="取消(Q)" name="cancel" onclick="cstable.removeMask();"/>
        </div>
</div>
<div id="submitImge" style="left:30px;top:80px;z-index:111;position:absolute;display:none;">
    <img src="/html/nds/images/submitted.gif"/>
</div>
<div id="alert-message" style="position:absolute;top:0pt;left:0pt;z-index:100;background-color:#000000;opacity:0.51;filter:alpha(opacity=41);height:100%;width:100%;display:none;" />
</body>
</html>
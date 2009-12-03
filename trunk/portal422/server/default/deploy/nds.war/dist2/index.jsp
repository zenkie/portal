<%@ page language="java"  pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://java.fckeditor.net" prefix="FCK" %>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    String idS=request.getParameter("id");
    int id=-1;
    if (idS != null) {
        id=Integer.parseInt(idS);
    }
    if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
        /*session.invalidate();
        com.liferay.util.servlet.SessionErrors.add(request,PrincipalException.class.getName());
        response.sendRedirect("/login.jsp");*/
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>配货单</title>
    <link rel="Shortcut Icon" href="/html/nds/images/portal.ico" />
    <script language="javascript" src="/html/nds/js/top_css_ext.js"></script>
    <script language="javascript" language="javascript1.5" src="/html/nds/js/ieemu.js"></script>
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
    <script language="javascript" src="/html/nds/js/objdropmenu.js"></script>
    <script language="javascript" src="/html/nds/js/formkey.js"></script>
    <script type="text/javascript" src="/html/nds/js/selectableelements.js"></script>
    <script type="text/javascript" src="/html/nds/js/selectabletablerows.js"></script>
    <script language="javascript" src="/html/js/dragdrop/coordinates.js"></script>
    <script language="javascript" src="/html/js/dragdrop/drag.js"></script>
    <script language="javascript" src="/html/nds/js/calendar.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
    <script language="javascript" src="/html/nds/js/application.js"></script>
    <script language="javascript" src="/html/nds/js/alerts.js"></script>
    <script language="javascript" src="/html/nds/js/dw_scroller.js"></script>
    <script type="text/javascript" src="/html/nds/js/init_object_query_zh_CN.js"></script>
    <script language="javascript" src="/html/nds/js/init_objcontrol_zh_CN.js"></script>
    <script language="javascript" src="/html/nds/js/obj_ext.js"></script>
    <script language="javascript" src="/html/nds/js/gridcontrol.js"></script>
    <script type="text/javascript" src="/html/nds/js/object_query.js"></script>
    <script language="javascript" src="dist2.js"></script>
    <link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/header_aio_min.css">
    <link typ e="text/css" rel="stylesheet" href="/html/nds/css/nds_header.css">
    <link href="ph.css" rel="stylesheet" type="text/css"/>
</head>
<% if(id!=-1){ %>
<script language="javascript">
    jQuery(document).ready(function(){dist.reShow();});
</script>
<%}%>
<body class="body-bg">
<div id="ph-btn">
	<div id="ph-from-btn">
        <input type="hidden" id="load_type" value="<%=id==-1?"load":"reload"%>"/>
        <input type="hidden" id="fund_balance" value="<%=id!=-1?id:""%>"/>
        <input type="hidden" id="isChanged" value="false">
        <input type="hidden" id="orderStatus" value="1"/>
        <input type="image" name="imageField" src="images/ph-btn-zj.gif"  onclick="dist.showObject('fund_balance.jsp',710,250)"/>
        <input type="image" name="imageField2" src="images/ph-btn-ph.gif" onclick="dist.autoDist();" />
        <input type="image" name="imageField4" src="images/ph-btn-xz.gif" onclick="window.location='/dist2/index.jsp?&&fixedcolumns=&id=-1';"/>
        <input type="image" name="imageField3" src="images/ph-btn-bc.gif" onclick="dist.saveDate('sav');"/>
        <input type="image" name="imageField4" src="images/ph-btn-dj.gif" onclick="dist.saveDate('ord');"/>
        <input type="image" name="imageField4" src="images/ph-btn-gb.gif" onclick="window.close();"/>
    </div>
</div>
<div id="ph-container">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td colspan="2" background="images/ph-pic-bg.gif"><div id="ph-serach">
  <div id="" class="djh-table">
      <table width="660" border="0" cellspacing="1" cellpadding="0" class="obj" align="left">
    <tr>
      <td width="100" align="right" valign="top" nowrap="nowrap" class="ph-desc"><div class="desc-txt">订单号<font color="red">*</font>：</div></td>
        <td nowrap="" align="left" width="16%" valign="top" class="ph-value">
            <input type="text" value="" id="column_40252" readonly="true" class="ipt-4-2" size="20" maxlength="80" tabindex="1" name="b_so_id__docno"/>
            <input type="hidden" value="" name="B_SO_ID" id="fk_column_40252"/>
            <span onaction="oq.toggle('/html/nds/query/search.jsp?table=12943&amp;return_type=s&amp;column=40252&amp;accepter_id=column_40252&amp;qdata='+encodeURIComponent(document.getElementById('column_40252').value)+'&amp;queryindex=','column_40252')" id="cbt_40252" class="coolButton"><img height="16" border="0" align="absmiddle" width="16" title="Find" src="/html/nds/images/find.gif"/></span>
            <script>
                createButton(document.getElementById("cbt_40252"));
            </script>
        </td>
      <td class="ph-value" width="100" valign="top" nowrap="nowrap" align="left"><div class="desc-txt">店仓<font color="red">*</font>：</div></td>
        <td class="ph-value" width="160" valign="top" nowrap="nowrap" align="left"><input type='hidden' id='column_26993' name="column_26993" value=''>
            <input name="" readonly type="text" class="ipt-4-2" id='column_26993_fd' value="" >
            <span  class="coolButton" id="column_26993_link" title=popup onaction="dist.getCustomId();"><img id='column_26993_img' width="16" height="16" border="0" align="absmiddle" title="Find" src="images/filterobj.gif"/></span>
            <script type="text/javascript" >createButton(document.getElementById('column_26993_link'));</script>
        </td>
        <td class="ph-value" width="80" valign="top" nowrap="" align="left"><%if(id==-1){%><input type="image" name="imageField5" src="images/btn-search01.gif" onclick="dist.queryObject()" /><%}%>
        </td>
         <td width="100" align="right" valign="top" nowrap="nowrap" class="ph-desc">
            <div class="desc-txt" align="right" style="color:blue;">物流备注*：</div>
        </td>
        <td nowrap="" align="left" valign="top" class="ph-value" colspan="2">
            <input type="text" class="notes" id="notes" name="canModify"/>
        </td>
    </tr>
  </table>
  </div>
<div id="ph-pic">
<div id="ph-pic-img">
             <div id="ph-pic-img-width">
			<div id="ph-pic-img-border"><img src="images/img.jpg" width="90" height="75" /></div>
			<div id="ph-pic-img-txt"></div>
			</div></div>
<div id="ph-pic-left">
			<div id="ph-pic-txt">
			<ul>
			<li>
			<div class="left">可&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="totStyleCan"></div>
			</li>
			<li>
			<div class="left">未&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="totStyleRem"></div>
			</li>
			<li>
			<div class="left-red">当前已配：</div>
			<div class="right-red" id="totStyleAlready"></div>
			</li>
			</ul>
			</div>
	  </div>
<div id="ph-pic-right">
			<div id="ph-pic-txt">
			<ul>
			<li>
			<div class="left">未&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="barcodeRem"></div>
			</li>
			<li>
			<div class="left-red">当前已配：</div>
			<div class="right-red" id="barcodeAlready"></div>
			</li>
			</ul>
			</div>
	  </div>
</div>
</div></td>
</tr>
  <tr>
    <td colspan="2"><div class="ph-height"></div></td>
  </tr>
  <tr>
    <td valign="top" width="1%" align="left">
<div id="ph-from-left">
<div id="ph-from-left-bg">
<div class="left-search">
			  <div><input name="textfield" type="text" class="left-search-input" id="quickSearch"/></div>
		  </div>
			<div id="left-section-height"></div>
<div id="left-section">
              <ul id="styleManu">
              </ul>
		  </div>
</div>
</div></td>
    <td valign="top" width="99%" align="left">
        <div class="ph-from-right">
            <div id="ph-from-right-border">
<div id="ph-from-right-b">
  <div id="ph-from-right-table">
  </div>
  <div class="ph-height"></div>
	  </div>
</div></div></td>
  </tr>
</table>
</div>
<div id="submitImge" style="left:30px;top:80px;z-index:111;position:absolute;display:none;">
    <img src="/html/nds/images/submitted.gif"/>
</div>
</body>
</html>
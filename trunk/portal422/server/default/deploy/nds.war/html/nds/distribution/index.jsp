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
<link href="ph.css" rel="stylesheet" type="text/css" />

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
<script language="javascript" src="/html/js/dragdrop/dragdrop.js"></script>
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
<script language="javascript" src="/html/nds/js/distribution.js"></script>
<script language="javascript" src="/html/nds/js/xml2json.js"></script>
<link type="text/css" rel="stylesheet" href="/html/nds/css/nds_header.css">
<link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/objdropmenu.css">
<link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/css/cb2.css">
<link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/nds_portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/themes/classic/01/css/custom-ext.css" />
<link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/ui.tabs.css">
</head>

<body>
<iframe id="CalFrame" name="CalFrame" frameborder=0 src=/html/nds/common/calendar.jsp style="display:none;position:absolute; z-index:99999"></iframe>
<table width="1003" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="8" height="9" valign="top"><img src="images/ph-top-leftbg.gif" width="8" height="9" /></td>
    <td width="986" valign="top" background="images/ph-top-centerbg.gif"></td>
    <td width="9" height="9" valign="top"><img src="images/ph-top-rightbg.gif" width="9" height="9" /></td>
  </tr>
  <tr>
    <td valign="top"><img src="images/ph-center-leftbg.gif" width="8" height="598" /></td>
    <td valign="top" background="images/ph-center-centerbg.gif">

	<table width="986" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><table width="986" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="14" height="27"><img src="images/ph-title-left.gif" width="14" height="27" /></td>
            <td width="958" background="images/ph-title-center.gif">
			<div id="ph-head">
			<div id="ph-head-right"><SCRIPT language=javascript>
<!--
function initArray()
{

  for(i=0;i<initArray.arguments.length;i++)

  this[i]=initArray.arguments[i];

 }

var isnMonths=new initArray("01月","02月","03月","04月","05月","06月","07月","08月","09月","10月","11月","12月");

 var isnDays=new initArray("星期日","星期一","星期二","星期三","星期四","星期五","星期六","星期日");

 today=new Date();

 hrs=today.getHours();

 min=today.getMinutes();

 sec=today.getSeconds();

 clckh=""+((hrs>12)?hrs-12:hrs);

 clckm=((min<10)?"0":"")+min;clcks=((sec<10)?"0":"")+sec;

 clck=(hrs>=12)?"下午":"上午";

 var stnr="";

 var ns="0123456789";

 var a="";

function getFullYear(d)

{

  yr=d.getYear();if(yr<1000)

  yr+=1900;return yr;}

  document.write("<table align=\"center\">");

  document.write("<TR><TD>"+getFullYear(today)+"年"+isnMonths[today.getMonth()]+""+today.getDate()+"日 "+isnDays[today.getDay()]+"</TD></TR>");

document.write("</table>");

//-->
</SCRIPT>
        </div>
			<div id="ph-head-left"></div>
			</div>
			</td>
            <td><img src="images/ph-title-right.gif" width="14" height="27" /></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="3"></td>
      </tr>
      <tr>
        <td><table width="986" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="14" height="92" valign="top"><img src="images/ph-search-left.gif" width="14" height="92" /></td>
            <td width="958" valign="top" background="images/ph-search-center.gif">
			<div id="ph-serach">
			<div id="ph-serach-title">查询条件</div>
			<div id="" class="obj">
			<table width="900" border="0" cellspacing="1" cellpadding="0" class="obj" align="center">
  <tr>
    <td class="ph-desc" width="80" valign="top" nowrap="" align="right"><div class="desc-txt">订单类型<font color="red">*</font>：</div></td>
    <td class="ph-value" width="180" valign="top" nowrap="" align="left"><select id="column_26991" class="objsl" tabindex="1" name="doctype">
<option value="0">--请选择--</option>
<option value="FWD">期货订单</option>
<option value="INS">现货订单</option>
<option selected="selected" value="ALL">全部</option>
</select></td>

      <!--发货店仓-->
      <td class="ph-desc" width="100" valign="top" nowrap="" align="right"><div class="desc-txt">发货店仓<font color="red">*</font>：</div></td>
      <td class="ph-value" width="180" valign="top" nowrap="" align="left"><input name="c_orig_id__name" type="text" class="ipt-4-2"  id="column_26992"  value="" />
                <input type="hidden" id="fk_column_26992" name="C_ORIG_ID" value="">
            <span  class="coolButton" id="cbt_26992" onaction="oq.toggle('/html/nds/query/search.jsp?table=14610&return_type=s&column=26992&accepter_id=column_26992&qdata='+encodeURIComponent(document.getElementById('column_26992').value)+'&queryindex='+encodeURIComponent(document.getElementById('queryindex_-1').value),'column_26992')">
                <img width="16" height="16" border="0" align="absmiddle" title="Find" src="images/find.gif"/>
      </span>
         <script type="text/javascript" >createButton(document.getElementById("cbt_26992"));</script>
      </td>

      <!--收货店仓--> 
    <td class="ph-desc" width="100" valign="top" nowrap="" align="right"><div class="desc-txt">收货店仓<font color="red">*</font>：</div></td>
    <td class="ph-value" width="180" valign="top" nowrap="" align="left">
        <input type='hidden' id='column_26993' name="column_26993" value=''>

        <input name="" readonly type="text" class="ipt-4-2" id='column_26993_fd' value="" >
        <span  class="coolButton" id="column_26993_link" title=popup onaction="oq.toggle_m('/html/nds/query/search.jsp?table=C_V_STORE2&return_type=f&accepter_id=column_26993', 'column_26993');">
                <img id='column_26993_img' width="16" height="16" border="0" align="absmiddle" title="Find" src="images/filterobj.gif"/>
        </span>
         <script type="text/javascript" >createButton(document.getElementById('column_26993_link'));</script>
    </td>
      
    <td class="ph-value" width="80" valign="top" nowrap="" align="left">&nbsp;</td>
    </tr>
  <tr>
      <!--选择款号-->
    <td class="ph-desc" width="80" valign="top" nowrap="" align="right"><div class="desc-txt">选择款号<font color="red">*</font>：</div></td>
    <td class="ph-value" width="180" valign="top" nowrap="" align="left">
        <input type='hidden' id='column_26994' name="product_filter" value=''>
        <input type="text" class="ipt-4-2"  readonly id='column_26994_fd' value="" />
        <span  class="coolButton" id="column_26994_link" title=popup onaction="oq.toggle_m('/html/nds/query/search.jsp?table='+'m_product'+'&return_type=f&accepter_id=column_26994', 'column_26994');">
            <img id='column_26994_img' width="16" height="16" border="0" align="absmiddle" title="Find" src="images/filterobj.gif"/>
        </span>
        <script type="text/javascript" >createButton(document.getElementById('column_26994_link'));</script>
    </td>

    <!--起止时间-->
      <%
          Date tody=new Date();
          SimpleDateFormat fmt=new SimpleDateFormat("yyyyMMdd");
          String end=fmt.format(tody);
         String st=(Long.parseLong(end)-10l)+"";
      %>
    <td class="ph-desc" width="100" valign="top" nowrap="" align="right"><div class="desc-txt"> 订单时间(起)<font color="red">*</font>：</div></td>
    <td class="ph-value" width="180" valign="top" nowrap="" align="left">
        <input type="text" class="ipt-4-2" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26995" value="<%=st%>" />
        <span  class="coolButton">
            <a onclick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar23',false,'column_26995',null,null,true);"><img id="imageCalendar23" width="16" height="18" border="0" align="absmiddle" title="Find" src="images/datenum.gif"/> </a>
        </span>
    </td>
    <td class="ph-desc" width="100" valign="top" nowrap="" align="right"><div class="desc-txt">订单时间(止)<font color="red">*</font>：</div></td>
    <td class="ph-value" width="180" valign="top" nowrap="" align="left">
        <input name="billdateend" type="text"  class="ipt-4-2" maxlength="10" size="20" title="8位日期，如20070823" id="column_269966"  value="<%=end%>"/>
        <span  class="coolButton">
            <a onclick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar144',false,'column_269966',null,null,true);">
                <img id='imageCalendar144' width="16" height="18" border="0" align="absmiddle" title="Find" src="images/datenum.gif"/>
            </a>
        </span>
    </td>

   <!--查询条件提交按钮-->   
    <td class="ph-value" width="80" valign="top" nowrap="" align="left"><input type="image" name="imageField5" src="images/btn-search01.gif" onclick="dist.queryObject()" />
    </td>

  </tr>
</table>
			</div>
			</div>
			</td>
            <td valign="top"><img src="images/ph-search-right.gif" width="14" height="92" /></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="2"></td>
      </tr>
      <tr>
        <td><table width="986" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="14" valign="top"><img src="images/ph-pic-left.gif" width="14" height="124" /></td>
            <td width="958" valign="top" background="images/ph-pic-center.gif">
			<div id="ph-pic">
			  <div id="ph-pic-img"> 
			<div id="ph-pic-img-border"><img id="pdt-img" width="90" height="84" /></div>
			<div id="ph-pic-img-txt"></div>
			</div>
			<div id="ph-pic-left">
			<div id="ph-pic-left-bg01">
			<div id="ph-pic-txt">
			<ul>
			<li>
			<div class="left">可&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="tot-can"></div>
			</li>
			<li>
			<div class="left">未&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="tot-rem"></div>
			</li>
			<li>
			<div class="left-red">当前已配：</div>
			<div class="right-red" id="tot-ready"></div>
			</li>
			</ul>
			</div>
			</div>
			</div>
			<div id="ph-pic-left">
			<div id="ph-pic-left-bg02">
			<div id="ph-pic-txt">
			<ul>
			<li>
			<div class="left">可&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="input-5"></div>
			</li>
			<li>
			<div class="left">未&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="input-4"></div>
			</li>
			<li>
			<div class="left-red">当前已配：</div>
			<div class="right-red" id="input-2" ></div>
			</li>
			</ul>
			</div>
			</div>
			</div>
			<div id="ph-pic-right">
			<div id="ph-pic-right-bg03">
			<div id="ph-pic-txt">
			<ul>
			<li>
			<div class="left">未&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;配：</div>
			<div class="right" id="rs"></div>
			</li>
			<li>
			<div class="left-red">当前可配：</div>
			<div class="right-red" id="input-1"></div>
			</li>
			</ul>
			</div>
			</div>
			</div>
			</div>
			</td>
            <td valign="top"><img src="images/ph-pic-right.gif" width="14" height="124" /></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td><table width="986" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="185" valign="top" background="images/ph-from-bg.gif">
			<div id="ph-from-left">
			<div id="ph-from-left-searchbg">
			<div class="left-search">
			  <div><input name="textfield" type="text" class="left-search-input" id="pdt-search" onkeyup="dist.pdt_search()" /></div>
			  
			</div>
			</div>
			<div id="ph-from-height"></div>
			<div id="ph-from-left-sectionbg">
			<div id="left-section-height"></div>
			<div id="left-section">
			<ul id="category_manu" >
			</ul>
			</div>
			</div>
			</div>
			</td>
            <td width="801" valign="top" bgcolor="#FFFFFF">
			<div id="ph-from-right">
			<div id="ph-from-right-table">
			</div>
			</div>
			</td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td><table width="986" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="14" height="39" valign="top"><img src="images/ph-footer-left.gif" width="14" height="39" /></td>
            <td width="958" valign="middle" background="images/ph-footer-center.gif">
			<div id="ph-footer">
			<div id="ph-footer-right">
              <input type="hidden" id="fund_balance" value=""/> 
			  <input type="image" name="imageField" src="images/ph-btn-zj.gif"  onclick="dist.showObject('fund_balance.jsp',710,295)"/>
			  <input type="image" name="imageField2" src="images/ph-btn-ph.gif" onclick="dist.showObject('auto_dist.jsp',450,281)" />
			  <input type="image" name="imageField3" src="images/ph-btn-bc.gif" />
			  <input type="image" name="imageField4" src="images/ph-btn-dj.gif" />
			</div>
			</div>
			</td>
            <td valign="top"><img src="images/ph-footer-right.gif" width="14" height="39" /></td>
          </tr>
        </table></td>
      </tr>
    </table>
	</td>
    <td valign="top"><img src="images/ph-center-rightbg.gif" width="9" height="598" /></td>
  </tr>
  <tr>
    <td valign="top"><img src="images/ph-bottom-leftbg.gif" width="8" height="9" /></td>
    <td valign="top" background="images/ph-bottom-centerbg.gif"></td>
    <td valign="top"><img src="images/ph-bottom-rightbg.gif" width="9" height="9" /></td>
  </tr>
</table>
<div id="obj-bottom">
<iframe id="print_iframe" name="print_iframe" width="1" height="1" src="/html/common/null.html"></iframe>
</div>
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
<table><tr><td>

   
  <script>
  	 	jQuery(document).ready(function(){dcq.createdynlist([])});
  	  var ti=setInterval("dcq.dynquery();",500);
  </script>
</td></tr></table>
</body> 
</html>

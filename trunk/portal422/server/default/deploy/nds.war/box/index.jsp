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
    String sound=userWeb.getUserOption("ALERT_SOUND","");
    String comp=String.valueOf(QueryEngine.getInstance().doQueryOne("select VALUE from AD_PARAM where NAME='portal.company'"));
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
    <script type="text/javascript" src="/flash/FABridge.js"></script>
    <script type="text/javascript" src="/flash/playErrorSound.js"></script>
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
<%if(!sound.equals("")){%>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
        id="playErrorSoundTest" width="1" height="1"
        codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab" style="float:right">
    <param name="movie" value="/flash/playErrorSound.swf"/>
    <param name="flashvars" value="bridgeName=b_playErrorSound"/>
    <param name="quality" value="high" />
    <param name="allowScriptAccess" value="sameDomain"/>
    <embed src="/flash/playErrorSound.swf" quality="high"
           width="1" height="1" name="playErrorSoundTest"
           align="middle"
           play="true"
           loop="false"
           quality="high"
           allowScriptAccess="sameDomain"
           type="application/x-shockwave-flash"
           pluginspage="http://www.adobe.com/go/getflashplayer"
           flashvars="bridgeName=b_playErrorSound">
    </embed>
</object>
<input type="hidden" id="sound" value="<%=sound%>"/>
<%}%>
<input id="m_box_id" type="hidden" value="<%=m_box_id%>"/>
<div id="zh-container">
    <div id="zh-btn">
        <input name="" type="image" src="images/btn-bc.gif" width="58" height="20"  onclick="box.toSave();"/>
        <input name="" type="image" src="images/btn-sc.gif" width="78" height="20" onclick="box.del();"/>
        <%if(!comp.equals("玖姿")){%>
        <input type="button" value="打印含汇总箱单" width="91" id="box-button" onclick="box.doSaveSettings('cx778');"/>
        <input type="button" value="单箱打印" id="box-button1" width="78" height="20" onclick="box.savePrintSettingForSingleBox('cx662');"/>
        <input name="" type="image" src="images/btn-td.gif" width="78" height="20" onclick="box.doSaveSettings('cx663');"/>
        <%}else{%>
        <input name="" type="image" src="images/btn-dy.gif" width="78" height="20" onclick="box.doSaveSettings('cx663');"/>
        <input type="button" value="按单打印" width="60" id="box-button1" onclick="box.doSaveSettings('cx776');"/>
        <%}%>
        <input name="" type="image" src="images/btn-zx.gif" width="78" height="20" onclick="box.toSave('T');"/>
        <input name="" type="image" src="images/btn-ck.gif" width="78" height="20" onclick="popup_window('/html/nds/object/object.jsp?table=14928&id=<%=m_box_id%>&fixedcolumns=','_blank')"/>
        <input name="" type="image" src="images/btn-gb.gif" width="58" height="20" onclick="box.closePop()"/>
        <input type="hidden" id="status" value=""/>
        <%if(comp.equals("玖姿")){%><input type="hidden" id="customer" value="jz"><%}%>
    </div>
    <div id="zh-main">
        <table  border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="8" height="395" valign="top"><img src="images/main-left-bg<%if(comp.equals("玖姿")){%>01<%}%>.gif" width="8" height="395" /></td>
                <td  valign="top" background="images/main-center-bg<%if(comp.equals("玖姿")){%>01<%}%>.gif">
                    <div id="zh-table">
                        <table  border="0" cellspacing="1" cellpadding="0" align="center">
                            <tr>
                                <td class="zh-desc" width="50" valign="top" nowrap="" align="right"><div class="desc-txt">单号：</div></td>
                                <td class="zh-value" width="130" valign="top" nowrap="" align="left"><input class="ipt-4-2" readonly="" id="docon" name="" type="text" style="border:0"/></td>
                                <td class="zh-desc" width="70" valign="top" nowrap="" align="right"><div class="desc-txt">单据类型：</div></td>
                                <td class="zh-value" width="130" valign="top" nowrap="" align="left"><input readonly="" class="ipt-4-2" id="tableType" name="" type="text" style="border:0"/></td>
                                <%if(comp.equals("玖姿")){%>
                                <td class="zh-desc" valign="top" nowrap="" align="right" width="80"><div class="desc-txt">备注：</div></td>
                                <td align="left" valign="top" nowrap="" class="zh-value" width="450"><input class="ipt-4-440" id="desc" name="" type="text" /></td>
                            </tr>
                            <tr>
                                <td colspan="6" width="500">&nbsp;</td>
                            </tr>
                            <%}else{%>
                            <td class="zh-desc" width="70" valign="top" nowrap="" align="right"><div class="desc-txt">装箱规则：</div></td>
                            <td class="zh-value" width="130" valign="top" nowrap="" align="left">
                                <select id="boxRule" class="objsl" tabindex="1" name="doctype">
                                    <option value="0">--请选择--</option>
                                    <option selected="true" value="DES">按目的地装箱</option>
                                    <option value="ORD">按单装箱</option>
                                </select>
                            </td>
                            <td class="zh-desc" width="70" valign="top" nowrap="" align="left"><div class="desc-txt">收货地址：</div></td>
                            <td class="zh-value" width="230" valign="top" nowrap="" align="left"><input id="address" readonly="" class="ipt-4-220" name="" type="text" style="border:0" /></td>
                            </tr>
                            <tr>
                                <td class="zh-desc" valign="top" nowrap="" align="right" width="70"><div class="desc-txt">备注：</div></td>
                                <td colspan="5" align="left" valign="top" nowrap="" class="zh-value" width="450"><input class="ipt-4-440" id="desc" name="" type="text" /></td>
                                <td class="zh-desc" valign="top" nowrap="" align="left" width="70">&nbsp;</td>
                                <td class="zh-value" valign="top" nowrap="" align="left" width="230">&nbsp;</td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                    <div class="zh-height"></div>
                    <div id="zh-table">
                        <div id="zh-from-left">
                            <div id="zh_left_lb" <%if(comp.equals("玖姿")){%>style="display:none;"<%}%>>
                                <div id="zh-left-lb-title" class="zh-left-lb-title">分类标识</div>
                                <div id="zh-lb">
                                    <ul id="destination">
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <%if(comp.equals("玖姿")){%><DIV><%}%>
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
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title"></div></th>
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">款号</div></th>
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">品名</div></th>
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">色号</div></th>
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">尺寸</div></th>
                                    <th  bgcolor="#8db6d9" class="table-title-bg"><div class="td-title">扫描数量</div></th>
                                </tr>
                            </table>
                        </div>
                        <div id ="showContent">
                        </div>
                        <%if(comp.equals("玖姿")){%></div><%}%>
                    </div>
                </td>
                <td width="8" valign="top"><img src="images/main-right-bg.gif" width="8" height="395" /></td>
            </tr>
        </table>
        <input type="hidden" id="isSaved"/>
    </div>
    <div class="zh-height"></div>
    <div id="zh-cz-bg"><input type="hidden" id="isRecoil" value="normal"/>
        <div id="zh-cz-height"><table width="600" border="0" cellspacing="1" cellpadding="0" align="center">
            <tr>
                <td class="zh-desc" width="80" valign="top" nowrap="" align="right">
                    <div class="desc-txt">
                        <select id="model" width="60" tabindex="1" name="doctype" onchange="if($('model').value =='pdt'){box.pdtModel()}else{box.codeModel()}">
                            <option selected="true" value="code">条码模式</option>
                            <option value="pdt">款号模式</option>
                        </select>
                    </div>
                </td>
                <td class="zh-value" width="110" valign="top" nowrap="" align="left"><input id="barcode" class="ipt-4-2" name="" type="text"/></td>
                <td class="zh-desc" width="60" valign="top" nowrap="" align="right"><div class="desc-txt" >数量：</div></td>
                <td class="zh-value" width="110" valign="top" nowrap="" align="left"><input id="pdt_count" type="text" class="ipt-4-2" value="1" onblur="box.checkIsNum(event)" /></td>
                <td width="100"><nobr><input name="isRecoil" type="radio" value="normal" checked onclick="$('isRecoil').value='normal';"/>扫描&nbsp;<input name="isRecoil" type="radio" value="recoil" onclick="$('isRecoil').value='recoil';" />反冲</nobr></td>
                <td class="zh-desc" width="140" valign="top" nowrap="" align="right"><div class="desc-txt" style="color:red;" >箱合计：</div></td>
                <td class="zh-desc" width="40" valign="top" nowrap="" align="left"><div class="desc-txt" style="text-align:left;" id="currentBox"></div>
                <td class="zh-desc" width="60" valign="top" nowrap="" align="right"><div class="desc-txt" style="color:red;" >总合计：</div></td>
                <td class="zh-desc" width="40" valign="top" nowrap="" align="left"><div class="desc-txt" style="text-align:left;" id="totBox"></div></td>
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
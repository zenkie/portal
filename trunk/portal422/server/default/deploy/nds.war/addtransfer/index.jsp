﻿<%@ page language="java"  pageEncoding="utf-8"%>
<%@ page import="java.util.Date,java.util.regex.Pattern,java.util.regex.Matcher" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="nds.control.web.UserWebImpl" %>
<%@ page import="nds.query.QueryEngine" %>
<%@ page import="nds.control.web.WebUtils" %>
<%@ page import="nds.schema.Table" %>
<%@ page import="nds.schema.TableManager" %>
<%@ page import="nds.schema.TableImpl" %>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-cache");
    response.setDateHeader("Expires", 0);
    UserWebImpl userWeb =null;
    try{
        userWeb= ((UserWebImpl)WebUtils.getSessionContextManager(session).getActor(nds.util.WebKeys.USER));
    }catch(Throwable userWebException){
        System.out.println("########## found userWeb=null##########"+userWebException);
    }
    String idS=request.getParameter("id");
    int id=-1;
    if (idS != null){
        id=Integer.parseInt(idS);
    }
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
    Table t=TableManager.getInstance().getTable("M_ADDTRANSFER");
     String directory=t.getSecurityDirectory();
    int permission=userWeb.getPermission(directory);
     if((permission&nds.security.Directory.READ)==0){
%>
<script type="text/javascript">
    document.write("<span color='red' algin='center'>您没有权限！</span>")
</script>
<%
            return;
        }
    String tableName=t.getName();
    int distributionTableId=t.getId();
    String comp=String.valueOf(QueryEngine.getInstance().doQueryOne("select VALUE from AD_PARAM where NAME='portal.company'"));
    String orgStore=String.valueOf(QueryEngine.getInstance().doQueryOne("SELECT b.ad_table_id from ad_column a,ad_column b where a.name= 'M_ALLOT.C_ORIG_ID' and a.ref_column_id=b.id"));
    String destStore=String.valueOf(QueryEngine.getInstance().doQueryOne("select a.REGEXPRESSION from ad_column a where a.name= 'M_ADDTRANSFER.STORE_FILTER'"));
    String column=String.valueOf(QueryEngine.getInstance().doQueryOne("select id from ad_column where name='M_ALLOT.B_SO_FILTER'"));
   	Pattern p=Pattern.compile("\"table\":\"(\\w+)\"");
    Matcher m=p.matcher(destStore);
    if(m.find()){
        destStore=m.group(1);
     }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>多店调拨单</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
   <!-- <script language="javascript" src="/html/nds/js/top_css_ext.js"></script>
    <script language="javascript" language="javascript1.5" src="/html/nds/js/ieemu.js"></script>
    <script language="javascript" src="/html/nds/js/cb2.js"></script>
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
    <script type="text/javascript" src="/html/nds/js/selectableelements.js"></script>
    <script type="text/javascript" src="/html/nds/js/selectabletablerows.js"></script>
    
    <script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
    <script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
    <script language="javascript" src="/html/nds/js/application.js"></script>
    <script language="javascript" src="/html/nds/js/alerts.js"></script>
    <script language="javascript" src="/html/nds/js/init_objcontrol_zh_CN.js"></script>
    <script type="text/javascript" src="/html/nds/js/object_query.js"></script>
    <script language="javascript" src="/addtransfer/addtransfer.js"></script>
   <script language="javascript" src="/html/nds/js/calendar.js"></script>
    <link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/header_aio_min.css"/>
     <link type="text/css" href="css/home.css" rel="stylesheet" />
    <link type="text/css" rel="stylesheet" href="/html/nds/css/nds_header.css"/>-->
    
     <script language="javascript" src="/html/nds/js/jdate/My97DatePicker/calendar.js"></script>
    <script language="javascript" src="/html/nds/js/portal_aio_zh_CN_min.js"></script>
<link type="text/css" rel="stylesheet" href="/html/nds/themes/classic/01/css/header_aio_min.css"/>
<script language="javascript" src="/addtransfer/addtransfer.js"></script>
<link type="text/css" href="css/home.css" rel="stylesheet" />
    <!--<link href="ph.css" rel="stylesheet" type="text/css"/>-->
   
</head>
<script language="javascript">
<% if(id!=-1){ %>
    jQuery(document).ready(function(){dist.reShow();});
<%}%>
    if(!window.document.addEventListener){
        window.document.attachEvent("onkeydown",hand11);
        function hand11()
        {
            if(window.event.keyCode==13){
                return false;
            }
        }
    }
 

</script>


<body>
	
 <input type="hidden" id="load_type" value="<%=id==-1?"load":"reload"%>"/>
 <input type="hidden" id="m_addtransfer_id" value="<%=id!=-1?id:""%>"/>
 <input type="hidden" id="showStyle" value="list">
 <input type="hidden" id="isChanged" value="false"/>
 <input type="hidden" id="orderStatus" value="1"/>
 <input type="hidden" id="diffDate" value="1"/>
 
<!--<table width="228">
  <tr>
        <td class="text-right"><a onclick="dist.saveDate('sav');" href="#"><img src="images/s1-search_15.png" /></a></td>
        <td class="text-right"><a onclick="dist.saveDate('ord');" href="#"><img src="images/s1-search_17.png" /></a></td>
        <td class="text-right"><a onclick="dist.refresh_ff_ie();" href="#"><img src="images/s1-search_20.png" /></a></td>
        <td class="text-right"><a onclick="window.close();" href="#"><img src="images/s1-search_21.png" /></a></td>
  </tr>
</table>-->



    <div id="ph-from-btn">
        <input type="button" id="button2" value="新增" onclick="window.location='/addtransfer/index.jsp?&&fixedcolumns=&id=-1';"/>
        <%if((permission&nds.security.Directory.WRITE)==nds.security.Directory.WRITE){%>
        <input type="button" id="button2" value="保存" onclick="dist.saveDate('sav');"/>
        <%
            }
            if((permission&nds.security.Directory.SUBMIT)==nds.security.Directory.SUBMIT){
        %>
        <input type="button" id="button2" value="提交" onclick="dist.saveDate('ord');"/>
        <%}%>
       
	      
         <input type="button"  id="button2" value="刷新"  onclick="window.location.reload();" />
        <input type="button" id="button2" value="关闭" onclick="window.close();"/>

    </div>
</div>


 
<div class="s1-search">
  <div class="s1-search-t">查询条件 - 调拨查询</div>
  <div class="s1-search-m">
    <table class="table_s02"  border="1">
      <tr height="30">
        <td class="text-right" width="100">单据编号：</td>
        <td class="width-190"><input class="input_s02" type="text"  id="doc_no" readonly value="【系统维护】"/></td>
       <td class="text-right" width="100">店仓（多选）<font color="red">*</font>：</td>
        <td class="width-190">
        	<input type='hidden' id='column_26993' name="column_26993" value=''>
        	<input class="input_s02" type="text"  name="" readonly  id='column_26993_fd' value="" />
        	<span  class="coolButton" id="column_26993_link" title=popup onaction="oq.toggle_m('/html/nds/query/search.jsp?table=<%=destStore%>&return_type=f&accepter_id=column_26993', 'column_26993');"><img id='column_26993_img' width="16" height="16" border="0" align="absmiddle" title="Find" src="/html/nds/images/filterobj.gif"/></span>
                                <script type="text/javascript" >createButton(document.getElementById('column_26993_link'));</script>
        </td>
              

      </tr>
      <tr height="30">
      	<!-- <%
                                Date tody=new Date();
                                SimpleDateFormat fmt=new SimpleDateFormat("yyyyMMdd");
                                String end=fmt.format(tody);
                                Long stL=tody.getTime()-24*60*60*1000*10l;
                                Date std=new Date(stL);
                                String st=fmt.format(std);
                            %>
            <td class="text-right">订单时间(起)<font color="red">*</font>：</td>
        <td><input class="input_s02" type="text" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26996" value="<%=st%>"/>
         <span   class="coolButton">
                                    <a   onclick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar23',false,'column_26996',null,null,true);"><img id="imageCalendar23"  title="Find" style="vertical-align:bottom; padding-left:6px;" src="images/s1-search_22.png" /></a>
                                </span>
                                </td>
           <td class="text-right">订单时间(止)<font color="red">*</font>：</td>
        <td><input class="input_s02" type="text" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26997" value="<%=end%>"/>
         <span   class="coolButton">
                                    <a id="end_coolButton" onclick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar23',false,'column_26997',null,null,true);"><img id="imageCalendar23"  title="Find" style="vertical-align:bottom; padding-left:6px;" src="images/s1-search_22.png" /></a>
                                </span>
                                </td>              
      	</tr>
      <tr height="30">
      	 
        <td class="text-right">单据日期<font color="red">*</font>：</td>
        <td><input class="input_s02" type="text" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26995" value="<%=end%>"/>
         <span  class="coolButton">
                                    <a onclick="event.cancelBubble=true;" href="javascript:showCalendar('imageCalendar23',false,'column_26995',null,null,true);"><img id="imageCalendar23"  title="Find" style="vertical-align:bottom; padding-left:6px;" src="images/s1-search_22.png" /></a>
                                </span>
                                </td>-->
                                
                                
       <!--起止时间-->
                            
                            <td class="ph-desc" valign="top" nowrap="" align="right"><div class="desc-txt"> 订单时间(起)<font color="red">*</font>：</div></td>
                            <td class="ph-value"  valign="top" nowrap="" align="left">
                                <input type="text" class="input_s02" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26996" value="<%=st%>" />
                                <span  id="str_coolButton" class="coolButton">
                                    <a onclick="event.cancelBubble=true;" href="javascript:WdatePicker({el:'column_26996'});"><img id="imageCalendar23" width="16" height="18" border="0" align="absmiddle" title="Find" src="images/datenum.gif"/></a>
                                </span>
                            </td>
                            <td class="ph-desc" valign="top" nowrap="" align="right"><div class="desc-txt">订单时间(止)<font color="red">*</font>：</div></td>
                            <td class="ph-value" valign="top" nowrap="" align="left">
                                <input name="billdateend" type="text"  class="input_s02" maxlength="10" size="20" title="8位日期，如20070823" id="column_26997"  value="<%=end%>"/>
        <span id="end_coolButton" class="coolButton">
            <a onclick="event.cancelBubble=true;" href="javascript:WdatePicker({el:'column_26997'});"><img id='imageCalendar144' width="16" height="18" border="0" align="absmiddle" title="Find" src="images/datenum.gif"/></a>
        </span>
                            </td>
       
       </tr>
      <tr height="30">
      	<td class="text-right">单据日期<font color="red">*</font>：</td>
        <td><input class="input_s02" type="text" name="billdatebeg"  tabIndex="5" maxlength="10" size="20" title="8位日期，如20070823" id="column_26995" value="<%=end%>"/>
         <span  class="coolButton">
            <a onclick="event.cancelBubble=true;" href="javascript:WdatePicker({el:'column_26995'});"><img id='imageCalendar144' width="16" height="18" border="0" align="absmiddle" title="Find" src="images/datenum.gif"/></a>
        </span>
                                </td>
      	
        <td class="text-right">款号（多选）<font color="red">*</font>：</td>
        <td>
        	<!-- <input type='hidden' id='column_26994' name="product_filter" value=''>
        	<input class="input_s02" type="text" readonly id='column_26994_fd' value=""/>
        	<span  class="coolButton" id="column_26994_link" title=popup onaction="oq.toggle_m('/html/nds/query/search.jsp?table='+'m_product'+'&return_type=f&accepter_id=column_26994', 'column_26994');"><img id='column_26994_img' title="Find" style="vertical-align:bottom; margin-left:6px;" src="/html/nds/images/filterobj.gif"/></span>
                                <script type="text/javascript" >createButton(document.getElementById('column_26994_link'));</script>-->
                                
                                <input type='hidden' id='column_26994' name="product_filter" value=''>
                                <input type="text" class="input_s02"  readonly id='column_26994_fd' value="" />
        <span  class="coolButton" id="column_26994_link" title=popup onaction="oq.toggle_m('/html/nds/query/search.jsp?table='+'m_product'+'&return_type=f&accepter_id=column_26994', 'column_26994');"><img id='column_26994_img' width="16" height="16" border="0" align="absmiddle" title="Find" src="/html/nds/images/filterobj.gif"/></span>
                                <script type="text/javascript" >createButton(document.getElementById('column_26994_link'));</script>
        	</td>
        
       
        <td class="text-right" ><a  onclick="dist.queryObject();"><img id="query_button" src="images/s1-search_11.png" /></a></td>
        <td class="text-right" >&nbsp;&nbsp;&nbsp;&nbsp;</td>
        <td class="text-right"><a onclick="dist.makeOrder();" href="#"><img src="images/s1-search_13.png" /></a></td>
       
       <!-- <td class="text-right"><a href="#"><img src="images/s1-search_19.png" /></a></td>-->
      </tr>
    </table>
  </div>
</div>

<div class="s1">
  <div class="s1-left" id="load-s1-left">
    <div class="s1-left-t">
      <span>&nbsp;&nbsp;快速查找</span>&nbsp;<input type="text" id="pdt-search"/>
    </div>
    <div class="left-main">
      <div class="left-main-t">
        <div class="span-130 text-center" style="padding-left:15px;">款号</div><div class="span-50">颜色</div>
      </div>
      <div class="left-main-m">
        <ul id="style_color_name">
         <!-- <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">黑色</div></li>
          <li><div class="span-130">TW201210213201</div><div class="span-50">粉红色</div></li>-->
        </ul>
      </div>
      <div class="left-main-b"></div>
    </div><!--left-main end-->
  </div><!--s1-left  end-->
  <div class="s1-right" id="load-s1-right" >
   
  </div>
</div>


<div id="submitImge" style="left:30px;top:80px;z-index:111;position:absolute;display:none;">
    <img src="/html/nds/images/submitted.gif"/>
</div>


</body>
</html>

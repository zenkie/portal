<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	String dialogURL=request.getParameter("redirect");
	if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
		response.sendRedirect("/c/portal/login"+
			(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+
				java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
			return;
	}
		
	if(!userWeb.isActive()){
		session.invalidate();
		com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
		response.sendRedirect("/login.jsp");
		return;
	}	
	int ad_client_id=userWeb.getAdClientId();//公司id
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" src="/html/nds/oto/js/top_css_ext.js"></script>
<script language="javascript" language="javascript1.5" src="/html/nds/oto/js/ieemu.js"></script>
<script language="javascript" src="/html/nds/oto/js/cb2.js"></script>
<script language="javascript" src="/html/nds/oto/js/common.js"></script>
<script language="javascript" src="/html/nds/oto/js/print.js"></script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.2.3/ui.tabs.js"></script>
<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/sniffer.js"></script>
<script language="javascript" src="/html/nds/oto/js/ajax.js"></script>

<script type="text/javascript" src="/html/nds/oto/js/selectableelements.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/selectabletablerows.js"></script>
<script language="javascript" src="/html/nds/oto/js/calendar.js"></script>
<script language="javascript" src="/html/nds/oto/js/jdate/My97DatePicker/WdatePicker_dp.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/alerts.js"></script>
<script language="javascript" src="/html/nds/oto/js/init_objcontrol_zh_CN.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/object_query.js"></script>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-ui-1.8.21.custom.min.js"></script>

<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>

<script language="javascript" src="/html/nds/oto/sendmessage/js/MassMessage.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/SendCommand.js"></script>
<script type="text/javascript" src="/html/nds/oto/sendmessage/js/jquery.qqFace.js"></script>

<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/object.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/portal_header.css">
<link type="text/css" rel="stylesheet" href="<%=userWeb.getThemePath()%>/css/portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/css/cb2.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/themes/01/css/nds_portal.css">
<link type="text/css" rel="StyleSheet" href="/html/nds/oto/themes/01/css/aple_menu.css" />

<link type="text/css" href="/html/nds/oto/js/jquery1.3.2/css/smoothness/jquery-ui-1.8.21.custom.css" rel="stylesheet" />

<link type="text/css" href="/html/nds/oto/themes/01/css/base.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/page.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/wxreplay.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/sendmessage/css/emotion.css" rel="Stylesheet">
<style>
.btn_submit
{
background:#acc136;
height:33px;
}
.body{
overflow-y: visible;
}
.masstopdiv{
text-align: left;margin-top: 10px;border-bottom: 1px solid #ededed;height:39px;
}
.masstoph4{
width: 50%;padding: 0px;margin: 0px;float: left;border:none;
}
</style>
</head>
<body class="body">
    <form name="form1" method="post" action="" id="form1">
    <div id="mainer">
		<div>
		<h4>群发信息</h4>
		<div style="padding: 0px 0px 10px 20px;text-align: left;">
		<span class="desc-txt">VIP卡号:</span>
		<input type="text" name="WX_BINDCARD.WX_VIP_ID" size="15" onkeypress="pc.onSearchReturn(event)" class="qline ucase" id="WX_BINDCARD.WX_VIP_ID" value="">
		<input type="hidden" name="WX_BINDCARD.WX_VIP_ID/sql" id="WX_BINDCARD.WX_VIP_ID_sql">
		<input type="hidden" name="WX_BINDCARD.WX_VIP_ID/filter" id="WX_BINDCARD.WX_VIP_ID_filter">
		<span id="WX_BINDCARD.WX_VIP_ID_link" title="popup" onclick="oq.toggle_m('/html/nds/query/search.jsp?table=15939&amp;return_type=m&amp;column=43785&amp;accepter_id=WX_BINDCARD.WX_VIP_ID&amp;qdata='+encodeURIComponent(document.getElementById('WX_BINDCARD.WX_VIP_ID').value)+'&amp;queryindex='+encodeURIComponent(document.getElementById('queryindex_-1').value),'WX_BINDCARD.WX_VIP_ID')" class="coolButton">
		<img id="WX_BINDCARD.WX_VIP_ID_img" border="0" width="16" height="16" align="absmiddle" src="/html/nds/oto/themes/01/images/filterobj.gif" alt="Find">
		</span>
		<script>createButton(document.getElementById("WX_BINDCARD.WX_VIP_ID_link"));</script>	
		</div>
		</div>
		</div>
        <div class="mainbox">
            <div class="mform">
                <table id="TableList" width="100%" class="tbmodify" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td colspan="2">
                                <div class="float-p">
                                    <div class="replyList">
                                        <div class="cLine header">
                                            <p class="left b">回复内容</p>
                                            <p class="right red">（注意：禁止发布色情、反动、暴力等违规内容。）</p>
                                        </div>
                                        <div class="cntBox">
                                            <p class="left">回复类型：<span id="returnType" rtype="text">文字</span></p>
                                            <span id="spnAddLink" class="addlink">
                                                <a title="插入指定链接标记" href="javascript:send.setTarget()">插入链接</a>
                                            </span>
                                            <div class="clear"></div>
                                        </div>
									    <script id="test1">
										</script>
                                        <div id="divRelpys" class="replyItems showWords showFile showAppMsg">
                                            <div id="divRelpyWords" style="height: 350px;">											
												<div id="txtReplyWords" contenteditable="true" style="overflow-y: auto; overflow-x: hidden;height: 100%;"></div>												
											</div>
                                            <div id="divRelpyNews" class="divhidden msg-item-wrapper ">
                                               <div class="msg-item multi-msg">
                                                    <div class="appmsgItem" flag="0">
                                                        <p class="msg-meta"><span class="msg-date">&nbsp;</span></p>
                                                        <div class="cover">
                                                            <p id="pDefaultTip" class="default-tip" style="">封面图片</p>
                                                            <div class="msg-t h4">
                                                                <span id="spnTitle" class="i-title"></span>
                                                            </div>
                                                            <ul class="abs tc sub-msg-opr">
                                                                <li class="b-dib sub-msg-opr-item">
                                                                    <a href="javascript:void(0);" onclick="send.editTuwen(this)" class="th icon18 iconEdit">编辑</a>
                                                                </li>
                                                            </ul>
															<img id="imgPic" class="i-img" style="display:none;">
                                                        </div>
                                                    </div>                                                    
                                                    <div class="sub-add">
                                                        <a href="javascript:;" class="block tc sub-add-btn" onclick="send.addNews()"><span class="vm dib sub-add-icon"></span>增加一条</a>
                                                    </div>
                                                </div>
                                            </div>
										
										</div>
                                        <div class="btnArea float-p">
                                            <span class="emotion">表情</span>
											<span id="spnReplyWordsInfo" class="gray left">（您还可输入 <span class="red" id="spnCnt">1000</span> 字）</span>
                                            <span id="spnReplyNewsInfo" class="gray left" style="display:none;">（鼠标移动到图文上可编辑或删除）</span>
											<input type="button" class="addWords btnAdd c-opr" onclick="send.SetReplyType('Words')" value="文字"/>
                                            <input type="button" class="addAppMsg btnAdd c-opr" onclick="send.SetReplyType('News')" value="图文"/>
											<input type="button" onclick="send.commitSave()" name="btnEnter" value="发送消息" id="btnEnter" class="btn btn_submit">&nbsp;
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>                        
                    </tbody>
                </table>
            </div>
        </div>
    </div>
	<input type="hidden" name="show_all" value="true">
	<input type="hidden" name="queryindex_-1" id="queryindex_-1" value="-1">
<script type="text/javascript">
var ad_client_id=<%=ad_client_id%>;
</script>
</form>
</body></html>
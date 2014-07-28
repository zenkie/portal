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
	//用户信息
	String openId = "";
	String name = "";
	String imgUrl = "";
	String vipid = "";
	//获取该条信息的记录
	String id = request.getParameter("id");
	TableManager manager=TableManager.getInstance();
	String tableId="WX_MESSGAE";
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory = table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryEngine engine=QueryEngine.getInstance();
	QueryRequestImpl query = engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("WX_VIP_ID;NAME").getId());//用户昵称
	query.addSelection(table.getColumn("CUSTOMER").getId());//用户openId
	query.addSelection(table.getColumn("WX_VIP_ID;PHOTO").getId());//用户图像
	query.addSelection(table.getColumn("WX_VIP_ID").getId());//用户图像
	query.addParam(table.getColumn("ID").getId(),id);
	QueryResult result = QueryEngine.getInstance().doQuery(query);
	result.next();		
	name =result.getString(1); 
	openId = result.getString(2);
	imgUrl = result.getString(3);
	vipid  = result.getString(4);
	if(imgUrl.equals("") || (imgUrl==null)){
		imgUrl = "/html/nds/oto/themes/01/images/upimg.jpg";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script id="dialog" language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/SingleMessage.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/SendCommand.js"></script>
<script type="text/javascript" src="/html/nds/oto/sendmessage/js/jquery.qqFace.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/readMessage.js"></script>
<link type="text/css" href="/html/nds/oto/themes/01/css/base.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/page.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/wxreplay.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/sendmessage/css/emotion.css" rel="Stylesheet">
</head>
<body>
<div class="leftdiv" style="width: 57%;float:left">
    <form name="form1" method="post" action="" id="form1">
    <div id="mainer">
		<div class="topdiv">
		<img src="<%=imgUrl%>" class="topimg">
		<h4 class="toph4">与 <%=name%> 的聊天</h4>
		</div>
        <div class="mainbox" style="width:100%;">
            <div class="mform">
                <table id="TableList" width="100%" class="tbmodify" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td colspan="2">
                                <div class="float-p" style="heigth:460px;">
                                    <div class="replyList">
                                        <div class="cLine header">
                                            <p class="left b">回复内容</p>
                                            <p class="right red">（注意：禁止发布色情、反动、暴力等违规内容。）</p>
                                        </div>
                                        <div class="cntBox">
                                            <p class="left">回复类型：<span id="returnType" rtype="text">文字</span></p>
                                            <span id="spnAddLink" class="addlink">
                                                <a title="插入指定链接标记" href="javascript:send.setTarget()">插入链接</a>
                                                <a title="插入导航目录标记" href="javascript:send.AddMenuMark()" style="display:none;">导航目录</a>
                                                <a title="插入关注公众号标记" href="javascript:send.AddSubscribeMark()" style="display:none">关注公众号</a>
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
</div>
<div style="width: 42%;height:100%;float: right;">
	<iframe id="ifr1" name="ifr1" width="100%" height="100%" frameborder="0" marginwidth="0" marginheight="0" scrolling="auto" style="overflow-x:hidden" src="/html/nds/oto/sendmessage/message.jsp?id=<%=vipid%>"></iframe>
</div>
<script type="text/javascript">
var ad_client_id=<%=ad_client_id%>;
var openId = "<%=openId%>";
var replyid=<%=id%>;
</script>
</form>

</body></html>
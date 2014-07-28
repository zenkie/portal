<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

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

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/prg/upload/jquery.uploadify.min.js"></script>
<script>
	jQuery.noConflict();
</script>

<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>


<script language="javascript" src="/html/nds/oto/js/AsyncBox.v1.4.5.js"></script>


<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script language="javascript" src="/html/nds/oto/attention/js/fileupload.js"></script>
<script language="javascript" src="/html/nds/oto/attention/js/keywords.js"></script>
<script type="text/javascript" src="/html/nds/oto/attention/js/jquery.qqFacese.js"></script>
<link type="text/css" href="/html/nds/oto/attention/css/emotion.css" rel="Stylesheet">

<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<link type="text/css" href="/html/nds/oto/attention/css/base.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/attention/css/page.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/attention/css/wxreplay.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/asyncbox.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/attention/css/reply.css" rel="Stylesheet">
<link type="text/css" rel="StyleSheet" href="/html/prg/upload/uploadify.css">
</head>
<body>
    <form name="form1" method="post" action="" id="form1">


    <div id="mainer">

        <div class="mainbox">
            <div class="mform">
                <table id="TableList" width="100%" class="tbmodify" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td width="80" class="tdtitle"><span class="red">*</span>规则名：</td>
                            <td>
                                <input name="txtRuleName" type="text" value="" maxlength="60" id="txtRuleName" class="txt350">
                                <span class="gray">（规则名最多60个字）</span>
                            </td>                    
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="float-p">
                                    <div class="left keywordsList">
                                        <div class="cLine header">
                                            <span class="left b">关键字</span>
                                        </div>
                                        <ul id="keywordItems" class="keywordItems">	
										</ul>
                                        <div class="btnArea float-p">
                                            <button class="delKeyword btnGreenS left" type="button" onclick="editKeyWords.DeleteKeyword()">删除选中</button>
                                            <button class="addKeyword btnGrayS right" type="button" onclick="editKeyWords.ShowAddKeyword()">添加关键字</button>
                                        </div>
                                    </div>
                                    <div class="replyList">
                                        <div class="cLine header">
                                            <p class="left b">回复内容</p>
                                            <p class="right red">（注意：禁止发布色情、反动、暴力等违规内容。）</p>
                                        </div>
                                        <div class="cntBox">
                                            <p class="left">回复类型：<span id="returnType" rtype="text">文字</span></p>
                                            <span id="spnAddLink" class="addlink">
                                                <a title="插入指定链接标记" href="javascript:editKeyWords.setTarget()">插入链接</a>
                                                <a title="插入导航目录标记" href="javascript:editKeyWords.AddMenuMark()">导航目录</a>
                                                <a title="插入关注公众号标记" href="javascript:editKeyWords.AddSubscribeMark()">关注公众号</a>
                                            </span>
                                            <div class="clear"></div>
                                        </div>
                                        <div id="divRelpys" class="replyItems showWords showFile showAppMsg">
                                            <div id="divRelpyWords">
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
                                                                    <a href="javascript:void(0);" onclick="editKeyWords.editTuwen(this)" class="th icon18 iconEdit">编辑</a>
                                                                </li>
                                                            </ul>
															<img id="imgPic" class="i-img" style="display:none;">
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="sub-add">
                                                        <a href="javascript:;" class="block tc sub-add-btn" onclick="editKeyWords.addNews()"><span class="vm dib sub-add-icon"></span>增加一条</a>
                                                    </div>
                                                </div>
                                            </div>
										
										</div>
                                        <div class="btnArea float-p">
                                            <span class="emotion">表情</span>
											<span id="spnReplyWordsInfo" class="gray left">（您还可输入 <span class="red" id="spnCnt">600</span> 字）</span>
                                            <span id="spnReplyNewsInfo" class="gray left" style="display:none;">（鼠标移动到图文上可编辑或删除）</span>
											<input type="button" class="addWords btnAdd c-opr" onclick="editKeyWords.SetReplyType('Words')" value="文字"/>
                                            <input type="button" class="addAppMsg btnAdd c-opr" onclick="editKeyWords.SetReplyType('News')" value="图文"/>
											<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="editKeyWords.SetReplyType('Language')" value="语音"/>
											<input type="hidden" class="addWords btnAdd c-opr" onclick="editKeyWords.SetReplyType('Video')" value="视频"/>
											<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="editKeyWords.SetReplyType('Music')" value="音乐"/>
											<input type="hidden" class="addWords btnAdd c-opr" onclick="editKeyWords.SetReplyType('')" value="图片"/>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="button" onclick="editKeyWords.commitSave()" name="btnEnter" value=" 保存修改 " id="btnEnter" class="btn btn_submit" style="float:left;">&nbsp;
                                <input type="button" class="btn btn_cannel" value=" 取 消 " onclick="editKeyWords.commitCancel()">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    </form>
</body></html>
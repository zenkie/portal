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
	 
	int ad_client_id=0;
	ad_client_id=userWeb.getAdClientId();
	TableManager manager=TableManager.getInstance();
	String tableId="WX_ATTENTIONSET";
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("MSGTYPE").getId());
	query.addSelection(table.getColumn("GROUPID").getId());
	
	query.addParam(table.getColumn("DOTYPE").getId(),"= 1");
	result= QueryEngine.getInstance().doQuery(query);
	JSONObject obj = new JSONObject();
	//只有一组数据
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		
		String idNum =result.getString(1); 
		obj.put("ID",idNum);
		obj.put("MESSAGETYPE",result.getString(2));
		obj.put("GROUPID",result.getString(3));
	}
	System.out.println("%%%%%%%%%%%%%%%%%%"+obj);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>

<script type="text/javascript">

</script>
</head>
<body>
    <form name="form1" method="post" action="" id="form1">


    <div id="mainer">

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
                                                <a title="插入指定链接标记" href="javascript:notFoundKey.setTarget()">插入链接</a>
                                                <a title="插入导航目录标记" href="javascript:notFoundKey.AddMenuMark()">导航目录</a>
                                                <a title="插入关注公众号标记" href="javascript:notFoundKey.AddSubscribeMark()">关注公众号</a>
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
                                                                    <a href="javascript:void(0);" onclick="notFoundKey.editTuwen(this)" class="th icon18 iconEdit">编辑</a>
                                                                </li>
                                                            </ul>
															<img id="imgPic" class="i-img" style="display:none;">
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="sub-add">
                                                        <a href="javascript:;" class="block tc sub-add-btn" onclick="notFoundKey.addNews()"><span class="vm dib sub-add-icon"></span>增加一条</a>
                                                    </div>
                                                </div>
                                            </div>
										
										</div>
                                        <div class="btnArea float-p">
                                            <span class="emotion">表情</span>
                                            <span id="spnReplyWordsInfo" class="gray left">（您还可输入 <span class="red" id="spnCnt">600</span> 字）</span>
                                            <span id="spnReplyNewsInfo" class="gray left" style="display:none;">（鼠标移动到图文上可编辑或删除）</span>
											<input type="button" class="addWords btnAdd c-opr" onclick="notFoundKey.SetReplyType('Words')" value="文字"/>
                                            <input type="button" class="addAppMsg btnAdd c-opr" onclick="notFoundKey.SetReplyType('News')" value="图文"/>
											<input type="button" onclick="notFoundKey.commitSave()" name="btnEnter" value=" 保存修改 " id="btnEnter" class="btn btn_submit">&nbsp;
											<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="notFoundKey.SetReplyType('Language')" value="语音"/>
											<input type="hidden" class="addWords btnAdd c-opr" onclick="notFoundKey.SetReplyType('Video')" value="视频"/>
											<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="notFoundKey.SetReplyType('Music')" value="音乐"/>
											<input type="hidden" class="addWords btnAdd c-opr" onclick="notFoundKey.SetReplyType('')" value="图片"/>
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
<script type="text/javascript">
notData = '<%=obj%>';


notFoundKey.onreadyHtml();
		


</script>

    </form>
</body></html>
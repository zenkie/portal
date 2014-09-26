<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
String dialogURL=request.getParameter("redirect");
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
}
int id=0;
id=Tools.getInt(request.getParameter("id"),0);
String trees=null;
int ad_client_id=userWeb.getAdClientId();
ArrayList params=new ArrayList();
params.add(id);
params.add(ad_client_id);
ArrayList para=new ArrayList();
para.add( java.sql.Clob.class);
String resultStr="";
JSONObject jo=null;
//try {
	Collection list=QueryEngine.getInstance().executeFunction("wx_rqcodemessage_getjson",params,para);
	resultStr=(String)list.iterator().next();
	System.out.println("rqCode.jsp success:"+resultStr);
	jo=new JSONObject(resultStr);
/* }catch (Exception e) {
	System.out.println("rqCode.jsp error:"+e.getMessage());
	jo=new JSONObject();
} */

QueryRequestImpl query;
QueryResult result=null;
QueryEngine engine=QueryEngine.getInstance();

List temp=null;
StringBuffer ats=new StringBuffer();
ats.append("<option value=\"\">请选择</option>");
String sql="select alv.value,alv.description from ad_limitvalue alv where alv.ad_limitvalue_group_id in(select id from ad_limitvalue_group alg where alg.name='AD_ACTION_TYPE')";
List allActionType=engine.doQueryList(sql);
if(allActionType!=null&&allActionType.size()>0){
	for(int i=0;i<allActionType.size();i++){
		temp=(List)allActionType.get(i);
		ats.append("<option value=\"");
		ats.append(String.valueOf(temp.get(0)));
		ats.append("\">");
		ats.append(String.valueOf(temp.get(1)));
		ats.append("</option>");
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/base.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/page.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/style.css">
<link type="text/css" rel="stylesheet" href="/html/nds/oto/js/xloadtree222/xtree.css" />
<link type="text/css" href="/html/nds/oto/rqcode/css/wxreplay.css" rel="Stylesheet">
<link type="text/css" href="/html/nds/oto/themes/01/css/qrcodes.css" rel="Stylesheet">

<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/js/upload/jquery.uploadify.min.js"></script>

<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js"></script>
<link type="text/css" href="/html/nds/oto/js/artDialog4/skins/default.css" rel="Stylesheet">
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/oto/js/menuoperation.js"></script>
<script language="javascript" src="/html/nds/oto/rqcode/js/rqcode.js"></script>
<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>
<script type="text/javascript">
	var upinit={
		'sizeLimit':1024*1024 *1,		//上传文件最大值
		'buttonText'	: '选择',
		'fileDesc'      : '上传文件(dat)',
		'fileExt'		: '*.dat;'		//文件类型过滤,暂时没用到
	};
	var para={
		"next-screen":"/html/prg/msgjson.jsp",		//
		"formRequest":"/html/nds/msg.jsp",			//
		//"JSESSIONID":"<%=session.getId()%>",
		"isThum":true,
		"width":100,
		"hight":100,
		"onsuccess":"jQuery(\"#rqcodelogo\").attr(\"src\",\"$filepath$\");",
		"onfail":"alert(\"上传图片失败，请重新选择上传\");"	,
		"modname":"TwoDimensionalCode"
	};
</script>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
<title>自动回复</title>

</head>
<body>
<form name="form1" method="post" action="" id="form1">
    <div id="mainer">
		<div>
			<div id="lines" style="height: 100%;"></div>
		</div>
        <div class="mainbox">
			<div id="ddddd"></div>
            <div class="mform"> 
                <h4>二维码维护<span><em>*</em>为必填项！</span></h4>
                <div class="float-p float-main">
                    <div class="float-left">
						<div class="types">
							<span class="left_text">名称<em>*</em>：</span>
							<input id="rqcodename" type="text" name="" value=""/>
							<a id="isenable" href="javascript:rq.setEnable()" class="left_status" value="Y">失效</a>
						</div>
						<div class="types">
							<span class="left_text">参数<em>*</em>：</span>
							<input id="rqcodeparam" type="text" name="" value=""/>
						</div>
						<div id="rqcodetype" class="types radioinfo">
							<span>类型<em>*</em>：</span>
							<input id="" name="rqocdetype" type="radio" value="permanence"/>
							<span style="padding-right:5px;">永久</span>
							<input name="rqocdetype" type="radio" value="temporary" checked />
							<span>临时（30分钟）</span>
						</div>
						<div class="types">
							<span class="left_text">关联活动：</span>
							<input id="rqcodedisposeid" type="hidden" value="" />
							<input id="rqcodedisposeidobjid" type="hidden" value="" />
							<input id="rqcodedisposename" type="text" name="" value="" style="width:113px;"/>
							<a href="javascript:rq.setRqcodeDispose()" class="left_status">选择</a>
						</div>
						<div class="types">
							<span class="left_text">Logo图片：</span>
							<img id="rqcodelogo" name="showPic" src="" class="left_img"/>
							<input type="hidden" id="PicUrl" name="PicUrl" value="">
							<a id="fileInput1" name="imgFile" href="javascript:;" class="left_status">选择</a>
							<label id="spUpload"></label>
							<p id="whole"></p>
						</div>
						<div class="types logo_code">
							<img id="rqcodeimage" src="" class="logo_img"/>
						</div>
						<div id="rqcodehidden" style="display:none;">
							<input type="hidden" id="ticket" value="" />
							<input type="hidden" id="gourl" value="" />
						</div>
						
                        <div>
							<button type="button" class="btnGreenS left_btn" onclick="return rq.createTwoDimensionalCode()">&nbsp;生成二维码&nbsp;</button>
						</div>
                    </div>
					
					<div class="replyList float-right">
						<div class="cLine header">
							<p class="left b">回复内容</p>
							<p class="right red">(注意：禁止发布色情、反动、暴力等违规内容。)</p>
						</div>
						<div id="relpys">
							<div class="cntBox">
								<div id="replyheads">
									<div id="ordinaryReply" class="types actionTypes" style="display:none;">
										<p class="left">回复类型：<span id="returnType" rtype="text">文字</span></p>
										<p id="spnAddLink" class="addlink">
											<a title="插入指定链接标记" href="javascript:wem.setTarget()">插入链接</a>
											<a title="插入导航目录标记" href="javascript:wem.addMenu()" style="display:none;">导航目录</a>
											<a title="插入关注公众号标记" href="javascript:wem.addSubscribeMark()" style="display:none;">关注公众号</a>
										</p>
										<div class="clear"></div>
									</div>
									<div id="actionReply" class="types actionTypes">
											<span>动作类型<em>*</em>：</span>
											<select id="actiontype" name="" class="selectTypes">                   
											  <%=ats%>
											</select>
									</div>
								</div>
							</div>
							<div id="divRelpys" class="replyItems showWords showFile showAppMsg" style="height: 365px;">
								<!--<div id="divRelpyLink" style="display:none;">
									<span>网页链接：</span><input id="Linktitle" type="text" value="" readonly="readonly" class="linkurl"/>
									<input type="button" value="链接设置" onclick="wem.setMenuLinkValue()" class="linkediturl"/>
									<div style=" text-align: left; padding: 15px 0 0 60px; ">
										<div><span>功能说明：</span><span>点击菜单后直接跳转至设置的链接页面。</span></div>
										
									</div>
								</div>-->
								<div id="divRelpyWords" style="display:none;height: auto;" class="scriptDiv">
									<textarea id="txtReplyWords" name="txtReplyWords" onchange="javascript:wem.changeWords();" onkeyup="wem.setRemainString();" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="types scriptContent"></textarea>
								</div>
								<div id="divRelpyNews" class="divhidden msg-item-wrapper" style="display:none;">
									<div class="msg-item multi-msg">
										<div class="appmsgItem" flag="0" imagetype="bigImage" style="position:relative;">
											<p class="msg-meta"><span class="msg-date">&nbsp;</span></p>
											<div class="cover">
												<span class="cover" style="position: absolute;width: 322px;left:0;">
													<p id="pDefaultTip" class="default-tip" style="">封面图片</p>
													<img id="imgPic" class="i-img" style="display:none;">
												</span>
												<div class="msg-t h4">
													<span id="spnTitle" class="i-title"></span>
												</div>
												<ul class="abs tc sub-msg-opr">
													<li class="b-dib sub-msg-opr-item">
														<a href="javascript:void(0);" onclick="wem.editTuwen(this)" class="th icon18 iconEdit">编辑</a>
													</li>
												</ul>
											</div>
										</div>
										
										<div class="sub-add">
											<a href="javascript:;" class="block tc sub-add-btn" onclick="wem.addNews()"><span class="vm dib sub-add-icon"></span>增加一条</a>
										</div>
									</div>
								</div>
								<!--<div id="divRelpyLanguage" class="divhidden msg-item-wrapper ">
									<textarea name="txtReplyWords" id="txtReplyWords" onblur="CheckReplyWords()" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea">语音</textarea>
								</div>
								<div id="divRelpyVideo" class="divhidden msg-item-wrapper ">
									<textarea name="txtReplyVideo" id="txtReplyVideo" onblur="CheckReplyWords()" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea">视频</textarea>
								</div>
								<div id="divRelpyMusic" class="divhidden msg-item-wrapper ">
									<textarea name="txtReplyMusic" id="txtReplyMusic" onblur="CheckReplyWords()" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea">音乐</textarea>
								</div>-->
								<div id="divRelpyAction" class="scriptDiv">
									<div class="types actionTypes" style="display:none;">
										<span>动作类型<em>*</em>：</span>
										<select id="" name="" class="selectTypes">                   
										  <option value='0'></option>
										</select>
									</div>
									<textarea id="actioncontent" class="types scriptContent" placeholder="请在此输入脚本内容" autocomplete="off"></textarea>	
								</div>
							</div>
						</div>
						
						
						<div class="replyList btnArea float-p">
							<div id="buttons" class="btns">
								<span class="red left" id="snpReplyErr"></span>
								<span id="spnReplyLinkInfo" class="gray left" style="display:none;">（请设置链接）</span>
								<input type="button" class="addUrl btnAdd c-opr" style="display:none;" onclick="rq.changeMenuType('Link')" value="链接"/>
								<input type="button" class="addWords btnAdd c-opr" onclick="rq.changeMenuType('Words')" value="文字"/>
								<input type="button" class="addNews btnAdd c-opr" onclick="rq.changeMenuType('News')" value="图文"/>
								<input type="button" class="c-opr addDispose" onclick="rq.changeMenuType('Action')" value="动作定义"/>
								<button type="button" class="btnGreenS saveReply" onclick="return rq.saveReply()">保&nbsp;&nbsp;存</button>
							</div>
						</div>
					</div>
                </div>
            </div>
        </div>
    </div>
    </form>
	<script>
		jQuery(document).ready(
			function init(){
				fup.initForm(upinit,para);
				rqcode.main();
				rq.ad_client_id=<%=ad_client_id%>;
				rq.id=<%=id%>;
				rq.content=<%=jo%>;
				rq.initRqcode();
			}
		);
	</script>
</body>
</html>
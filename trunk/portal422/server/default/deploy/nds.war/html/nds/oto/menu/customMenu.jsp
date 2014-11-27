<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
String trees=null;
String searchmenu="select m.MENUCONTENT from wx_menuset m WHERE m.ad_client_id=?";
int ad_client_id=userWeb.getAdClientId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css"-->
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/base.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/page.css">
<!--link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/wxreplay.css"-->
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/style.css">
<!--link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/asyncbox.css"-->
<link type="text/css" rel="stylesheet" href="/html/nds/oto/menu/js/xloadtree222/xtree.css" />
<link type="text/css" href="/html/nds/oto/themes/01/css/wemenu.css" rel="Stylesheet">

<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<!--<script language="javascript" src="/html/nds/oto/js/upload/jquery.uploadify.min.js"></script>-->
<script language="javascript" src="/html/nds/oto/js/prg/upload/jquery.uploadifive.min.js"></script>
<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<!--<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>-->
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js"></script>
<link type="text/css" href="/html/nds/oto/js/artDialog4/skins/default.css" rel="Stylesheet">
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script language="javascript" src="/html/nds/oto/menu/js/xloadtree222/xtree.js"></script>
<script language="javascript" src="/html/nds/oto/menu/js/xloadtree222/xmlextras.js"></script>
<script language="javascript" src="/html/nds/oto/menu/js/xloadtree222/xloadtree.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
<script language="javascript" src="/html/nds/oto/menu/js/wemenu.js"></script>
<!--script language="javascript" src="/html/nds/oto/js/customMenu.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/cxtabdef.js"></script-->
<script type="text/javascript">

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
                <h4>微信菜单维护<span><em>*</em>为必填项！</span></h4>
                <div class="remind">
                    <p>1. 只有服务号能创建自定义菜单 【<a href="/html/nds/oto/operateintro/WxServiceType.htm" target="_blank">查看公众号类型与认证情况</a>】、最多创建3 个一级菜单(菜单名不超过16个字节)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;每个一级菜单下最多可以创建 5 个二级菜单(菜单名不超过40个字节)，菜单最多支持两层。</p>
                    <p>2. 使用本模块，必须在 <a href="http://mp.weixin.qq.com/" target="_blank" title="点击访问微信公众平台">微信公众平台</a>获取自定义菜单使用的AppId和AppSecret【<a href="/html/nds/oto/operateintro/WxAppId.htm" target="_blank">如何获取参数</a>】<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;然后在【微信】菜单中的<a href="javascript:wem.setWeixin()" title="点击进行微信绑定设置">微信接口配置</a>中设置。</p>
					<p style="display:none;">3. 拖动树形菜单再点击“保存排序”可以对菜单重排序，但最终只有“发布”后才会生效。公众平台限制了每天的发布次数。 </p>
                    <p>3. 公众平台规定，菜单发布24小时后生效。如果为新增粉丝，则可马上看到菜单。 </p>
                </div>
                <div class="float-p">
                    <div class="left">
                        <div class="menu">
	                        <ul class="simpleTree">
		                        <!--<li class="root" id="0">
			                        <span>自定义菜单列表</span>
			                        <div class="right"></div>
			                        <ul class="level1">
			                        <li class="line">&nbsp;</li>
									<li id="140409110044003937" class="folder-open">
										<img class="trigger" src="/html/nds/oto/themes/01/images/spacer.gif" border="0" style="float: left;">
										<span class="text">微商城</span>
										<div class="right">
											<i class="editmenu" title="编辑菜单"></i>
										</div>
										<ul class="level2">
											<li class="line">&nbsp;</li>
											<li id="140409110044004937" class="doc">
											<span class="text">进入商城</span>
											<div class="right"><i class="editmenu" onclick="var options={width:963,height:399,title:'选择菜单',resize:false,drag:true,lock:true,esc:true,skin:'chrome',ispop:false,close:function(){var dataObj = art.dialog.data('dataObj');alert(dataObj.url);}}; var url='/html/nds/oto/object/jumpUrl.jsp?fromid=14&objid=23'; art.dialog.open(url,options);" title="编辑菜单"></i>
											<i class="del" title="删除菜单"></i>
											</div></li>
											<li class="line">&nbsp;</li>
											<li id="140409110044005937" class="doc">
											<span class="text">我的订单</span>
											<div class="right">
											<i class="editmenu" title="编辑菜单"  onclick="var options={width:963,height:399,title:'选择菜单',resize:false,drag:true,lock:true,esc:true,skin:'chrome',ispop:false,close:function(){var dataObj = art.dialog.data('dataObj');alert(dataObj.url);}}; var url='/html/nds/oto/object/jumpUrl.jsp?fromid="+valSec.fromid+"&objid="+valSec.objid+"'; art.dialog.open(url,options);"></i>
											<i class="del" title="删除菜单"></i></div></li>
											<li class="line">&nbsp;</li>
											<li id="140409110044006937" class="doc">
											<span class="text">会员中心</span>
											<div class="right"><i class="editmenu" title="编辑菜单"></i>
											<i class="del" title="删除菜单"></i></div></li>
											<li class="line">&nbsp;</li>
											<li id="140409110044007937" class="doc">
												<span class="text">购物车</span>
												<div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div>
											</li>
											<li class="line">&nbsp;</li>
											<li id="140414163803515835" class="doc-last">
												<span class="text">12321</span>
												<div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div>
											</li>
											<li class="line-last"></li>
										</ul>
									</li>
									<li class="line">&nbsp;</li>
									<li id="140409110044008937" class="folder-open"><img class="trigger" src="/html/nds/oto/themes/01/images/spacer.gif" border="0" style="float: left;"><span class="text">商品导航</span><div class="right"><i class="add add-level2" title="添加二级子菜单"></i><i class="editmenu" title="编辑菜单"></i></div><ul class="level2"><li class="line">&nbsp;</li><li id="140409110044009937" class="doc"><span class="text">新品上市</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line">&nbsp;</li><li id="140409110044010937" class="doc"><span class="text">今日特价</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line">&nbsp;</li><li id="140409110044011937" class="doc"><span class="text">精品热销</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line">&nbsp;</li><li id="140409110044012937" class="doc-last"><span class="text">全部商品</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line-last"></li></ul></li><li class="line">&nbsp;</li><li id="140409110044013937" class="folder-open-last"><img class="trigger" src="/html/nds/oto/themes/01/images/spacer.gif" border="0" style="float: left;"><span class="text">关于我们</span>
										<div class="right"><i class="add add-level2" onclick="cus.addSecMenu(this)" title="添加二级子菜单"></i><i class="editmenu" title="编辑菜单"></i></div>
										<ul class="level2">
											<li class="line">&nbsp;</li>
											<li id="" class="doc"><span class="text">公司介绍</span><div class="right"><i class="editmenu"></i><i class="del"></i></div></li>
											<li class="line">&nbsp;</li>
											<li id="140409110044015192" class="doc"><span class="text">联系我们</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line">&nbsp;</li><li id="140409110044016192" class="doc"><span class="text">品牌介绍</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line">&nbsp;</li><li id="140409110044017192" class="doc-last"><span class="text">购物须知</span><div class="right"><i class="editmenu" title="编辑菜单"></i><i class="del" title="删除菜单"></i></div></li><li class="line-last"></li></ul></li><li class="line-last"></li></ul>
		                        </li>
	                        </ul>-->
							<div id="initmenu" class="root" style="list-style: none;margin: 0;padding: 0 10px 0 30px;font-size: 14px;">
							</div>
						</div>
                        <div class="btnArea">
                            <button type="button" class="btnGreenS" onclick="return wem.publishMenu()"> 发 布 </button>
                            <button type="button" class="btnGreenS" onclick="return wem.previewMenu()"> 预 览 </button>
                            <button type="button" class="btnGreenS" onclick="return wem.deleteWeixinMenu()"> 停 用 </button>
                            <button type="button" class="btnGreenS" onclick="return wem.saveMenu()">保 存</button>
                        </div>
                        <input name="hidTreeJson" type="hidden" id="hidTreeJson" value="[{&quot;id&quot;:&quot;140409110044003937&quot;,&quot;name&quot;:&quot;微商城&quot;,&quot;hasChilds&quot;:&quot;1&quot;,&quot;childs&quot;:[{&quot;id&quot;:&quot;140409110044004937&quot;,&quot;name&quot;:&quot;进入商城&quot;},{&quot;id&quot;:&quot;140409110044005937&quot;,&quot;name&quot;:&quot;我的订单&quot;},{&quot;id&quot;:&quot;140409110044006937&quot;,&quot;name&quot;:&quot;会员中心&quot;},{&quot;id&quot;:&quot;140409110044007937&quot;,&quot;name&quot;:&quot;购物车&quot;},{&quot;id&quot;:&quot;140414163803515835&quot;,&quot;name&quot;:&quot;12321&quot;}]},{&quot;id&quot;:&quot;140409110044008937&quot;,&quot;name&quot;:&quot;商品导航&quot;,&quot;hasChilds&quot;:&quot;1&quot;,&quot;childs&quot;:[{&quot;id&quot;:&quot;140409110044009937&quot;,&quot;name&quot;:&quot;新品上市&quot;},{&quot;id&quot;:&quot;140409110044010937&quot;,&quot;name&quot;:&quot;今日特价&quot;},{&quot;id&quot;:&quot;140409110044011937&quot;,&quot;name&quot;:&quot;精品热销&quot;},{&quot;id&quot;:&quot;140409110044012937&quot;,&quot;name&quot;:&quot;全部商品&quot;}]},{&quot;id&quot;:&quot;140409110044013937&quot;,&quot;name&quot;:&quot;关于我们&quot;,&quot;hasChilds&quot;:&quot;1&quot;,&quot;childs&quot;:[{&quot;id&quot;:&quot;140409110044014937&quot;,&quot;name&quot;:&quot;公司介绍&quot;},{&quot;id&quot;:&quot;140409110044015192&quot;,&quot;name&quot;:&quot;联系我们&quot;},{&quot;id&quot;:&quot;140409110044016192&quot;,&quot;name&quot;:&quot;品牌介绍&quot;},{&quot;id&quot;:&quot;140409110044017192&quot;,&quot;name&quot;:&quot;购物须知&quot;}]}]">
                    </div>
					
					<div class="replyList">
						<div class="cLine header">
							<p class="left b">回复内容</p>
							<p class="right red">(注意：禁止发布色情、反动、暴力等违规内容。)</p>
						</div>
						<div id="defaultrelpy" style="height: 441px;margin-top: 15px;">请点选左侧菜单，然后为其设置响应动作</div>
						<div id="notrelpys" class="" style="display:none;height: 441px;margin-top: 15px;">所选菜单下有二级菜单，无法为其设置响应动作</div>
						<div id="relpys" style="display:none;">
							<div class="cntBox">
								<p class="left">回复类型：<span id="returnType" rtype="text">文字</span></p>
								<p id="spnAddLink" class="addlink">
									<a title="插入指定链接标记" href="javascript:wem.setTarget()">插入链接</a>
									<a title="插入导航目录标记" href="javascript:wem.addMenu()" style="display:none;">导航目录</a>
									<a title="插入关注公众号标记" href="javascript:wem.addSubscribeMark()" style="display:none;">关注公众号</a>
								</p>
								<div class="clear"></div>
							</div>
							<div id="divRelpys" class="replyItems showWords showFile showAppMsg">
								<div id="divRelpyLink">
									<span>网页链接：</span><input id="Linktitle" type="text" value="" readonly="readonly" class="linkurl"/>
									<input type="button" value="链接设置" onclick="wem.setMenuLinkValue()" class="linkediturl"/>
									<div style=" text-align: left; padding: 15px 0 0 60px; ">
										<div><span>功能说明：</span><span>点击菜单后直接跳转至设置的链接页面。</span></div>
										
									</div>
								</div>
								<div id="divRelpyWords" style="display:none;">
									<textarea id="txtReplyWords" name="txtReplyWords" onchange="javascript:wem.changeWords();" onkeyup="wem.setRemainString();" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea"></textarea>
								</div>
								<div id="divRelpyNews" class="divhidden msg-item-wrapper" style="display:none;">
									<div class="msg-item multi-msg">
										<div class="appmsgItem" flag="0" imagetype="bigImage">
											<p class="msg-meta"><span class="msg-date">&nbsp;</span></p>
											<div class="cover">
												<span class="cover" style="position: absolute;width: 322px;">
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
								</div>
								<div id="divRelpyPicAndPicAndWords" class="divhidden msg-item-wrapper ">
									<textarea name="txtReplyPicAndWords" id="txtReplyWords" onblur="CheckReplyWords()" placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea">图文</textarea>
								</div>-->
							</div>
						</div>	
						<div class="replyList btnArea float-p">
							<div id="buttons" style="display:none;">
								<span class="red left" id="snpReplyErr"></span>
								<span id="spnReplyLinkInfo" class="gray left" style="display:none;">（请设置链接）</span>
								<input type="button" class="addUrl btnAdd c-opr" onclick="wem.changeMenuType('Link')" value="链接"/>
								<span id="spanReplyLink" class="gray left" style="display:none;min-width: 266px;">（请设置菜单链接）</span>
								<span id="spanReplyWords" class="gray left" style="display:none;min-width: 266px;">（您已输入【<span class="red" id="spnCnt">1000</span>】个字）</span>
								<span id="spanReplyNews" class="gray left" style="display:none;min-width: 266px;">（鼠标移动到图文上可操作相应图文）</span>
								<input type="button" class="addWords btnAdd c-opr" onclick="wem.changeMenuType('Words')" value="文字"/>
								<input type="button" class="addAppMsg btnAdd c-opr" onclick="wem.changeMenuType('News')" value="图文"/>
								<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="wem.changeMenuType('Language')" value="语音"/>
								<input type="hidden" class="addWords btnAdd c-opr" onclick="wem.changeMenuType('Video')" value="视频"/>
								<input type="hidden" class="addAppMsg btnAdd c-opr" onclick="wem.changeMenuType('Music')" value="音乐"/>
								<input type="hidden" class="addWords btnAdd c-opr" onclick="wem.changeMenuType('Image')" value="图片"/>
								<button type="button" class="btnGreenS saveReply" onclick="return wem.saveReply()">保 存</button>
								<button type="button" class="btnGreenS saveReply" onclick="return wem.perfectionVipinfo()" style="display:none;">完善会员资料</button>
							</div>
						</div>
						<!--<div class="replyList">
							<div class="cLine header">
								<p class="left b">菜单动作</p>
								<p class="right red">（注意：禁止发布色情、反动、暴力等违规内容。）</p>
							</div>
							<div id="divWait" class="wait">
								<div class="loading" style="display: none;"></div>
								<div class="cover" unselectable="on" style="display: none;"></div>
								<div class="required hide" style="display: block;">请点选左侧菜单节点，然后为其设置响应动作</div>
								<div class="bottom">&nbsp;</div>
							</div>
							
						</div>-->
					</div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>

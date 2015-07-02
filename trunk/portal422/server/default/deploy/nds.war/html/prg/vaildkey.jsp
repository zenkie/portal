<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
	//com.liferay.portal.util.CookieKeys.addSupportCookie(response);
	String maconly=com.getMAC.GetMACH.get_maconly();
	//String maconly="sdfasdf";
	SimpleDateFormat bartDateFormat = new SimpleDateFormat("yyyy");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Portal注册界面</title>
    <link rel="stylesheet" href="/html/nds/css/prg.css" type="text/css" />
    <link rel="Shortcut Icon" href="/html/nds/images/portal.ico" />
    <script type="text/javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="/html/nds/js/jquery1.3.2/hover_intent.min.js"></script>
    <script type="text/javascript" src="/html/prg/upload/jquery.uploadify.min.js"></script>
    <script type="text/javascript">
        jQuery.noConflict();
    </script>
    <script type="text/javascript" src="/html/nds/js/prototype.js"></script>
    <script type="text/javascript" src="/html/prg/fileupload.js"></script>
    <link rel="stylesheet" type="text/css" href="/html/prg/upload/uploadify.css" />
</head>
<body>
    <div>
        <div class="title">
            <h4 class="Logo">
                <img src="/images/newimages/home_logo.png" alt="伯俊logo" title="" /></h4>
        </div>
        <div class="main">
            <h1 align="center"><font color="#ffffff">Portal注册本机序号</font></h1>
            <div align="center">
                <div class="white">
                    <c:if test="<%=true %>">
   <c:if test="<%= SessionErrors.contains(request, "VERIFY_KEYFILE_ERROR") %>">
                  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "inactive-keyfile-error") %></div>
                  <br/>
                </c:if>   
   <c:if test="<%= SessionErrors.contains(request, "VERIFY_KEY_ERROR") %>">
                  <div class="portlet-msg-error"> <%= LanguageUtil.get(pageContext, "inactive-key-error") %></div>
                  <br/>
                </c:if>         
     </c:if>
                </div>
            </div>
            <div style="margin: 2% 30%; height: 100px;">
                <textarea rows="" cols="" class="form-control" id="inputSerialNo" name="localMac" style="width: 100%; height: 100%;"><%=maconly%></textarea>
            </div>
            <div style="margin: 0px 35%;">
                <div id="flashcontent">
                    <input id="fileInput1" name="file1" size="35" type="file" />
                </div>
                <!--input type='button' id="btnImport" name='Upload' value='开始上传并处理' onclick="javascript:fup.beginUpload();" -->
                <script type="text/javascript">
                    var upinit = {
                        'sizeLimit': 1024 * 1024 * 1,
                        'buttonText': '上传证书',
                        'fileDesc': '上传文件(dat)',
                        'fileExt': '*.dat;'
                    };
                    var para = {
                        "next-screen": "/html/prg/msgjson.jsp",
                        "formRequest": "/html/nds/msg.jsp",
                        "JSESSIONID": "<%=session.getId()%>",
                    };
                    jQuery(document).ready(function () {
                        fup.initForm(upinit, para);
                    });
                </script>
            </div>
            <div style="margin: 10px 48.3%">
            </div>
        </div>
		<div style="display:none" id="whole"></div>
        <div id="bottom">
            <div id="bottom-right">
                <span class="bottom-logo"></span>
                &copy;2008-<%=Calendar.getInstance().get(Calendar.YEAR)%>上海伯俊软件科技有限公司 版权所有 了解更多产品请点击:<a class="bottom-text" target="_parent" href="http://www.burgeon.com.cn">www.burgeon.com.cn</a>
            </div>
        </div>
        <fieldset id="output" style="display: none">
            <legend><%=PortletUtils.getMessage(pageContext, "import-result",null)%></legend>
        </fieldset>
    </div>
</body>
</html>


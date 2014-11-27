<%@ page language="java" import="java.util.*,nds.weixin.ext.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%
//String contexturl="http://weixin.kun-hong.com/wap/index/421?openid=OPENID";
String rightpct=request.getParameter("rightpct");
String ptype=request.getParameter("ptype");
if(ptype.equals("mall")){
ptype="mall.jsp?client=pc";
}else{
ptype="index.jsp?client=pc";
}
WeUtilsManager Wemanage =WeUtilsManager.getInstance();
WeUtils wu=Wemanage.getByAdClientId(userWeb.getAdClientId());
//System.out.print("getDoMain"+userWeb.getAdClientId());
%>
<style>
.wap-iframe {
	overflow: hidden;
	width: 233px;
	height: 413px;
	position: absolute;
	left: 54px;
	top: 85px;
	border: 0px;
}
.wap-preview {
	position: relative;
	width: 340px;
	height: 580px;
	/* border-left: 1px solid #ccc; */
	top: 10px;
	right: 0;
	background: url(/html/nds/oto/viewtmp/wapphone.png) no-repeat center center;
}
</style>
<div class="rightcontent" style="width:<%=rightpct%>; float: right; text-align: center; padding-bottom: 0px;">
    <div class="location">
    </div>
    <div name="vimtmp" id="vimtmp" class="wap-preview" style="">
		<iframe id="ifrvtmp" src="http://<%=wu.getDoMain()%>/<%=ptype%>" width="273px" class="wap-iframe">
        </iframe>
    </div>
    <p style="border-left: 0px solid #ccc;">
        <font style="color: blue;"><img src="" alt=""></font></p>
    <p style="border-left: 0px solid #ccc;">扫描二维码，通过手机预览微商城</p>
</div>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,nds.query.QueryEngine,nds.control.util.ValueHolder" %>
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
String searchmenu="select m.MENUCONTENT from wx_menuset m WHERE m.ad_client_id=?";
int ad_client_id=userWeb.getAdClientId();
QueryEngine engine=QueryEngine.getInstance();
Object menu=engine.doQueryOne(searchmenu,new Object[]{ad_client_id});
String menustr=null;
JSONArray menuChildja=null;
JSONArray menuja=null;
JSONObject menujo=null;
if(menu!=null){
	java.sql.Clob clob=(java.sql.Clob)menu;
	Reader inStream=clob.getCharacterStream();;
	char[] c=new char[(int) clob.length()];
	inStream.read(c);
	menustr=new String(c);
	inStream.close();
	if(nds.util.Validator.isNotNull(menustr)){
		try{
			menujo=new JSONObject(menustr);
			menuja=menujo.optJSONArray("button");
		}
		catch(Exception e){}
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>菜单预览</title>
		<style>
			.wap-preview {
				/*width: 297px;*/
				height: 557px;
				/* border-left: 1px solid #ccc; */
				top: 10px;
				right: 0;
				text-align:center;
				background: url(/html/nds/oto/viewtmp/wapphone.png) no-repeat center center;
				margin-left: auto;
				margin-right: auto;
			}
			#menu ul,#menu ul li ul{
				list-style-type:none;
			}
			#menu>ul>li {
				min-width: 63px;
				display: table-cell;
				border-left: 1px ridge;
			}
			#menu>ul>li:hover {
				cursor: pointer;
			}
			#menu>ul{
				width: 237px;
				display: table;
				position: relative;
				margin-left: auto;
				margin-right: auto;
				/*padding-left: 30px;*/
				line-height: 33px;
				border-top: 1px ridge;
				background: url(/html/nds/oto/themes/01/images/bg_pre3.png) no-repeat;
				background-position: 7px;
			}
			#menu>ul>li:hover>ul{
				display:block;
			}
			.childmenu{
				
			}
			.content{
				width: 277px;
				height: 416px;
				margin-left: auto;
				margin-right: auto;
				top: 46px;
				background: #fff;
				position: relative;
			}
			.childul{
				display:none;
				position: absolute;
			}
			#menu>ul>li>ul {
				width: 75px;
				padding-left: 0;
				bottom: 33px;
				/* float: right; */
				/* text-align: center; 
				padding-right: 12px;*/
				border: 1px ridge;
				border-bottom: none;
			}
			#menu > ul > li > ul > li> span {
				padding-left: 10px;
			}
			.haschild_img {
				width: 10px;
				height: 10px;
				padding-bottom: 10px;
				vertical-align: bottom;
				background:url();
			}
			#menu > ul > li> ul > li {
				text-align: left;
				border-bottom: 1px ridge;
			}
			body{
				margin:0;
			}
		</style>
	</head>
	<body>
		<div>
			<div id="menu" class="wap-preview" style="">
				<div class="content"></div>
				<ul style=" font-size: 12px; ">
					<%
					if(menuja!=null&&menuja.length()>0){
						for(int i=0;i<menuja.length();i++){
							menujo=menuja.optJSONObject(i);
							if(menujo.has("sub_button")){menuChildja=menujo.optJSONArray("sub_button");}
							else{menuChildja=null;}
							%>
							<li class="menu <%=menuChildja!=null&&menuChildja.length()>0?"haschild":"nochild"%>"><span><%=menujo.optString("name")%></span>
							<%
							if(menuChildja!=null&&menuChildja.length()>0){%>
								<img class="haschild_img" />
								<ul class="childul">
								<%
								for(int j=0;j<menuChildja.length();j++){
									menujo=menuChildja.optJSONObject(j);%>
									<li class="childmenu"><span><%=menujo.optString("name")%></span></li>
								<%}%>
								</ul>
							<%}
							%>
							</li>
						<%}
					}
					%>
				</ul>
			</div>
		</div>
	</body>
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	/**------获取参数---**/
	String id=request.getParameter("id");
	String flag=request.getParameter("flag");
	String mustsee="";
	String model="";
	String conjson="";
	String confirmtxt="";
	if(id!=null){
		int ad_client_id=userWeb.getAdClientId();//公司ID
		String searchTPCLASS="select * from WX_REGISSET w where w.ad_client_id = ? and w.id = ?";
		List tpclassList=QueryEngine.getInstance().doQueryList(searchTPCLASS,new Object[]{ad_client_id,id});
		if(tpclassList!=null){
		   List list = (List)tpclassList.get(0);
		   mustsee=list.get(3).toString();
		   model=list.get(4).toString();
		   conjson=list.get(5).toString();
		   confirmtxt=list.get(6).toString();
		}
	}
%>
<%
ArrayList params=new ArrayList();
ArrayList para=new ArrayList();
para.add(java.sql.Clob.class);
String resultStr="";
JSONArray json=null;
try {
	Collection list=QueryEngine.getInstance().executeFunction("wx_regiscontrol_getjson",params,para);
	resultStr=(String)list.iterator().next();
	json = new JSONArray(resultStr);
}catch (Exception e) {
	json=new JSONArray();
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="js/invitation.js"></script>
<link rel="stylesheet" href="/html/nds/oto/regisset/css/style.css" type="text/css"/>
<title>微报名</title>
</head>
<body>
<input type="hidden" id="ddd" value='<%=conjson%>'/>
<input type="hidden" id="flag" value='<%=flag%>'/>
<input type="hidden" id="ids" value='<%=id%>'/>
<div class="registration-top">
	<span class="registration-button">		
    	<a href="javascript:void(0);" id="regColumn">保存</a>
		<% if(flag == null){ %>
        <a href="javascript:void(0);" id="del">删除</a>
		<% } %>
    </span>
</div>
<div class="registration-cont">
	<div class="registration-cont-left">
	    <% if(mustsee.equals("Y")){ %>
        <div class="p1"><input type="checkbox" name="mustsee" checked="true" id="mustsee"><span>必须关注才可报名</span></div>
		<% }else{ %>
		<div class="p1"><input type="checkbox" name="mustsee" id="mustsee"><span>必须关注才可报名</span></div>
		<% } %>
    	<dl class="dl">
        	<dt>报名模板：</dt>
            <dd><input type="text" name="name" id="model" value="<%=model%>"></dd>
        </dl>
        <dl class="dl2">
        	<dt>报名内容设置：</dt>
            <dd>建议填选项在2~6个以内 </dd>
        </dl>
        <div class="registration-cont-select">
        	<ul>			
			<%
			for(int i =0,length=json.length();i<length;i++){
				JSONObject j = json.getJSONObject(i);
				String inputAttr = "";//input的属性值
				if(j.get("REQUIRED").equals("Y")){
					inputAttr = "checked='checked'";
				}
				if(j.get("IFMODIFY").equals("Y")){//Y不可修改
					inputAttr = inputAttr + "disabled";
				}
			%>
				<li>
                    <input type="checkbox" <%=inputAttr%> name="<%=j.get("KEY")%>" value='<%=j.toString()%>'/>
                	<span><%=j.get("NAME")%></span>
					
                </li>
			<%
			}
			%>
            </ul>
        </div>
        <dl class="dl4">
        	<dt>报名确认：</dt>
            <dd>报名者会收到以下微信信息，若为空白则不发送（字数限制xxx,且此消息只能发送给已关注报名者）</dd>
        </dl>
        <dl class="dl3">
        	<dt></dt>
            <dd>
            	<textarea cols=42 rows=10 id="txtTarea"><%=confirmtxt%></textarea>
           </dd> 
        </dl>
        
    </div>
    <div class="registration-cont-right">	
    	<div class="registration-cont-r-phone">
		<iframe id="ifr" name="ifr" class="phone-iframe" src="/html/nds/oto/regisset/index.html"></iframe></div>
    </div>
</div>
</body>
</html>
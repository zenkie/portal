<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page errorPage="/html/nds/error.jsp"%>
<%@ page import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%	
	String dialogURL = request.getParameter("redirect");
	if(userWeb == null || userWeb.getUserId() == userWeb.GUEST_ID){
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
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
<title>伯俊微官网</title>
<!--<link href="/html/nds/oto/operateintro/css/weistore.css" rel="stylesheet" type="text/css">-->
</head>
<body>
	<div class="weixin">		
		<div class="ewmdiv"  style="display:none;">
			<img src="" style="margin-left: 6px;" />
			<span>扫描二维码关注我们</span>
		</div>
		<div class="buttondiv">
		   <button type="button" id="button">一键设置</button>
		</div>
	</div>
	<script type="text/javascript">
	jQuery("#button").click(function(){			
		jQuery.ajax({
            url: '/html/nds/oto/operateintro/weixin.html',
            type: 'post',
			success: function (data) {			
				jQuery("#page-table").hide();
				jQuery("#portal-main").prepend(data);
            }
        });
		});
	</script>
</body>
</html>
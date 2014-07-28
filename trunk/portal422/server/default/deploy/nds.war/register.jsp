<%@ page language="java" import="java.util.*,nds.velocity.*,nds.weixin.ext.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %> 
<%@ include file="/html/portal/init.jsp" %>
<%
ValueHolder holder= (ValueHolder)request.getAttribute(nds.util.WebKeys.VALUE_HOLDER);
Boolean flag = false;
if(holder!=null && holder.get("message")!=null){
	Object messageObj=holder.get("message");
	String message = String.valueOf(messageObj);
	if("@registrate-success@".equals(message)){
		flag = true;
	}	
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
<title>注册</title>
<link href="/html/nds/oto/themes/01/css/register.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/register.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script type="text/javascript">
	 window.onload=function(){
		var flag = <%=flag%>;
		if(flag){
			art.dialog({
				content:'注册成功',
				lock:true,
				time: 2,
				cancel:false,
				close:function(){
					location.href = "/";
				}
			});			
		}
	};
	function addhtml(second){
		jQuery("#mes span")[0].innerHTML="注册成功！"+second+"s后跳转！";
	}
</script>
</head>
<body>
<div class="register">
	<div class="register_main">
		<div class="register_table">
			<form action="/control/register" method="post"  id="regForm">
				<table>
					<tr>
						<td><label><img src="/html/nds/oto/themes/01/images/user_icon.png"></label></td>
						<td>
							<span>用户注册</span><input type="hidden" name="table" value="WX_REGUSER"/>
						</td>
					</tr>
					<tr>
						<td><label class="control_mail" for="EMAIL">邮箱</label></td>
						<td>
							<input type="text" name="EMAIL" id="input_mail" onblur="reg.checkMail()"><span class="maroon">*</span>
						</td>
					</tr>					
					<tr>
						<td><label class="control_pswd" for="PASSWORD">设置密码</label></td>
						<td>	
							<input type="password" name="PASSWORD" id="pswd" onblur="reg.checkPswd()">
							<span class="maroon">*</span>
							<span class="help-inline">长度为6~16位字符</span>
						</td>
					</tr>
					<tr>
						<td><label class="control_repswd">确认密码</label></td>
						<td>
							<input type="password" id="repswd" onblur="reg.checkPswdSe()">
						</td>
					</tr>
					<tr>
						<td><label class="control_repswd">微信公众号</label></td>
						<td>
							<input type="text" id="wxappid" name="WXAPPID" onblur="reg.checkWxappid()">
							<span class="maroon">*</span>
						</td>
					</tr>
					<tr>
						<td><label class="control_company" for="COMPANY">企业名称</label></td>
						<td>
							<input type="text" name="COMPANY" id="company" onblur="reg.checkCompany()">
							<span class="maroon">*</span>
						</td>
					</tr>
					<tr>
						<td><label class="control_username" for="USERNAME">联系人</label></td>
						<td>
							<input type="text" name="USERNAME" id="username" onblur="reg.checkUserName()">							
							<span class="maroon">*</span>
						</td>
					</tr>
					<tr>
						<td><label class="control_address" for="ADDRESS">详细地址</label></td>
						<td>
							<input type="text" name="ADDRESS" id="address">
						</td>
					</tr>
					<tr>
						<td><label class="control_phone" for="PHONENUMBER">电话</label></td>
						<td>
							<input type="text" name="PHONENUMBER" id="phone" onblur="reg.checkPhone()">
						</td>
					</tr>					
					<tr>
						<td><label class="control_submit" for="input_pin">验证码</label></td>
						<td>
							<input type="text" name="verifyCode" id="input_pin" onblur="reg.checkPin()"><span class="maroon">*</span>
							<c:if test="<%= SessionErrors.contains(request,"VERIFY_CODE_ERROR") %>">
								<div class="portlet-msg-error" style="color:red;"> <%= LanguageUtil.get(pageContext, "error-verify-code") %> </div>
								<br />
							</c:if>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<img src="/servlets/vms" width="64" height="30" align="absmiddle" id="chkimg" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()">
							<span><a href="javascript:void(0);" title="" target="_blank" onclick="javascript:document.getElementById('chkimg').src='/servlets/vms?'+Math.random()">换一张</a></span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" class="input_submit" name="input_submit" onclick="reg.submitButton()">
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>				
</body>
</html>

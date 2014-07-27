<%@page errorPage="/html/nds/error.jsp" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/oto/security/header.jsp" %> 
<%
    /**
     * parameter:
     *      1.  objectid  - user Id whose password will be changed, if not set,default to current user's id
     */
int userid= ParamUtils.getIntParameter(request, "objectid", -1);
if(userid==-1){ userid= userWeb.getUserId();}

String tabName=PortletUtils.getMessage(pageContext, "change-password",null);
Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);	
if(conf.getProperty("security.password.file")!=null){
	response.sendRedirect(conf.getProperty("security.password.file")+"?objectid="+userid);
}
%>
<script>
	document.title="<%=tabName%>";
</script>
<style>
	#maintab-body{background-color: transparent;}
</style>
<div id="obj-top">
	<div style="position: relative;">
		<h4 id="table_title" class="table_title"><%=tabName%></h4>
		<div class="buttons">
			<span id="buttons">
			<a class="table-buttons2" href="javascript:checkOptions(document.password_modify);"><%=PortletUtils.getMessage(pageContext, "save",null)%></a>
			</span>
			<span id="closebtn"></span>
		</div>
		<div id="objmenu" class="obj-dock interactive-mode"><!--OBJMENU_BEGIN--><!--OBJMENU_END--></div>
		<div id="message" class="nt">
			<div id="message_txt"></div>
		</div>
	</div>
	<div id="tab1" class="objtb">
		<%
			 /**------check permission---**/
		String directory;
		directory="USERS_LIST";
		try{
			WebUtils.checkDirectoryWritePermission(directory,request);
		}catch(Throwable t){
			// user must be himeself then
			if( userWeb.getUserId()==-1 || userWeb.getUserId()!=userid) throw new NDSException("@no-permission@");
		}
		TableManager manager=TableManager.getInstance();
		Table table= manager.getTable("USERS");
		int tableId= table.getId();

		ResultSet result= QueryEngine.getInstance().doQuery("select name, truename from users where id="+userid);
		if(!result.next()) {
			out.println("The pointed user is not found!");
			return;
		}

		String userName=result.getString(1);
		String userDesc= result.getString(2);

		%>
		<script language="JavaScript" src="<%=NDS_PATH%>/js/formkey.js"></script>
		<script>
			function testComplex(val){
				var minLen=6;
				var minAZ=2;
				var minDigits=2;
				var UpperandLower=1;    //true=1 false=0
				var numPunc=1;
				if (val.length != val.replace(/^\s+|\s+$/g,"").length){ return false; }// start and end no space allowed
				if (val.lenght<minLen ||val.lenght>12 ){ return false;}
				if (minAZ){
					if (!/[a-z]/i.test(val) || val.match(/[A-Z]/gi).length < minAZ){ return false;}
				}
				if (minDigits){
					if (!/\d/.test(val) || val.match(/\d/g).length < minDigits ){ return false;}
				}
				if (UpperandLower){
					if (!/[a-z]/g.test(val) || !/[A-Z]/g.test(val) ){return false;}
				}
				if (numPunc){
					if  ( !/[\.\'\;\,\!\"\:\?]/.test(val) || (val.match(/[\.\'\;\,\!\"\:\?]/g).length < numPunc)){ return false;}
				}

				return true;
			}

			function checkOptions(form){
				if(form.password1.value != form.password2.value){
					alert("<%= PortletUtils.getMessage(pageContext, "please-enter-matching-passwords",null)%>");
					return false;
				}
				if( isWhitespace(form.password1.value)){
					alert("<%= PortletUtils.getMessage(pageContext, "please-enter-a-valid-password",null)%>");
					return false;
				}
				/*	
				if(!testComplex(form.password1.value)){
					alert("<%= PortletUtils.getMessage(pageContext, "please-enter-a-valid-password",null)%>");
					return false;
				}
				*/
				submitForm(form); 
			}
		</script>
		<p>
		<form name="password_modify" method="post" action="<%=contextPath%>/control/command" >
			<br>
			<table align="center" border="0" cellpadding="1" cellspacing="1" width="90%">
				<input type="hidden" name="userid" value="<%=userid %>">
				<input type="hidden" name="formRequest" value="<%=NDS_PATH+"/oto/security/changepassword.jsp?objectid="+ userid%>">
				<input type="hidden" name="command" value="ChangePassword">
				<input type="hidden" name="nds.control.ejb.UserTransaction" value="N">
					<!--<tr><td align="center" colspan="2"><%= PortletUtils.getMessage(pageContext, "password-requirement",null)%></td></tr>-->
				<tr>
					<td nowrap align="right"><div class="desc-txt">用户名称:</div></td>
					<td align="left" class="value"><input type='text' style=" height: 24px; " value='<%=userName%>' readonly="readonly"></td>
				</tr>
				<tr style="display:none;">
					<td nowrap align="right"><div class="desc-txt">用户姓名:</div></td>
					<td align="left" class="value"><input type='password' style=" height: 24px; " value='<%=userDesc%>' readonly="readonly"></td>
				</tr>
				<tr>
					<td nowrap align="right"><div class="desc-txt"><%= PortletUtils.getMessage(pageContext, "password",null)%>:</div></td>
					<td align="left" class="value"><input type='password' style=" height: 24px; " name='password1' value=''></td>
				</tr>
				<tr>
					<td nowrap align="right"><div class="desc-txt"><%= PortletUtils.getMessage(pageContext, "enter-again",null)%>:</div></td>
					<td align="left" class="value"><input type='password' style=" height: 24px; " name='password2' value=''></td>
				</tr>
			 </table>
		</form>
    </div>
</div>		
<%@ include file="/html/nds/footer_info.jsp" %>

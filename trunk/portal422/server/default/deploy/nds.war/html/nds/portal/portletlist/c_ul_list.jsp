<%@ page pageEncoding="utf-8"%>
<%
/**
 if only one column displayed, will not add div to the element//13052221905
*/
try{
	%>
	<%@ include file="/html/nds/portal/portletlist/c_data_list.jsp" %>
	<dt>
		<a href="javascript:;" style="display:none;"><img src="/images/newimages/tanchu/delete1.png" alt="" /></a>
		<span>系统消息</span>
	</dt>
	<ul class="<%=uiConfig.getCssClass()%>">
		<%if(result.getRowCount() == 0){%>
			<li class="even-row">
				<%= PortletUtils.getMessage(pageContext, "no-data",null)%>
			</li>
		<%}
		String queryPath= NDS_PATH+"/sheet/object.jsp?input=false&table=";
		String mainTablePath= dataConfig.getMainURL();
		String mainTarget=dataConfig.getMainTarget();
		if(mainTarget==null)mainTarget="_blank";
		if(mainTablePath ==null){
			mainTablePath= queryPath+query.getMainTable().getId()+"&id=@ID@";
		}

		int serialno=startIndex -1, currentId; 
		boolean whiteBg= false;
		
		int pkValue;
		while(result.next()){
			//if(serialno%5==0) whiteBg = (whiteBg==false);
			whiteBg = (whiteBg==false);
			serialno ++;
			String itemId = "-1";
			%>
			<li id='<%=namespace%>li_<%=serialno%>' class='<%=(whiteBg?"even-row":"odd-row")%> not_<%=result.getObject(2)%>'>
				<%
				Object id = result.getObject(1);
				String columnData=(String)result.getObject(2);
				%>
				<a href="javascript:im.dlgo2(10083,<%=id%>)">
				<%=columnData%>
				</a>

			</li>
		<%}//while
		if(!"NONE".equals(uiConfig.getMoreStyle())  && !"TITLE".equals(uiConfig.getMoreStyle())  ){
			String moreURL= uiConfig.getMoreURL();
			if(nds.util.Validator.isNull(moreURL)){
				moreURL=portletDisplay.getURLMax();
			}
			%>
			<li>
				<a class="action" href="<%=moreURL%>"><%=LanguageUtil.get(pageContext, "text-more")%></a>
			</li>
		<%}%>
	</ul>
	<script>
		jQuery("#mail_nums").html(<%=totalCount%>);
		if(<%=totalCount%>>0){jQuery("#mail_nums").css({"min-width":"14px"});}
	</script>
<%}catch(Exception expd){
	expd.printStackTrace();
	%>
	<ul class="<%=uiConfig.getCssClass()%>">
		<li><p><font color='red'><%= MessagesHolder.getInstance().translateMessage(expd.getMessage(),locale)%></font></li>
	</ul>
<%}%>

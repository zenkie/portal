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
		<%}// end getRowCount=0
		QueryResultMetaData meta=result.getMetaData();

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
		boolean showDiv=false;//(meta.getColumnCount()>2);
		while(result.next()){
			//if(serialno%5==0) whiteBg = (whiteBg==false);
			whiteBg = (whiteBg==false);
			serialno ++;
			String itemId = "-1";
			%>
			<li id='<%=namespace%>li_<%=serialno%>' class='<%=(whiteBg?"even-row":"odd-row")%> not_<%=result.getObject(3)%>'>
				<%
				String resPkId = null;
				String tdAttributes;
				Column colmn;
				pkValue= Tools.getInt(result.getObject(1),-1);
				String columnDataShort;
				for(int i=1;i< meta.getColumnCount()-1;i++){ // first column should always be PK
					tdAttributes="";
					String columnData=(String)result.getObject(i+1);
					String originColumnData= result.getString(i+1, false);
					colmn=manager.getColumn(meta.getColumnId(i+1));
					String url=null;
					int objId= result.getObjectID(i+1);
					String target=null;
					if(objId!=-1){
						String s=(String)urls.get(new Integer(i+1)) ;
						if( s!=null) {
							url= contextPath+ s+"?id="+objId;
						}else{
							url=queryPath+ colmn.getTable().getId() +"&id="+objId;
						}
						url="javascript:showObject(\""+url+"\")";
					}
					if(i==1){
						// alway set first column to PK url
						objId=pkValue;
						url= mainTablePath.replaceAll("@ID@",String.valueOf(pkValue));
						tdAttributes="id='td_obj_"+ pkValue + "'";
						if("_popup".equals(mainTarget))
							url="javascript:showObject(\""+url+"\")";
						else
							target=mainTarget;
					}
					columnDataShort=columnData;
					//Tools.isHTMLAnchorTag(columnData)
					/*if(uiConfig.getColumnLength()!=null){
						columnDataShort= StringUtils.shortenInBytes(columnData, uiConfig.getColumnLength()[i-1]);
					}else{
						columnDataShort= StringUtils.shortenInBytes(columnData, MAX_COLUMNLENGTH_WHEN_TOO_LONG);
					}*/
					if(url!=null) columnData="<a "+ 
						(columnDataShort.length()==columnData.length()?"": "title='"+columnData+"' ")
						+(target==null?"":"target='"+target+"' ") +"href='"+ url+"'>"+ columnDataShort + "</a>";
					nds.web.alert.ColumnAlerter ca=(nds.web.alert.ColumnAlerter)colmn.getUIAlerter();
					if(ca!=null){
						String rowCss=ca.getRowCssClass(result, i+1, colmn);
						if(nds.util.Validator.isNotNull(rowCss ))tableAlertHolder.add(namespace+"li_"+serialno, rowCss);
					}
					if(showDiv){%>
						<div class="lidiv_<%=i%>">
							<%=columnData%>
						</div>	
						<%}else{%>
						<%=columnData%>

							<%}
					
				}// for循环
				%>
			
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

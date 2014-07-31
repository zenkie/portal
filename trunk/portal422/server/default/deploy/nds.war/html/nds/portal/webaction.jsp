<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
/**
 Show webaction as tree in TableCategory menu
*/
	TableManager manager=TableManager.getInstance();
	int actionId=Tools.getInt( request.getParameter("id"), -1);
	WebAction action=manager.getWebAction(actionId);
	String desc=action.getDescription();
	String url=action.getIconURL();
	String urlTarget=action.getUrlTarget();
	String istree=userWeb.getUserOption("ISTREE","Y");
%>   
<table>
	<tr>
		<td>
			<script type="text/javascript">
				var istree="<%=istree%>";
				if(istree=="Y"){
					webFXTreeConfig.autoExpandAll=true;
					var tree=pc.createTree("<%=desc%>","/html/nds/portal/webactionxml.jsp?id=<%=actionId%>", <%=(url==null?"null":"\"javascript:pc.navigate('"+url+"'"+(urlTarget==null?"":",'"+urlTarget+"'")+")\"")%>);
				}else{
					jQuery.post("/html/nds/portal/webactionxmlout.jsp?id=<%=actionId%>",
						function(data){
							var result=data;
							
							changeClass();
							jQuery("#portal_middle_left_smenu").html(result.xml);
							try{
								loadIndex();
							}catch(ex){}
							
							//alert(result);
							// alert(result.documentElement);
							//jQuery("#tree-list").html(result.xml);
							//jQuery("#tree-list").css("padding","0");
							//jQuery("#rpt-list-content").css("width","213px");
							//jQuery("#rpt-list-content").css("overflow-y","hidden");
							//jQuery("#gamma-tab").remove();
							var act=0;
							var fa_show=jQuery("#fav_show").val();
							//alert(fa_show);
							//if($("mu_favorite").childElementCount>0&&fa_show!='1'){var act=0;}
							jQuery("#tab_accordion").accordion({ header: "h3",collapsible:true,autoHeight:false,navigation:true,active:act});
							//			.sortable({
							//				axis: "y",
							//				handle: "h3",
							//				stop: function( event, ui ) {
							//					// IE doesn't register the blur when sorting
							//					// so trigger focusout handlers to remove .ui-state-focus
							//					ui.item.children( "h3" ).triggerHandler( "focusout" );
							//				}
							//			});
						}
					);
				}
				function changeClass(){
					jQuery("#container").removeAttr("class");
					jQuery("#portal_top").attr("class","sub_top");
					jQuery("#portal_top_left").attr("class","sub_top_left");

					jQuery("#portal_middle").attr("class","content cl");
					jQuery("#portal_middle_left").attr("style","width:222px;");
					//jQuery("#portal_middle_left").removeAttr("style");

					jQuery("#portal_middle_right").attr("class","content_right");
					jQuery("#portal_middle_right_search").attr("class","");
					jQuery("#portal_middle_right_search_title").attr("class","content_right-title");
					jQuery("#portal_middle_right_search_input").attr("class","search-1");
				}
				<%if(url!=null){%>
					pc.navigate('<%=url%>'<%=(urlTarget==null?"":",'"+urlTarget+"'")%>);
				<%}%>
			</script>    
		</td>
	</tr>
</table>

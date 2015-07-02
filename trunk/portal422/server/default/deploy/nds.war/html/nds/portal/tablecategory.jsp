<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.control.util.*" %>
<%@ page import="nds.web.config.*" %>
<%
if(userWeb==null || userWeb.isGuest()){
	String redirect=java.net.URLEncoder.encode(request.getRequestURI()+"?"+request.getQueryString() ,"UTF-8");
	response.sendRedirect("/login.jsp?redirect="+redirect);
	return;
}
//if((userWeb.getPermission("M_PRODUCT_ALIAS_LIST")& nds.security.Directory.READ )!= nds.security.Directory.READ )
//	throw new NDSException("@no-permission@");
	
   TableManager manager=TableManager.getInstance();
   int catId=Tools.getInt( request.getParameter("id"), -1);
   TableCategory cat=(TableCategory)manager.getTableCategory(catId);
   String desc=cat.getName();
   String func="pc.qrpt";
   String url=cat.getPageURL();
   String istree=userWeb.getUserOption("ISTREE","N");
   if(url!=null){
%>
<%	}%>
<table><tr><td>
<script type="text/javascript">
				var url="<%=url%>";
				var istree="<%=istree%>";
				if(istree=="Y"){
					webFXTreeConfig.autoExpandAll=false;
					var tree=pc.createTree("<%=desc%>","/html/nds/portal/tablecategory.xml.jsp?id=<%=catId%>", <%=(url==null?"null":"\"javascript:pc.navigate('"+url+"')\"")%>,false);
				}else{
					jQuery.post("/html/nds/portal/tablecategoryout.jsp?id=<%=catId%>",
						function(data,b,response){
							var result=data;
							//alert(result);
							//alert(result.xml);
							var xml = result.xml;
							xml = xml==null?response.responseText:xml;//兼容ie11
							
							changeClass();
							var wrapper = jQuery('<div id="myscroll_container" style="height:100%;overflow:hidden;"></div>');
							wrapper.html(xml);
							jQuery("#portal_middle_left_smenu").empty().append(wrapper);
							commjs_registCustomerScrollBar(wrapper,{suppressScrollX:true})						
							try{
								loadIndex();
							}catch(ex){}
							
							
							//jQuery("#tree-list").css("padding","0");
							//jQuery("#rpt-list-content").css("width","213px");
							//jQuery("#rpt-list-content").css("overflow-y","hidden");
							//jQuery("#gamma-tab").remove();
							var act=0;
							var fa_show=jQuery("#fav_show").val();
							//alert(fa_show);
							if($("menuList").childElementCount>0&&fa_show!='1'){ act=0;}
							
							jQuery("#tab_accordion").accordion({ header: "h3",collapsible:true,autoHeight:true,navigation:true,active:act});
								//.sortable({
								//		axis: "y",
								//		handle: "h3",
								//		stop: function( event, ui ) {
								//			//IE doesn't register the blur when sorting
								//			// so trigger focusout handlers to remove .ui-state-focus
								//			ui.item.children( "h3" ).triggerHandler( "focusout" );
								//		}
								//	});
						}
					);
					<%=(url==null?"null":"javascript:pc.navigate('"+url+"');")%>
				};
				
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
			</script>     
</td></tr></table>

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
<table><tr><td>
<script type="text/javascript">
 var istree="<%=istree%>";
 if(istree=="Y"){
 webFXTreeConfig.autoExpandAll=true;
 var tree=pc.createTree("<%=desc%>","/html/nds/portal/webactionxml.jsp?id=<%=actionId%>", <%=(url==null?"null":"\"javascript:pc.navigate('"+url+"'"+(urlTarget==null?"":",'"+urlTarget+"'")+")\"")%>);
 }else{
 jQuery.post("/html/nds/portal/webactionxmlout.jsp?id=<%=actionId%>",
   function(data){
     var result=data;
     //alert(result);
     // alert(result.documentElement);
     jQuery("#tree-list").html(result.xml);
     jQuery("#tree-list").css("padding","0");
     //jQuery("#rpt-list-content").css("width","213px");
     //jQuery("#rpt-list-content").css("overflow-y","hidden");
     //jQuery("#gamma-tab").remove();
     var act=1;
     var fa_show=jQuery("#fav_show").val();
     //alert(fa_show);
     if($("mu_favorite").childElementCount>0&&fa_show!='1'){var act=0;}
     jQuery("#tab_accordion").accordion({ header: "h3",collapsible:true,autoHeight:true,navigation:true,active:act});
//			.sortable({
//				axis: "y",
//				handle: "h3",
//				stop: function( event, ui ) {
//					// IE doesn't register the blur when sorting
//					// so trigger focusout handlers to remove .ui-state-focus
//					ui.item.children( "h3" ).triggerHandler( "focusout" );
//				}
//			});
   });
 }
 <%if(url!=null){%>
 pc.navigate('<%=url%>'<%=(urlTarget==null?"":",'"+urlTarget+"'")%>);
 <%}%>
</script>    
</td></tr></table>

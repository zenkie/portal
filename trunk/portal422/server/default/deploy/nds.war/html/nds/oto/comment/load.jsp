<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	String id = request.getParameter("id");//商品记录id
	String comId = request.getParameter("lastId");//评论lastId
	int ad_client_id=userWeb.getAdClientId();
	//String searchmenu="select id,itemphoto,itemname,itemunitprice,content,goodcomment,vipId,name,photo,commentId from (select goods.id,goods.itemphoto,goods.itemname,goods.itemunitprice,com.content,com.goodcomment,vip.id as vipId,vip.name,vip.photo,com.id as commentId from wx_comment com,wx_vip vip,wx_appendgoods goods where com.wx_appendgoods_id = (select wx_appendgoods_id from wx_comment where id = ?) and com.wx_vip_id = vip.id and com.wx_appendgoods_id = goods.id and com.ad_client_id = ? and com.id < ? order by com.id desc) where rownum < 11";
	String searchmenu="select id,itemphoto,itemname,itemunitprice,content,goodcomment,vipId,name,photo,commentId from (select goods.id,goods.itemphoto,goods.itemname,goods.itemunitprice,com.content,com.goodcomment,vip.id as vipId,vip.name,vip.photo,com.id as commentId from wx_comment com,wx_vip vip,wx_appendgoods goods where com.wx_appendgoods_id = ? and com.wx_vip_id = vip.id and com.wx_appendgoods_id = goods.id and com.ad_client_id = ? and com.id < ? order by com.id desc) where rownum < 11";
	List commentList=QueryEngine.getInstance().doQueryList(searchmenu,new Object[]{id,ad_client_id,comId});
	String goodsPhoto=null;
	String goodsName=null;
	String goodsPrice=null;
	if(commentList!=null&&commentList.size()>0){
		List list = (List)commentList.get(0);
		goodsPhoto = (list.get(1)!=null)?list.get(1).toString():"/html/nds/oto/themes/01/images/upimg.jpg";
		goodsName = list.get(2).toString();
		goodsPrice = list.get(3).toString();
	}
	
	if(commentList!=null&&commentList.size()>0){
		String comment=null;
		String goodComment=null;
		String vipName=null;
		String vipPhoto=null;
		String goodcommentPhoto = "/html/nds/oto/comment/images/b_red_1.gif";
		for(int i=0;i < commentList.size(); i++){
			List list = (List)commentList.get(i);
			comment = list.get(4).toString();
			goodComment = list.get(5).toString();
			if(goodComment.equals("1")){
				goodcommentPhoto = "/html/nds/oto/comment/images/b_red_5.gif";
			}else if(goodComment.equals("0")){
				goodcommentPhoto = "/html/nds/oto/comment/images/b_red_3.gif";
			}
			vipName = list.get(7).toString();
			vipPhoto = (list.get(8)!=null)?list.get(8).toString():"/html/nds/oto/themes/01/images/upimg.jpg";
		%>
				<tr data-id="<%=list.get(9)%>">
					<td class="tm-col-master">
						<div class="tm-rate-content">
							<div class="tm-rate-fulltxt">
							<span>评价：</span><%=comment%>
							</div>
						</div>
					</td>
					<td class="col-meta">
						<div class="rate-sku">
							<p>
								<span>满意度：</span>
								<img src="<%=goodcommentPhoto%>">
							</p>
						</div>
					</td>
					<td class="col-author">						
						<div class="rate-user-grade">
							<a href="javascript:void(0);">
								<img height=40 width=40 src="<%=vipPhoto%>">
							</a>
						</div>
						<div class="rate-user-info"><%=vipName%></div>
						<input type="button" class="button" value="删除" onclick="deleteComment(this)">
					</td>
				</tr>
		<%
			}
		}else{
		%>
		nodata
		<%
		}
		%>
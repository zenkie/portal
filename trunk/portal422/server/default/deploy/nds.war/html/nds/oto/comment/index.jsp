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
	//获取商品的ID
	String id = request.getParameter("id");
	//获取公司ID
	int ad_client_id=userWeb.getAdClientId();
	//查询评论记录对应商品的评论总数
	//String searchcount="select count(*) from wx_comment where wx_appendgoods_id = (select wx_appendgoods_id from wx_comment where id = ? ) and ad_client_id = ?";//得到总数量
	String searchcount="select count(*) from wx_comment where wx_appendgoods_id = ? and ad_client_id = ?";//得到总数量
	Object count=QueryEngine.getInstance().doQueryOne(searchcount,new Object[]{id,ad_client_id});	
	//查询评论信息
	//String searchmenu="select id,itemphoto,itemname,itemunitprice,content,goodcomment,vipId,name,photo,commentId from (select goods.id,goods.itemphoto,goods.itemname,goods.itemunitprice,com.content,com.goodcomment,vip.id as vipId,vip.name,vip.photo,com.id as commentId from wx_comment com,wx_vip vip,wx_appendgoods goods where com.wx_appendgoods_id = (select wx_appendgoods_id from wx_comment where id = ?) and com.wx_vip_id = vip.id and com.wx_appendgoods_id = goods.id and com.ad_client_id = ? order by com.id desc) where rownum < 11";
	String searchmenu="select id,itemphoto,itemname,itemunitprice,content,goodcomment,vipId,name,photo,commentId from (select goods.id,goods.itemphoto,goods.itemname,goods.itemunitprice,com.content,com.goodcomment,vip.id as vipId,vip.name,vip.photo,com.id as commentId from wx_comment com,wx_vip vip,wx_appendgoods goods where com.wx_appendgoods_id = ? and com.wx_vip_id = vip.id and com.wx_appendgoods_id = goods.id and com.ad_client_id = ? order by com.id desc) where rownum < 11";
	List commentList=QueryEngine.getInstance().doQueryList(searchmenu,new Object[]{id,ad_client_id});
	String goodsPhoto=null;//商品图片
	String goodsName=null;//商品名称
	String goodsPrice=null;//商品价格
	if(commentList!=null&&commentList.size()>0){
		List list = (List)commentList.get(0);
		//商品没有图片时，给个默认图片
		goodsPhoto = (list.get(1)!=null)?list.get(1).toString():"/html/nds/oto/themes/01/images/upimg.jpg";
		goodsName = list.get(2).toString();
		goodsPrice = list.get(3).toString();
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
<meta charset="UTF-8">
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">jQuery.noConflict(); </script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script language="javascript" src="/html/nds/oto/comment/js/dialog.js"></script>
<script language="javascript" src="/html/nds/oto/comment/js/loadmore.js"></script>
<link href="/html/nds/oto/comment/css/main.css" rel="stylesheet" type="text/css">
<link href="/html/nds/oto/comment/css/dialog.css" rel="stylesheet" type="text/css">
<title>商品评价</title>
</head>
<body>
<div class="viewport">
	<header class="navbar">
		<ul>
			<li>商品评价</li>			
			<li></li>
		</ul>
	</header>
	<%
	if(commentList==null || commentList.size()<=0){
		return;
	}	
	%>
	<section class="content">
		<div class="wrap">
			<div id="J_rate_plugin">
				<section class="oc-m">
					<div class="oc-info"> 
						<div class="oc-info-l"> 
							<img src="<%=goodsPhoto%>" height=40 width=40> 
						</div> 
						<div class="oc-info-r"> 
							<h2 style="font-size: 14px;"><%=goodsName%></h2> 
							<div> ￥<strong class="red"><%=goodsPrice%></strong></div> 
						</div>
					</div>					
				</section>
			</div>
		</div>
	</section>
</div>
<div class="rate-grid">
	<table>
		<tbody>
		<%
		if(commentList!=null&&commentList.size()>0){
			String comment=null;//评论内容
			String goodComment=null;//好评 返回数据为  1好评 0中评 -1差评
			String vipName=null;//会员昵称
			String vipPhoto=null;//会员图片
			String goodcommentPhoto = "/html/nds/oto/comment/images/b_red_1.gif";//根据好评度 显示相应的图片 默认值是 差评图片
			for(int i=0;i < commentList.size(); i++){
				List list = (List)commentList.get(i);
				comment = list.get(4).toString();
				goodComment = list.get(5).toString();
				if(goodComment.equals("1")){//好评显示 图片b_red_5.gif
					goodcommentPhoto = "/html/nds/oto/comment/images/b_red_5.gif";
				}else if(goodComment.equals("0")){//中评显示 图片b_red_3.gif
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
		}
		%>
		</tbody>
	</table>
</div>
<input type="hidden" id="total" value="<%=count%>">
<input type="hidden" id="commentID" value="<%=id%>">
</body>
</html>
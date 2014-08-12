<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	/**------获取参数---**/
	String usetmp=request.getParameter("ptype");//ptype:  home官网 mall商城 （模板使用者）
	/**------获取参数 end---**/
	int ad_client_id=userWeb.getAdClientId();//公司ID
	//获取模板类型  HOME首页 CLASS类目 LIST列表
	//String searchTPCLASS="select DISTINCT a.tpclass from ad_site_template a where a.ad_client_id = ? and a.usetmp = ?";
	//List tpclassList=QueryEngine.getInstance().doQueryList(searchTPCLASS,new Object[]{ad_client_id,usetmp});
	List tpclassList = new ArrayList();
	tpclassList.add("HOME");	
	tpclassList.add("LIST");
	tpclassList.add("CLASS");
	
	//获取该公司的首页，类目，列表 默认模板ID
	String queryTemp = null;
	if(usetmp.equals("home")){
		queryTemp = "select HOME_TMP,LIST_TMP,CLASS_TMP from WEB_CLIENT_TMP where AD_CLIENT_ID = "+ ad_client_id;
	}else if(usetmp.equals("mall")){
		queryTemp = "select HOME_TMP,MLIST_TMP,MCLASS_TMP from WEB_MAIL_TMP where AD_CLIENT_ID = "+ ad_client_id;	
	}
	List queryTempList = QueryEngine.getInstance().doQueryList(queryTemp);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>模板选择</title>
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=default"></script>

<script src="/html/nds/oto/temple/js/tab.js"></script>
<script src="/html/nds/oto/temple/js/select_template.js"></script>
<link href="/html/nds/oto/temple/css/main.css" rel="stylesheet" type="text/css">
<body>
<div id="mainContent">
    <div id="contentWrap" class="ui-form">
        <legend>模板设置</legend>
        <div id="tabs" class="tag-panel">
                <ul class="tag-panel-head ui-nav-tabs clearfix" id="divTempHeader">
                    <li class="active">
						<a href="javascript:void(0);" class="tag-panel-title">首页模板</a>
					</li>                    
                    <li class="">
						<a href="javascript:void(0);" class="tag-panel-title">列表模板</a>
					</li>
					<li class="">
						<a href="javascript:void(0);" class="tag-panel-title">类目模板</a>
					</li>
                </ul>
                <div class="tag-panel-contnt1">
				<%
					for(int i =0,size=tpclassList.size();i<size;i++){
						//获取模板类型 下的风格
						String tpclass = tpclassList.get(i).toString();
						String searchTPSTYLE="SELECT DISTINCT AD_SITE_TEMPLATE.WX_TP_STYLE_ID,a0.NAME FROM AD_SITE_TEMPLATE,WX_TP_STYLE a0 WHERE (a0.ID (+)=AD_SITE_TEMPLATE.WX_TP_STYLE_ID) AND (AD_SITE_TEMPLATE.USETMP = ?) and AD_SITE_TEMPLATE.tpclass =? ORDER BY AD_SITE_TEMPLATE.WX_TP_STYLE_ID asc";
						List tpstyleList=QueryEngine.getInstance().doQueryList(searchTPSTYLE,new Object[]{usetmp,tpclass});
				%>
					<div id="<%=tpclass%>template" class="tag-panel-content" style="position: relative;">
						<div class="stylelist" id="tempTypeList">
				<%
					for(int h=0,styleSize2=tpstyleList.size();h<styleSize2;h++){
						//获取模板类型 且是 该风格的 模板信息
						List style = (List)tpstyleList.get(h);
						if(style.get(1) != null){
							String wx_tp_style_name = style.get(1).toString();						
				%>
								<a href="javascript:void(0);"><%=wx_tp_style_name%></a>
				<%
						}
					}
				%>       
                        </div>
						<div class="tempListBox">
				<%
					for(int j=0,styleSize=tpstyleList.size();j<styleSize;j++){
						//获取模板类型 且是 该风格的 模板信息
						List style = (List)tpstyleList.get(j);
						String wx_tp_style_id = null;
						if(style.get(0) == null){
							wx_tp_style_id = "is null";
						}else{
							wx_tp_style_id = "= " + style.get(0).toString();
						}	
						String searchTEMP="select ID,NAME,IMGURL,TPCLASS,WX_TP_STYLE_ID from ad_site_template a where a.usetmp = ? and a.tpclass = ? and a.wx_tp_style_id "+wx_tp_style_id+" order by a.name asc";
						List tpTEMPList=QueryEngine.getInstance().doQueryList(searchTEMP,new Object[]{usetmp,tpclass});
				%>					
						<ul class="templatelist clearfix" id="temp1">
				<%
					for(int k=0,tempSize=tpTEMPList.size();k<tempSize;k++){
						List temp = (List)tpTEMPList.get(k);
				%>
							<li onclick="st.choose_template(this,'<%=usetmp%>')">
								<a href="javascript:void(0);" class="zz" id="tempImg<%=temp.get(0).toString()%>">
									<img src="<%=temp.get(2).toString()%>" class="templateimg">
									<em class="templatechoose">T<%=temp.get(1).toString()%></em> 
								</a>
							</li>
				<%
					}
				%>
						</ul>
				<%					
					}
				%>							
					</div>				
                    </div>
				<%						
					}					
				%>
                </div>
        </div>
    </div>
</div>
<input type="hidden" id="ad_client_id" value="<%=ad_client_id%>"/>
<%
	if(queryTempList.size()>0){
		List list = (List)queryTempList.get(0);
		//公司默认模板
%>
<input type="hidden" id="homeTemp" value="#tempImg<%=list.get(0).toString()%>"/>
<input type="hidden" id="listTemp" value="#tempImg<%=list.get(1).toString()%>"/>
<input type="hidden" id="classTemmp" value="#tempImg<%=list.get(2).toString()%>"/>
<%	
	}
%>
</body>
</html>
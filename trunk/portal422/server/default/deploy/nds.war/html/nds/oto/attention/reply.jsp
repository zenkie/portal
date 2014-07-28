<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%!
	private StringBuffer sb;
%>
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
	 
	int ad_client_id=0;
	ad_client_id=userWeb.getAdClientId();
	TableManager manager=TableManager.getInstance();
	String tableId="WX_MESSAGEAUTOONE";
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("KEYWORDS").getId());
	query.addSelection(table.getColumn("TITLE").getId());
	query.addSelection(table.getColumn("MESSAGETYPE").getId());
	query.addSelection(table.getColumn("NYTEPY").getId());
	query.addSelection(table.getColumn("GROUPID").getId());
	query.addSelection(table.getColumn("TABLEID").getId());
	query.addSelection(table.getColumn("PPTEPY").getId());
	
	int[] orderKey;
	Column colOrderNo = table.getColumn("ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	query.setOrderBy(orderKey, true);
	query.setRange(0,10000);
	
	result= QueryEngine.getInstance().doQuery(query);
	
	
	JSONObject jsonObjAll = new JSONObject();
	JSONObject obj;
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		obj = new JSONObject();
		String idNum =result.getString(1); 
		obj.put("ID",idNum);
		obj.put("KEYWORDS",result.getString(2));
		obj.put("TITLE",result.getString(3));
		obj.put("MESSAGETYPE",result.getString(4));
		obj.put("NYTEPY",result.getString(5));
		obj.put("GROUPID",result.getString(6));
		obj.put("TABLEID",result.getString(7));
		obj.put("PPTEPY",result.getString(8));
		jsonObjAll.put(idNum,obj);
	}
	gettebleHtml(jsonObjAll);
%>
<%!
  public void gettebleHtml(JSONObject orijsonAll){
		sb=new StringBuffer();
		sb.append("<thead>");
		sb.append("<tr><th width=\"150\">规则名称</th><th>关键词</th><th width=\"80\">回复消息类型</th><th width=\"60\">是否禁用</th><th width=\"100\">操作</th></tr>");
		sb.append("</thead><tbody>");
		for (Iterator iter = orijsonAll.keys(); iter.hasNext();) {
			String key = (String)iter.next();  
			if(key==null || key=="") continue;
			try {
				JSONObject jsonObj = (JSONObject)orijsonAll.get(key);
				if(jsonObj==null) continue;
				
				sb.append("<tr>");
				sb.append("<td>").append(jsonObj.get("TITLE")).append("</td>");
				sb.append("<td class=\"ltd\">").append(jsonObj.get("KEYWORDS")).append("</td>");
				sb.append("<td class=\"txtcenter\">").append(jsonObj.get("MESSAGETYPE")).append("</td>");
				Boolean nytype = !(String.valueOf(jsonObj.get("NYTEPY"))).equals("Y");
				sb.append("<td class=\"txtcenter\">").append((nytype)?"是":"否").append("</td>");
				sb.append("<td class=\"ltd\">").append("<a href=\"javascript:addKeywords(").append(jsonObj.get("ID")).append(")\">编辑</a>|").append("<a href=\"javascript:void(0)\" onclick=\"changeNytype(this,").append(jsonObj.get("ID")).append(",'").append((nytype)?"Y":"N").append("'").append(")\">").append((nytype)?"启用":"禁用").append("</a>|<a href=\"javascript:void(0)\" onclick=\"delautooneid(").append(jsonObj.get("ID")).append(")\" id=\"\">删除</a>").append("</td>");
				sb.append("</tr>");
			} catch (JSONException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		sb.append("</tbody>");
  }

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

	<title>自动回复</title>
	
	
	
	<script language="javascript" src="/html/nds/js/prototype.js"></script>
	<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
	<script language="javascript" src="/html/prg/upload/jquery.uploadify.min.js"></script>
	<script>
		jQuery.noConflict();
	</script>
	
	<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
	<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
	
	
	
	
	<script type="text/javascript" src="/html/nds/oto/attention/js/jquery.qqFace.js"></script>
	<script language="javascript" src="/html/nds/oto/attention/js/notFoundkeywords.js"></script>
<script language="javascript" src="/html/nds/oto/attention/js/fileupload.js"></script>
<script language="javascript" src="/html/nds/oto/js/AsyncBox.v1.4.5.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/menuoperation.js"></script>
	<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="/html/nds/oto/attention/css/base.css">
	<link rel="stylesheet" type="text/css" href="/html/nds/oto/attention/css/page.css">
	<link rel="stylesheet" type="text/css" href="/html/nds/oto/attention/css/wxreplay.css">
	<link rel="stylesheet" type="text/css" href="/html/nds/oto/attention/css/style.css">
<link type="text/css" href="/html/nds/oto/themes/01/css/asyncbox.css" rel="Stylesheet">
	<link type="text/css" href="/html/nds/oto/attention/css/reply.css" rel="Stylesheet">
	<link type="text/css" href="/html/nds/oto/attention/css/emotion.css" rel="Stylesheet">
	<link type="text/css" rel="StyleSheet" href="/html/prg/upload/uploadify.css">
<script type="text/javascript">
var notData = '{}';

var jsonObjAll = <%=jsonObjAll%>;
var ad_client_id=<%=ad_client_id%>;
	function addKeywords(autooneid){
		
		var url='/html/nds/oto/attention/keywordset.jsp';
		art.dialog.data('jsonObjAll',"");
		art.dialog.data('ad_client_id',ad_client_id);
		if(typeof(autooneid)!="undefined"){
			art.dialog.data('jsonObjAll', jsonObjAll[autooneid]);
		}
		var titleName="添加回复规则";
		var options={
				width:963,
				height:600,
				title:titleName,
				resize:false,
				drag:true,
				lock:true,
				esc:true,
				skin:'chrome',
				ispop:false,
				close:function(){
					//局部刷新显示页面刷新
						jQuery.post("/html/nds/oto/attention/replyData.jsp",
								{},
								function(data){
									jQuery(".tab").html(data);
									
							}
						);
				}
			}; 
		 
		art.dialog.open(url,options);
	}
	function delautooneid(autooneid){
		//delMenuArt("",);
		var _param = {command:"ObjectDelete",params:"{\"table\":\"WX_MESSAGEAUTOONE\",\"id\":"+autooneid+"}"};
	jQuery.ajax({
		url: '/html/nds/schema/restajax.jsp',
		type: 'post',
		data:_param,
		async: false,
		success:function(data){
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					art.dialog({
						time: 2,
						lock:true,
						cancel: false,
						content: '数据删除成功！',
					});
					jQuery.post("/html/nds/oto/attention/replyData.jsp",
							{},
							function(data){
								jQuery("#TableListFir").html(data);
						}
					);
                } else {
					art.dialog.tips("删除失败！");
                }
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {
				alert("返回错误信息"+textStatus+":::"+errorThrown);
			}
		});
		
	}
	var flagchange;
	function changeNytype(obj,autooneid,type){
		var _params="{\"table\":\"WX_MESSAGEAUTOONE\",";
			_params+="id:"+autooneid+",";
			_params+="partial_update:true,";
			_params+="NYTEPY:\""+type+"\"";
			_params+="}";
			editTable(_params);
			if(flagchange){
				art.dialog.tips("修改成功");
				jQuery.post("/html/nds/oto/attention/replyData.jsp",
								{},
								function(data){
									jQuery(".tab").html(data);
							}
						);
			}else{
				art.dialog.tips("修改失败");
			}
		//修改成功
		/*if(flagchange){
			art.dialog.tips("修改成功");
			if(type=="N"){
				obj.innerHTML = "启用";
				//jQuery(obj).attr("onclick","changeNytype(this,"+autooneid+",'Y')")
				obj.onclick=function onclick(event) {
				  changeNytype(this,2,'Y');
				}
				obj.parentNode.previousSibling.innerHTML="是";
			}else{
				obj.innerHTML = "禁用";
				//jQuery(obj).attr("onclick","changeNytype(this,"+autooneid+",'N')");
				obj.onclick=function onclick(event) {
				  changeNytype(obj,2,'N');
				}
				obj.parentNode.previousSibling.innerHTML="否";
			}
			//修改刷新内容
			jQuery.post("/html/nds/oto/attention/replyData.jsp",
					{},
					function(data){
						alert(data);
						jQuery("#TableList").html(data);
				}
			);	
			//修改json
			jsonObjAll[autooneid].NYTEPY = type;
			
		}else{
			art.dialog.tips("修改失败");
		}*/
	}
	function notFoundReply(){
		//notFoundKey.onreadyHtml();
		jQuery.post("/html/nds/oto/attention/notFound.jsp",
					{},
					function(data){
						jQuery("#tab2").html(data);
						//executeLoadedScript(jQuery("#tab2"));
				}
			);
	};
</script>



</head>
<body>
<div id="mainContent">
    <h4 id="aeaoofnhgocdbnbeljkmbjdmhbcokfdb-mousedown">消息自动回复</h4>
    <div class="tag-panel" style="float: left; ">
        <div class="tag-panel-head">
            <a href="javascript:void(0);" class="tag-panel-title tag-panel-iscurrent" onclick="jQuery(this).next().removeClass('tag-panel-title tag-panel-iscurrent');jQuery(this).next().addClass('tag-panel-title');jQuery(this).addClass('tag-panel-title tag-panel-iscurrent');jQuery('#tab1').show();jQuery('#tab2').hide();">关键词自动回复</a>
            <a href="javascript:void(0);" class="tag-panel-title" onclick="jQuery(this).prev().removeClass('tag-panel-title tag-panel-iscurrent');jQuery(this).prev().addClass('tag-panel-title');jQuery(this).addClass('tag-panel-title tag-panel-iscurrent');jQuery('#tab1').hide();jQuery('#tab2').show();notFoundReply();">不匹配默认回复</a>
        </div>
        <div class="tag-panel-content">
            <div id="tab1" style="display: block;">
                <div class="search">
					<input type="button" value="添加关键词" class="button" onclick="addKeywords()">
				</div>
                <div class="compartb"></div>
				<div class="list">
					<div class="tab">
						<table id="TableListFir" width="100%" class="tblist" border="0" cellspacing="0" cellpadding="0">
							
								<%=sb.toString()%>
						</table>	
					</div>
					
			
			 </div>
            </div>
            <div id="tab2" style="display: none;">
                
                               
            </div>
        </div>
    </div>
</div>
</body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
String dialogURL=request.getParameter("redirect");
if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
	return;
}
if(!userWeb.isActive()){
	session.invalidate();
	com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
	response.sendRedirect("/login.jsp");
	return;
}
%>
<%
	/**------获取参数---**/
	String objectTuwen = request.getParameter("objectTuwen");
	JSONObject joTuwen = new JSONObject(objectTuwen);
	System.out.println("==###===="+joTuwen);
	int imagewidth=200;
	int imageheight=200;
	if(joTuwen!=null&&joTuwen.has("imageSize")){
		String imageSize=joTuwen.optString("imageSize","smallImage");
		if("bigImage".equalsIgnoreCase(imageSize)){imagewidth=360;}
	}
	/**------获取参数 end---**/
	TableManager manager=TableManager.getInstance();
	String tableId="WX_JUMPURL";
	Table table,dataTable;
	int temp=-1;//用来区别首页模板的风格
	table= manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);
	
	JSONObject colUrlJsonObj=new JSONObject();
	
	
	result=null;
	table= manager.getTable(tableId);
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("NAME").getId());
	query.addSelection(table.getColumn("URL").getId());
	query.addSelection(table.getColumn("AD_TABLE_ID").getId());
	query.addSelection(table.getColumn("FIFTLE_DC").getId());
	query.addSelection(table.getColumn("SHOW_DC").getId());
	query.addSelection(table.getColumn("TMP_CLASS").getId());
	query.addSelection(table.getColumn("FIFTLE_CONDITION").getId());
	
	int[] orderKey;
	Column colOrderNo = table.getColumn("ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	query.setOrderBy(orderKey, true);
	
	query.setRange(0, Integer.MAX_VALUE  );

	result= QueryEngine.getInstance().doQuery(query);
	
	StringBuffer options=new StringBuffer();
	JSONObject menuArr=new JSONObject();
	JSONObject jc;
	options.append("<option value=\"\">==请选择跳转去向==</option>");
	int pType=0;
	if(joTuwen!=null && joTuwen.has("fromid") && joTuwen.get("fromid")!=null){
		try{pType = Integer.valueOf(String.valueOf(joTuwen.get("fromid")));}
		catch(Exception e){}
	}
	String sid = "";
	if(joTuwen!=null && joTuwen.has("objid") && joTuwen.get("objid")!=null){
		sid = String.valueOf(joTuwen.get("objid"));
	}
	String content1 = "";
	if(joTuwen!=null && joTuwen.has("content1") && joTuwen.get("content1")!=null){
		content1 = String.valueOf(joTuwen.get("content1"));
	}
	String title1 = "";
	if(joTuwen!=null && joTuwen.has("title1") && joTuwen.get("title1")!=null){
		title1 = String.valueOf(joTuwen.get("title1"));
	}
	String imgsrc = "";
	if(joTuwen!=null && joTuwen.has("url1") && joTuwen.get("url1")!=null){
		imgsrc = String.valueOf(joTuwen.get("url1"));
	}
	for (int i=0;i<result.getRowCount();i++){
			result.next();
			jc=new JSONObject(); 
			jc.put("ID",result.getObject(1));
			String jname =  String.valueOf(result.getObject(2));
			jc.put("NAME",jname);
			jc.put("URL",result.getObject(3));
			jc.put("AD_TABLE_ID",result.getObject(4));
			jc.put("FIFTLE_DC",result.getObject(5));
			jc.put("SHOW_DC",result.getObject(6));
			jc.put("TMP_CLASS",result.getObject(7));
			//FIFTLE_CONDITION
			jc.put("FIFTLE_CONDITION",result.getObject(8));
			options.append("<option value=\"");
			options.append(result.getString(1)).append("\"");
			if(pType==Integer.valueOf(result.getString(1))){
				options.append(" selected=\"selected\" ");
			}
			options.append(">");
			
			options.append(jname);
			options.append("</option>");
			
			menuArr.put(String.valueOf(result.getObject(1)),jc);
		}
%>

<style type="text/css">
.aui_main{overflow: auto;}
.uploadifive-button{
margin-top:130px!important;
}
</style>

<!--<link rel="stylesheet" type="text/css" href="../themes/01/css/uploadify.css">-->

<!--
<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
<link type="text/css" rel="StyleSheet" href="/html/prg/upload/uploadify.css">
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/oto/js/upload/jquery.uploadify.min.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>

<script language="javascript" src="/html/nds/oto/js/AsyncBox.v1.4.5.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
-->

<!--<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>-->

<script language="javascript" src="/html/nds/oto/js/webrootupload.js"></script>

<script language="javascript" src="/html/nds/oto/js/menuoperation.js"></script>



<link type="text/css" href="/html/nds/oto/attention/css/wxreplay.css" rel="Stylesheet">
<link href="/html/nds/oto/attention/css/reply.css" rel="stylesheet" type="text/css">

<link type="text/css" rel="StyleSheet" href="/html/nds/oto/js/prg/upload/uploadify.css">
 
<script type="text/javascript">
	var tuWen=<%=objectTuwen==null?null:objectTuwen.toString()%>;
	
	var proposalSize={
		bigImage:"360*200",
		smallImage:"200*200"
	};
	jQuery(document).ready(
		function init(){
			var sid="<%=sid%>";
			var imgsrc = "<%=imgsrc%>";
			if(imgsrc!=""){jQuery("#grouponimage").attr("src",imgsrc);}
			if(tuWen&&tuWen.hasOwnProperty("imageSize")){jQuery("#proposalSize").html(proposalSize[tuWen.imageSize]);}
			
			var reg = new RegExp("^[0-9]*$");
			if(sid&&reg.test(sid)&&!new RegExp("null|\s+","i").test(sid)){changeOpFir();}
			//判断到url
			if(sid&&!reg.test(sid)&&!new RegExp("null|\s+","i").test(sid)){
				jQuery("#goodsTable").html("<label for=\"writeUrl\">输入连接:</label><input id=\"writeUrl\" type=\"text\" name=\"writeUrl\" value=\""+sid+"\">");
			}
		}
	);
	function changeOpFir(){
		
		var se = String(document.getElementById("jumpType").value);
		var former;
		var arra=<%=menuArr%>;
		var sid="<%=sid%>";
		
		
		var select=arra[se];
		
		
		if(arra[se].SHOW_DC==null){
			jQuery("#goodsTable").html("");
		}else{
			var arr=JSON.stringify(select);
			
			jQuery.post("/html/nds/oto/object/addMenu_goodstable.jsp",
					{"arr":arr,"sid":sid},
					function(data){
					jQuery('#goodsTable').html(data);
				}
			);
		}
	}
	//下拉切换
	function changeOp(){
		var se = String(document.getElementById("jumpType").value);
		if(se==""){
			jQuery("#goodsTable").html("");
			return;
		}
		var former;
		var arra=<%=menuArr%>;
		//var sid=0;
		var select=arra[se];
		if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION==null){
			jQuery("#goodsTable").html("");
		}else if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION!=null){
			jQuery("#goodsTable").html("<label for=\"writeUrl\">输入连接:</label><input id=\"writeUrl\" type=\"text\" name=\"writeUrl\" value=\"http://\">");
		}else{
			
			var arr=JSON.stringify(select);
			jQuery.post("/html/nds/oto/object/addMenu_goodstable.jsp",
					{"arr":arr,"sid":0},
					function(data){
					jQuery('#goodsTable').html(data);
				}
			);
		}
	}
	//搜索
	function changSelection(){
		var tableId=jQuery("#tableID").val();
		var SHOW_DC=jQuery("#SHOW_DC").val();
		var artOrPro=jQuery("#artOrPro").val();
		var sigleid="";
		var chooseUrl=  document.getElementsByName("chooseUrl");
		if(chooseUrl.length>0){
			jQuery("#goodsTable").contents().find("input[name=chooseUrl]:checked").each(function () {
				sigleid = jQuery(this).val();
			});
		}
		jQuery('#listTable').html("正在查询，请耐心等待...");
		jQuery.post("/html/nds/oto/object/addMenu_tbody.jsp",
				{"tableId":tableId,"artOrPro":artOrPro,"SHOW_DC":SHOW_DC,"sid":sigleid,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
				function(data){
					
					jQuery('#listTable').html(data);
			}
		);		
	}
	//返回保存数据
	function submitMessage(){
		//跳转连接文字
		//var txtTitle=jQuery("#txtTitle").val().trim();
		var txtTitle=jQuery("#txtTitle").val();
		if(txtTitle==""){
			art.dialog.tips('您未输入链接文字！');
			return false;
		}
		var grouponimage=jQuery("#grouponimage").attr("src");
		if(grouponimage=="/html/nds/oto/themes/01/images/noimage.png"){
			art.dialog.tips('您未上传图片！');
			return false;
		}
		//获得描述
		//var description = jQuery("#description").val().trim();
		var description = jQuery("#description").val();
		if(description==""){
			art.dialog.tips('您未输入描述！');
			return false;
		}
		//获得ptype
		var fromid=jQuery("#jumpType").val();
		if(fromid=="" || fromid.length <= 0){
			art.dialog.tips('请选择跳转去向！');
			return false;
		}
		//获得id
		var sigleid="";
		//如果是input type=“text”
		var writeUrl=  document.getElementById("writeUrl");
		if(writeUrl!=null){
			sigleid=writeUrl.value+"";
		}
		var chooseUrl=  document.getElementsByName("chooseUrl");
		if(chooseUrl.length>=0){
			jQuery("#goodsTable").contents().find("input[name=chooseUrl]:checked").each(function () {
				sigleid = jQuery(this).val();
				return false;
			});
		}
		if(!tuWen){
			tuWen={
				"fromid":-1,
				"objid":"",
				"title1":"",
				"content1":description,
				"wx_media_id1":"",
				"url1":"",
				"gourl1":"",
				"groupid1":"",
				"imageSize":"smallImage"
			};
		}
		tuWen.fromid=fromid;
		tuWen.objid=sigleid;
		tuWen.title1=txtTitle;
		tuWen.url1=grouponimage;
		tuWen.content1=description;
		
		art.dialog.data('obj',tuWen);// 存储数据
		art.dialog.list['load_dialog'].close();
	}
	art.dialog.data('obj',null);
	
	function cancelMessage(){
		art.dialog.data('obj',null);
		art.dialog.list['load_dialog'].close();
	}
	var upinit={
		'sizeLimit':1024*1024 *1,
		'buttonText'	: '上传图片',
		'fileDesc'      : '上传文件(dat)',
		'fileExt'		: '*.dat;'
	};
	var para={
		//"next-screen":"/html/prg/msgjson.jsp",
		//"formRequest":"/html/nds/msg.jsp",
		//"JSESSIONID":"<%=session.getId()%>",
		"isThum":true,
		"width":<%=imagewidth%>,
		"hight":<%=imageheight%>,
		"onsuccess":"jQuery(\"#grouponimage\").attr(\"src\",\"$filepath$\");",
		"onfail":"alert(\"上传图片失败，请重新选择上传\");"	,
		"modname":"menuAdd"
	};
	

</script>


    <div id="mainContent" style="height: 460px;">
    <div id="contentWrap">
        <table class="fieldTable">
            <tbody>
				<tr>
					<th>
					</th>
					<td>
						<input type="submit" value="保存" id="btn" class="btnGreenS" onclick="submitMessage()">
						 <input type="submit" value="取消" id="btn" class="btnGreenS" onclick="cancelMessage()">
					</td>
				</tr>
				<tr>
					<th>链接文字：</th>
					<td>
						<input type="text" id="txtTitle" maxlength="100" class="txt350" value="<%=title1%>">
					</td>
				</tr>
				<tr style="">
					<th>
						栏目图片：
					</th>
					<td>
						<img src="/html/nds/oto/themes/01/images/noimage.png" alt="" id="grouponimage" name="showPic" width="120" height="120" style="float:left; padding-right:20px;">
						<input type="hidden" id="PicUrl" name="PicUrl" value="">
						<input type="button" class="btn" id="fileInput1" name="imgFile" value="选择图片">
						<label id="spUpload">
						</label>
						<span class="required">*</span>
						<label style="color: red; font-size: 14px;">&nbsp;&nbsp;</label>
						<font style="font-size:12px;color:red;">建议大小：<span id="proposalSize"><span></font>
					</td>
				</tr>
				<tr>              
					<th>
						图文描述：
					</th>
					<td>
						<textarea id="description"  placeholder="请在此输入您的回复内容，1000字以内" autocomplete="off" class="txtarea" style="width: 480px;height:64px;"><%=content1%></textarea>
						
						<br/>
						<font style="font-size:12px;color:red;">若只有一条图文，回复用户时显示描述；否则不显示。</font>
					</td>
				</tr>
				<tr>              
					<th>
						链接目标：
					</th>
					<td>
						<select id="jumpType" name="jumpType" onchange="changeOp()">
							<%=options%>
						</select>
						
					   
					</td>
				</tr>
				<tr>
					<th></th>
					<td><div id="goodsTable" style="border:none;"></div></td>
				</tr>
			</tbody>
		</table>
        </form>
    </div>
	<p id="whole"></p>

<script>
			  fup.initForm(upinit,para,"fileInput1");
</script>
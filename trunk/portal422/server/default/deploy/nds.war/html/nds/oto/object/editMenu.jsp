<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	/**------获取参数---**/
	String bycat=request.getParameter("bycat");
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
	//String colUrl=null;
	String colid="";
	int pType=0;
	//判断是否是编辑
	String sid="";
	colid=request.getParameter("colid");
	//org.json.JSONObject colJsonObj = new org.json.JSONObject("{'ID':'','COLTITLE':'','SUBTITLE':'','COLPHOTO':'/html/nds/oto/themes/01/images/noimage.png','COLURL':''}");
	org.json.JSONObject colJsonObj = new org.json.JSONObject("{'ID':'','COLTITLE':'','SUBTITLE':'','COLPHOTO':'/html/nds/oto/themes/01/images/noimage.png','fromid':'','objid':''}");
	String ISENABLEDCheck="";
	if(Integer.valueOf(colid)!=-1 && !"".equals(colid)){
		query=engine.createRequest(userWeb.getSession());
		table= manager.getTable("WX_SETCOLUMN");
		query.addSelection(table.getColumn("ID").getId());
		query.addSelection(table.getColumn("COLTITLE").getId());
		query.addSelection(table.getColumn("SUBTITLE").getId());
		query.addSelection(table.getColumn("COLPHOTO").getId());
		query.addSelection(table.getColumn("FROMID").getId());
		query.addSelection(table.getColumn("OBJID").getId());
		query.addSelection(table.getColumn("ISENABLED").getId());
		
		query.addParam(table.getColumn("ID").getId()," = "+colid);
		
		result= QueryEngine.getInstance().doQuery(query);
		result.next();
		
		colJsonObj.put("ID",result.getObject(1));
		colJsonObj.put("COLTITLE",result.getObject(2));
		//子标题不一定存在
		if(result.getObject(3)==null){
			colJsonObj.put("SUBTITLE","");
		}else{
			colJsonObj.put("SUBTITLE",result.getObject(3));
		}
		colJsonObj.put("COLPHOTO",result.getObject(4));
		//colUrl=String.valueOf(result.getObject(5));
		pType=Integer.valueOf(result.getString(5));
		if(result.getString(6)!=null && !"".equals(result.getString(6))){
			sid=result.getString(6);
		}
		
		
		if("Y".equals(result.getObject(7))){
			
			ISENABLEDCheck="checked=\"checked\"";
		}
	}
	org.json.JSONObject colUrlJsonObj=new org.json.JSONObject();
	
	//colUrlJsonObj保存colUrl
	//if(colUrl!=null && !"".equals(colUrl)){
	//	colUrlJsonObj=new org.json.JSONObject(colUrl);
	//	pType=colUrlJsonObj.optInt("ptype");
	//	sid=colUrlJsonObj.optInt("sid");
	//}
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
	//
	
	
	int[] orderKey;
	Column colOrderNo = table.getColumn("ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	query.setOrderBy(orderKey, true);
	
	query.setRange(0, Integer.MAX_VALUE  );
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission

	result= QueryEngine.getInstance().doQuery(query);
	QueryResultMetaData meta=result.getMetaData();
	
	int urgentCount=0;	
	StringBuffer options=new StringBuffer();
	org.json.JSONObject menuArr=new org.json.JSONObject();
	org.json.JSONObject jc;
	options.append("<option value=\"\">==请选择跳转去向==</option>");
	for (int i=0;i<result.getRowCount();i++){
			result.next();
			jc=new org.json.JSONObject(); 
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<!--<link rel="stylesheet" type="text/css" href="../themes/01/css/uploadify.css">-->
<link type="text/css" rel="StyleSheet" href="/html/prg/upload/uploadify.css">
<script language="javascript" src="/html/nds/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/js/upload/jquery.uploadify.min.js"></script>
<script>
	jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script type="text/javascript">


jQuery(document).ready(
		 function a(){
			
			var colid=<%=colid%>;
			var sp="<%=sid%>";
			var reg = new RegExp("^[0-9]*$");
			//判断到url
			 if(!reg.test(sp)){
				jQuery("#goodsTable").html("<label for=\"writeUrl\">输入连接:</label><input id=\"writeUrl\" type=\"text\" name=\"writeUrl\" value=\""+sp+"\">");
				return;
			 }
			
			if(colid!=-1){
					changeOpFir();
			}
			
        }

);

function showPicEve(e,sUrl){
	var x,y;
	x=e.clientX;
	y=e.clientY;
	document.getElementById("Layer1").style.left = x+2+'px'; 
	document.getElementById("Layer1").style.top = y+2+'px'; 
	document.getElementById("Layer1").innerHTML = "<img border='0' src=\"" + sUrl + "\">"; 
	document.getElementById("Layer1").style.display = ""; 
}
function hiddenPicEve(){ 
	document.getElementById("Layer1").innerHTML = ""; 
	document.getElementById("Layer1").style.display = "none"; 
} 

function changeOpFir(){
	
	var se = String(document.getElementById("jumpType").value);
	if(se==null){
		jQuery("#goodsTable").html("");
		return;
	}
	var former;
	var arra=<%=menuArr%>;
	var sid="<%=sid%>";
	
	var select=arra[se];
	if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION=="text"){
		jQuery("#goodsTable").html("");
	}else if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION!="text"){
		jQuery("#goodsTable").html("<label for=\"writeUrl\">输入连接:</label><input id=\"writeUrl\" type=\"text\" name=\"writeUrl\" value=\"http://\">");
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


var upinit={
            'sizeLimit':1024*1024 *1,
            'buttonText'	: '上传图片',
            'fileDesc'      : '上传文件(dat)',
            'fileExt'		: '*.dat;'
        };
        var para={
            "next-screen":"/html/prg/msgjson.jsp",
            "formRequest":"/html/nds/msg.jsp",
           // "JSESSIONID":"<%=session.getId()%>",
			"isThum":true,
			"width":600,
			"hight":600,
			"onsuccess":"jQuery(\"#grouponimage\").attr(\"src\",\"$filepath$\");",
			"onfail":"alert(\"上传图片失败，请重新选择上传\");"	,
			"modname":"menuAdd"
        };
        jQuery(document).ready(function(){
              fup.initForm(upinit,para);
        });

function submitMessage(){
	var _params="{\"table\":15921,";
	var editOrAdd="ObjectCreate";
	var colidnum = <%=colid%>;
	
	if(!(colidnum==-1)){
		//修改
		_params+="\"id\":"+colidnum+",";
		_params+="\"partial_update\":true,";
		editOrAdd="ObjectModify";
	}else{
	//新增
		//添加bycat
		_params+="\"BYCAT\":\"<%=bycat%>\",";
	}
	
	//栏目名称
	var coltitle=jQuery("#ChannelName").val();
	if(coltitle=="" || coltitle.length <= 0){
		alert("请输入栏目名称");
		return false;
	}
	_params+="\"COLTITLE\":\""+coltitle+"\",";
	//子标题
	var SUBTITLE=jQuery("#SubChannelName").val();
	if(!(SUBTITLE=="" || SUBTITLE.length <= 0)){
		_params+="\"SUBTITLE\":\""+SUBTITLE+"\",";
	}
	//栏目图片
	var grouponimage=jQuery("#grouponimage").attr("src");
	if(grouponimage=="/html/nds/oto/themes/01/images/noimage.png" || grouponimage.length <= 0){
		alert("请上传栏目图片");
		return false;
	}
	_params+="\"COLPHOTO\":\""+grouponimage+"\",";
	
	//跳转去向
	//获得ptype
	var jumpType=jQuery("#jumpType").val();
	if(jumpType=="" || jumpType.length <= 0){
		alert("请选择跳转去向");
		return false;
	}
	_params+="\"FROMID\":"+jumpType;
	
	//获得id
	var sigleid="";
	//如果是input type=“text”
	var writeUrl=  document.getElementById("writeUrl");
	if(writeUrl!=null){
		var val="";
		val=writeUrl.value+"";
		//匹配
		_params+=",\"OBJID\":\"";
		_params+=val+"\"";
	}
	var chooseUrl=  document.getElementsByName("chooseUrl");
	if(chooseUrl.length>=0){
		
		jQuery("#goodsTable").contents().find("input[name=chooseUrl]:checked").each(function () {
			sigleid = jQuery(this).val();
			 _params+=",\"OBJID\":"+sigleid;
        });
		
	}
	
	//是否启用
	if(jQuery("#IsHidden").attr("checked")){
		_params+=",\"ISENABLED\":\"Y\"";
	}else{
		_params+=",\"ISENABLED\":\"N\"";
	}
	_params+="}";
	
	//alert(_params);
	jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:editOrAdd+"",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
					art.dialog({
						time: 2,
						lock:true,
						cancel: false,
						content: '数据操作成功'
					});
					art.dialog.close();
                } else {
                    alert("操作失败！");
                }
            },
			error:function (XMLHttpRequest, textStatus, errorThrown) {
				alert("返回错误信息"+textStatus+":::"+errorThrown);
			}
			
        });
	
	
}
function cancelMessage(){
	art.dialog.close();
}
</script>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
<title>自动回复</title>

</head>
<body>
<div id="Layer1" style="display: none; position: absolute; z-index: 100;">
    </div>
    <div id="mainContent">
    <h4> 微官网&nbsp;&gt;&nbsp;栏目添加</h4>
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
                <th>
                    栏目名称：
                </th>
                <td>
                    <input id="ChannelName" type="text" name="ChannelName" value="<%=colJsonObj.get("COLTITLE")%>" style="width: 250px;">
                    <span class="required">*</span>
                    <a id="whatLanMu" href="javascript:void(0);" onmouseout="hiddenPicEve()" onmouseover="showPicEve(event,'/html/nds/oto/themes/01/images/lmmc.jpg')" class="tooltip">什么是栏目名称?</a>
                </td>
            </tr>
            <tr class="popupBox-firstTr" style="">
                <th>
                    子标题：
                </th>
                <td>
                    <input id="SubChannelName" type="text" name="SubChannelName" value="<%=colJsonObj.get("SUBTITLE")%>" style="width: 250px;">
                    <a id="whatLanMu" href="javascript:void(0);" onmouseout="hiddenPicEve();" onmousemove="showPicEve(event,'/html/nds/oto/themes/01/images/zbt.jpg');" class="tooltip">什么是栏目子标题?</a>
                </td>
            </tr>
            <tr style="">
                <th>
                    栏目图片：
                </th>
                <td>
                    <img src="<%=colJsonObj.get("COLPHOTO")%>" alt="" id="grouponimage" name="showPic" width="120" height="120" style="float:left; padding-right:20px;">
                    <input type="hidden" id="PicUrl" name="PicUrl" value="">
                    <input type="button" class="btn" id="fileInput1" name="imgFile" value="选择图片">
                    <label id="spUpload">
                    </label>
                    <span class="required">*</span>
                    <label style="color: red; font-size: 12px;">
                        &nbsp;&nbsp;
                        </label>
						<font style="font-size:12px;color:red;">建议大小：300*200</font>
                </td>
            </tr>
           <tr class="popupBox-firstTr" style="">
                <th>
                    是否启用：
                </th>
                <td>
					<input type="checkbox" id="IsHidden" <%=ISENABLEDCheck%> name="IsHidden" value="">  
                </td>
            </tr>

            <tr>
                <th>
                    跳转去向：
                </th>
                <td>
					<select id="jumpType" name="jumpType" onchange="changeOp()">
						<%=options%>
                    </select>
                    <span style="color:#ababab;font-size:14px;">
						（用户点击栏目时候跳转到的内容页面）
					</span>
                   
                </td>
            </tr>
			<tr>
				<th></th>
				<td><div id="goodsTable" style="border:none;"></div></td>
			</tr>
            
        </tbody></table>
        </form>
    </div>
	<p id="whole"></p>
</body>
</html>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ include file="top_meta.jsp" %>
<%
	/**------获取参数---**/
	String str1=request.getParameter("username");
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
	String colUrl=null;
	//判断是否是编辑
	String colid=request.getParameter("colid");
	//org.json.JSONObject colJsonObj = new org.json.JSONObject("{'ID':'','COLTITLE':'','SUBTITLE':'','COLPHOTO':'/html/nds/oto/themes/01/images/noimage.png','COLURL':''}");
	org.json.JSONObject colJsonObj = new org.json.JSONObject("{'ID':'','COLTITLE':'','SUBTITLE':'','COLPHOTO':'/html/nds/oto/themes/01/images/noimage.png','fromid':'','objid':''}");
	int pType=0;
	int sid=0;
	if(colid!=null && !"".equals(colid)){
		query=engine.createRequest(userWeb.getSession());
		table= manager.getTable("WX_SETCOLUMN");
		query.addSelection(table.getColumn("ID").getId());
		query.addSelection(table.getColumn("COLTITLE").getId());
		query.addSelection(table.getColumn("SUBTITLE").getId());
		query.addSelection(table.getColumn("COLPHOTO").getId());
		//query.addSelection(table.getColumn("COLURL").getId());
		query.addSelection(table.getColumn("FROMID").getId());
		query.addSelection(table.getColumn("OBJID").getId());
		
		query.addParam(table.getColumn("ID").getId()," = "+colid);
		
		result= QueryEngine.getInstance().doQuery(query);
		result.next();
		
		colJsonObj.put("ID",result.getObject(1));
		colJsonObj.put("COLTITLE",result.getObject(2));
		colJsonObj.put("SUBTITLE",result.getObject(3));
		colJsonObj.put("COLPHOTO",result.getObject(4));
		//colUrl=String.valueOf(result.getObject(5));
		pType=result.getObject(5);
		sid=result.getObject(6);
	}
	//org.json.JSONObject colUrlJsonObj=new org.json.JSONObject();
	
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
			options.append("<option value=\"");
			options.append(result.getString(1)).append("\"");
			if(pType==Integer.valueOf(result.getString(1))){
				options.append(" selected=\"selected\" ");
			}
			options.append(">");
			
			options.append(jname);
			options.append("</option>");
			System.out.println(options.toString());
			menuArr.put(String.valueOf(result.getObject(1)),jc);
		}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<link href="/html/nds/oto/themes/01/css/reply.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<link rel="stylesheet" type="text/css" href="../themes/01/css/uploadify.css">


	<script language="javascript" src="/html/nds/js/jquery1.3.2/hover_intent.min.js"></script>
	<script language="javascript" src="/html/nds/js/upload/jquery.uploadify.min.js"></script>
	<script>
		jQuery.noConflict();
	</script>
	<script language="javascript" src="/html/nds/js/prototype.js"></script>
	<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>

<script type="text/javascript">

jQuery(document).ready(
		 function a(){
			var sid=<%=sid%>;
			alert(sid);
			if(sid!=0){
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
	var former;
	var arra=<%=menuArr%>;
	var sid=<%=sid%>;
	var select=arra[se];
	if(arra[se].SHOW_DC==null){
		jQuery("#goodsTable").html("");
	}else{
	
		var arr=JSON.stringify(select);
		
		jQuery.post("addMenu_goodstable.jsp",
					{"arr":arr,"sid":sid},
					function(data){
				//alert(data);
					jQuery('#goodsTable').html(data);
				}
			);
		}
}
function changeOp(){
	var se = String(document.getElementById("jumpType").value);
	var former;
	var arra=<%=menuArr%>;
	var sid=0;
	var select=arra[se];
	if(arra[se].SHOW_DC==null){
		jQuery("#goodsTable").html("");
	}else{
	
		var arr=JSON.stringify(select);
		
		jQuery.post("addMenu_goodstable.jsp",
					{"arr":arr,"sid":sid},
					function(data){
				//alert(data);
					jQuery('#goodsTable').html(data);
				}
			);
		}
}

function changSelection(){
		var tableId=jQuery("#tableID").val();
		var SHOW_DC=jQuery("#SHOW_DC").val();
		var artOrPro=jQuery("#artOrPro").val();
		jQuery('#listTable').html("正在查询，请耐心等待...");
		jQuery.post("addMenu_tbody.jsp",
					{"tableId":tableId,"artOrPro":artOrPro,"SHOW_DC":SHOW_DC,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
					function(data){
				//alert(data);
					jQuery('#listTable').html(data);
				}
			);		
}
function changSelectionSe(no){
		
		var pageSize=no;
		var tableId=jQuery("#tableID").val();
		var artOrPro=jQuery("#artOrPro").val();
		var SHOW_DC=jQuery("#SHOW_DC").val();
		var STYLE_TYPE=jQuery("#STYLE_TYPE").val();
		jQuery('#listTable').html("正在查询，请耐心等待...");
		jQuery.post("addMenu_tbody.jsp",
					{"tableId":tableId,"artOrPro":artOrPro,"SHOW_DC":SHOW_DC,"STYLE_TYPE":STYLE_TYPE,"pageSize":pageSize,"options": decodeURIComponent(jQuery(".goodsChoose form").serialize(),true)},
					function(data){
				//alert(data);
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
</script>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
<title>自动回复</title>

</head>
<body>
<div id="Layer1" style="display: none; position: absolute; z-index: 100;">
    </div>
    <div id="mainContent">
    <div class="location">
        微官网&nbsp;&gt;&nbsp;栏目添加
    </div>
    <div id="contentWrap">
        <table class="fieldTable">
            <tbody>
			<tr>
                <th>
                </th>
                <td>
                    <input type="submit" value="保存" id="btn" class="btn">
                </td>
            </tr>
			<tr>
                <th>
                    栏目名称：
                </th>
                <td>
                    <input id="ChannelName" type="text" name="ChannelName" value="<%=colJsonObj.get("COLTITLE")%>" style="width: 250px;">
                    <span class="required">*</span>
                    <a id="whatLanMu" href="/html/nds/oto/themes/01/images/lmmc.jpg" onmouseout="hiddenPicEve()" onmouseover="showPicEve(event,'/html/nds/oto/themes/01/images/lmmc.jpg')" class="tooltip">什么是栏目名称?</a>
                </td>
            </tr>
            <tr class="popupBox-firstTr" style="">
                <th>
                    子标题：
                </th>
                <td>
                    <input id="SubChannelName" type="text" name="SubChannelName" value="<%=colJsonObj.get("SUBTITLE")%>" style="width: 250px;">
                    <a id="whatLanMu" onmouseout="hiddenPicEve();" onmousemove="showPicEve(event,'/html/nds/oto/themes/01/images/zbt.jpg');" href="/html/nds/oto/themes/01/images/zbt.jpg" class="tooltip">什么是栏目子标题?</a>
                </td>
            </tr>
            <tr style="">
                <th>
                    栏目图片：
                </th>
                <td>
                    <img src="<%=colJsonObj.get("COLPHOTO")%>" alt="" id="grouponimage" name="showPic" width="50" height="50" style="float:left; padding-right:20px;">
                    <input type="hidden" id="PicUrl" name="PicUrl" value="">
                    <input type="button" class="btn" id="fileInput1" name="imgFile" value="选择图片">
                    <label id="spUpload">
                    </label>
                    <span class="required">*</span>
                    <label style="color: red; font-size: 14px;">
                        &nbsp;&nbsp;
                        </label>
                </td>
            </tr>
            <tr style="display:none;">
                <th>
                    是否启用：
                </th>
                <td>
                    <input type="checkbox" id="IsHidden" name="IsHidden" checked="" value="true">
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

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	/**------获取参数---**/
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
	
	org.json.JSONObject colUrlJsonObj=new org.json.JSONObject();
	
	
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

<script>
	jQuery.noConflict();
</script>


<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>

<!--
<link rel="stylesheet" type="text/css" href="../themes/01/css/uploadify.css">

<script language="javascript" src="/html/nds/js/upload/jquery.uploadify.min.js"></script>
<script language="javascript" src="/html/nds/js/jquery1.3.2/hover_intent.min.js"></script>
<script language="javascript" src="/html/nds/js/prototype.js"></script>
<script language="javascript" src="/html/nds/oto/js/keywords.js"></script>
<script language="javascript" src="/html/nds/oto/js/menuopration.js"></script>
<script language="javascript" src="/html/nds/oto/js/AsyncBox.v1.4.5.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/oto/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/oto/groupon/js/fileupload.js"></script>
<script language="javascript" src="/html/nds/oto/js/application.js"></script>
<script language="javascript" src="/html/nds/oto/js/dw_scroller.js"></script>
-->



<script type="text/javascript">
art.dialog.data('url',"");
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
	if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION=="text"){
		jQuery("#goodsTable").html("");
	}else if(arra[se].SHOW_DC==null && arra[se].FIFTLE_CONDITION!="text"){
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
	var txtTitle=jQuery("#txtTitle").val().trim();
	if(txtTitle==""){
		art.dialog.tips('您未输入链接文字！');
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
        });
	}
	
	if(fromid!=""){
		var arra=<%=menuArr%>;
		var url = '@@\\"fromid\\":'+fromid;
		//if(sigleid!=""){
			url += ',\\"replace\\":\\"'+sigleid+'\\"';
		//}	
		url+='@@';
		url='[@a href="'+url+'"@]'+txtTitle+'[@/a@]';
		/*var url = arra[fromid].URL;  
		if(sigleid!="")
			url=url.replace("@ID@",sigleid);
		url='[@ href="'+url+'">'+txtTitle+'</@]';*/
		art.dialog.data('url',url);// 存储数据
	//art.dialog.data('objid', sigleid);// 存储数据
	}
	art.dialog.close();
}



function cancelMessage(){
	art.dialog.close();
}
</script>
<head>


</head>
<body style="width:auto;height:auto;">
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
                    <input type="text" id="txtTitle" maxlength="100" class="txt350">
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
            
        </tbody></table>
        </form>
    </div>
</body>
</html>

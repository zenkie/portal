<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp"%>
<%@ page
	import="java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	String grouponid = request.getParameter("ID");//请求编辑团购ID
	TableManager manager=TableManager.getInstance();
	String tableId="WX_GROUPON";//需要读取的表
	Table table;
	int clientId = userWeb.getAdClientId();
	table=manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("NAME").getId());
	query.addSelection(table.getColumn("PRICE").getId());
	query.addSelection(table.getColumn("PHOTO").getId());
	query.addSelection(table.getColumn("STARTTIME").getId());
	query.addSelection(table.getColumn("ENDTIME").getId());
	query.addSelection(table.getColumn("ISENABLED").getId());
	query.addSelection(table.getColumn("WX_APPENDGOODS_ID").getId());
	if(grouponid != null && !grouponid.equals("")){
		query.addParam(table.getColumn("ID").getId(), grouponid);//添加条件
	}	
	query.setRange(0, Integer.MAX_VALUE  );
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);
	result= QueryEngine.getInstance().doQuery(query);
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String id="",name="",price="";
	String photo="",start="",end="";//表中的各个字段
	String isenabled="",goods_id="";
	if(grouponid != null && !grouponid.equals("")){
	for (int j = 0; j < 1; j++) {
			result.next();			
			id = result.getObject(1).toString();
			name = result.getObject(2).toString();
			price = result.getObject(3).toString();
			photo = result.getObject(4).toString();
			start = sdf.format((Date)result.getObject(5));
			end = sdf.format((Date)result.getObject(6));
			isenabled = result.getObject(7).toString();
			goods_id = result.getObject(8).toString();
}
}			
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">    
    <script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
	<script language="javascript" src="/html/nds/js/jquery1.3.2/hover_intent.min.js"></script>
	<script language="javascript" src="/html/nds/js/upload/jquery.uploadify.min.js"></script>
	<script>
		jQuery.noConflict();
	</script>
	<script language="javascript" src="/html/nds/js/prototype.js"></script>
	<script language="javascript" src="./js/fileupload.js"></script>
	<script language="javascript" src="./js/WdatePIcker.js"></script>
	<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
	<link rel="stylesheet" type="text/css" href="./css/uploadify.css">	
	<link href="./css/goodsCatg.css" rel="stylesheet" type="text/css">
    <link type="text/css" rel="stylesheet" href="./css/style.css"></link>
	<link type="text/css" rel="stylesheet" href="./css/index.css"></link>
 <title>编辑团购</title>
</head>
<body>    
	<div id="mainContent">
       <h4 id=""><a href="./index.jsp">微团购</a>&nbsp;&gt;&nbsp;编辑团购</h4>
    <div id="contentWrap">
	<div id="operaterBar">
		<input type="button" class="btn searchBtn" value="保存" onclick="AddGroupon()">
		<input id="grouponid" type="hidden" value="<%=grouponid!=null?grouponid:0%>">
	</div>
	<div class="tableDiv">
        <table class="fieldTable">
            <tbody><tr>
                <th>
                    团购名称：
                </th>
                <td>
                    <input type="text" id="groupontitle" name="groupontitle" value="<%=name%>" maxlength="128">
                    <span class="required">*</span>
                    <br><span class="tiptext">（最多不超过128个汉字）</span>
                </td>
            </tr>
            <tr>
                <th>
                    团购价格：
                </th>
                <td>
                    <input type="text" id="gorouponprice" name="gorouponprice" value="<%=price%>" onkeyup="this.value=this.value.replace(/\D/g,&#39;&#39;)" onafterpaste="this.value=this.value.replace(/\D/g,&#39;&#39;)" onchange="this.value=this.value.replace(/\D/g,&#39;&#39;)">元
                    <span class="required">*</span>
                </td>
            </tr>
            <tr>
                <th>
                    团购图片：
                </th>
                <td>
                    <img src="<%=photo%>" style="border:1px solid #c0c0c0; width:50px; height:50px;float:left" id="grouponimage">
                    <input type="button" name="imgFile" class="btn searchBtn" id="fileInput1" value="选择图片">
                    <span class="required">*</span>
                    <span class="tiptext">（建议上传尺寸为600px*600px的图片）</span>
                </td>
            </tr>
            <tr>
                <th>
                    开始时间：
                </th>
                <td>
                    <input class="Wdate" type="text" id="begintime" name="begintime" value="<%=start%>" onclick="beginDatePicker();">
                    <span class="required">*</span>
                </td>
            </tr>
            <tr>
                <th>
                    结束时间：
                </th>
                <td>
                    <input class="Wdate" type="text" id="endtime" name="endtime" value="<%=end%>" onclick="endDatePicker();">
                    <span class="required">*</span>
                </td>
            </tr>
            <tr>
                <th>
                    选择参加团购的商品：
                </th>
                <td>
                    <span class="required">*</span>
                </td>
            </tr>
            <tr>
                <th>
                </th>
                <td>
				<div>
				<fieldset class="forsearch">
				<div>
                    <label for="">&nbsp;&nbsp;&nbsp;&nbsp;名称：</label><input type="text" id="lblGoodsName" name="goodsName">
                    <input type="hidden" id="lblGoodsTypeID" name="goodsTypeID" value="">
                    <input type="hidden" id="mulitSelect" name="mulitSelect" value="">
                    <input class="btn searchBtn" type="submit" value="搜索" id="btnSearch" onclick="searchGoods()">
                </div>
				</fieldset>
				</div>
                    <div>
                        <iframe src="./goodsPaged.jsp?goods_id=<%=goods_id%>" id="iframepage" name="iframepage" frameborder="0" width="100%" height="400px"></iframe>
                    </div>
                </td>
            </tr>
        </tbody></table>
		</div>
    </div>
</div>
<div id="whole">
</div>
<script type="text/javascript">
    var upinit={
            'sizeLimit':1024*1024 *1,
            'buttonText'	: '选择图片',
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
			"modname":"gounpon"
        };
        jQuery(document).ready(function(){
               fup.initForm(upinit,para); 
        });
		
    function beginDatePicker() {
        WdatePicker({
            el: "begintime", dateFmt: 'yyyy-MM-dd HH:mm:ss', minDate: '%y-%M-%d %H:%m:%s'
        });
    }
     function endDatePicker() {
        var begin = jQuery("#begintime").val();
        if (begin == "") {
            begin = "%y/%M/%d %H:%m:%s";
        }
        WdatePicker({ el: "endtime", dateFmt: 'yyyy-MM-dd HH:mm:ss', minDate: '' + begin });
    }
	
	function searchGoods(){
		var searchWord = "./goodsPaged.jsp?goodsName="+jQuery("#lblGoodsName").val();
		jQuery('#iframepage').attr("src",searchWord);
	}

    function AddGroupon() {
        var title = jQuery("#groupontitle").val().trim();
        var price = jQuery("#gorouponprice").val();
		var img = jQuery("#grouponimage").attr("src");
        var begintime = jQuery("#begintime").val();
        var endtime = jQuery("#endtime").val();
        var goodsid = 0;
		var grouponid = jQuery("#grouponid").val();
		var remaintime = Date.parse(endtime)-Date.parse(begintime);
	   jQuery("#iframepage").contents().find("input[name=GoodsCheckbox]:checked").each(function () {
            goodsid = jQuery(this).val();
        });
		
        if (goodsid == 0) {
            alert("请选择商品！");
            return false;
        }

        if (title == "" || title.length <= 0) {
            alert("请输入团购名称！");
            return false;
        }

        if (price == "" || price.length <= 0) {
            alert("请输入价格！");
            return false;
        }		
		if(remaintime < 0){
			alert("请重新选择时间");
			return false;
		}
		
		if(grouponid == 0){
				art.dialog({
				time: 2,
				lock:true,
				cancel: false,
				content: '编辑失败，请重新编辑',
				close:function(){
					location.href = "/html/nds/oto/groupon/index.jsp";
				}
				
				});
		}
		
		goodsid = goodsid.replace(/goods_/,"");
		var _params = "{\"table\":15979,\"id\":"+grouponid+",\"partial_update\":true,\"NAME\":\""+title+"\",\"PRICE\":"+price+",\"PHOTO\":\""+img+"\",\"STARTTIME\":\""+begintime+"\",\"ENDTIME\":\""+endtime+"\",\"WX_APPENDGOODS_ID\":"+goodsid+"}";
        jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectModify",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
				art.dialog({
				time: 2,
				lock:true,
				cancel: false,
				content: '编辑数据成功',
				close:function(){
					location.href = "/html/nds/oto/groupon/index.jsp";
				}
				
				});
				
                } else {
                    alert("编辑数据成功");
                }
            }	
			
        });
    }
</script>
</body></html>
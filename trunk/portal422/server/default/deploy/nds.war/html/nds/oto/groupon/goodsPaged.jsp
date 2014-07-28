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
	String goods_id = request.getParameter("goods_id");//请求编辑团购ID
	String goods_name = request.getParameter("goodsName")!=null?request.getParameter("goodsName"):"";//请求编辑团购ID
	int pageNow = request.getParameter("p")!=null ? Integer.parseInt(request.getParameter("p")):0;//分页计数
	int pageSize = 8;//一页总数
	int pageCount;//总页数
	StringBuffer pageString = new StringBuffer();//分页html
	TableManager manager=TableManager.getInstance();
	String tableId="WX_APPENDGOODS";//需要读取的表
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
	query.addSelection(table.getColumn("ITEMNAME").getId());
	query.addSelection(table.getColumn("ITEMPHOTO").getId());
	if(goods_id != null && !goods_id.equals("")){
		query.addParam(table.getColumn("ID").getId(), goods_id);//添加条件
	}
	if(goods_name != null && !goods_name.equals("")){
		query.addParam(table.getColumn("ITEMNAME").getId(), goods_name);//添加条件
	}		
	query.setRange(pageNow*pageSize,pageSize);
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);
	result= QueryEngine.getInstance().doQuery(query);
	pageCount = (result.getTotalRowCount()-1)/pageSize+1;
	if(pageCount > 1 ){	//进行分页
		if(pageNow == 0){
			pageString.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageNow+1)+"' class='paging-item'>下一页</a>")
			.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageCount-1)+"' class='lastPage paging-item'>尾页</a>");
		}else if(pageNow == pageCount-1){
			pageString.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+0+"' class='firstPage paging-item'>首页</a>")
			.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageNow-1)+"' class='paging-item'>上一页</a>");
		
		}else{
			pageString.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+0+"' class='firstPage paging-item'>首页</a>")
			.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageNow-1)+"' class='paging-item'>上一页</a>")
			.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageNow+1)+"' class='paging-item'>下一页</a>")
			.append("<a href='./goodsPaged.jsp?goodsName="+goods_name+"&p="+(pageCount-1)+"' class='lastPage paging-item'>尾页</a>");
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>_TemplateLayout</title>
	<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
	<script language="javascript">
	   jQuery.noConflict();
	</script>
    <link href="./css/style.css" rel="stylesheet" type="text/css">
    <link href="./css/goodsCatg.css" rel="stylesheet" type="text/css">
    <link href="./css/index.css" rel="stylesheet" type="text/css">	
</head>
<body>
 <div id="mainContent">
      <div id="contentWrap" style="height:342px;overflow:auto;border:1px black">
        <table id="goodsTable" class="normaltable">
            <thead>
                <tr>
                    <th>选择</th>
                    <th>名称</th>
                </tr>
            </thead>
            <tbody>
			<%
			for (int j = 0; j < result.getRowCount(); j++) {
				result.next();
				String check = goods_id!=null?"checked='true'":"";
				String itemId = result.getObject(1).toString();
				String itemName= result.getObject(2).toString();
				String itemPhoto= (result.getObject(3)!=null)?result.getObject(3).toString():"null";
				
			%>
                <tr>
                    <td>
                        <input type="checkbox" <%=check%> name="GoodsCheckbox" class="chainShopID" value="goods_<%=itemId%>" onclick="selectOne(this)">
                    </td>
                    <td>
                        <a href="<%=itemPhoto%>" class="tooltip" target="_blank">
                        <img src="<%=itemPhoto%>" width="50px" height="50px" style="float: left;padding-left:5px"></a>
                        <span title="<%=itemName%>" style="width: 100px; float: left; text-align: left; margin-left: 10px">
						<%							
							if(itemName.length()>8){
								itemName = StringUtil.shorten(itemName,7);
							}
						%>
						<%=itemName%>
						</span>
                    </td>

                </tr>
			<%
			}
			%>
            </tbody>
        </table>        
    </div>
	<div id="countPages">
		<div class='paging mt20'>
		<%=pageString.toString()%>
		</div>
        </div>
</div>
<script type="text/javascript">
    var mulit = '';

    function selectOne(obj) {
        if (mulit != '1') {
            var objCheckBox = document.getElementsByName("GoodsCheckbox");
            for (var i = 0; i < objCheckBox.length; i++) {
                //判断复选框集合中的i元素是否为obj，若为否则便是未被选中 
                if (objCheckBox[i] != obj) {
                    objCheckBox[i].checked = false;
                } else {
                    //若是，原先为被勾选的变成勾选，反之则变成未勾选 
                    //objCheckBox[i].checked = obj.checked; 
                    //或者使用下句，亦可达到同样效果 
                    objCheckBox[i].checked = true;
                }
            }
        }
        else {
            var idlist = jQuery('#idList', window.parent.document).val();
            if (obj.checked == true) {
                idlist += obj.value + "|";
                jQuery('#idList', window.parent.document).val(idlist);
            }
            else {
                var currentVal = obj.value + "|";
                jQuery('#idList', window.parent.document).val(idlist.replace(currentVal, ""))
            }
        }
    }
    function clearGoodisList() {
        if (jQuery('#idList', window.parent.document).val()) {
            jQuery('#idList', window.parent.document).val("");
        }
    }
    
</script>
</body></html>
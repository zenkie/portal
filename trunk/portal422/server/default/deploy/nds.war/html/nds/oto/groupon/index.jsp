<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp"%>
<%@ page
	import="java.text.*,java.util.*,java.util.Map.Entry,java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
	query.setRange(0, Integer.MAX_VALUE  );
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);
	result= QueryEngine.getInstance().doQuery(query);
	StringBuffer[] groupon = getContent(result);	
%>
<%!
private StringBuffer[] getContent(QueryResult result){
		StringBuffer currentGroupon = new StringBuffer();
		StringBuffer pastGroupon = new StringBuffer();
		StringBuffer[] groupon = new StringBuffer[2];
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try{
		String id=null,name=null,price=null;
		String photo=null,end=null;//表中的各个字段
		String isenabled=null,goods_id=null;
		String start=null;
		String remainTime = null;
		for (int j = 0; j < result.getRowCount(); j++) {
			result.next();			
			id = result.getObject(1).toString();
			name = result.getObject(2).toString();
			price = result.getObject(3).toString();
			photo = result.getObject(4).toString();
			start = sdf.format((Date)result.getObject(5));
			end = sdf.format((Date)result.getObject(6));
			isenabled = result.getObject(7).toString();
			goods_id = result.getObject(8).toString();
			remainTime = calculateRemainTime(end);
			if(isenabled.equals("Y")){
			currentGroupon.append("<tr><td><a id='imga_"+id+"' href='"+photo+"' target='_blank' class='tooltip'> <img src='")
			.append(photo+"' width='50' height='50' style='float: left;padding-left:5px'/></a>")
			.append(" <span style='width:150px;float: left; text-align: left; margin-left: 10px'>"+name+"</span><script>try{jQuery(\"#imga_"+id+"\").imgShowPop();}catch(e){};</script></td>")
			.append("<td>"+price+"</td><td>"+start+"</td><td>"+remainTime+"</td><td style='display:none;'>0</td>")
			.append("<td><a	href='./editGounpon.jsp?ID="+id+"' class='operateBtn'>编辑</a><a href='javascript:void(0)' onclick='EndGroupon("+id+")'")
			.append("class='operateBtn'>结束</a><a href='"+id+"' class='operateBtn' style='display:none;'>团购的用户</a> <a")
			.append("class='operateBtn board' id='board93' href='javascript:void(0)' onclick=''> 复制链接</a> <br/>")
			.append("<a class='operateBtn' href=''>设置微信回复关键词</a><a class='operateBtn' href=''>设置微网站栏目</a></td></tr>");
			}
			else{
			pastGroupon.append("<tr><td><a id='imga_"+id+"' href='"+photo+"' class='tooltip'> <img src='"+photo+"'")
			.append(" width='50' height='50' style='float: left;padding-left:5px'></a>")
			.append(" <span	style='width:150px;float: left; text-align: left; margin-left: 10px'>"+name+"</span><script>try{jQuery(\"#imga_"+id+"\").imgShowPop();}catch(e){};</script></td>")
			.append("<td>"+price+"</td><td>"+start+"</td><td>"+remainTime+"</td><td style='display:none;'>0</td><td><a href='")
			.append(id+"' class='operateBtn' style='display:none;'>团购的用户</a>")
			.append("<a class='operateBtn' onclick='DelGroupon("+id+");' href='javascript:void(0)'>删除</a>")
			.append("<a class='operateBtn' href=''>设置微信回复关键词</a>	<a class='operateBtn' href=''>设置微网站栏目</a></td></tr>");
			}
			
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		groupon[0] = currentGroupon;
		groupon[1] = pastGroupon;
		return 	groupon;
	}
	
	private String calculateRemainTime(String endTime){//计算剩余时间
		SimpleDateFormat dfs = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date begin;
		java.util.Date end;
		String remainTime=null;
		try {
			begin = dfs.parse(dfs.format(new Date()));
			end = dfs.parse(endTime);
			long remain = end.getTime() - begin.getTime();// 除以1000是为了转换成秒
			if(remain > 0){
				long day = remain / (1000 * 60 * 60 * 24);
				long hour = remain / (1000 * 60 * 60) % 24;
				long min = remain / (1000 * 60) % 60;
				long s = remain / 1000 % 60;
				remainTime="" + day + "天" + hour + "小时" + min + "分" + s + "秒";
			}else{
				remainTime = "已经结束";
			}
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return remainTime;
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
	<script language="javascript">
	   jQuery.noConflict();
	</script>
<script type="text/javascript" src="/html/nds/oto/js/jqzoom/imgShowPop.js"></script>
<script type="text/javascript" src="./js/ssdptabs.js"></script>
<script type="text/javascript" src="./js/ZeroClipboard.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<link type="text/css" rel="stylesheet" href="./css/style.css"></link>
<link type="text/css" rel="stylesheet" href="./css/goodsCatg.css"></link>
<link type="text/css" rel="stylesheet" href="./css/index.css"></link>
<title>微团购</title>
</head>
<body>
	<div id="mainContent" class="mainContentH">
		<h4>微团购</h4>
		<div id="contentWrap">
			<div id="operaterBar">
				<a href="./addGounpon.htm" class="btn">发起团购</a>
			</div>
			<div id="tabs" class="tag-panel">
				<div class="tag-panel-head">
					<a style="cursor: pointer;" id="tab1" class="tag-panel-title"
						rel="#current">正在进行的团购</a> <a style="cursor: pointer;" id="tab2"
						class="tag-panel-title" rel="#past">往期团购</a>
				</div>
				<div class="tag-panel-content1">
					<div id="current" class="tag-panel-content" style="display: none;">
						<table id="goodsTable" class="normaltable" style="width:100%;">
							<thead>
								<tr>
									<th>名称</th>
									<th>价格</th>
									<th>开始时间</th>
									<th>剩余时间</th>
									<th style="display:none;">参团人数</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
								<%=groupon[0]%>
							</tbody>
						</table>
					</div>
					<div id="past" class="tag-panel-content" style="display: none;">
						<table id="goodsTable" class="normaltable" style="width:100%;">
							<thead>
								<tr>
									<th>名称</th>
									<th>价格</th>
									<th>开始时间</th>
									<th>剩余时间</th>
									<th style="display:none;">参团人数</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							<%=groupon[1]%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
    jQuery(function () {
        jQuery("#tabs").ssdptabs();
        jQuery(".board").each(function () {
            var dataId = jQuery(this).attr("dataId");
            var data = jQuery(this).attr("data");
            toClipboard(dataId, data);
        });
    });
  
    jQuery("#tab1").click(function () {
        jQuery("embed").parent().remove();
        jQuery(".board").each(function () {
            var dataId = jQuery(this).attr("dataId");
            var data = jQuery(this).attr("data");
            toClipboard(dataId, data);
        });

    });
    jQuery("#tab2").click(function () {
        jQuery("embed").parent().remove();
    });
  
    function toClipboard(copy_id, text) {
        var clip = new ZeroClipboard.Client();
        clip.setHandCursor(true);
        clip.setText(text);
        clip.addEventListener('complete', function (client) {
            alert("链接地址已复制！");
        });
        clip.glue(copy_id);
    }


    //团购
    function EndGroupon(grouponid) {
        if (confirm("确定要结束团购吗？")) {
        var _params = "{\"webaction\":131,\"id\":"+grouponid+"}";        
            jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ExecuteWebAction",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
				art.dialog({
				time: 2,
				lock:true,
				cancel: false,
				content: '结束团购成功',
				close:function(){
					location.href = "/html/nds/oto/groupon/index.jsp";
				}
				
				});
				
                } else {
                    alert("结束团购失败！");
                }
            }
        });
        }        
    }

    function DelGroupon(grouponid) {
	var _params = "{\"table\":15979,\"id\":"+grouponid+"}";
        if (confirm("确定要删除吗？")) {
            jQuery.ajax({
            url: '/html/nds/schema/restajax.jsp',
            type: 'post',
            data:{command:"ObjectDelete",params:_params},
			success: function (data) {
			var _data = eval("("+data+")");
                if (_data[0].code == 0) {
				art.dialog({
				time: 2,
				lock:true,
				cancel: false,
				content: '删除数据成功',
				close:function(){
					location.href = "/html/nds/oto/groupon/index.jsp";
				}
				
				});
				
                } else {
                    alert("删除数据失败！");
                }
            }
			
        });
        }
    }
</script>
</body>
</html>
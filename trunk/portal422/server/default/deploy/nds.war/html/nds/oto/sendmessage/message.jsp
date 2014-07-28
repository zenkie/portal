<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/oto/sendmessage/getWeixin.jsp"%>
<%
	String vipid = request.getParameter("id");
	int ad_client_id=userWeb.getAdClientId();
	TableManager manager=TableManager.getInstance();
	String tableId="WX_MESSGAE";
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory = table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryEngine engine=QueryEngine.getInstance();
	QueryRequestImpl query = engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("WX_VIP_ID;NAME").getId());//用户昵称
	query.addSelection(table.getColumn("WX_VIP_ID;PHOTO").getId());//用户图像
	query.addSelection(table.getColumn("MESSAGE").getId());
	query.addSelection(table.getColumn("SEND_TIME").getId());
	query.addParam(table.getColumn("WX_VIP_ID").getId(),vipid);
	int[] orderKey;//排序
	Column colOrderNo = table.getColumn("ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	query.setOrderBy(orderKey, false);//降序
	//query.setRange(0, Integer.MAX_VALUE);
	query.setRange(0, 8);
	Expression sexpr= userWeb.getSecurityFilter(table.getName(), 1);// read permission
	query.addParam(sexpr);	
	QueryResult result = QueryEngine.getInstance().doQuery(query);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script language="javascript" src="/html/nds/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript">
   jQuery.noConflict();
</script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=simple"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/plugins/iframeTools.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/dialog_min.js"></script>
<script language="javascript" src="/html/nds/oto/sendmessage/js/loadmore.js"></script>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/sendmessage/css/message.css">
<link rel="stylesheet" type="text/css" href="/html/nds/oto/sendmessage/css/dialog.css">
<title>全部消息</title>
</head>  
<body style="overflow-x:hidden;">
<div class="main_bd" style="width:421px;margin-top: 20px;">
	<div class="main_head">
		<h3>全部消息</h3>
	</div>
	<ul>
		<%
		try{
		String id="";
		String name="";
		String photo="";		
		String message="";
		String time="";
		for (int j = 0; j < result.getRowCount(); j++) {
			result.next();			
			id = result.getObject(1).toString();
			name = result.getObject(2).toString();
			photo = (result.getObject(3)!=null)?result.getObject(3).toString():"/html/nds/oto/themes/01/images/upimg.jpg";
			message = result.getObject(4).toString();
			time = result.getObject(5).toString();
			
			%>
			<li class="message_item replyMessage" data-id="<%=id%>">
			<div class="message_avatar">
				<a target="_blank" href="<%=photo%>">
					<img src="<%=photo%>">
				</a>
			</div>
			<div class="message_info">				
				<div class="message_time">
					<%=time%>
				</div>
				<div class="nickname">
					<%=name%>
				</div>
			</div>
			<div class="message_content left_content">
				<%=message%>
			</div>
			</li>
		<%			
			String searchmenu="select id,orginalcontent,creationdate,msgtype,groupid from wx_notify where id in(select wx_notify_id from wx_notifymember where wx_messgae_id = ?  and state='Y') and ad_client_id = ?  ORDER by id desc";
			List notifyList=QueryEngine.getInstance().doQueryList(searchmenu,new Object[]{id,ad_client_id});
			Object clobMessage=null;
			String notifyId="";
			String notifyTime="";
			String notifyMessage="";
			
			if(notifyList!=null&&notifyList.size()>0){
				for(int i=0;i < notifyList.size(); i++){
					List notify = (List)notifyList.get(i);
					notifyId = notify.get(0).toString();
					clobMessage = notify.get(1);
					notifyTime = notify.get(2).toString();
					if(clobMessage==null || clobMessage.equals("")){
						notifyMessage = "";
					}else{
						java.sql.Clob clob=(java.sql.Clob)clobMessage;
						Reader inStream = clob.getCharacterStream();
						char[] c = new char[(int) clob.length()];
						inStream.read(c);
						notifyMessage = new String(c);
						inStream.close();
					}					
			%>
			<li class="message_item">
			<div class="message_avatar" style="float:right;margin-left: 15px;">
				<a target="_blank" href="<%=clientQRCODE%>">
					<img src="<%=clientQRCODE%>">
				</a>
			</div>
			<div class="message_info">				
				<div class="message_time" style="float:left;">
					<%=notifyTime%>
				</div>
				<div class="nickname" style="float:right;">
					<%=clientWXNUM%>
				</div>
			</div>
			<%
					if(Integer.parseInt(notify.get(3).toString()) == 6){
						String searchmenu1="select url from wx_noitfyitem where groupid = ? and ad_client_id= ? and sort=0";
					    Object tuwen=QueryEngine.getInstance().doQueryOne(searchmenu1,new Object[]{notify.get(4).toString(),ad_client_id});	
			%>
			<div class="message_content right_content" style="margin-top: 28px;height: 40px;">
				<div class="appmsgImgArea">
					<img src="<%=tuwen.toString()%>">
				</div>
				<div class="appmsgContentArea">
					<a href="javascript:void(0);" onclick="showTuwen(<%=notify.get(4).toString()%>)">
						[图文消息]
					</a>
				</div>
			</div>
			</li>
			<%
			
			}else{
					
			%>
			<div class="message_content right_content" style="margin-top: 28px;">
				<%=notifyMessage%>
			</div>
			</li>						
			<%
				}				
			}
			}		
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		%>		 
		</ul>
	  </div>
<input type="hidden" id="total" value="<%=result.getTotalRowCount()%>"/>
<input type="hidden" id="issue" value="<%=vipid%>"/>
</body>
</html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.control.util.ValueHolder,java.net.*,java.io.*,java.text.*"%>
<%@ page import="nds.rest.RestUtils"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
			String indentID = request.getParameter("id");
			TableManager manager=TableManager.getInstance();
			String tableId="WX_ORDERITEM";
			
			Table table = manager.getTable(tableId);
			if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
			
			QueryEngine engine=QueryEngine.getInstance();
			QueryRequestImpl query = engine.createRequest(null);
			query.setMainTable(table.getId());
			query.addSelection(table.getColumn("ID").getId());
			query.addSelection(table.getColumn("WX_APPENDGOODS_ID;ITEMNAME").getId());//商品名称		
			query.addSelection(table.getColumn("WX_APPENDGOODS_ID;ITEMPHOTO").getId());//商品图像			
			query.addSelection(table.getColumn("QTY").getId());	//商品数量				
			query.addSelection(table.getColumn("SIZE_NAME").getId());	//商品规格
			query.addSelection(table.getColumn("PRICELIST").getId());//商品单价

			query.addParam(table.getColumn("WX_ORDER_ID").getId(),indentID);
			int[] orderKey;//排序
			Column colOrderNo = table.getColumn("ID");
			if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
			else orderKey= new int[]{ table.getAlternateKey().getId()};
			query.setOrderBy(orderKey, false);//降序
			query.setRange(0, Integer.MAX_VALUE);
			QueryResult result = QueryEngine.getInstance().doQuery(query);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="x-rim-auto-match" content="none">
<link rel="stylesheet" type="text/css" href="./css/main.css" />
<title>快递查询</title>
</head>
<body>
	<div class="viewport">
		<!--<header class="navbar">
			<ul>
				<li>查看物流</li>
				<li> <a href="javascript:history.go(-1)" class="c-btn c-btn-aw">返回</a> </li>
				<li> </li>
			</ul>
		</header>-->
		
		<section class="content">
			<div class="wrap">
				<!--<div class="inactive prev"></div>-->
				<div class="active">
					<div id="J_oper_plugin">						
					<%
						String content = null;
						String com = request.getParameter("com");
						String nu = request.getParameter("nu");
						try {								
								URL url = new URL("http://api.ickd.cn/?id=EA08B368D6C199E50704D412EB3B5DEA&com="+com+"&nu="+nu+"&type=json&ord=desc");
								URLConnection con = url.openConnection();
								con.setAllowUserInteraction(false);
								InputStream urlStream = url.openStream();
								String type = con.guessContentTypeFromStream(urlStream);
								String charSet = "gbk";
								if (type == null)
									type = con.getContentType();

								if (type == null || type.trim().length() == 0
										|| type.trim().indexOf("text/html") < 0)
									return;

								if (type.indexOf("charset=") > 0)
									charSet = type.substring(type.indexOf("charset=") + 8);

								byte b[] = new byte[10000];
								int numRead = urlStream.read(b);
								content = new String(b, 0, numRead,charSet);
								while (numRead != -1) {
									numRead = urlStream.read(b);
									if (numRead != -1) {
										 String newContent = new String(b, 0, numRead, charSet);
										content += newContent;
									}
								}
								urlStream.close();
							} catch (MalformedURLException e) {
								e.printStackTrace();
							} catch (IOException e) {
								e.printStackTrace();
							}
					%>
					<%
						JSONObject jso=new JSONObject(content);
						String errCode = jso.getString("errCode");
						if(errCode.equals("0")){						
					%>
						<div class="logis-info">
							<div class="logis-tit">
								<p style="font-size: 17px;"><%=jso.getString("expTextName")%></p>
								<p></p>								
								<p>运单编号:<%=jso.getString("mailNo")%></p>
			
							</div>
						</div>
						<div class="logis-order" style="padding-top: 72px;">商品详情</div>
						
							<%
								String id="";
								String goodsname="";
								String photo="";								
								String amount="";	
								String goossize="";	
								String price="";								
								
								for (int j = 0; j < result.getRowCount(); j++) {
									result.next();			
									id = result.getObject(1).toString();
									goodsname = result.getObject(2).toString();
									photo = (result.getObject(3)!=null)?result.getObject(3).toString():"/html/nds/oto/themes/01/images/upimg.jpg";									
									amount = result.getObject(4).toString();
									goossize = result.getObject(5).toString();
									price = result.getObject(6).toString();
									
							%>
									<div class="mb-ollr">							
										<div class="ol-l">
											<img style="border: 1px solid #ddd;" src="<%=photo%>" height="60px" width="60px">
										</div>
										<div class="ol-r">
											<div style="color: #898989;height: 33px;"><%=goodsname%></div>
											<div style="color: #898989;">规格：x<%=goossize%></div>
											<div style="float: left;color: #898989;">￥<%=price%>&nbsp;&nbsp;&nbsp;</div>
											<div style="color: #898989;">x<%=amount%></div>
											
										</div>
									</div>
							<%
							}
							%>
						
						<div class="logis-order">物流详情</div>
					<%	JSONArray array=jso.getJSONArray("data");%>
						<div class="logis-detail">
							<ul style="padding-top: 41px;">
								<%	
								Date today=new Date();//今天的日期
								Date newDate=null;//新的日期
								Date oldDate=new Date();//中间值
								
								
								int flag=0;//用来判断是否要写p标签的判断条件
								int index=0;//用来做为明天以及明天以后的判断条件
								
								int countToday=0;//用来判断是否是今天重复数据的判断条件
								int countYestoday=0;//用来判断是否是昨天重复数据的判断条件
								int countMore=0;//用来判断是否是昨天以前重复数据的判断条件
								
								String pContent="";//p标签里面的内容
								String todayStr="";//今天的日期字符串
								String oldDateStr ="";//记录数据
								String newDateStr ="";//新的一条日期字符串
								for (int i = 0; i < array.length(); i++) {//遍历data数组里的数据
								
								String str=array.getString(i);//数组里面取出的单个json格式数据
								
								JSONObject  jsonStr=new JSONObject(str);
								
								newDateStr=jsonStr.getString("time").split(" ")[0];//获得日期字符串

								SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");//日期格式：字符串与日期转换时候用到	
								
								todayStr=sdf.format(today);// 把今天的日期转换为字符串
								
								//首先判断是否是今天的日期
								//if (newDateStr.equals(todayStr)&&countToday==0) {
								//	pContent="今天";//今天的数据第一次出现
								//	countToday=1;
								//	flag=0;
								//}
								//else 
								if(newDateStr.equals(todayStr)&&countToday==1){//今天的数据重复出现
									flag=1;
								}
								else{
									//把字符串转换为日期
									newDate=sdf.parse(newDateStr);
									oldDate=sdf.parse(todayStr);
									
									//计算相差天数
									Calendar cal = Calendar.getInstance();
									cal.setTime(newDate);
									long time1 = cal.getTimeInMillis();
									cal.setTime(oldDate);
									long time2 = cal.getTimeInMillis();
									long between_days = (time2 - time1) / (1000 * 3600 * 24);
									index = Integer.parseInt(String.valueOf(between_days));
									if(index==1&&countYestoday==0){//昨天的数据第一次出现
										pContent="昨天";
										countYestoday=1;
										flag=0;
									}
									else if(index==1&&countYestoday==1){//昨天的数据重复出现
										flag=1;
									}
									else if(index>1){	
										if(countMore==0){//昨天以前第一次出现的数据
											pContent=newDateStr.substring(5,newDateStr.length());
											flag=0;
											countMore++;
										}
										else 
										{
											if(oldDateStr.equals(newDateStr))
												{
													flag=1;
												}
											else
												{
													pContent=newDateStr.substring(5,newDateStr.length());//昨天以前第一次以后其他的第一次数据
													flag=0;
												}
										}
									}
									oldDateStr=newDateStr;
								if(flag==0){
								%>								
							    <li>								
									<div class="logis-detail-d logis-detail-first">										
										<div class="logis-detail-content" style="position:absolute;top:-14px;">
									
											<div class="logis-detail-content-detail">
												<div><%=jsonStr.getString("context")%></div>
												<div><%=jsonStr.getString("time")%></div>
											</div>										
										</div>
										
									</div>
								</li>
								
								<%}else if(flag==1){%>
								
								<li>
									
									<div class="logis-detail-d ">
										
										<div class="logis-detail-content" style="position:absolute;top:-14px;">
										
											<div class="logis-detail-content-detail">
												<div><%=jsonStr.getString("context")%></div>
												<div><%=jsonStr.getString("time")%></div>
											</div>
											
										</div>										
									</div>
								</li>
								
								<%
								}
								}
								}
								%>
							</ul>
						</div>
						<%
						}else{
						%>
						<div class="logis-info">						
							<p style="color:red;"><%=jso.getString("message")%></p>
							<p style="color:red;">订单不存在或订单还未发货，请与管理员联系</p>
						</div>
						<%
						}
						%>
					</div>
				</div>
			  </div>
		</section>
	</div>
</body>
</html>
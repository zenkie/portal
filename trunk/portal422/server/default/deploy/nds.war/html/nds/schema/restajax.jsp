<%@ page language="java" import="nds.rest.*,org.json.*,java.net.*,java.io.*,javax.sql.*,java.util.*,nds.util.*,nds.query.*,nds.weixin.ext.*" pageEncoding="utf-8"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%
	java.sql.Connection conn=null;
	PreparedStatement stmt;
	ResultSet rs;
	String command=request.getParameter("command");
	String cmdparam=  request.getParameter("params");
	String appkey=  request.getParameter("appkey");
	String pwd=  request.getParameter("pwd");
	int ad_clientid=-1;
	try{
	String psql="select t.email from users t where t.name='root' and t.ad_client_id=?";
	conn=QueryEngine.getInstance().getConnection();
	if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
	java.net.URL url = new java.net.URL(request.getRequestURL().toString());
	WeUtilsManager Wemanage =WeUtilsManager.getInstance();
	WeUtils wu =Wemanage.getByDomain(url.getHost());
	ad_clientid=wu.getAd_client_id();
	//WeUtils wu=Wemanage.getByAdClientId(userWeb.getAdClientId());
	//System.out.print(url.getHost());
	//folderName=Wemanage.getAdClientTemplateFolder(url.getHost());
	}else{
	ad_clientid=userWeb.getAdClientId();
	}
	stmt=conn.prepareStatement(psql);
	stmt.setString(1,String.valueOf(ad_clientid));
	rs=stmt.executeQuery();
	if (!rs.next()){rs.close();stmt.close();return;};
	appkey=rs.getString("email");
	rs.close();
	stmt.close();
	}catch(Exception e) {
	out.println("error:"+e.getMessage());
	}
	finally{if(conn!=null)conn.close();}
	if(appkey==null){appkey="nea@burgeon.com.cn";}
	if(pwd==null){pwd="123456";}
	//System.out.print(command);
	//System.out.print(appkey);
	//System.out.print(pwd);
	
	//System.out.print(cmdparam);
	String serverUrl=null;
	ValueHolder vh= null;
	JSONArray ja=null;
if(	command !=null){
	SimpleDateFormat a=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSS");
	a.setLenient(false);
	
	HashMap<String, String> params =new HashMap<String, String>();
	params.put("sip_appkey",appkey);
	params.put("sip_timestamp", a.format(new Date()));
	params.put("sip_sign",pwd);
/*
tranaction - 单个Transaction的内容，不能与transactions 同时存在
transactions -[transaction,...] //多个Transaction, 一个transaction里的多个操作将全部成功，或全部失败，每个Transaction对象的定义见下
transaction:{
	id: <transaction-id> // 通过ID使得客户端能获取transaction的执行情况
	command:"ObjectCreate"|"ObjectModify"|"ObjectDelete"|"ObjectSubmit"|"WebAction"|"ProcessOrder"|"Query"|"Import",//Transaction的操作命令
	params:{ //操作命令的参数
		<command-param>:<command-value>,
		...
	}*/
	JSONObject tra=new JSONObject();
	tra.put("id", 112);
	tra.put("command",command);
	
	tra.put("params",  new JSONObject(cmdparam));
	
	ja=new JSONArray();
	ja.put(tra);
	
	params.put("transactions", ja.toString());

	Enumeration  enu=request.getHeaders("Origin");
//System.out.print(request.getServerName());
	if(enu.hasMoreElements()){ 

		//serverUrl=(String)enu.nextElement(); 
	}
	
	if(serverUrl==null)serverUrl=request.getScheme()+"://localhost:"+request.getServerPort();  
	//System.out.print(serverUrl);
	vh=RestUtils.sendRequest(serverUrl+"/servlets/binserv/Rest", params,"POST");
	//System.out.print(vh.get("message"));

}	
if(vh!=null){%>
<%=vh.get("message")%>
<%}%> 

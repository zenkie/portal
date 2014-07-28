<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

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
	 
	String groupid=request.getParameter("groupid");
	String tableName=request.getParameter("tableName");
	TableManager manager=TableManager.getInstance();
	//String tableId="WX_MESSAGEAUTOITEM";
	String tableId=tableName;
	StringBuffer sb = new StringBuffer();
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	QueryEngine engine=QueryEngine.getInstance();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryRequestImpl query;
	
	QueryResult result=null;
	
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("TITLE").getId());
	query.addSelection(table.getColumn("URL").getId());
	query.addSelection(table.getColumn("FROMID").getId());
	query.addSelection(table.getColumn("OBJID").getId());
	query.addSelection(table.getColumn("SORT").getId());
	query.addSelection(table.getColumn("CONTENT").getId());
	
	query.addParam(table.getColumn("GROUPID").getId()," = "+groupid);
	Column sortOrderNo = table.getColumn("sort");
	int colOrder[];
	if(sortOrderNo!=null) 
		colOrder=new int[]{sortOrderNo.getId()};
	else
		colOrder= new int[]{table.getColumn("ID").getId()};
	query.setOrderBy(colOrder, true);
	
	result= QueryEngine.getInstance().doQuery(query);
	JSONObject menuAll=new JSONObject();
	JSONObject menuArr=new JSONObject();
	JSONObject jc;
	List<String> keysOr =new ArrayList<String>();
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		jc=new org.json.JSONObject();
		String id = String.valueOf(result.getObject(1));
		jc.put("title1",result.getObject(2));
		jc.put("url1",result.getObject(3));
		jc.put("fromid",result.getObject(4));
		Object o = result.getObject(5);
		if(o!=null)
			jc.put("objid",o);
		else
			jc.put("objid","");
		//String o = (result.getObject(5))?String.valueOf(result.getObject(5):"";
		jc.put("sort",result.getObject(6));
		jc.put("content1",result.getObject(7));
		menuArr.put(id,jc);
		keysOr.add(id);
	}
	System.out.println(menuArr);
	menuAll.put("keysSort",keysOr);
	menuAll.put("menuArr",menuArr);
	System.out.println("menuAll+====="+menuAll); 
	//getHtml(menuArr);
%>
<%!
public void getHtml(JSONObject jo){
	int i = 0;
	for (Iterator iterator = jo.keys(); iterator.hasNext();) { //先遍历整个 people 对象    
		try {
			 String key = (String)iterator.next();  
			 JSONObject jsonObj = (JSONObject)jo.get(key);
			 if(i==0){
			 }
			System.out.println(jsonObj); 
		} catch (JSONException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
	} 
};
%>
<%=menuAll%>


<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="org.json.JSONObject,org.json.JSONArray,org.json.JSONException,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%!
	private StringBuffer sb;
%>
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
	String tableId="WX_MESSAGEAUTOONE";
	
	Table table = manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("KEYWORDS").getId());
	query.addSelection(table.getColumn("TITLE").getId());
	query.addSelection(table.getColumn("MESSAGETYPE").getId());
	query.addSelection(table.getColumn("NYTEPY").getId());
	query.addSelection(table.getColumn("GROUPID").getId());
	query.addSelection(table.getColumn("TABLEID").getId());
	query.addSelection(table.getColumn("PPTEPY").getId());
	
	int[] orderKey;
	Column colOrderNo = table.getColumn("ID");
	if(colOrderNo!=null)orderKey= new int[]{ colOrderNo.getId()};
	else orderKey= new int[]{ table.getAlternateKey().getId()};
	query.setOrderBy(orderKey, true);
	query.setRange(0,10000);
	result= QueryEngine.getInstance().doQuery(query);
	
	
	JSONObject jsonObjAll = new JSONObject();
	JSONObject obj;
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		obj = new JSONObject();
		String idNum =result.getString(1); 
		obj.put("ID",idNum);
		obj.put("KEYWORDS",result.getString(2));
		obj.put("TITLE",result.getString(3));
		obj.put("MESSAGETYPE",result.getString(4));
		obj.put("NYTEPY",result.getString(5));
		obj.put("GROUPID",result.getString(6));
		obj.put("TABLEID",result.getString(7));
		obj.put("PPTEPY",result.getString(8));
		jsonObjAll.put(idNum,obj);
	}
	gettebleHtml(jsonObjAll);
%>
<%!
  public void gettebleHtml(JSONObject orijsonAll){
		sb=new StringBuffer();
		sb.append("<table id=\"TableListFir\" width=\"100%\" class=\"tblist\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><thead>");
		sb.append("<tr><th width=\"150\">规则名称</th><th>关键词</th><th width=\"80\">回复消息类型</th><th width=\"60\">是否禁用</th><th width=\"100\">操作</th></tr>");
		sb.append("</thead><tbody>");
		for (Iterator iter = orijsonAll.keys(); iter.hasNext();) {
			String key = (String)iter.next();  
			if(key==null || key=="") continue;
			try {
				JSONObject jsonObj = (JSONObject)orijsonAll.get(key);
				if(jsonObj==null) continue;
				
				sb.append("<tr>");
				sb.append("<td>").append(jsonObj.get("TITLE")).append("</td>");
				sb.append("<td class=\"ltd\">").append(jsonObj.get("KEYWORDS")).append("</td>");
				sb.append("<td class=\"txtcenter\">").append(jsonObj.get("MESSAGETYPE")).append("</td>");
				Boolean nytype = !(String.valueOf(jsonObj.get("NYTEPY"))).equals("Y");
				sb.append("<td class=\"txtcenter\">").append((nytype)?"是":"否").append("</td>");
				sb.append("<td class=\"ltd\">").append("<a href=\"javascript:addKeywords(").append(jsonObj.get("ID")).append(")\">编辑</a>|").append("<a href=\"javascript:changeNytype(this,").append(jsonObj.get("ID")).append(",'").append((nytype)?"Y":"N").append("'").append(")\">").append((nytype)?"启用":"禁用").append("|<a href=\"javascript:delautooneid(").append(jsonObj.get("ID")).append(")\" id=\"\">删除</a>").append("</td>");
				sb.append("</tr>");
			} catch (JSONException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
		}
		sb.append("</tbody></table>");
  }
%>

<%=sb.toString()%>
<script type="text/javascript">
jsonObjAll=<%=jsonObjAll%>;
</script>


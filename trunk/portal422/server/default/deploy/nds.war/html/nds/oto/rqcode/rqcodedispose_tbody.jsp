<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray"%>
<%@ page import="org.apache.commons.collections.CollectionUtils,org.apache.commons.collections.Predicate" %>
<%!
	StringBuffer sBuffer;
	StringBuffer space;
	String rqcodedisposeid="";
	Boolean flag=true;
	
	int sign=0;
	List all=null;
	JSONObject jos=null;
%>
<%
	sBuffer=new StringBuffer();
	space= new StringBuffer();
	StringBuffer tableCon=new StringBuffer();
	//获得传过来的json对象
	org.json.JSONObject jsonObj=new org.json.JSONObject(request.getParameter("currentdispose"));
	//递归显示
	
	String dialogURL=request.getParameter("redirect");
	if(userWeb==null || userWeb.getUserId()==userWeb.GUEST_ID){
		response.sendRedirect("/c/portal/login"+(nds.util.Validator.isNotNull(dialogURL)?"?redirect="+java.net.URLEncoder.encode(dialogURL,"UTF-8"):""));
		return;
	}
	if(!userWeb.isActive()){
		session.invalidate();
		com.liferay.util.servlet.SessionErrors.add(request,"USER_NOT_ACTIVE");
		response.sendRedirect("/login.jsp");
		return;
	}
	TableManager manager=TableManager.getInstance();
	//String tableId="AD_SITE_TEMPLATE";//需要读取的表
	System.out.println("table==json==addMenu_goodstable~~~!!!"+jsonObj);
	int tableId=jsonObj.optInt("AD_TABLE_ID");
	Table table;
	Table tableMenu;
	HashMap<String, String> tempMap = new HashMap<String, String>();//用来存储首页模板的风格
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
	
	//用以判断是文章还是商品 false代表商品
	Boolean setALL=null;
	String tableMenuName="";
	
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	//query=QueryEngine.getInstance();
	
	//判断是否有显示选择条件
	if(nds.util.Validator.isNotNull(jsonObj.optString("FIFTLE_DC"))){
		String[] selectOption=jsonObj.optString("FIFTLE_DC").trim().split(",");
		tableCon.append("<div class=\"goodsChoose\"><form><p>");
		for(String strOption : selectOption){
			ColumnLink clink = new ColumnLink(strOption);
			Column[] columns =clink.getColumns();
			
			if(columns.length>0){
				Column col=columns[0];
				//下拉菜单
				if(col.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_SELECT){
					if(columns.length<2){
						tableCon.append("<label for=\"").append(col.getName()).append("\">").append(columns[0].getDescription(locale)).append("</label>");
						setALL=true;
					}else{
						tableCon.append("<label for=\"").append(col.getName()).append("\">").append(columns[1].getDescription(locale)).append("</label>");
						setALL=false;
					}
				}
				
				//文本框
				if(col.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_TEXT){
					if(columns.length<2){
						tableCon.append("<label for=\"").append(col.getName()).append("\">").append(columns[0].getDescription(locale)).append("</label>");
						setALL=true;
					}else{
						tableCon.append("<label for=\"").append(col.getName()).append("\">").append(columns[1].getDescription(locale)).append("</label>");
						setALL=false;
					}
					tableCon.append("<input type=\"text\" id=\"").append(strOption).append("\" name=\"").append(strOption).append("\" value=\"\"/>");
				}
			}
		}
		tableCon.append("<input class=\"btnGreenS searchBtn\" onclick=\"rqd.searchDisposeRecode()\" type=\"button\" value=\"搜索\">");
		
		tableCon.append("</p></form></div>");
	}
	tableCon.append("<div id=\"listTable\"><table><thead>");
	
	//构造查询列表对象
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	//query=QueryEngine.getInstance();
	query.setMainTable(table.getId());
	rqcodedisposeid=request.getParameter("rqcodedisposeid"); 
	rqcodedisposeid=Tools.getInt(rqcodedisposeid,0)==0?"0":rqcodedisposeid;
	System.out.println("addMenu_goodstable.jsp==rqcodedisposeid:"+rqcodedisposeid);
	
	
	//构造表头	
	String[] selectName=jsonObj.optString("SHOW_DC").trim().split(",");
	List<Integer> showColumnsObjType=new ArrayList<Integer>();
	for(int i=0;i< selectName.length;i++){
		ColumnLink clink = new ColumnLink(selectName[i]);
		query.addSelection(clink.getColumnIDs(),false,"");
		showColumnsObjType.add(clink.getLastColumn().getDisplaySetting().getObjectType());
		if(i==0){
			//添加单选框的标题
			tableCon.append("<td width=\"90px\">选择</td>");
		}else{
			//添加非单选框的标题
			tableCon.append("<td width=\"190px\">"+clink.getLastColumn().getDescription(locale)+"</td>");
		}
	}
	tableCon.append("</thead>");
	tableCon.append("<tbody>");
	
	result=null;
	query.setRange(0, Integer.MAX_VALUE);
	result= QueryEngine.getInstance().doQuery(query);	
	
	for(int i=0;i<result.getRowCount();i++){
		result.next();
		tableCon.append("<tr>");
		for (int j=0;j< showColumnsObjType.size();j++) {
			if(j==0){
				tableCon.append("<td width=\"90px\"");
				//System.out.println("rqcodedisposeid:"+rqcodedisposeid+",==result.getObject(j+1)"+result.getObject(j+1)+"####"+rqcodedisposeid.equals(result.getObject(j+1)));
				if(("0").equals(rqcodedisposeid) && i==0){
					tableCon.append("id =\"haveselected\"");
				}
				if(rqcodedisposeid!=null && rqcodedisposeid.equals(String.valueOf(result.getObject(j+1)))){
					tableCon.append("id =\"haveselected\"");
				}
				tableCon.append("><input  type=\"radio\" name=\"chooseUrl\" value=\"").append(result.getObject((j+1))).append("\"");
				tableCon.append("/>");
			}else{
				//显示图片
				if(showColumnsObjType.get(j)==DisplaySetting.OBJ_IMAGE){
					tableCon.append("<td width=\"190px\"><img src=\"").append(result.getObject((j+1))).append("\" width=\"50\" height=\"50\"/>");
				}else if(showColumnsObjType.get(j)==DisplaySetting.OBJ_TEXT){
					tableCon.append("<td width=\"190px\">").append(result.getObject((j+1)));
				}
			}
			tableCon.append("</td>");
		}
	}
	tableCon.append("</tbody>");
	tableCon.append("</table></div>");
%>
	
<%=tableCon%><br/>

<script type="text/javascript">
	jQuery("#listTable table tbody").prepend(jQuery("#haveselected").parent());
	jQuery("#haveselected input").attr("checked","checked");
	jQuery(document).bind("keydown",function(event){
		if(event.which==13){
			if(!jQuery.isEmptyObject(jQuery("#currentdispose .goodsChoose form p input.searchBtn").val())){
				jQuery("#currentdispose .goodsChoose form").attr("onsubmit","return false");
				rqd.searchDisposeRecode();
			}
		}
	});
</script>
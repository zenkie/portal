<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%
	StringBuffer tableCon=new StringBuffer();
	
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
	int tableId=Integer.valueOf(request.getParameter("tableId"));
	Table table;
	HashMap<String, String> tempMap = new HashMap<String, String>();//用来存储首页模板的风格
	int clientId = userWeb.getAdClientId();
	table=manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);
	
	/**------check permission---**/
	String directory,group_bysql=null;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	String options=request.getParameter("options");
	
	
	
	//条件
	if(options!=null && !"".equals(options)){
		String[] optionE=request.getParameter("options").split("&");
		for (String str : optionE) {
			String[] optionEve=str.split("=");
			if(optionEve.length<2){continue;}
			ColumnLink clink = new ColumnLink(optionEve[0]);
			//判断是否为=
			Column[] columns =clink.getColumns();
			if(columns.length>0){
				Column col=columns[0];
				if(col.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_SELECT){
					query.addParam(clink.getColumnIDs(),"="+optionEve[1].trim());
					continue;
				}
			}
			query.addParam(clink.getColumnIDs(),optionEve[1]);
		}
	}
	
	
	//用以判断是文章还是商品 false代表商品
	if(Boolean.valueOf(request.getParameter("artOrPro"))==null){
		
	}else if(Boolean.valueOf(request.getParameter("artOrPro"))){
		query.addSelection("distinct ID","ID");
	}else{
		query.addSelection("distinct a0.ID","ID");
	}

	tableCon.append("<div id=\"listTable\"><table><thead>");
	//获得要查询的String对象	
	String[] selectName=request.getParameter("SHOW_DC").trim().split(",");
	List<Integer> showColumnsObjType=new ArrayList<Integer>();
	for (int i=0;i< selectName.length;i++) {
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
	
	
	tableCon.append("</thead><tbody>");
	query.setRange(0, Integer.MAX_VALUE);
	result= QueryEngine.getInstance().doQuery(query);
	
	String sid = request.getParameter("sid");
	for(int i=0;i<result.getRowCount();i++){
		result.next();
		tableCon.append("<tr>");
		for (int j=0;j< showColumnsObjType.size();j++) {
			if(j==0){
				tableCon.append("<td width=\"90px\"><input  type=\"radio\" name=\"chooseUrl\" value=\"").append(result.getObject((j+1))).append("\"");
				//添加单选框
				if(sid!=null && !"0".equals(sid) ){
					if(sid.equals(result.getString(j+1))){
						tableCon.append("checked=\"checked\"");
					}
				}
				tableCon.append("/>");
			}else{
				//显示图片
				if(showColumnsObjType.get(j)==DisplaySetting.OBJ_IMAGE){
					tableCon.append("<td width=\"190px\"><img src=\"").append(result.getObject((j+1))).append("\" width=\"50\" height=\"50\"/>");
				}
				if(showColumnsObjType.get(j)==DisplaySetting.OBJ_TEXT){
					tableCon.append("<td width=\"190px\">").append(result.getObject((j+1)));
				}
			}
			tableCon.append("</td>");
		}
		tableCon.append("</tr>");
		
	}
	tableCon.append("</tbody></table>");
	
%>

<%=tableCon%>


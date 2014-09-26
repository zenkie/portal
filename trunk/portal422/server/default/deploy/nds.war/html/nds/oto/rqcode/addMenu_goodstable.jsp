<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray"%>
<%@ page import="org.apache.commons.collections.CollectionUtils,org.apache.commons.collections.Predicate" %>
<%!
	StringBuffer sBuffer;
	StringBuffer space;
	String sid="";
	Boolean flag=true;
%>
<%
	sBuffer=new StringBuffer();
	space= new StringBuffer();
		StringBuffer tableCon=new StringBuffer();
	//获得传过来的json对象
	org.json.JSONObject jsonObj=new org.json.JSONObject(request.getParameter("arr"));
	//递归显示
	
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
	
	//判断是否有显示选择类目
	if(!"".equals(jsonObj.optString("FIFTLE_DC"))){
		
		String[] selectOption=jsonObj.optString("FIFTLE_DC").trim().split(",");
		
		tableCon.append("<div class=\"goodsChoose\"><form><p>");
		for (String strOption : selectOption) {
			
		
			
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
					//判断是否是树形下拉显示
					Table tables=columns[columns.length-1].getTable();
					JSONObject ordersFir=columns[columns.length-1].getTable().getJSONProps();
					if(ordersFir!=null && ordersFir.has("fold")){
						query.setMainTable(columns[columns.length-1].getTable().getId());
						System.out.println(columns[columns.length-1].getTable().getId()+"table.getJSONProps()=======:fold"+ordersFir);
						query.addSelection(tables.getPrimaryKey().getId());
						query.addSelection(tables.getDisplayKey().getId());
						
						int[] orderKey;
						String cn=null;
						JSONObject jo=null;
						boolean isAsc=true;
						String correlation=ordersFir.optString("correlation");
						String isParent=ordersFir.optString("parentcolumn");
						query.addSelection(tables.getColumn(correlation).getId());
						System.out.println(columns[columns.length-1].getTable().getId()+"==ordersFir@@@@@@@@@@@@@@@@@@@@@@@@"+ordersFir+"===isParent:"+isParent);
						System.out.println("isparent->"+(tables.getColumn(isParent)==null?"null":tables.getColumn(isParent).getName()));
						query.addSelection(tables.getColumn(isParent).getId());
						query.addSelection(tables.getColumn("CATEGORYPHOTO").getId());

						orderKey= new int[]{tables.getPrimaryKey().getId()};
						query.setOrderBy(orderKey, true);


						query.setRange(0, Integer.MAX_VALUE);
						System.out.println("query->====="+query.toSQL());
						all=QueryEngine.getInstance().doQueryList(query.toSQL());
						List temp=getSub(all,"",2);
						JSONArray jaaa=getTree(temp,"");
						
						
						sBuffer=new StringBuffer();
						getHtmlTreeSelect(jaaa);
						//tableCon.append("<select id=\"").append(referenceTableId).append("\" name=\"").append(referenceTableId).append("\" style=\"width:100px\">");
						tableCon.append("<select name=\"").append(strOption).append("\" id==\"").append(strOption).append("\">");
						tableCon.append("<option value=\"\">").append("请选择分类").append("</option>");
						tableCon.append(sBuffer.toString());
						tableCon.append("</select>");
						System.out.println("树形下拉query->====="+sBuffer.toString());
						
						continue;
					}
					
					
					/*query.setMainTable(table.getId());
					query.addSelection(clink.getColumnIDs(),false,"");
					String referenceTableId=null;
					//排序和添加另一个表的id
					if(col.getJSONProps()!=null){
						//添加另一个表的id
						referenceTableId = col.getJSONProps().optString("referenceTableId");
						if(referenceTableId!=null && !"".equals(referenceTableId)){
							query.addSelection((new ColumnLink(referenceTableId)).getColumnIDs(),false,"");
						}else{
							query.addSelection(table.getColumn("ID").getId());
						}
						//排序
						String orderby=null;
						orderby=col.getJSONProps().optString("orderby");
						if(orderby!=null && !"".equals(orderby)){
							org.json.JSONArray jsonArray=new org.json.JSONArray(orderby);
								for(int i=0;i<jsonArray.length();i++){
									org.json.JSONObject jsonObject=jsonArray.optJSONObject(i);
									ColumnLink cl= new ColumnLink(jsonObject.optString("column"));
									query.addSelection(cl.getColumnIDs(),false,"");
									query.setOrderBy(cl.getColumnIDs(), jsonObject.optBoolean("asc",false));
								}
						}
					}
					result= QueryEngine.getInstance().doQuery(query);
						//构造下拉菜单
						tableCon.append("<select id=\"").append(referenceTableId).append("\" name=\"").append(referenceTableId).append("\" style=\"width:100px\">");
						tableCon.append("<option value=\"\">全部</option>");
						for(int i=0;i<result.getRowCount();i++){
								result.next();
								
								if(nds.util.Validator.isNull(String.valueOf(result.getObject(3)))||nds.util.Validator.isNull(String.valueOf(result.getObject(4)))){
									tableCon.append("<option value=\""+result.getObject(2)+"\">└─"+result.getObject(1)+"</option>");
									continue;
								}
								tableCon.append("<option value=\""+result.getObject(2)+"\">&nbsp;&nbsp;&nbsp;&nbsp;└─"+result.getObject(1)+"</option>");
							}
							tableCon.append("</select>");*/
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
		tableCon.append("<input class=\"btnGreenS searchBtn\" onclick=\"changSelection()\" type=\"button\" value=\"搜索\">");
		
		tableCon.append("</p></form></div>");
	}
	tableCon.append("<input id=\"tableID\"  type=\"hidden\" value=\""+jsonObj.optInt("AD_TABLE_ID")+"\">");
	tableCon.append("<input id=\"SHOW_DC\"  type=\"hidden\" value=\""+jsonObj.optString("SHOW_DC")+"\">");
	tableCon.append("<input id=\"artOrPro\"  type=\"hidden\" value=\""+setALL+"\">");
	
	//查询列表
	query=QueryEngine.getInstance().createRequest(userWeb.getSession());
	tableCon.append("<div id=\"listTable\"><table><thead>");
	//获得要查询的String对象	
	String[] selectName=jsonObj.optString("SHOW_DC").trim().split(",");
	List<Integer> showColumnsObjType=new ArrayList<Integer>();
	for (int i=0;i< selectName.length;i++) {
			ColumnLink clink = new ColumnLink(selectName[i]);
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
	query.setMainTable(table.getId());
	sid=request.getParameter("sid"); 
	
	System.out.println("addMenu_goodstable.jsp==sid:"+sid);
	//Column c=table.getColumn("ID");
	//String showName=c.getName();
	//如果是要树形显示
	JSONObject orders=table.getJSONProps();
	if(orders!=null && orders.has("fold")){
		
		System.out.println("table.getJSONProps()=======:fold");
		query.addSelection(table.getPrimaryKey().getId());
		query.addSelection(table.getDisplayKey().getId());
		
		int[] orderKey;
		String cn=null;
		JSONObject jo=null;
		boolean isAsc=true;
		String correlation=orders.optString("correlation");
		String isParent=orders.optString("parentcolumn");
		query.addSelection(table.getColumn(correlation).getId());
		query.addSelection(table.getColumn(isParent).getId());
		query.addSelection(table.getColumn("CATEGORYPHOTO").getId());

		orderKey= new int[]{table.getPrimaryKey().getId()};
		query.setOrderBy(orderKey, true);


		query.setRange(0, Integer.MAX_VALUE);
		result=null;
		result= QueryEngine.getInstance().doQuery(query);
		System.out.println("query->====="+query.toSQL());
		all=QueryEngine.getInstance().doQueryList(query.toSQL());
		List temp=getSub(all,"",2);
		JSONArray jaaa=getTree(temp,"");
		//tableCon.append("<tbody>");
		String TMP_CLASS=jsonObj.optString("TMP_CLASS");
		sBuffer=new StringBuffer();
		getHtmlTree(jaaa,TMP_CLASS);
		//tableCon.append("</tbody>");
		tableCon.append(sBuffer.toString());
		System.out.println("query->====="+jaaa.toString());
		flag=true;
	}else{
	tableCon.append("<tbody>");
	//非树形显示
	
	if(setALL==null){
		
	}else if(setALL){
		query.addSelection("distinct ID","ID");
	}else{
		query.addSelection("distinct a0.ID","ID");
	}
	
	
	
	
	for (int i=0;i< selectName.length;i++) {
			ColumnLink clink = new ColumnLink(selectName[i]);
			query.addSelection(clink.getColumnIDs(),false,"");
			/*if(i==0){
				//添加单选框的标题
				if(sid!=null && !"0".equals(sid) ){
					query.addParam(clink.getColumnIDs(), sid);
				}
			}*/
		}
	
	result=null;
	query.setRange(0, Integer.MAX_VALUE);
	result= QueryEngine.getInstance().doQuery(query);

	
	
	System.out.println("table.getJSONProps()=======not :fold"+"getName()"+table.getName()+"==table.getJSONProps():"+table.getJSONProps());
	
	
	
	for(int i=0;i<result.getRowCount();i++){
		result.next();
		tableCon.append("<tr>");
		for (int j=0;j< showColumnsObjType.size();j++) {
			if(j==0){
				tableCon.append("<td width=\"90px\"");
				System.out.println("sid:"+sid+",==result.getObject(j+1)"+result.getObject(j+1)+"####"+sid.equals(result.getObject(j+1)));
				if(("0").equals(sid) && i==0){
					tableCon.append("id =\"haveselected\"");
				}
				if(sid!=null && sid.equals(String.valueOf(result.getObject(j+1)))){
					tableCon.append("id =\"haveselected\"");
				}
				tableCon.append("><input  type=\"radio\" name=\"chooseUrl\" value=\"").append(result.getObject((j+1))).append("\"");
				//添加单选框
				//if(sid!=null && !"0".equals(sid) ){
				//	if(sid==result.getObject((j+1))){
				//	if(i==0)
				//		tableCon.append("checked=\"checked\"");
				//	}
				//}
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
		
	}
	sid=null;
	
	tableCon.append("</tbody>");
	}
	tableCon.append("</table></div>");
%>
	<%=tableCon%><br/>
<%!
int sign=0;
List all=null;
JSONObject jos=null;

boolean isCheck=false;
//查到父节点下所有的子节点
public List getSub(List inputlist,String parentId,int index){
	if(inputlist==null||inputlist.size()<=0){return null;}
	
	final String tparentid=parentId;
	final int tindex=index;
	System.out.print("parentId->"+tparentid+",asize->"+inputlist.size());
	List al= (ArrayList) CollectionUtils.select(
		inputlist,
		new Predicate(){
			public boolean evaluate(Object arg0){
				List temps=(ArrayList)arg0;
				
				if(nds.util.Validator.isNull(tparentid)){
					return temps.get(tindex)==null||nds.util.Validator.isNull(String.valueOf(temps.get(tindex)));
				}else{	
					System.out.print("t->"+temps.get(tindex)+",eq->"+tparentid.equals(String.valueOf(temps.get(tindex))));
					return tparentid.equals(String.valueOf(temps.get(tindex)));
				}
			}
		}
	);
	return al;
}

//获得树的json
public JSONArray getTree(List t,String cp){
	JSONArray ctrees=new JSONArray();
	if(t==null) return ctrees;
	int pcount=-1;
	int ccount=-1;
	List ct=null;
	List temps=null;
	JSONObject node=null;
	
	String csign=String.valueOf((char)(sign+65));
	
	for(int i=0;i<t.size();i++){
		temps=(List)t.get(i);
		if(jos!=null&&jos.has(String.valueOf(temps.get(0)))){isCheck=true;}
		else{isCheck=false;}
		if("N".equalsIgnoreCase(String.valueOf(temps.get(3)))){
			ccount++;
			node=new JSONObject();
			try{
				node.put("id",temps.get(0));
				node.put("text",temps.get(1));
				node.put("parentid",temps.get(2));
				node.put("nodeid",(csign+ccount));
				node.put("parentnodeid",cp);
				node.put("childrens",new JSONArray());
				node.put("logo",temps.get(4));
				node.put("ischeck",isCheck);
				ctrees.put(node);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			pcount++;
			node=new JSONObject();
			try{
				node.put("id",temps.get(0));
				node.put("text",temps.get(1));
				node.put("parentid",temps.get(2));
				node.put("nodeid",(csign+pcount));
				node.put("parentnodeid",cp);
				node.put("logo",temps.get(4));
				node.put("ischeck",isCheck);
			} catch (Exception e) {
				e.printStackTrace();
			}
			sign++;
			ct=getSub(all,String.valueOf(temps.get(0)),2);
			try{
				node.put("childrens",getTree(ct,(csign+pcount)));
			} catch (Exception e) {
				e.printStackTrace();
			}
			ctrees.put(node);
		}
	}
	return ctrees;
}
//jsonArr数组 str显示html spacing空格
//StringBuffer sBuffer=new StringBuffer();
//StringBuffer space=;
public void getHtmlTree(JSONArray jsonArr,String TMP_CLASS){
	
	
	if(jsonArr!=null){
		for (int i = 0; i < jsonArr.length(); i++) {
			
			try {
				JSONObject jsonObj=(JSONObject) jsonArr.get(i);
				sBuffer.append("<tr>");
				sBuffer.append("<td width=\"90px\">");
				if(TMP_CLASS==null||"".equals(TMP_CLASS)){return;}
				JSONArray jsonArrChild=new JSONArray();
				jsonArrChild=(JSONArray)jsonObj.get("childrens");
				//多级分类
				if(TMP_CLASS.contains("CLASS_TMP")){
					
					System.out.println("TMP_CLASS.contains(classTmp)"+TMP_CLASS);
					if(jsonArrChild.length()>0){
						
						sBuffer.append("<input  type=\"radio\" name=\"chooseUrl\" value=\"").append(jsonObj.get("id")).append("\"");
						System.out.println(jsonObj.get("id")+"====="+flag+"====="+sid);
						if(flag && "0".equals(sid) || sid == null){
							sBuffer.append("checked=\"checked\"");
							flag=false;
						}
						if(flag && sid!=null && !"".equals(sid)){
							if(sid.equals(String.valueOf(jsonObj.get("id")))){
								System.out.println("===checked====");
								sBuffer.append("checked=\"checked\"");
								flag=false;
							}
						}
						sBuffer.append("/>");
					}
				}
				//列表
				if(TMP_CLASS.contains("LIST_TMP")){
					if(jsonArrChild.length()==0){
						sBuffer.append("<input  type=\"radio\" name=\"chooseUrl\" value=\"").append(jsonObj.get("id")).append("\"");
						if(flag && "0".equals(sid) || sid == null){
							sBuffer.append("checked=\"checked\"");
							flag=false;
						}
						if(flag && sid!=null && !"".equals(sid)){
							if(sid.equals(String.valueOf(jsonObj.get("id")))){
								sBuffer.append("checked=\"checked\"");
								flag=false;
							}
						}
						sBuffer.append("/>");
					}
				}
				sBuffer.append("</td>");
				//sBuffer.append("<td width=\"190px\">").append("<span width=\"").append(space).append("px\"></span>").append("└─").append(jsonObj.get("text")).append("</td>");
				sBuffer.append("<td width=\"190px\" style=\"text-align:left;\">").append(space.toString()).append("└").append(jsonObj.get("text")).append("</td>");
				sBuffer.append("<td width=\"190px\"><img src=\"").append(jsonObj.get("logo")).append("\" width=\"50\" height=\"50\"/>").append("</td>");
				sBuffer.append("</tr>");
				
				
				if(jsonArrChild!=null){
					space.append("&nbsp;&nbsp;&nbsp;&nbsp;");
					getHtmlTree(jsonArrChild,TMP_CLASS);
				}
					
			} catch (Exception e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
			
				
		}
		
	}
	if(space.length()>=24){
		space.delete(space.length()-24,space.length());
	}
	
}
public void getHtmlTreeSelect(JSONArray jsonArr){
	if(jsonArr!=null){
		for (int i = 0; i < jsonArr.length(); i++) {
			try {
				JSONObject jsonObj=(JSONObject) jsonArr.get(i);
				sBuffer.append("<option value=\"").append(jsonObj.get("text")).append("\">");
				JSONArray jsonArrChild=new JSONArray();
				jsonArrChild=(JSONArray)jsonObj.get("childrens");
				sBuffer.append(space.toString()).append("└").append(jsonObj.get("text"));
				sBuffer.append("</option>");
				System.out.println("sBuffer###"+sBuffer.toString());
				if(jsonArrChild!=null){
					space.append("&nbsp;&nbsp;&nbsp;&nbsp;");
					getHtmlTreeSelect(jsonArrChild);
				}	
			} catch (Exception e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			}
			
				
		}
		
	}
	if(space.length()>=24){
		space.delete(space.length()-24,space.length());
	}
	
}
%>
<script type="text/javascript">
jQuery("#listTable table tbody").prepend(jQuery("#haveselected").parent());
jQuery("#haveselected input").attr("checked","checked");
jQuery(document).bind("keydown",function(event){
			if(event.which==13){
				if(!jQuery.isEmptyObject(jQuery("#goodsTable .goodsChoose form p input.searchBtn").val())){
					jQuery("#goodsTable .goodsChoose form").attr("onsubmit","return false");
					changSelection();
					
				}
			}
});
</script>
<%--

//列表的情况下判断二级列表的父类不为空
	if(table.getColumn("NODE_CHILD")!=null){
		query.addParam(table.getColumn("NODE_CHILD").getId(), " is not null");
	}

query.setRange(pageNow*pageSize,pageSize);

int pageNow = request.getParameter("p")!=null ? Integer.parseInt(request.getParameter("p")):0;//分页计数
	int pageSize = 1;//一页总数
	int pageCount;//总页数
System.out.println("==sid=0=="+sid);
	pageCount = (result.getTotalCount()-1)/pageSize+1;
	if(pageCount > 1 ){	
		tableCon.append("<tr><td colspan=\"3\">");
		if(pageNow == 0){
			tableCon.append("<a href='javascript:changSelectionSe("+(pageNow+1)+");'>下一页</a>")
			.append("<a href='javascript:changSelectionSe("+(pageCount-1)+");'>尾页</a>");
		}else if(pageNow == pageCount-1){
			tableCon.append("<a href='javascript:changSelectionSe(0);'>首页</a>")
			.append("<a href='javascript:changSelectionSe("+(pageNow-1)+");'>上一页</a>");
		
		}else {
			tableCon.append("<a href='javascript:changSelectionSe(0);'>首页</a>")
			.append("<a href='javascript:changSelectionSe("+(pageNow-1)+");'>上一页</a>")
			.append("<a href='javascript:changSelectionSe("+(pageNow+1)+");'>下一页</a>")
			.append("<a href='javascript:changSelectionSe("+(pageCount-1)+");'>尾页</a>");
		}
		tableCon.append("</td></tr>");
	}
--%>
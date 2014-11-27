<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray"%>
<%!
	//存放选择规格项
	JSONObject specs;
	//存放生成的html
	StringBuffer innerHtmlSB;
%>
<%
	/**------获取参数---**/
	String eieid=request.getParameter("eleid");
	String objid=request.getParameter("objid");
	
	String spaces=request.getParameter("spaces");
	String str1=request.getParameter("username");
	/**------获取参数 end---**/
	TableManager manager=TableManager.getInstance();
	String tableId="WX_SPEC";
	Table table;
	table= manager.getTable(tableId);
	if(table ==null) throw new NDSException("Internal Error: message table not found."+ tableId);

	/**------check permission---**/
	String directory;
	directory=table.getSecurityDirectory();
	WebUtils.checkDirectoryReadPermission(directory, request);
	/**------check permission end---**/
	QueryRequestImpl query;
	QueryResult result=null;
	QueryEngine engine=QueryEngine.getInstance();
	SessionContextManager scmanager= WebUtils.getSessionContextManager(session);


	query=engine.createRequest(userWeb.getSession());
	query.setMainTable(table.getId());
	query.addSelection(table.getColumn("ID").getId());
	query.addSelection(table.getColumn("NAME").getId());
	query.addSelection(table.getColumn("DESCRIPTION").getId());
	int[] cols=new int[]{table.getColumn("ID").getId()};
	query.setOrderBy(cols, true);
	result= QueryEngine.getInstance().doQuery(query);
	//存放选择规格项
	specs= new JSONObject();
	JSONArray jaa=new JSONArray();

	System.out.println(query);
	for (int i=0;i<result.getRowCount();i++){
		result.next();
		JSONObject specobj = new JSONObject();
		String id = result.getString(1);
		specobj.put("id",id);
		specobj.put("name",result.getObject(2));
		specobj.put("description",result.getObject(3)==null?"":result.getObject(3));
		specs.put(id,specobj);
		jaa.put(specobj);
	}
	innerHtmlSB=new StringBuffer();
	innerHtmlSB.append(initPage(jaa));
	JSONObject jb;
	JSONArray sigleChildjsonArr = new JSONArray();
	//保存数据的json
	JSONObject saveJsonObject = new JSONObject();
	//查询是否是编辑
	loop:if(nds.util.Validator.isNotNull(spaces)){
		try{jb = new JSONObject(spaces);}
		catch(Exception e){
			jb=null;
			e.printStackTrace();
		}

		if(jb==null) break loop;
		JSONArray childJsonArr = jb.optJSONArray("child");
		if(childJsonArr==null) break loop;

		try {
				for (int i = 0; i < childJsonArr.length(); i++) {
					//[{"id": "1", "value": "170"},{"id": "2", "value": "ee"}]
					JSONObject joo = childJsonArr.optJSONObject(i);
					if(joo==null){ continue;}
					JSONArray ja= joo.optJSONArray("space");
					if(ja==null){continue;}
					for (int j = 0; j < ja.length(); j++) {
						JSONObject jo = ja.optJSONObject(j);
						if(jo==null) {continue;}
						String id = jo.optString("id");
						String pid=jo.optString("pid");
						//if(id==-1||pid==-1){continue;}
						String name=jo.optString("name");
						String value = jo.optString("value");
						JSONObject temp=new JSONObject();

						if(!saveJsonObject.has(pid)){saveJsonObject.put(pid,new JSONObject());}
						if(!saveJsonObject.optJSONObject(pid).has(id)){
							temp.put("id",id);
							temp.put("name",name);
							temp.put("value",value);
							saveJsonObject.optJSONObject(pid).put(id,temp);
						}
						
						//if(jo.get(jo.get("id"))==null || jo.get(jo.get("id")).get(jo.get("value")) )

					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}


		//childStr=(List<JSONArray>)jb.get("child");


	}
%>
<%!
//初始化界面 返回初始化界面string类型
public String initPage(JSONArray specListXi){
	StringBuffer options=new StringBuffer();
	options.append("<div id=\"divSpecSelTab\" class=\"SpecSelTab\">");
	for (int i = 0; i < specListXi.length(); i++) {
		try {
			JSONObject jsonObj=(JSONObject) specListXi.get(i);
			if(jsonObj==null) continue;
			options.append("<span id=\"WX_SPEC_"+jsonObj.get("id")+"\" tag=\"seltab\" title=\""+jsonObj.get("description")+"\" showway=\"0\" class=\""+(i==0?"speTabSel":"speTab")+"\" onclick=\"tabChange('"+jsonObj.get("id")+"');\"><span>");
			options.append(jsonObj.get("name"));
			options.append("</span><label onclick=\"si.deleteItem("+jsonObj.get("id")+");\" class=\"tabdel\" title=\"删除\"></label>");
			options.append("</span>");
		} catch (Exception e) {
			// TODO 自动生成的 catch 块
			e.printStackTrace();
		}
	}
	options.append("<input type=\"button\" onclick=\"addSPEC()\" value=\"+\" class=\"BtnAdd\">");

	options.append("</div> ");
	options.append("<div id=\"divSpecSelValue\" class=\"SpecSelVal\">");
	options.append("</div> ");
	options.append("<div class=\"selItemBottom\"><input id=\"GenSpecPdt\" type=\"button\" class=\"opbutton\" onclick=\"submitDetails()\" value=\"生成货品\"><input type=\"button\" class=\"opbutton\" onclick=\"submitDetails()\" value=\"确定\"><input type=\"button\" class=\"opcancel\" onclick=\"cf.closeSpace();\" value=\"取消\"></div>");
	return options.toString();
}
%>
<link rel="stylesheet" type="text/css" href="/html/nds/oto/themes/01/css/spacification.css">
<script language="javascript" src="/html/nds/oto/product/js/spacification.js"></script>
<script type="text/javascript">
specValueList={};
var eleid="<%=eieid%>";
specs=<%=specs.toString()%>;
var node=document.getElementById("iframe_<%=eieid%>").contentWindow;
if(node){
	savedata=node.extendspace.spaces;
	detailsValueList=node.extendspace.selectspace;
}

saveEditJsonObject=<%=saveJsonObject%>;
jQuery(document).ready(
	function init(){
		var key;
		if(!si){spe.main();}
		si.objid=<%=objid%>;
		si.eleid="<%=eieid%>";
		if(Object.keys){key=Object.keys(specs);}
		else{key=Object.getOwnPropertyNames(specs);}
		if(key&&key.length>0){tabChange(key[0]);}
	}
);
</script>
<div id="divSpecSelContainer" style="width:650px;height:300px;overflow: auto;">
	<%=innerHtmlSB.toString()%>
</div>


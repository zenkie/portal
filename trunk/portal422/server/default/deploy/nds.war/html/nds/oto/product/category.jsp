<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
<%@ page import="org.apache.commons.collections.CollectionUtils,org.apache.commons.collections.Predicate" %>
<%
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
%>
<%!
int sign=0;
List all=null;
JSONObject jos=null;

boolean isCheck=false;

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
					return tparentid.equals(String.valueOf(temps.get(tindex)));
				}
			}
		}
	);
	return al;
}
public JSONArray getTree(List t,String cp){
	int pcount=-1;
	int ccount=-1;
	List ct=null;
	List temps=null;
	
	JSONObject node=null;
	boolean isParent=false;
	JSONArray ctrees=new JSONArray();
	String csign=String.valueOf((char)(sign+65));

	for(int i=0;i<t.size();i++){
		temps=(List)t.get(i);
		if(jos!=null&&jos.has(String.valueOf(temps.get(0)))){isCheck=true;}
		else{isCheck=false;}
		//isParent="Y".equalsIgnoreCase(String.valueOf(temps.get(3)));
		isParent=nds.util.Validator.isNull(String.valueOf(temps.get(2)))||"Y".equalsIgnoreCase(String.valueOf(temps.get(3)));
		if(isParent){
			pcount++;
			node=new JSONObject();
			try{
				node.put("id",temps.get(0));
				node.put("text",temps.get(1));
				node.put("parentid",temps.get(2));
				node.put("nodeid",(csign+pcount));
				node.put("parentnodeid",cp);
				node.put("isparent",isParent);
				node.put("ischeck",isCheck);
			} catch (Exception e) {
				e.printStackTrace();
			}
			sign++;
			ct=getSub(all,String.valueOf(temps.get(0)),2);
			try{
				node.put("childs",getTree(ct,(csign+pcount)));
			}catch (Exception e) {
				e.printStackTrace();
			}
			ctrees.put(node);
		}else{
			ccount++;
			node=new JSONObject();
			try{
				node.put("id",temps.get(0));
				node.put("text",temps.get(1));
				node.put("parentid",temps.get(2));
				node.put("nodeid",(csign+ccount));
				node.put("parentnodeid",cp);
				node.put("childs",new JSONArray());
				node.put("isparent",isParent);
				node.put("ischeck",isCheck);
				ctrees.put(node);
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	return ctrees;
}
public void getHtml(List t,StringBuffer h,String spacing,String cp){
	int pcount=0;
	int ccount=0;
	List ct=null;
	List temps=null;
	String spacs=spacing;
	
	String csign=String.valueOf((char)(sign+65));
	if(h==null){h=new StringBuffer();}
	
	for(int i=0;i<t.size();i++){
		temps=(List)t.get(i);
		if(jos!=null&&jos.has(String.valueOf(temps.get(0)))){isCheck=true;}
		else{isCheck=false;}
		if("N".equalsIgnoreCase(String.valueOf(temps.get(3)))){
			ccount++;
			h.append("<div id='nfold_").append(csign+ccount);
			h.append("' text='").append(temps.get(1));
			h.append("' value=").append(temps.get(0)).append(">");
			h.append(spacs);
			h.append("<image \"style=\"cursor: pointer;margin: 0 8px 2px 5px;\" src='' />");
			h.append("<input type='checkbox' ").append(isCheck?"checked=\"true\"":"");
			h.append(" onclick=\"cf.selectnode(this,'#nfold_"+(csign+ccount)+"','#pfold_"+cp+"','#cfold_"+cp+"',false);\" />");
			h.append("<span style=\"cursor: pointer;vertical-align: top;\">").append(temps.get(1)).append("</span></div>");
		}else{
			pcount++;
			h.append("<div id='pfold_").append(csign+pcount).append("' text='").append(temps.get(1));
			h.append("' value=").append(temps.get(0)).append(" ondblclick=\"cf.fold('#img_"+(csign+pcount)+"','#cfold_"+(csign+pcount)+" div')\" currentrowstate='hide'>");
			h.append(spacs);
			h.append("<image id='img_").append(csign+pcount).append("' style=\"cursor: pointer;margin: 0 8px 2px 5px;\" src='/html/nds/oto/themes/01/images/fold-hidden.png'");
			h.append(" onclick=\"cf.fold('#img_"+(csign+pcount)+"','#cfold_"+(csign+pcount)+" div')\"/>");
			h.append("<input type='checkbox' ").append(isCheck?"checked=\"true\"":"");
			h.append(" onclick=\"cf.selectnode(this,'#pfold_"+(csign+pcount)+"','#pfold_"+(csign+pcount)+"','#cfold_"+(csign+pcount)+" div',true);\" />");
			h.append("<span style=\"cursor: pointer;vertical-align: top;\">").append(temps.get(1)).append("</span></div>");
			
			//ct=getSub(all,Tools.getInt(temps.get(0),-1),2);
			sign++;
			ct=getSub(all,String.valueOf(temps.get(0)),2);
			h.append("<div id='cfold_").append(csign+pcount).append("'>");
			getHtml(ct,h,(spacs+"<span style=\"width:40px;display: inline-block;\"></span>"),(csign+pcount));
			h.append("</div>");
		}
	}
}
%>
<%
String tn=null;
JSONObject tjo=null;
String val=null;
JSONArray ja=null;
JSONArray jas=null;
StringBuffer rs=new StringBuffer();
String source=request.getParameter("category");
String objid=request.getParameter("id");

QueryEngine engine=QueryEngine.getInstance();
ArrayList params=new ArrayList();
params.add(objid);
ArrayList para=new ArrayList();
para.add(java.sql.Clob.class);
try {
	Collection list=QueryEngine.getInstance().executeFunction("wx_productcategory_$r_getjson",params,para);
	source=(String)list.iterator().next();
} catch (Exception e1) {
	e1.printStackTrace();
}

jos=null;
if(nds.util.Validator.isNotNull(source)){
	jos=new JSONObject();
	try{
		jas=new JSONArray(source);
	}catch(Exception e){
		jas=new JSONArray();
		//response.sendRedirect( NDS_PATH+ "/query/query_portal.jsp" );
		return;
	}
	for(int i=0;i<jas.length();i++){
		tjo=jas.optJSONObject(i);
		val=tjo.optString("name");
		jos.put(tjo.optString("categoryid"),tjo);
		rs.append(val).append("<br>");
	}
}
int tableId=nds.util.Tools.getInt(request.getParameter("table"),-1);
TableManager tableManager=TableManager.getInstance();
Table table=null;
String eid=request.getParameter("eid");

if(tableId==-1) {
	tn=request.getParameter("table");
	table=tableManager.getTable(tn);
	tableId= table.getId();
}else{
	table=tableManager.getTable(tableId);
}	
if(table ==null){
	//response.sendRedirect( NDS_PATH+ "/query/query_portal.jsp" );
	return;
}

String tabName= table.getName();
System.out.print(tabName);
QueryRequestImpl query;
QueryResult result=null;


query=engine.createRequest(userWeb.getSession());
query.setMainTable(table.getId());
query.addSelection(table.getPrimaryKey().getId());
query.addSelection(table.getDisplayKey().getId());


int[] orderKey;
String cn=null;
JSONObject jo=null;
boolean isAsc=true;
JSONObject orders=table.getJSONProps();
if(orders==null||!orders.has("correlation")||!orders.has("parentcolumn")){return;}
String correlation=orders.optString("correlation");
String isParent=orders.optString("parentcolumn");
query.addSelection(table.getColumn(correlation).getId());
query.addSelection(table.getColumn(isParent).getId());

orderKey= new int[]{table.getPrimaryKey().getId()};
query.setOrderBy(orderKey, true);


query.setRange(0, Integer.MAX_VALUE);

result= engine.doQuery(query);
System.out.println("query->"+query.toSQL());
all=engine.doQueryList(query.toSQL());
List temp=getSub(all,"",2);

StringBuffer ss=new StringBuffer();
//getHtml(temp,ss,"","");
sign=0;
int current=-1;
int count=-1;
JSONArray jaaa=getTree(temp,"");
%>
<table style="width:600px;border-spacing:23px;">
	<tr style="vertical-align: top;background: #e5e5e5;height:266px;">
		<td style="width:50%;text-align:left;">
			<div id="cstree" style="width:100%;float: left;max-height:300px;overflow:auto;">
				
			</div>
		</td>
		<td style="width:50%;text-align:left;">
			<div id="result" style="width:100%;float: right;max-height:300px;overflow:auto;"><%=rs.toString()%></div>
		</td>
	</tr>
	<tr style="text-align: center;">
		<td colspan="2">
			<input type="button" value="保存" onclick="cf.savefold(pjson)" style="margin: 0 50px;" />
			<input type="button" value="关闭" onclick="cf.closefold()" style="margin: 0 50px;" />
		</td>
	</tr>
</table>
<!--script language="javascript" src="/html/nds/oto/js/customtree.js"></script-->
<script>
	var eid="#<%=eid%>";
	var pjs=<%=jos==null?null:jos.toString()%>;
	var pjson=<%=jas==null?null:jas.toString()%>;
	var tree=<%=jaaa.toString()%>;
	//$("cstree").innerHTML=createtree(tree).toString();
	oct.id=<%=objid%>;
	oct.eid="#<%=eid%>";
	oct.trees=<%=jaaa.toString()%>;
	oct.hastrees=<%=jos==null?null:jos.toString()%>;
	$("cstree").innerHTML=oct.createtree();
	//$("cstree").innerHTML=toCTreeString(tree);
	
	var pcategory=jQuery(eid).prev().prev().html();
	if(pcategory){
		var pcagetorys=pcategory.split("<br>");
		oct.pcategorys=pcagetorys;
	}
</script>
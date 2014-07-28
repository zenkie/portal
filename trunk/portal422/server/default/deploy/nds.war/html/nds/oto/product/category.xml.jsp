<%@ include file="/html/nds/common/init.jsp" %>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page import="org.json.JSONObject,org.json.JSONArray" pageEncoding="UTF-8" %>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>
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
<%
int tableId=nds.util.Tools.getInt(request.getParameter("table"),-1);
TableManager tableManager=TableManager.getInstance();
Table table=null;
if(tableId==-1) {
	String tn= request.getParameter("table");
	table=tableManager.getTable(tn);
	if(table ==null){
		response.sendRedirect( NDS_PATH+ "/query/query_portal.jsp" );
		return;
	}
	tableId= table.getId();
}else{
	table= tableManager.getTable(tableId);
}	

String tabName= table.getName();
System.out.print(tabName);
QueryRequestImpl query;
QueryResult result=null;

QueryEngine engine=QueryEngine.getInstance();
query=engine.createRequest(userWeb.getSession());
query.setMainTable(table.getId());
query.addSelection(table.getPrimaryKey().getId());
query.addSelection(table.getDisplayKey().getId());


int[] orderKey;
String cn=null;
JSONObject jo=null;
JSONArray ja=null;
boolean isAsc=true;
JSONObject orders=table.getJSONProps();
if(orders==null||!orders.has("correlation")){return;}
String correlation=orders.optString("correlation");
query.addSelection(table.getColumn(correlation).getId());
if(orders.has("orderby")){
	ja=orders.optJSONArray("orderby");
	for(int i=0;i<ja.length();i++){
		jo=ja.optJSONObject(i);
		try{
			ColumnLink cl= new ColumnLink(table.getName()+"."+ jo.getString("column"));
			query.setOrderBy(cl.getColumnIDs(), jo.optBoolean("asc",true));
		}catch(Throwable t){
		}
	}
}else{
	orderKey= new int[]{table.getPrimaryKey().getId()};
	query.setOrderBy(orderKey, true);
}

query.setRange(0, Integer.MAX_VALUE);

result= QueryEngine.getInstance().doQuery(query);
int current=-1;
int count=-1;

String source=request.getParameter("category");
JSONObject jos=null;
JSONObject tjo=null;
String val=null;
StringBuffer rs=new StringBuffer();
ja=null;
if(nds.util.Validator.isNotNull(source)){
	jos=new JSONObject();
	ja=new JSONArray(source);
	for(int i=0;i<ja.length();i++){
		tjo=ja.optJSONObject(i);
		val=tjo.optString("name");
		jos.put(tjo.optString("id"),val);
		rs.append(val).append("<br>");
	}
}
boolean isCheck=false;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
<script language="javascript" src="/html/nds/oto/js/jquery1.3.2/jquery-1.7.2.js"></script>
<script language="javascript" src="/html/nds/oto/js/artDialog4/jquery.artDialog.js?skin=chrome"></script>
<script>
	var pjson=<%=ja==null?null:ja.toString()%>;
</script>
<script>
	function inarrays(elem,array){
		var len = array.length;
		var index=-1;
		var sameCount=0;
		var allCount=Object.getOwnPropertyNames(elem).length;
		for (var i=0 ; i < len; i++ ) {
			sameCount=0;
			for(k in array[i]){
				if(elem[k]!=array[i][k]){break;}
				sameCount++;
				if(sameCount==allCount){return i;}
			}
		}
		return index;
	}
	function selectnode(node,current,parent,nextparent,isParent){
		var currentString;
		var parentString=jQuery(parent).attr("text");
		var reg=new RegExp("("+parentString+".[^(<br>)]*<br>)+");
		reg.compile(reg);
		var result=jQuery("#result").html();
		var allcount=jQuery(parent).nextUntil(nextparent).find('input[type="checkbox"]').size();
		if(!pjson){pjson=[];}
		if(isParent){
			jQuery(parent).nextUntil(nextparent).find('input[type="checkbox"]').prop("checked", node.checked);
			if(node.checked){
				if(allcount==0){
					result+=parentString+"<br>";
					pjson.push({id:jQuery(parent).attr("value"),name:parentString});
				}
				jQuery(parent).nextUntil(nextparent).each(function(index){
					currentString=parentString+"."+jQuery(this).attr("text")+"<br>";
					if(!new RegExp(currentString,"i").test(result)){
						if(reg.test(result)){
							var lastreg=reg.exec(result)[0];
							if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
							else{result+=currentString;}
						}else{
							result+=currentString;
						}
						pjson.push({id:jQuery(this).attr("value"),name:parentString+"."+jQuery(this).attr("text")});
					}
				});
			}else{
				var index=-1;
				if(allcount==0){
					result=result.replace(parentString+"<br>","");
					index=inarrays({id:jQuery(parent).attr("value"),name:parentString},pjson);
					if(index>-1){pjson.splice(index,1);}
				}
				jQuery(parent).nextUntil(nextparent).each(function(index){
					currentString=parentString+"."+jQuery(this).attr("text")+"<br>";
					result=result.replace(currentString,"");
					index=inarrays({id:jQuery(this).attr("value"),name:parentString+"."+jQuery(this).attr("text")},pjson);
					if(index>-1){pjson.splice(index,1);}
				});
			}
		}else{
			var checkedcount=jQuery(parent).nextUntil(nextparent).find('input[type="checkbox"]:checked').size();
			if(checkedcount==0){jQuery(parent).find('input[type="checkbox"]').removeAttr("checked");}
			else if(checkedcount==allcount){jQuery(parent).find('input[type="checkbox"]').attr({"checked":true});}
			if(node.checked){
				currentString=parentString+"."+jQuery(current).attr("text")+"<br>";
				if(reg.test(result)){
					var lastreg=reg.exec(result)[0];
					if(lastreg){result=result.replace(lastreg,(lastreg+currentString));}
					else{result+=currentString;}
				}
				else{result+=parentString+"."+jQuery(current).attr("text")+"<br>";}
				pjson.push({id:jQuery(current).attr("value"),name:parentString+"."+jQuery(current).attr("text")});
			}else{
				var index=-1;
				currentString=parentString+"."+jQuery(current).attr("text")+"<br>";
				result=result.replace(currentString,"");
				index=inarrays({id:jQuery(current).attr("value"),name:parentString+"."+jQuery(current).attr("text")},pjson);
				if(index>-1){pjson.splice(index,1);}
			}
		}
		jQuery("#result").html(result);
	}
	function showFold(ele){
		var val="{\"id\":\"101\",\"name\":\"服装.女装\"}";
		var table="WX_APPENDGOODS";
		try{
			vals=jQuery.parseJSON(val);
			vals=JSON.stringify(val);
		}catch(e){}
		var url="/html/nds/oto/product/category.xml.jsp?table="+table;
		var options={};//$H({padding: 0,width:'700px',height:'370px',top:'7%',title:'test',skin:'chrome',drag:true,lock:true,esc:true,effect:false});
		/*new Ajax.Request(url, {
			method: 'post',
			data:{"category":"{\"category\":\"WX_APPENDGOODS\",\"table\":\"WX_APPENDGOODS\"}"},
			onSuccess: function(data) {
				options.content=data.responseText;
				cf.dia=art.dialog(options);
			},
			onFailure:function(data){
				alert(data);
			}
		});*/
		$.post(url,
			{"category":vals},
			function(data){
				options.content=data.responseText;
				var dia=art.dialog(options);
			}
		);
	}
	function savefold(json){
		alert(json);
	}
	function closefold(){
		if(cf.dia){cf.dia.close();}   
	}
	function fold(ci,currentnode,nextnode){
		var rowstate=jQuery(currentnode).attr("currentrowstate");
		if(!rowstate||rowstate=="show"){
			jQuery(currentnode).nextUntil(nextnode).hide();
			jQuery(currentnode).attr({"currentrowstate":"hide"});
			jQuery(ci).attr("src","/html/nds/oto/themes/01/images/fold-hidden.png");
		}else{
			jQuery(currentnode).nextUntil(nextnode).show();
			jQuery(currentnode).attr({"currentrowstate":"show"});
			jQuery(ci).attr("src","/html/nds/oto/themes/01/images/fold-show.png");
		}
	}
</script>
</head>
<body>
<table style="width:500px;">
	<tr style="vertical-align: top;">
		<td>
			<div style="width:50%;float: left;max-height:300px;overflow:auto;">
				<%while(result.next()){%>
					<%if(nds.util.Validator.isNull(String.valueOf(result.getObject(3)))){
						current++;
						if(jos!=null&&jos.has(String.valueOf(result.getObject(1)))){isCheck=true;}
						%>
						<div id="fold_<%=current%>" text="<%=result.getObject(2)%>" value="<%=result.getObject(1)%>" ondblclick="fold('#img_<%=current%>','#fold_<%=current%>','#fold_<%=(current+1)%>')" currentrowstate="hide">
						<image id="img_<%=current%>" style="cursor: pointer;" src="/html/nds/oto/themes/01/images/fold-hidden.png" onclick="fold('#img_<%=current%>','#fold_<%=current%>','#fold_<%=(current+1)%>')"/>
						<input type="checkbox" <%=isCheck?"checked='checked'":""%> onclick="selectnode(this,'#fold_<%=current%>','#fold_<%=current%>','#fold_<%=(current+1)%>',true);" />
					<%}else{
						count++;
						%>
						<div id="nfold_<%=count%>" text="<%=result.getObject(2)%>" value="<%=result.getObject(1)%>" style="display:none;margin-left: 40px;">
						<image src="" />
						<input type="checkbox" <%=isCheck?"checked='checked'":""%> onclick="selectnode(this,'#nfold_<%=count%>','#fold_<%=current%>','#fold_<%=(current+1)%>',false);" />
					<%}%>
						<span style="cursor: pointer;"><%=result.getObject(2)%></span>
					</div>    
				<%}%> 
			</div>
		</td>
		<td>
			<div id="result" style="width:50%;float: right;max-height:300px;overflow:auto;"><%=rs.toString()%></div>
		</td>
	</tr>
	<tr style="text-align: center;">
		<td colspan="2">
			<input type="button" value="保存" onclick="savefold(pjson)" style="margin: 0 50px;" />
			<input type="button" value="test" onclick="showFold()" style="margin: 0 50px;" />
			<input type="button" value="关闭" onclick="closefold()" style="margin: 0 50px;" />
		</td>
	</tr>
</table>
</body>
</html>
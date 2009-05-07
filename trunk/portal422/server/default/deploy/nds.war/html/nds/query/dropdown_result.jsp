<%@ include file="/html/nds/common/init.jsp" %>

<%!
	private nds.log.Logger logger= nds.log.LoggerManager.getInstance().getLogger("dropdown_result_jsp");
%>
<%
	/**
	当第一次调用dropdown_result时是有dropdown.jsp传下来的参数，这时jsonobject的值为NULL；
	然后在dropdown_result.jsp里自身调用时，取jsonobject里的数据，jsonobject时从AjaxControler.java传递过来的参数
	 attribute : 
	 	jsonobject - attribute JSONObject, if null, following parameters must exists in request
		 		         table       - id of main table to list data)
		 		         accepter_id - accepter input box id
		 		         column      - id of column work as fk
		 		         
					 if not null, above params should exist in jsonobject
		result*    - always in attribute of request		 	
		wildcardfilter - if exists in attribute of request, will be nds.query.Expression.toString, which contains wildcard filter.
		
	*/
	String accepter_id;
	String tablename;
	String wildcardfilter;
	int columnId;
	org.json.JSONObject jsonobject=(org.json.JSONObject) request.getAttribute("jsonobject");
	if(jsonobject==null){
		//dropdown.jsp传下来的参数
	    accepter_id = request.getParameter("accepter_id");
	    Table table= TableManager.getInstance().getTable(Tools.getInt(request.getParameter("table"),-1));
	    if(table==null){
	     table=TableManager.getInstance().getTable(request.getParameter("table"));
	     }
	     tablename=table.getName();
 		 columnId=Tools.getInt(request.getParameter("column"),-1);
 		 wildcardfilter=(String)request.getAttribute("wildcardfilter");
 	}else{
		//jsonobject传下来的参数
		accepter_id=jsonobject.getString("accepter_id");
    	tablename=jsonobject.getString("table");
    	columnId=jsonobject.getInt("column");
    	wildcardfilter=jsonobject.optString("param_expr");
	}
    Object objRs=request.getAttribute("result");
    QueryResult result =null;
    if( objRs instanceof QueryResult){
        result= (QueryResult)objRs;

    }
      QueryRequest qRequest ;
      qRequest = result.getQueryRequest();
    
    int range = qRequest.getRange();
	int rowcount = result.getRowCount();
  	int totalCount = result.getTotalRowCount();
  	int start = qRequest.getStartRowIndex()+1;// 0 is the begin
	int divHeight=(rowcount== 0 ?40:rowcount*20+26);
%>

<div id="<%="tdv_"+accepter_id%>" Style="height:<%=divHeight%>px;position: relative; z-index: 11;overflow-y: scroll; overflow-x:visible;padding:0px"> 
   
<%
String strflag;
org.json.JSONArray dropdownjson=new org.json.JSONArray();
org.json.JSONArray tb=null;
QueryResultMetaData meta;
while(result.next()){
    tb=new org.json.JSONArray();
    tb.put(result.getString(1, true));
    tb.put(result.getString(2, true));
    strflag=result.getString(3, true);
    if(strflag.equals("&nbsp;")){
	    tb.put("");
    }else{
    	tb.put(strflag);
    }
  	dropdownjson.put(tb);  	
}
	org.json.JSONObject dropdownquery=new org.json.JSONObject();
	dropdownquery.put("table",tablename);
	dropdownquery.put("callbackEvent","DropdownQueryRefresh");
	dropdownquery.put("column_masks",4);
 	dropdownquery.put("accepter_id",accepter_id);
	dropdownquery.put("start",start);
 	dropdownquery.put("range",range);
 	dropdownquery.put("rowcount",rowcount);
 	dropdownquery.put("totalCount",totalCount);
 	dropdownquery.put("order_asc",false);
 	dropdownquery.put("order_column","");
 	dropdownquery.put("param_str","");
 	if(wildcardfilter!=null)dropdownquery.put("param_expr",wildcardfilter);
 	dropdownquery.put("column",columnId);
 	dropdownquery.put("resulthandler","/html/nds/query/dropdown_result.jsp");
 	dropdownquery.put("poppath",QueryUtils.getTableRowURL(qRequest.getMainTable()));
 	//System.out.print(dropdownquery);
 	out.print(dropdownjson);
 %>

<table><tr><td>
<script type="text/javascript">
  dq.drawTable(<%=dropdownjson%>,<%=dropdownquery%>);
</script>	
</td></tr></table>
</div>
 

 

	
	
	
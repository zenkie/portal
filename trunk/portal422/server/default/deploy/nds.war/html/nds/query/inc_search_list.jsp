
<form id="q_fm_list_<%=queryindex%>">
<table width="100%" cellspacing="0" cellpadding="0"  align="center">
    <tr >
    <td align="left">
<div id="q_line"></div>
<div id="q_embed_lines_<%=queryindex%>" class="q_embed_lines"> 
<table id="q_inc_table" style="float:left;width:100%" cellpadding="0" cellspacing="0" border="1" class="modify_table">
	<thead><tr>
  	<td nowrap align='center' width="40"><%=PortletUtils.getMessage(pageContext, "rowindex",null)%></td>
<%
ArrayList columns=table.getColumns(new int[]{Column.MASK_QUERY_LIST},false,userWeb.getSecurityGrade() );
int colWidth=15,maxLength=10;
String cid;
PairTable values;
String colName,cId;
boolean isModifiable=false;
Column col,col2;
int type;
//String typeIndicator;
Table refTable;
String fixedColumnMark;
boolean isFixedColumn;

for(int i=0;i< columns.size();i++){
	col=(Column)columns.get(i);
	if(col.getReferenceTable()!=null){
		col2=col.getReferenceTable().getAlternateKey();
		colName=col.getName()+"__"+ col2.getName();	
		maxLength=col2.getLength();
		type= col2.getType();
	}else{
		colName=col.getName();
		maxLength=col.getLength();
		type= col.getType();
	}
	cId= colName;            
    //typeIndicator= nds.query.web.TableQueryModel.toTypeIndicator(type,locale);
	colWidth=15;
	if(col.getDisplaySetting().getObjectType()==DisplaySetting.OBJ_CHECK) colWidth=5;
	// for other columns that are modifiable in both creation form and modification form
	if(!isModifiable){
		colWidth= col.isColumnLink()? col.getColumnLink().getLastColumn().getLength(): col.getLength();
		if(colWidth>30) colWidth=30;
		}
	String descp= col.getDescription(locale);
	// add reflable desc
	if(col.getJSONProps()!=null){
	JSONObject jor=col.getJSONProps();
	if(jor.has("reflable")){
	JSONObject jo=col.getJSONProps().getJSONObject("reflable");
	 int lable_id=jo.optInt("ref_id",0);
		 int lable_tabid=jo.optInt("tabid",0);
		 Table reftable= TableManager.getInstance().getTable(lable_tabid);
		 QueryRequestImpl query=QueryEngine.getInstance().createRequest(userWeb.getSession());
		 query.setMainTable(lable_tabid);
		 query.addSelection(reftable.getAlternateKey().getId());
		 query.addParam( reftable.getPrimaryKey().getId(), ""+ lable_id);
	   QueryResult rs=QueryEngine.getInstance().doQuery(query); 
	   if(lable_id !=0 || (rs!=null && rs.getTotalRowCount()>0)){
		while(rs.next()) {
		   descp=rs.getObject(1).toString(); 
		}
		}
		}
	}
 %>
  <td nowrap align='center'>
    <span onClick="javascript:oq.orderGrid(<%=col.getId()%>)"><span id="q_title_<%=col.getId()%>_<%=queryindex%>"></span>
    	<%=descp%>
    </span>
  </td>
<%
}//for(int i=0;i< meta.getColumnCount();i++)
%>
  </tr>
 </thead><!--$QGRIDTABLE_START-->
<tbody id="q_grid_table_<%=queryindex%>"></tbody><!--$QGRIDTABLE_END-->
</table>
<br>
</div> <!-- q_embed-lines-->
    </td>
    </tr>
  </table>
</form>  

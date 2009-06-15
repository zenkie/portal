<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %><%@ page import="org.json.*"%>
<%
/**
   params:
   cxtab* - cxtab id, or cxtab name 
   if ad_cxtab.pre_procedure is not null, will direct page to search_jreport.jsp for query form construction, since parameters will be from ad_cxtab_jpara
*/
	int cxtabId= ParamUtils.getIntAttributeOrParameter(request, "cxtab", -1);
	if(cxtabId ==-1){
		//try loading as name
		cxtabId=Tools.getInt( QueryEngine.getInstance().doQueryOne("select id from ad_cxtab where ad_client_id="+
				userWeb.getAdClientId()+" and name="+QueryUtils.TO_STRING(request.getParameter("cxtab"))) ,-1);
	}
	if(cxtabId==-1) throw new NDSException("Internal error, cxtab id="+ request.getParameter("cxtab") + " does not exist");
	List list=QueryEngine.getInstance().doQueryList("select ad_table_id,name, description,attr1,attr2,pre_procedure from ad_cxtab where id="+ cxtabId);
 	if(list.size()==0)throw new NDSException("Internal error, cxtab id="+ cxtabId + " does not exist");
  	int tableId= Tools.getInt( ((List)list.get(0)).get(0),-1);
  	
	String cxtabName=(String) ((List)list.get(0)).get(1);
	String cxtabDesc=(String) ((List)list.get(0)).get(2);
	String excelPath= (String) ((List)list.get(0)).get(3);
	String jReportPath= (String) ((List)list.get(0)).get(4);
	String preProcedure= (String) ((List)list.get(0)).get(5);
	
	if(tableId==-1 || nds.util.Validator.isNotNull(preProcedure)){
  		// redirect to search_jreport.jsp
  		request.getRequestDispatcher("search_jreport.jsp").forward(request, response);
  		return;
  	}	
	TableManager manager=TableManager.getInstance();
	Table table= manager.getTable(tableId);
	Table cxtabTable=manager.getTable("ad_cxtab");
 
	int[] columnMasks= new int[]{Column.MASK_QUERY_LIST};
	int listViewPermissionType= 1;
	JSONObject q=new JSONObject();
	q.put("table", table.getName());
	q.put("column_masks", JSONUtils.toJSONArrayPrimitive(columnMasks));
	q.put("dir_perm",listViewPermissionType);
	q.put("init_query",true);
	q.put("start",0);
	q.put("range",QueryUtils.DEFAULT_RANGE);

    String return_type= "n";
    String accepter_id= null;
    int tab_count= 1;
    boolean firstDateColumnFound=false;
	ArrayList qColumns=table.getIndexedColumns();
	TableQueryModel model= new TableQueryModel(tableId,qColumns,false,false,locale);
%>
<table border="0" cellspacing="0" cellpadding="0" align='center' width="98%"><tr><td>
<div id="rpt-desc">
	<span style="width:100px;"><%=PortletUtils.getMessage(pageContext, "current-cxtab",null)%>:</span>
		<select name="rep_templet" id="rep_templet">
					<%
					List rep_templet=QueryEngine.getInstance().doQueryList("select id,name from ad_cxtab where ad_table_id="+tableId+" and ad_client_id="+userWeb.getAdClientId());
					String str="";
					int rep_templet_id;
					if(rep_templet.size()>0){
						for(int i=0;i<rep_templet.size();i++){
							str=(String)((List)(rep_templet.get(i))).get(1);
							rep_templet_id=Tools.getInt(((List)(rep_templet.get(i))).get(0),-1);
						%>
						<option value="<%=rep_templet_id%>" <%=(rep_templet_id==cxtabId)?"selected='selected'":" "%>><%=str%></option>
						<%
						}
					}
					%>
		  		</select></br>
	<span style="width:100px;"><%=PortletUtils.getMessage(pageContext, "description",null)%>:</span><%=cxtabDesc%>
</div>
</td></tr></table>
	    <form id="list_query_form" name="list_query_form" method="post" action="/servlets/QueryInputHandler" onSubmit="pc.queryList();return false;" >
        <input type='hidden' name='table' value='<%=tableId %>'>
        <input type='hidden' name='tab_count' value='<%=tab_count%>'>
        <input type='hidden' name='return_type' value='<%=return_type %>'>
        <input type='hidden' name='accepter_id' value='<%=accepter_id %>'>
        <input type='hidden' name='param_count' value='<%=qColumns.size() %>'>
        <input type='hidden' name='resulthandler' value='/html/nds/portal/table_list.jsp'>
        <input type='hidden' name='show_maintableid' value='true'>
		<input type='hidden' name='show_all' value='true'>       
		  <%
		  	for(int tabIdx=0;tabIdx< tab_count;tabIdx ++){
		  		// page setting
		  %>
                <table border="0" cellspacing="0" cellpadding="0" align='center' width="98%" bordercolordark="#FFFFFF" bordercolorlight="#999999">
                   <!--<tr>
                    <td colspan=2 height="20" >

						<b><%= PortletUtils.getMessage(pageContext, "page",null)%><%=tabIdx+1%></b>&nbsp;&nbsp;&nbsp;
						   	<% if( tabIdx !=0){
						   		StringHashtable osql_comb = new StringHashtable();
						   		osql_comb.put(  PortletUtils.getMessage(pageContext, "and-condition",null),""+SQLCombination.SQL_AND);
						   		osql_comb.put(  PortletUtils.getMessage(pageContext, "or-condition",null),""+SQLCombination.SQL_OR);
						   		osql_comb.put(  PortletUtils.getMessage(pageContext, "andnot-condition",null),""+SQLCombination.SQL_AND_NOT);
						   		osql_comb.put(  PortletUtils.getMessage(pageContext, "ornot-condition",null),""+SQLCombination.SQL_OR_NOT);
						   		HashMap aosql_comb=new java.util.HashMap();
						   		String nosql_comb="tab"+tabIdx+"_sql_combination";
						   	%>
						<input:select name="<%=nosql_comb%>" default="2" attributes="<%=aosql_comb%>" options="<%= osql_comb %>" />
                    		<%}/*--end if tabIdx !=0 */%>
                    </td>
                  </tr>-->
                  <tr>
                    <td  colspan="2">
                      <table align="center" border="0" cellpadding="1" cellspacing="1" width="98%" >
                        <%
                           int columnsPerRow=4;// 4 field per row
                           int widthPerColumn= (int)(100/(columnsPerRow*2));

                      for(int i=0;i< qColumns.size();i++){
                          Column column=(Column)qColumns.get(i);

                          String desc=  model.getDescriptionForColumn(column);
                          String fkDesc= model.getDescriptionForFKColumn(column);
                          if (! "".equals(fkDesc)) fkDesc= "("+ fkDesc+")";
                          String inputName="tab"+tabIdx+"_"+model.getNameForInput(column);
                          String cs= model.getColumns(column);
                          int inputSize=model.getSizeForInput(column);
                          String type=model.getTypeMeaningForInput(column);

                          nds.util.PairTable values = column.getValues(locale);
                          if(i%columnsPerRow == 0)out.print("<tr>");
                          String column_desc="column_"+column.getId()+"_desc"; // equals column_acc_Id + "_desc"
                        %>
                          <td height="18" width="<%=widthPerColumn*2/3%>%" nowrap align="left">
                               <div class="desc-txt"><%=column.getDescription(locale)%>:</div>
                          </td>
                          <td height="18" width="<%=widthPerColumn*4/3%>%" nowrap align="left">

                              <input type="hidden" name="<%=inputName%>/columns" value="<%=cs%>" >
                           <%
                            if(values != null){// ��ʾcombox��radio
                                //Hawke Begin
                                StringHashtable o = new StringHashtable();
								o.put(PortletUtils.getMessage(pageContext, "combobox-select-all",null),"0");
                                Iterator i1 = values.keys();
                                Iterator i2 = values.values();
                                while(i1.hasNext() && i2.hasNext())
                                {
                                    String tmp1 = String.valueOf(i2.next());
                                    String tmp2 = String.valueOf(i1.next());
                                    // add = so will match identically
                                    o.put(tmp1,"="+tmp2); // tmp1 is limit-description, tmp2 is limit-value
                                }
                                java.util.HashMap a = new java.util.HashMap();
                                inputName += "/value";
                               
                                // special handling "isactive" field
                                if("isactive".equalsIgnoreCase(column.getName()) && !"n".equals(return_type)){
                                // not attributesText="disabled", so user can still change it,especially in security filter setting
                           %>
                           <input:select name="<%=inputName%>" default="=Y" attributes="<%= a %>" options="<%= o %>" />
                           <input type="hidden" name="<%=inputName%>" value="=Y">
                           <%	}else{
                           %>
                           <input:select name="<%=inputName%>" default="0" attributes="<%= a %>" options="<%= o %>" />
                           <%
                           		}
                            }// end if(value != null)
                            else{
                                String column_acc_Id="tab"+tabIdx+"_column_"+column.getId();
                                String column_acc_name= inputName;
                                java.util.Hashtable h = new java.util.Hashtable();
                                   h.put("size", "15");
					            if((column.getReferenceTable()!=null && column.getReferenceTable().getAlternateKey().isUpperCase())||
					            	column.isUpperCase()){
					            	h.put("class","qline ucase");
					            }else
					            	h.put("class","qline");
					            //h.put("onkeypress", "pc.onSearchReturn(event)");
                                   inputName += "/value";
								if(column.getReferenceTable() !=null){                                   
	                                h.put("id",column_acc_Id);
                                    FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(column.getReferenceTable(), column_acc_Id,column,null,false);
                            %>
                              		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= type%>
                                    <input type='hidden' name='<%=column_acc_name+"/sql"%>' id='<%=column_acc_Id + "_sql"%>' />
                                    <input type='hidden' name='<%=column_acc_name+"/filter"%>' id='<%=column_acc_Id + "_filter"%>' />
                                        <span id='<%=column_acc_Id+"_link"%>' title="popup" onaction="<%=fkQueryModel.getButtonClickEventScript(false)%>">
                                        	<img id='<%=column_acc_Id+"_img"%>' border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/filterobj.gif' alt='<%=PortletUtils.getMessage(pageContext, "open-new-page-to-search",null)%>'>
                                        </span>
										<script>createButton(document.getElementById("<%=column_acc_Id+"_link"%>"));</script>	
                                    <%
                            	}else{
                            		//will check type first, for number, construct operator, for date, two fields, for string, contains or equal
                            		if(column.getType()==Column.DATE||column.getType()==Column.DATENUMBER ){
                            			String showDefaultRange=firstDateColumnFound?"N":"Y";// only first date column will have default range set
                            		%>
                            		<input:daterange id="<%=column_acc_Id%>" name="<%=inputName%>" showDefaultRange="<%=showDefaultRange%>" attributes="<%= h %>"/>
                            		<%
                            			firstDateColumnFound=true;
                            		}else if(column.getType()==Column.NUMBER){
                            		%>
                            		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= type%>
                            		<%
                            		}else if(column.getType()==Column.STRING){
                            		%>
                            		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= type%>
                            		<%
                            		}
                            	}
                            }%>
                          </td>
                        <%
                        if(i%columnsPerRow == (columnsPerRow -1))out.print("</tr>");
                        }%>
                      </table>
                    </td>
                  </tr>
                </table><br>
                <%}// end for(int tabIdx=0;tabIdx< tab_count;tabIdx ++)
                %>
 <div id="rpt-sbtns">
<%

if(Validator.isNotNull(excelPath)){%>
      <input id="btn_run_rpt2" type="button" class="cbutton" onclick="javascript:pc.doReportOnSelection(true,<%=tableId%>,'xls')" value="<%=PortletUtils.getMessage(pageContext, "execute-xls",null)%>">
      &nbsp;&nbsp;
<%}%>
      <input id="btn_run_rpt" type="button" class="cbutton" onclick="javascript:pc.doReportOnSelection(true,<%=tableId%>,'htm')" value="<%=PortletUtils.getMessage(pageContext, "execute-htm",null)%>">&nbsp;&nbsp;
      <input id="btn_run_cube" type="button" class="cbutton" onclick="javascript:pc.doReportOnSelection(true,<%=tableId%>,'cub')" value="<%=PortletUtils.getMessage(pageContext, "execute-cube",null)%>">&nbsp;&nbsp;
<%if(Validator.isNotNull(jReportPath)){
	if(jReportPath.endsWith(".jrxml")){%>
      <input id="btn_run_jxls" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=tableId%>,'xls')" value="<%=PortletUtils.getMessage(pageContext, "execute-jxls",null)%>">&nbsp;&nbsp;
      <input id="btn_run_jhtm" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=tableId%>,'htm')" value="<%=PortletUtils.getMessage(pageContext, "execute-jhtm",null)%>">&nbsp;&nbsp;
      <input id="btn_run_jpdf" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=tableId%>,'pdf')" value="<%=PortletUtils.getMessage(pageContext, "execute-jpdf",null)%>">&nbsp;&nbsp;
    <%}%>
<%	
  }
 int objPerm= userWeb.getObjectPermission("AD_CXTAB", cxtabId);
if((objPerm & nds.security.Directory.WRITE )== nds.security.Directory.WRITE ){
%>    
      <input type="button" class="cbutton" onclick="javascript:pc.modifyrep();" value="<%=PortletUtils.getMessage(pageContext, "define-cxtab",null)%>">
<%}%>      
<script>
 pc.initCxtabQuery(<%=q.toString()%>);
 pc.refreshCxtabHistoryFiles(<%=cxtabId%>);
</script>	
 </div>      
 </form>
<div id="history_files"></div>
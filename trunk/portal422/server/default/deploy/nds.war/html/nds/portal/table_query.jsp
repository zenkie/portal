<%
    /**
     * yfzhu added at 2003-9-26 to support adv security.
     * Request parameters:
     *  1. "retur_type" can be "s" (single line of selected row)or "m"(multiple line of rows), or "n" (default) nothing will be return
     *  2. "accepter_id" the input box's id in window
     *  3. "tab_count" integer, for count of tab control, default to 1
     */
    String return_type= "n";
    String accepter_id= null;
    int tab_count= 1;

WebUtils.checkTableQueryPermission(table.getName(), request);

ArrayList qColumns=table.getIndexedColumns();
TableQueryModel model= new TableQueryModel(tableId,qColumns,false,false,locale);
%>

	    <form id="list_query_form" name="list_query_form" method="post" action="/servlets/QueryInputHandler" onSubmit="pc.queryList();return false;" >
        <input type='hidden' name='table' value='<%=tableId %>'>
        <input type='hidden' name='tab_count' value='<%=tab_count%>'>
        <input type='hidden' name='return_type' value='<%=return_type %>'>
        <input type='hidden' name='accepter_id' value='<%=accepter_id %>'>
        <input type='hidden' name='param_count' value='<%=qColumns.size() %>'>
        <input type='hidden' name='resulthandler' value='/html/nds/portal/table_list.jsp'>
        <input type='hidden' name='show_maintableid' value='true'>
		  <%
		  	for(int tabIdx=0;tabIdx< tab_count;tabIdx ++){
		  		// page setting
		  %>
		  
                <table border="0" cellspacing="0" cellpadding="0" align='center' width="98%" bordercolordark="#FFFFFF" bordercolorlight="#999999">
                   <tr><!--
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
                      <table align="center" border="0" cellpadding="1" cellspacing="1" width="100%" >
                      	
                        <%
                           int columnsPerRow=4;// 4 field per row
                           int widthPerColumn= (int)(100/(columnsPerRow*2));
						  
						  boolean firstDateColumnFound=false;
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
                            if(values != null){// ÏÔÊ¾combox»òradio
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
                           		String defaultSelectValue="0";
                           		if("STATUS".equals(column.getName())){defaultSelectValue="=1";}
                           		if("ISACTIVE".equals(column.getName())){defaultSelectValue="=Y";}
                           %>
                           <input:select name="<%=inputName%>" default="<%=defaultSelectValue%>" attributes="<%= a %>" options="<%= o %>" />
                           <%
                           		}
                            }// end if(value != null)
                            else{
                                String column_acc_Id="tab"+tabIdx+"_column_"+column.getId();
                                String column_acc_name= inputName;
                                String defaultValue= userWeb.getUserOption(column.getName(),"");
                                java.util.Hashtable h = new java.util.Hashtable();
                                   h.put("size", "15");
					            if((column.getReferenceTable()!=null && column.getReferenceTable().getAlternateKey().isUpperCase())||
					            	column.isUpperCase()){
					            	h.put("class","qline ucase");
					            }else
					            	h.put("class","qline");
					            h.put("onkeypress", "pc.onSearchReturn(event)");
                                   //h.put("maxlength", String.valueOf(inputSize));
                                inputName += "/value";
                                   
                            	if(column.getReferenceTable() !=null){                                   
	                                h.put("id",column_acc_Id);
                                    //String url="/html/nds/query/search.jsp?table="+column.getReferenceTable().getId()+"&column="+column.getId()+"&return_type=m&accepter_id="+column_acc_Id;
                                    FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(column.getReferenceTable(), column_acc_Id,column,null,false);
                                    fkQueryModel.setQueryindex(-1);
                                    if(nds.util.Validator.isNotNull(defaultValue)) defaultValue="="+defaultValue;
                            %>
                              		<input:text name="<%=inputName%>" default="<%=defaultValue%>" attributes="<%= h %>" /><%= type%>
                                    <input type='hidden' name='<%=column_acc_name+"/sql"%>' id='<%=column_acc_Id + "_sql"%>' />
                                    <input type='hidden' name='<%=column_acc_name+"/filter"%>' id='<%=column_acc_Id + "_filter"%>' />
                                        <span id='<%=column_acc_Id+"_link"%>' title="popup" onaction="<%=fkQueryModel.getButtonClickEventScript()%>">
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
                            		<%	firstDateColumnFound=true;
                            		}else if(column.getType()==Column.NUMBER){
                            		%>
                            		<input:text name="<%=inputName%>" default="<%=defaultValue%>" attributes="<%= h %>" /><%= type%>
                            		<%
                            		}else if(column.getType()==Column.STRING){
                            		%>
                            		<input:text name="<%=inputName%>" default="<%=defaultValue%>" attributes="<%= h %>" /><%= type%>
                            		<%
                            		}
                            	}

                            }%>
                          </td>
                        <%
                        if(i%columnsPerRow == (columnsPerRow -1))out.print("</tr>");
                        }
                      %>
                      </table>
                    </td>
                  </tr>
                </table>
                <%}// end for(int tabIdx=0;tabIdx< tab_count;tabIdx ++)
                %>
 <%
//String columnTitles= ""; 
for(int i=0;i<qColumns.size();i++){
	Column column=(Column)qColumns.get(i);
	String desc=  model.getDescriptionForColumn(column);
	String selectName = model.getNameForSelect(column);
	//columnTitles += (i>0?",":"")+ column.getDescription(locale);
	String cols= model.getColumns(column);
	out.println("<input type='hidden' name='"+selectName+"/columns' value='"+cols+"'>");
}
//<input type='hidden' name='select_desc' value='=columnTitles'>
  %>                
<input type='hidden' name='show_all' value='true'>
<input type='hidden' name='queryindex_-1' id='queryindex_-1' value="-1" />
<!--<div id='tryrecent'><input type='checkbox' id='chk_tryrecent' value='1' checked><%=PortletUtils.getMessage(pageContext, "try-recent",null)%></div>-->
  </form>


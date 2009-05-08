<%
/**
   Only for report that not set ad_table, that means, whole parameters are read from ad_cxtab_jpara table
   params:
   	cxtab* - ad_cxtab.id
*/
	int reportId= ParamUtils.getIntAttributeOrParameter(request, "cxtab", -1);
	if(reportId ==-1) throw new NDSException("Internal error, jreport id="+ reportId + " does not exist");
	List list=QueryEngine.getInstance().doQueryList("select ad_table_id,name, description from ad_cxtab where id="+ reportId);
 	if(list.size()==0)throw new NDSException("Internal error, cxtab id="+ reportId + " does not exist");
  	int tableId= Tools.getInt( ((List)list.get(0)).get(0),-1);
	String jreportName=(String) ((List)list.get(0)).get(1);
	String jreportDesc=(String) ((List)list.get(0)).get(2);
%>
<table border="0" cellspacing="0" cellpadding="0" align='center' width="98%"><tr><td>
<div id="rpt-desc">
	<span style="width:100px;"><%=PortletUtils.getMessage(pageContext, "current-cxtab",null)%>:</span><b><%=jreportName%></b><br>
	<span style="width:100px;"><%=PortletUtils.getMessage(pageContext, "description",null)%>:</span><%=jreportDesc%>
</div>
</td></tr></table>
<form id="list_query_form" name="list_query_form">
<table align="center" border="0" cellpadding="1" cellspacing="1" width="98%" >
<%
    int columnsPerRow=4;// 4 field per row
    int widthPerColumn= (int)(100/(columnsPerRow*2));
	// construct using ad_jreport_para
	List paras= QueryEngine.getInstance().doQueryList("select name, paratype, defaultvalue, description, ad_column_id, selectiontype from ad_cxtab_jpara where ad_cxtab_id="+ reportId);

    for(int i=0;i<paras.size();i++){
          List para= (List) paras.get(i);
		  Column column=manager.getColumn( Tools.getInt( para.get(4),-1));
		  nds.util.PairTable values =null;
          String desc=(String)para.get(3);
          String inputName=(String)para.get(0);
          String type=(String)para.get(1);
          String typeDesc=TableQueryModel.toTypeDesc((String)para.get(1), 0,locale);
		  if(column!=null)	
           	values=column.getValues(locale);
          if(i%columnsPerRow == 0)out.print("<tr>");
        %>
          <td height="18" width="<%=widthPerColumn*2/3%>%" nowrap align="left">
               <div class="desc-txt"><%=desc%>:</div>
          </td>
          <td height="18" width="<%=widthPerColumn*4/3%>%" nowrap align="left">
           <%
            if(values != null){// ÏÔÊ¾combox»òradio
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
                %>
           <input:select name="<%=inputName%>" default="0" attributes="<%= a %>" options="<%= o %>" />
           <%
            }// end if(value != null)
            else{
                java.util.Hashtable h = new java.util.Hashtable();
                   h.put("size", "15");
	            if((column!=null && column.getReferenceTable()!=null && column.getReferenceTable().getAlternateKey().isUpperCase())||
	            	column.isUpperCase()){
	            	h.put("class","qline ucase");
	            }else
	            	h.put("class","qline");
				if(column!=null && column.getReferenceTable() !=null){                                   
                    h.put("id",inputName);
                    FKObjectQueryModel fkQueryModel=new FKObjectQueryModel(column.getReferenceTable(), inputName,column,null,false);
            %>
              		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= typeDesc%>
                    <input type='hidden' name='<%=inputName+"/sql"%>' id='<%=inputName + "_sql"%>' />
                        <span id='<%=inputName+"_link"%>' title="popup" onaction="<%=fkQueryModel.getButtonClickEventScript()%>"><img id='<%=inputName+"_img"%>' border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/find.gif' alt='<%=PortletUtils.getMessage(pageContext, "open-new-page-to-search",null)%>'></span>
						<script>createButton(document.getElementById("<%=inputName+"_link"%>"));</script>	
                    <%
            	}else{
            		//will check type first, for number, construct operator, for date, two fields, for string, contains or equal
            		if("d".equalsIgnoreCase(type)){
            			String showDefaultRange=firstDateColumnFound?"N":"Y";// only first date column will have default range set
            		%>
            		<input:daterange id="<%=inputName%>" name="<%=inputName%>" showDefaultRange="<%=showDefaultRange%>" attributes="<%= h %>"/>
            		<%
            			firstDateColumnFound=true;
            		}else if(column.getType()==Column.NUMBER){
            		%>
            		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= typeDesc%>
            		<%
            		}else if(column.getType()==Column.STRING){
            		%>
            		<input:text name="<%=inputName%>" attributes="<%= h %>" /><%= typeDesc%>
            		<%
            		}
            	}
            }%>
          </td>
        <%
        if(i%columnsPerRow == (columnsPerRow -1))out.print("</tr>");
        }%>
</table>
<br>
<div id="rpt-sbtns">
      <input id="btn_run_rpt2" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=jreportId%>,<%=tableId%>,'xls')" value="<%=PortletUtils.getMessage(pageContext, "execute-jxls",null)%>">
      &nbsp;&nbsp;
      <input id="btn_run_rpt" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=jreportId%>,<%=tableId%>,'htm')" value="<%=PortletUtils.getMessage(pageContext, "execute-jhtm",null)%>">
      &nbsp;&nbsp;
      <input id="btn_run_rpt3" type="button" class="cbutton" onclick="javascript:pc.doJReportOnSelection(<%=jreportId%>,<%=tableId%>,'pdf')" value="<%=PortletUtils.getMessage(pageContext, "execute-jpdf",null)%>">
</div>
 </form>


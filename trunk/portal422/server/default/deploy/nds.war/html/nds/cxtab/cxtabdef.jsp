<%@ include file="/html/nds/common/init.jsp" %>
<%
/**
  param 
	 id   - ad_cxtab.id, -1 for new
*/
int cxtabId= nds.util.Tools.getInt( request.getParameter("id"),-1);
TableManager manager=TableManager.getInstance();
QueryEngine engine =QueryEngine.getInstance();
Table cxtabTable=manager.getTable("ad_cxtab");
String title= PortletUtils.getMessage(pageContext, "crosstab-define",null);
List qr=engine.doQueryList("select ad_table_id, name from ad_cxtab where id="+ cxtabId);
int ownerId=Tools.getInt(QueryEngine.getInstance().doQueryOne("select ownerid from ad_cxtab where id="+cxtabId), -1);
if(qr.size()==0)  throw new NDSException("@object-not-find@");
// check write permission
int objPerm= userWeb.getObjectPermission("AD_CXTAB", cxtabId);
if((objPerm & nds.security.Directory.WRITE )!= nds.security.Directory.WRITE ){
	if(objPerm==0) throw new NDSException("@no-permission@");
}

int factTableId=Tools.getInt( ((List)qr.get(0)).get(0),-1);
String cxtabName=(String)((List)qr.get(0)).get(1);
Table factTable=manager.getTable(factTableId);
request.setAttribute("page_help", "CxtabDefine");
String tabName=title;
%>
<liferay-util:include page="/html/nds/header.jsp">
	<liferay-util:param name="html_title" value="<%=title%>" />
	<liferay-util:param name="show_top" value="true" />
	<liferay-util:param name="enable_context_menu" value="true" />
	<liferay-util:param name="table_width" value="100%" />
</liferay-util:include>
<script language="javascript">
document.bgColor="<%=colorScheme.getPortletBg()%>";
<%@ include file="/html/nds/cxtab/inc_cxtabdef.js.jsp" %>
</script>
<script type="text/javascript" src="<%=NDS_PATH+"/js/xloadtree111/xtree.js"%>"></script>
<script type="text/javascript" src="<%=NDS_PATH+"/js/xloadtree111/xmlextras.js"%>"></script>
<script type="text/javascript" src="<%=NDS_PATH+"/js/xloadtree111/xloadtree.js"%>"></script>
<link type="text/css" rel="stylesheet" href="<%=NDS_PATH+"/js/xloadtree111/xtree.css"%>" />

<script language="JavaScript" src="/html/nds/js/formkey.js"></script>

<script type='text/javascript' src='/html/nds/js/util.js'></script> 
<script type="text/javascript" src="/html/nds/js/dwr.Controller.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.engine.js"></script>
<script type="text/javascript" src="/html/nds/js/dwr.util.js"></script>
<script language="javascript" src="/html/nds/js/application.js"></script>
<script language="javascript" src="/html/nds/js/alerts.js"></script>
<script language="javascript" src="/html/nds/js/cxtabdef.js"></script>
<style>
.selectbox{width: 190px;}
</style>
<div id="maintab">
	<ul><li><a href="#tab1"><span><%=tabName%></span></a></li></ul>
	<div id="tab1">
<table width="98%" cellspacing="0" cellpadding="0" border="0" align="center" bordercolorlight="#999999" bordercolordark="#FFFFFF">
<form name= "cxtabrpt_form" method="post" target="_blank" action="/control/command">
  <input type='hidden' name="command" value="CreateCxtabRunnerProcessInstance">
<tr><td><br>
<%= manager.getColumn("ad_cxtab","ad_table_id").getDescription(locale)%>: <a href="<%=NDS_PATH%>/object/object.jsp?table=ad_table&id=<%=factTableId%>"><%=factTable.getDescription(locale)%></a>&nbsp;&nbsp;
<%
	if(ownerId==userWeb.getUserId()){
%>
<%= cxtabTable.getDescription(locale)%>:<input type="text" id="cxtabName" name="cxtabName" size="30" value="<%=cxtabName%>" readonly="true">
<%}else{%>
	<%= cxtabTable.getDescription(locale)%>:<input type="text" id="cxtabName" name="cxtabName" value="<%=cxtabName%>" readonly="true">
<%}%>
<input type="hidden" id="cxtabId" name="cxtabId" value="<%=cxtabId%>">
</td></tr>	
<tr><td><br>
<table cellpadding="0" cellspacing="0" width="600" height="420">
	<tr>
		<td valign="top" width="200" rowspan="2"><!--tree-->
<%= PortletUtils.getMessage(pageContext, "available-columns",null)%>:<br>
<div style="border-width:1;border-style:inset;padding:0px;border-color:#cccccc;width:200px; height:400px;overflow-y: auto; overflow-x: auto;"> 	
<script type="text/javascript">
/// XP Look
webFXTreeConfig.rootIcon		= "<%=NDS_PATH%>/images/table.gif";
webFXTreeConfig.openRootIcon	= "<%=NDS_PATH%>/images/table.gif";
webFXTreeConfig.folderIcon		= "<%=NDS_PATH%>/images/table.gif";
webFXTreeConfig.openFolderIcon	= "<%=NDS_PATH%>/images/table.gif";
webFXTreeConfig.fileIcon		= "<%=NDS_PATH%>/images/column.gif";

webFXTreeConfig.lMinusIcon		= "<%=NDS_PATH%>/js/xloadtree111/images/xp/Lminus.png";
webFXTreeConfig.lPlusIcon		= "<%=NDS_PATH%>/js/xloadtree111/images/xp/Lplus.png";
webFXTreeConfig.tMinusIcon		= "<%=NDS_PATH%>/js/xloadtree111/images/xp/Tminus.png";
webFXTreeConfig.tPlusIcon		= "<%=NDS_PATH%>/js/xloadtree111/images/xp/Tplus.png";
webFXTreeConfig.iIcon			= "<%=NDS_PATH%>/js/xloadtree111/images/xp/I.png";
webFXTreeConfig.lIcon			= "<%=NDS_PATH%>/js/xloadtree111/images/xp/L.png";
webFXTreeConfig.tIcon			= "<%=NDS_PATH%>/js/xloadtree111/images/xp/T.png";
webFXTreeConfig.blankIcon		= "<%=NDS_PATH%>/js/xloadtree111/images/xp/blank.png";
var tree = new WebFXLoadTree("<%=factTable.getDescription(locale)%>", "<%=NDS_PATH+"/cxtab/columns.xml.jsp?table="+factTableId%>");
tree.setBehavior("classic");
document.write(tree);
</script>       	
</div>	
		<!--end tree--></td>
<td rowspan="2">
<img border="0" hspace="0" width="10" height="10" src="<%=NDS_PATH%>/images/spacer.gif" vspace="0">
</td>
		<td valign="top" width="400" height="350"><!--dim-->
<%= PortletUtils.getMessage(pageContext, "dimensions-measures",null)%>:<br>
<div class="divline">
	<table cellpadding="4" cellspacing="0" width="424" height="316">
<tr><td width="25" height="21"></td>
	<td width="173" height="21"><%=PortletUtils.getMessage(pageContext, "axis-p",null)%></td>
	<td width="32" height="21"></td>
	<td width="194" height="21"><%=PortletUtils.getMessage(pageContext, "axis-h",null)%> </td></tr>
<tr>
	<td width="25" align="center">
		<input type="button" value=">" onclick="cxtabDefControl.addColumnToDim('axis_p')"/> 
		<input type="button" value="<" onclick="cxtabDefControl.removeSelection('axis_p')"/> <p>
		<span id='axis_p_moveup' onaction="cxtabDefControl.moveUp('axis_p')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/moveup.gif'></span><br>
		<span id='axis_p_movedown' onaction="cxtabDefControl.moveDown('axis_p')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/movedown.gif'></span>
		<script>
			createButton($("axis_p_moveup"));
			createButton($("axis_p_movedown"));
		</script>		
	</td>
	<td width="173"  height="117">
		<SELECT id="axis_p" class="selectbox" MULTIPLE size="7" ondblclick="cxtabDefControl.editDim('axis_p')"></SELECT>
	</td>
	<td width="32" align="center">
		<input type="button" value=">" onclick="cxtabDefControl.addColumnToDim('axis_h')"/>
		<input type="button" value="<" onclick="cxtabDefControl.removeSelection('axis_h')"/><p>
		<span id='axis_h_moveup' onaction="cxtabDefControl.moveUp('axis_h')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/moveup.gif'></span><br>
		<span id='axis_h_movedown' onaction="cxtabDefControl.moveDown('axis_h')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/movedown.gif'></span>
		<script>
			createButton($("axis_h_moveup"));
			createButton($("axis_h_movedown"));
		</script>
	</td>
	<td width="194" height="110">
		<SELECT class="selectbox" id="axis_h" MULTIPLE size="7" ondblclick="cxtabDefControl.editDim('axis_h')"></SELECT>
	</td>
</tr>
<tr>
	<td width="25" height="21"></td><td width="173" height="21"><input type="button" value="<%=PortletUtils.getMessage(pageContext, "edit-selected-dim",null)%>" onclick="cxtabDefControl.editDim('axis_p')" ></td>
	<td width="32"></td><td width="194" height="26"><input type="button" value="<%=PortletUtils.getMessage(pageContext, "edit-selected-dim",null)%>" onclick="cxtabDefControl.editDim('axis_h')" ></td>
</tr>
<tr><td width="25" height="21"></td>
	<td width="173" height="21"><%=PortletUtils.getMessage(pageContext, "axis-v",null)%></td>
	<td width="32" height="21"></td>
	<td width="194" height="21"><%=PortletUtils.getMessage(pageContext, "fact-desc",null)%> </td></tr>
<tr>
	<td width="25" align="center">
		<input type="button" value=">" onclick="cxtabDefControl.addColumnToDim('axis_v')"/> 
		<input type="button" value="<" onclick="cxtabDefControl.removeSelection('axis_v')"/> <p>
		<span id='axis_v_moveup' onaction="cxtabDefControl.moveUp('axis_v')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/moveup.gif'></span><br>
		<span id='axis_v_movedown' onaction="cxtabDefControl.moveDown('axis_v')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/movedown.gif'></span>
		<script>
			createButton($("axis_v_moveup"));
			createButton($("axis_v_movedown"));
		</script>		
	</td>
	<td width="173"  height="117">
	<SELECT id="axis_v" class="selectbox" MULTIPLE size="7" ondblclick="cxtabDefControl.editDim('axis_v')">
</SELECT></td>
	<td width="32" align="center">
			<input type="button" value=">" onclick="cxtabDefControl.addColumnToMeasure()"/> 
			<input type="button" value="<" onclick="cxtabDefControl.removeSelection('measure')"/> <p>
		<span id='measure_moveup' onaction="cxtabDefControl.moveUp('measure')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/moveup.gif'></span><br>
		<span id='measure_movedown' onaction="cxtabDefControl.moveDown('measure')"><img border=0 width=16 height=16 align=absmiddle src='<%=NDS_PATH%>/images/movedown.gif'></span>
		<script>
			createButton($("measure_moveup"));
			createButton($("measure_movedown"));
		</script>		
	</td>		
	<td width="194">
	<SELECT id="measure" class="selectbox" MULTIPLE size="7" ondblclick="cxtabDefControl.editMeasure()">
</SELECT></td>
</tr>
<tr>
	<td width="25" height="21"></td><td width="173" height="21"><input type="button" value="<%=PortletUtils.getMessage(pageContext, "edit-selected-dim",null)%>" onclick="cxtabDefControl.editDim('axis_v')" ></td>
	<td width="32" height="21"></td><td width="194" height="21"><input type="button" value="<%=PortletUtils.getMessage(pageContext, "edit-selected-measure",null)%>" onclick="cxtabDefControl.editMeasure()" >
		<input type="button" value="<%=PortletUtils.getMessage(pageContext, "new-measure",null)%>" onclick="cxtabDefControl.newMeasure()" ></td>
</tr>
</table>
</div>
</td>
	</tr>
	<tr>
		<td width="600" height="50"><!--btn-->
			<%
				if(ownerId==userWeb.getUserId()){
			%>
					<input class="cbutton" type='button' id="btn_save_cxtab" size="20" name='executeCxrpt' value='<%=PortletUtils.getMessage(pageContext, "modify-save-cxtab",null)%>' onclick="javascript:cxtabDefControl.saveCxtab('M');" >&nbsp;&nbsp;
					<input class="cbutton" type='button' id="btn_add_cxtab" size="20" value='<%=PortletUtils.getMessage(pageContext, "add-save-cxtab",null)%>' onclick="javascript:cxtabDefControl.saveCxtab('A');" >
		<%}else{%>
				 <input class="cbutton" type='button' id="btn_add_cxtab" size="20" value='<%=PortletUtils.getMessage(pageContext, "add-save-cxtab",null)%>' onclick="javascript:cxtabDefControl.saveCxtab('A');" >
		<%}%>
		<%@ include file="/html/nds/common/helpbtn.jsp"%>
		</td>
	</tr>
</table>
</td></tr>
</form>
</table>
<% //following is div used for dialogs%>
<div id="dlg_dim" style="display:none">
<div id="TMPLdlg_dim_content" style="border-width:1;border-style:solid;padding:0px;border-color:#cccccc;"> 	
	<table cellpadding="4" cellspacing="0" border="0" width="400" height="140">
		<tr><td width="15%" nowrap ><%=manager.getColumn("ad_cxtab_dimension","COLUMNLINK").getDescription(locale)%><font color="red">*</font>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_dimension","COLUMNLINK").getDescription(locale)%>" type="text"  id="TMPLdim_columnlink" value="" size="60" maxlength="255" /></td>
		</tr><tr>
			<td width="15%" nowrap><%=manager.getColumn("ad_cxtab_dimension","DESCRIPTION").getDescription(locale)%><font color="red">*</font>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_dimension","DESCRIPTION").getDescription(locale)%>" type="text"  id="TMPLdim_description" value="" size="60" maxlength="80" /></td>
		</tr><tr>
			<td width="15%" nowrap><%=PortletUtils.getMessage(pageContext, "hide-in-html-report",null)%>:</td>
			<td width="85%" align="left"><input type="checkbox"  id="TMPLdim_hidehtml" value=""/></td>
		</tr><tr>	
			<td colspan="2">
				<input class="command2_button" type='button' id="TMPLbtn_save_dim" size="20" value='<%=PortletUtils.getMessage(pageContext, "command.ok",null)%>' onclick="javascript:cxtabDefControl.saveDim();" > &nbsp;&nbsp;
				<input class="command2_button" type='button' id="TMPLbtn_cancel_dim" size="20" value='<%=PortletUtils.getMessage(pageContext, "command.cancel",null)%>' onclick="Alerts.killAlert(this)" > 
				<input type="hidden"  id="TMPLdim_axis" value=""/>
				<br><br>
			</td>
		</tr>		
	</table>
</div>
</div>

<div id="dlg_measure" style="display:none">
<div id="TMPLdlg_measure_content" style="border-width:1;border-style:solid;padding:0px;border-color:#cccccc;"> 	
	<table cellpadding="4" cellspacing="0" border="0" width="400" height="100">
		<tr><td width="15%" nowrap><%=manager.getColumn("ad_cxtab_fact","AD_COLUMN_ID").getDescription(locale)%>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_fact","AD_COLUMN_ID").getDescription(locale)%>" type="text"  id="TMPLmea_column" value="" size="60" maxlength="255" /></td>
		</tr><tr>
			<td width="15%" nowrap><%=manager.getColumn("ad_cxtab_fact","USERFACT").getDescription(locale)%>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_fact","USERFACT").getDescription(locale)%>" type="text"  id="TMPLmea_userfact" value="" size="60" maxlength="80" /></td>
		</tr><tr>
			<td width="15%" nowrap><%=manager.getColumn("ad_cxtab_fact","valuename").getDescription(locale)%>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_fact","valuename").getDescription(locale)%>" type="text"  id="TMPLmea_valuename" value="" size="60" maxlength="80" /></td>
		</tr><tr>
<%				
    String keyValue ;
    Column column= manager.getColumn("ad_cxtab_fact","FUNCTION_");
    PairTable values =column.getValues(locale);
    Iterator temp = values.keys();
    StringHashtable o = new StringHashtable();
	o.put(PortletUtils.getMessage(pageContext, "combobox-select",null),"0");
    while(temp.hasNext())
    {
        keyValue= temp.next().toString();
        o.put((String)values.get(keyValue),keyValue.toString());
    }
    java.util.HashMap a = new java.util.HashMap();
    a.put("id","TMPLmea_function");
    a.put("title", column.getDescription(locale));
    String defaultValue= (column.getDefaultValue()==null?"0":userWeb.replaceVariables(column.getDefaultValue()));
%>
			<td width="15%" nowrap><%=column.getDescription(locale)%><font color="red">*</font>:</td>
			<td width="85%" align="left"><input:select name="TMPLmea_function" default="<%=defaultValue%>" attributes="<%= a %>" options="<%= o %>" />
		</tr><tr>
			<td width="15%" nowrap><%=manager.getColumn("ad_cxtab_fact","DESCRIPTION").getDescription(locale)%><font color="red">*</font>:</td>
			<td width="85%" align="left"><input title="<%=manager.getColumn("ad_cxtab_fact","DESCRIPTION").getDescription(locale)%>" type="text"  id="TMPLmea_description" value="" size="60" maxlength="80" /></td>
		</tr><tr>
<%
    column= manager.getColumn("ad_cxtab_fact","VALUEFORMAT");
    values =column.getValues(locale);
    temp = values.keys();
    o = new StringHashtable();
	o.put(PortletUtils.getMessage(pageContext, "combobox-select",null),"0");
    while(temp.hasNext())
    {
        keyValue = temp.next().toString();
        o.put((String)values.get(keyValue),keyValue.toString());
    }
    a = new java.util.HashMap();
    a.put("id","TMPLmea_valueformat");
    a.put("title", column.getDescription(locale)); 
    defaultValue= (column.getDefaultValue()==null?"0":userWeb.replaceVariables(column.getDefaultValue()));
%>
			<td width="15%" nowrap><%=column.getDescription(locale)%><font color="red">*</font>:</td>
			<td width="85%" align="left"><input:select name="TMPLmea_valueformat" default="<%=defaultValue%>" attributes="<%= a %>" options="<%= o %>" />
		</tr><tr>
			<td colspan="2">
				<input class="command2_button" type='button' id="TMPLbtn_save_dim" size="20" value='<%=PortletUtils.getMessage(pageContext, "command.ok",null)%>' onclick="javascript:cxtabDefControl.saveMeasure();" > &nbsp;&nbsp;
				<input class="command2_button" type='button' id="TMPLbtn_cancel_dim" size="20" value='<%=PortletUtils.getMessage(pageContext, "command.cancel",null)%>' onclick="Alerts.killAlert(this)" > 
				
				<br><br>
			</td>
		</tr>		
	</table>
</div>
</div>
<br><br>
</div>
</div>
<%@ include file="/html/nds/footer_info.jsp" %>

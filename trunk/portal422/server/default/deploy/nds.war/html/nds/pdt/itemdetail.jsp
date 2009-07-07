<%@ include file="/html/nds/common/init.jsp" %>
<%@ page language="java" import="java.util.*,nds.control.event.DefaultWebEvent" pageEncoding="utf-8"%>
<%!
private nds.log.Logger logger= nds.log.LoggerManager.getInstance().getLogger("itemdetail.jsp");
private final static int TABINDEX_START=20000;
 
 /**
 * This is to record input element sequence, and will create next input element for each input
 */
 private void prepareAttributeTable(HashMap instances,int level, List attributes,List attributeValues, String prefix, List inputList){
	int attrId=Tools.getInt( ((List)attributes.get(level)).get(0),-1);
	String attrName= (String)((List)attributes.get(level)).get(1);
	List attrValues= (List) attributeValues.get(level);
	int levels= attributes.size();
	int j,k, vId, lastVId;
	String vDesc, lastVDesc;
	String key;
	Object instanceId;
	if(level<levels-2 && levels>2){
	 	//iteration
		for(j=0;j<attrValues.size();j++){
	 		vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		prepareAttributeTable(instances,level+1,attributes,attributeValues, prefix+"_"+vId, inputList);
	 	}
 	}else if(level==levels-2){
 		// table, first row is the last level, first column is the second last level
 		int lastAttrId= Tools.getInt(((List)attributes.get(level+1)).get(0),-1);
 		String lastAttrName= (String)((List)attributes.get(level+1)).get(1);
 		List lastAttrValues= (List) attributeValues.get(level+1);
 		for(j=0;j<lastAttrValues.size();j++){
	 		lastVDesc= (String)((List)lastAttrValues.get(j)).get(1);
	 		lastVId= Tools.getInt(((List)lastAttrValues.get(j)).get(0),-1);
	 	}
 		for(j=0;j<attrValues.size();j++){
 			vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		vDesc= (String)((List)attrValues.get(j)).get(1);	
	 		for(k=0;k<lastAttrValues.size();k++){
	 			lastVId =Tools.getInt(((List)lastAttrValues.get(k)).get(0),-1);	
	 			key= prefix+"_"+vId+"_"+lastVId;
	 			instanceId= instances.get(key);
	 			if(instanceId!=null){
	 				inputList.add(instanceId);
	 			}
	 		}
	 	}
 	}else{
 		// only one column
 		for(j=0;j<attrValues.size();j++){
	 		vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		vDesc= (String)((List)attrValues.get(j)).get(1);
	 		key= "_"+vId;
	 		instanceId= instances.get(key);
	 		if(instanceId!=null){
	 			inputList.add(instanceId);
	 		}
	 	}
 	}
 }
/**
 draw table of n level, checkbox name should in format like '_id1_id2_id3', id1 for first level,id2 for second, and so on
 @param prefix - is the prefix for checkbox name, for level 0, it will be "", for level 1, it will be "_id1", for level 2 "id1_ids2"
 @param instances - valid instances of current set, value:instanceid, key  _valueid1_valueid2, contains a special value
  named "inputCount" which is used for calcuate input tabIndex, and will get updated each time a new input elements added
*/
 private StringBuffer getAttributeTable(HashMap instances,int level, List attributes,List attributeValues, String prefix, List inputList,List li_store,List li_dest,boolean flagstore,boolean flagdest,Table store_table,Table dest_table,UserWebImpl userWeb){
 	int totalInputs= inputList.size();
 	String nextInputId;
	int attrId=Tools.getInt( ((List)attributes.get(level)).get(0),-1);
	String attrName= (String)((List)attributes.get(level)).get(1);
	List attrValues= (List) attributeValues.get(level);
	/*MessagesHolder mh= MessagesHolder.getInstance();
	UserWebImpl usr=(UserWebImpl) WebUtils.getSessionContextManager(request.getSession(true)).getActor(nds.util.WebKeys.USER);
	Locale locale= user.getLocale();
	*/
	StringBuffer sb=new StringBuffer();
	DefaultWebEvent event=new DefaultWebEvent("CommandEvent");
	MessagesHolder mh= MessagesHolder.getInstance();
	int levels= attributes.size();
	sb.append("<table align='left' id='modify_table_product' class='modify_table' width='100%' border='1' cellspacing='0' cellpadding='0'  bordercolordark='#FFFFFF' bordercolorlight='#FFFFFF'>");
	int j,k, vId, lastVId;
	String vDesc, lastVDesc;
	String key;
	Object instanceId;
	int inputCount=((Integer) instances.get("inputCount")).intValue();
	if(level<levels-2 && levels>2){
	 	//iteration
		for(j=0;j<attrValues.size();j++){
	 		vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		vDesc= (String)((List)attrValues.get(j)).get(1);	
	 		sb.append("<tr><td class='hd'>").
	 		append(vDesc).append("</td><td>&nbsp;</td></tr>");
	 		sb.append("<tr><td>&nbsp;</td><td>").append(
	 		getAttributeTable(instances,level+1,attributes,attributeValues, prefix+"_"+vId, inputList,li_store,li_dest,flagstore,flagdest,store_table,dest_table,userWeb)).
	 		append("</td></tr>");
	 	}
 	}else if(level==levels-2){
 		// table, first row is the last level, first column is the second last level
 		int lastAttrId= Tools.getInt(((List)attributes.get(level+1)).get(0),-1);
 		String lastAttrName= (String)((List)attributes.get(level+1)).get(1);
 		List lastAttrValues= (List) attributeValues.get(level+1);
 		sb.append("<tr><td>&nbsp;</td>");
 		for(j=0;j<lastAttrValues.size();j++){
	 		lastVDesc= (String)((List)lastAttrValues.get(j)).get(1);	
	 		lastVId= Tools.getInt(((List)lastAttrValues.get(j)).get(0),-1);
	 		sb.append("<td class='hd'>").append(lastVDesc).append("</td>");
	 	}
	 	sb.append("<td class='hd'>").append(mh.getMessage(event.getLocale(), "row_total")).append("</td>");
	 	sb.append("</tr>");
 		for(j=0;j<attrValues.size();j++){
 			vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		vDesc= (String)((List)attrValues.get(j)).get(1);	
	 		sb.append("<tr><td class='hd'>").append(vDesc).append("</td>");
	 		for(k=0;k<lastAttrValues.size();k++){
	 			lastVId =Tools.getInt(((List)lastAttrValues.get(k)).get(0),-1);	
	 			key= prefix+"_"+vId+"_"+lastVId;
	 			instanceId= instances.get(key);
	 			boolean flag_store =false;
	 			boolean flag_dest =false;
	 			if(instanceId!=null){
	 				nextInputId= inputCount+1>=totalInputs ?  ((Integer)inputList.get(0)).toString() : ((Integer)inputList.get(inputCount+1)).toString();
		 			sb.append("<td><table><tr><td><input class='inputline' type='text' tabIndex='").append((inputCount+TABINDEX_START)).append("' size='5' name='A").append(instanceId).append("' id='P").
		 			append(instanceId).append("' value='' onkeydown='return gc.onMatrixKey(event,").append(j).append(",").append(k).append(");'></td></tr>");
		 			if(flagstore){
			 			sb.append("<tr style='color: #996633'><td>");
			 			if(li_store.size()>0){
			 				boolean  directory_store=false;
			 				if((userWeb.getPermission(store_table.getSecurityDirectory())& nds.security.Directory.READ )== nds.security.Directory.READ ){
									directory_store =true;
							}
			 				for(int m=0;m<li_store.size();m++){
			 					int temp=Tools.getInt(((List)li_store.get(m)).get(0),-1);
			 					if(temp==Tools.getInt(instanceId,0)){
			 							if(directory_store){
					 						sb.append(Tools.getInt(((List)li_store.get(m)).get(1),0)).append("</td></tr>");
					 					}else{
					 						if(Tools.getInt(((List)li_store.get(m)).get(1),0)>0){
					 						 sb.append(mh.getMessage(event.getLocale(), "enough_goods")).append("</td></tr>");
					 						}else{
					 							sb.append(mh.getMessage(event.getLocale(), "lack_goods")).append("</td></tr>");
					 						}
					 					}
					 					flag_store =true;
				 					break;
		 				  	}
			 				}
			 			}
			 			if(!flag_store){
			 				sb.append("0").append("</td></tr>");
			 			}
			 		}
		 			if(flagdest){
			 			sb.append("<tr style='color:#339966'><td>");
			 			boolean  directory_dest=false;
			 			if((userWeb.getPermission(dest_table.getSecurityDirectory())& nds.security.Directory.READ )== nds.security.Directory.READ ){
								directory_dest =true;
						}
			 			if(li_dest.size()>0){
			 				for(int m=0;m<li_dest.size();m++){
			 					int temp=Tools.getInt(((List)li_dest.get(m)).get(0),-1);
			 					if(temp==Tools.getInt(instanceId,0)){
					 					if(directory_dest){
					 						sb.append(Tools.getInt(((List)li_store.get(m)).get(1),0)).append("</td></tr>");
					 					}else{
					 						if(Tools.getInt(((List)li_store.get(m)).get(1),0)>0){
					 						 sb.append(mh.getMessage(event.getLocale(), "enough_goods")).append("</td></tr>");
					 						}else{
					 							sb.append(mh.getMessage(event.getLocale(), "lack_goods")).append("</td></tr>");
					 						}
					 					}
					 					flag_dest =true;
					 					break;
			 				  	}
			 				}
			 			}
			 			if(!flag_dest){
			 				sb.append("0").append("</td></tr>");
			 			}
		 			}
		 			sb.append("</table></td>");
		 			inputCount++;
	 			}else{
	 				sb.append("<td></td>");
	 			}
	 		}
	 		sb.append("<td id='tot_");
	 		sb.append(j);
	 		sb.append("'align='center' valign='top'></td>");
	 		sb.append("</tr>");
	 	}
 	}else{
 		// only one column
 		for(j=0;j<attrValues.size();j++){
	 		vId=Tools.getInt(((List)attrValues.get(j)).get(0),-1);
	 		vDesc= (String)((List)attrValues.get(j)).get(1);
	 		key= "_"+vId;
	 		instanceId= instances.get(key);
	 		if(instanceId!=null){
	 			nextInputId= inputCount+1>=totalInputs ?  ((Integer)inputList.get(0)).toString() : ((Integer)inputList.get(inputCount+1)).toString();
	 			sb.append("<tr><td><table><tr><td><input class='inputline' type='text' tabIndex='").append((inputCount+TABINDEX_START)).append("' size='5' value='' name='A").
	 			append(instanceId).append("' value='' onkeydown='return gc.onMatrixKey(event,0,").append(j).append(");'></td></tr>");
	 			boolean flag_store =false;
	 			boolean flag_dest =false;
	 			if(flagstore){
		 			if(li_store.size()>0){
			 				sb.append("<tr style='color: #996633><td>");
			 				boolean  directory_store=false;
			 				if((userWeb.getPermission(store_table.getSecurityDirectory())& nds.security.Directory.READ )== nds.security.Directory.READ ){
									directory_store =true;
							}
			 				for(int m=0;m<li_store.size();m++){
			 					int temp=Tools.getInt(((List)li_store.get(m)).get(0),-1);
			 					if(temp==Tools.getInt(instanceId,0)){
					 					if(directory_store){
					 						sb.append(Tools.getInt(((List)li_store.get(m)).get(1),0)).append("</td></tr>");
					 					}else{
					 						if(Tools.getInt(((List)li_store.get(m)).get(1),0)>0){
					 						 sb.append(mh.getMessage(event.getLocale(), "enough_goods")).append("</td></tr>");
					 						}else{
					 							sb.append(mh.getMessage(event.getLocale(), "lack_goods")).append("</td></tr>");
					 						}
					 					}
					 					flag_store =true;
					 					break;
			 				  	}
			 				}
			 			}
			 			if(!flag_store){
			 					sb.append("0").append("</td></tr>");
			 			}
		 			}
		 			if(flagdest){
			 			if(li_dest.size()>0){
			 				sb.append("<tr style='color:#339966'><td>");
			 				boolean  directory_dest=false;
			 				if((userWeb.getPermission(dest_table.getSecurityDirectory())& nds.security.Directory.READ )== nds.security.Directory.READ ){
								directory_dest =true;
							}
			 				for(int m=0;m<li_dest.size();m++){
			 					int temp=Tools.getInt(((List)li_dest.get(m)).get(0),-1);
			 					if(temp==Tools.getInt(instanceId,0)){
					 					if(directory_dest){
					 						sb.append(Tools.getInt(((List)li_store.get(m)).get(1),0)).append("</td></tr>");
					 					}else{
					 						if(Tools.getInt(((List)li_store.get(m)).get(1),0)>0){
					 						 	sb.append(mh.getMessage(event.getLocale(), "enough_goods")).append("</td></tr>");
					 						}else{
					 							sb.append(mh.getMessage(event.getLocale(), "lack_goods")).append("</td></tr>");
					 						}
					 					}
					 					flag_dest =true;
					 					break;
			 				  	}
			 				}
			 			}
			 			if(!flag_dest){
			 					sb.append("0").append("</td></tr>");
			 			}
		 			}
		 			sb.append("</table></td>");
		 			sb.append("<td id='tot_");
	 				sb.append(j);
	 				sb.append("' align='center' valign='top'></td>");
	 				sb.append("</tr>");
	 			inputCount++;
	 		}
	 	}
 	}
	sb.append("</table>");
	instances.put("inputCount", new Integer(inputCount));
 	return sb;
 }
%>
<%
try{
/*
  Create json object for all attributes selected with input number 
  
  @param table - table id ,which contains columns: m_attributesetinstance_id,m_product_id
  @param pdtid    - product id
  @param asid - attribute set id of that product
*/
TableManager manager=TableManager.getInstance();
Table table = manager.getTable(Tools.getInt(request.getParameter("table"),-1));
if (!table.isActionEnabled(Table.ADD) ||( (table.getColumn("m_product_id")==null && !table.getName().equalsIgnoreCase("m_product")) 
				|| table.getColumn("m_attributesetinstance_id")==null)) throw new NDSException("@no-permission@");
if((userWeb.getPermission(table.getSecurityDirectory())& nds.security.Directory.WRITE )!= nds.security.Directory.WRITE ){
	out.print(PortletUtils.getMessage(pageContext, "no-permission",null));
	return;
}
int productId=Tools.getInt(request.getParameter("pdtid"),-1);
int setId=Tools.getInt(request.getParameter("asid"),-1);
int store_colId=Tools.getInt(request.getParameter("store_colId"),-1);
String storedata=(String)request.getParameter("storedata");
int dest_colId=Tools.getInt(request.getParameter("dest_colId"),-1);
String destdata=(String)request.getParameter("destdata");
Column store_col =manager.getColumn(store_colId);
Column dest_col =manager.getColumn(dest_colId);
boolean flagstore =false;
boolean flagdest =false;
Table store_table =null;
Table dest_table =null;
String attribueSetName=(String) QueryEngine.getInstance().doQueryOne("select name from m_attributeset where id="+ setId);
List attributes=QueryEngine.getInstance().doQueryList("select a.id, a.name from m_attribute a, m_attributeuse u where a.isactive='Y' and a.ATTRIBUTEVALUETYPE='L' and a.id=u.m_attribute_id and u.m_attributeset_id="+setId+" order by u.orderno asc");
if(attributes.size()<1) throw new NDSException("Not find List type attribute in set id="+ setId);

/**
* Should we check product alias table records to confirm that attribute set instance is suit for specifiec product
  This is mainly useful for fashion industry, in which all products share the same attribute set.
*/
Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
boolean checkAliasTableForAttributeSetInstanceExistance="true".equalsIgnoreCase(conf.getProperty("product.check_alias_table_for_attribute_instance","true"));
String checkAliasTableForAttributeSetInstanceExistanceStr="";

if(checkAliasTableForAttributeSetInstanceExistance){
	checkAliasTableForAttributeSetInstanceExistanceStr=" and exists(select 1 from m_product_alias a where a.isactive='Y' and a.m_product_id="+productId+" and a.M_ATTRIBUTESETINSTANCE_ID=si.id)";
}

List attributeValues=new ArrayList(); //elements are List, whose elements are List with 2 elements, first is id, second is desc
for(int i=0;i< attributes.size();i++){
	Object aid=((List)attributes.get(i)).get(0);
	String sql="select v.id, case when v.name=v.value then v.name else  v.name||'(' || v.value ||')' end "+
									"from m_attributevalue v where v.isactive='Y' and v.m_attribute_id="+aid ;
	if(checkAliasTableForAttributeSetInstanceExistance){
		sql+=" and exists(select 1 from m_product_alias a, m_attributeinstance si,m_attributesetinstance asi "+
		"where a.isactive='Y' and a.m_product_id="+productId+" and asi.id=a.M_ATTRIBUTESETINSTANCE_ID  and asi.M_ATTRIBUTESET_ID="+ setId+
		" and a.M_ATTRIBUTESETINSTANCE_ID=si.M_ATTRIBUTESETINSTANCE_ID and si.M_ATTRIBUTEVALUE_ID=v.id and si.M_ATTRIBUTE_ID="+ aid +")";
	}
	sql +=" order by v.value asc";
	attributeValues.add( QueryEngine.getInstance().doQueryList(sql));
}


List attributeInstances=QueryEngine.getInstance().doQueryList(
"select distinct si.id, ai.m_attributevalue_id, u.orderno from m_attributesetinstance si , m_attributeinstance ai, m_attributeuse u "+
"where si.isactive='Y' and ai.isactive='Y' and ai.m_attributesetinstance_id= si.id and u.m_attributeset_id= si.m_attributeset_id and u.m_attribute_id= ai.m_attribute_id "+
"and si.lot is null and si.serno is null and si.GUARANTEEDATE is null "+
"and si.m_attributeset_id="+setId+checkAliasTableForAttributeSetInstanceExistanceStr+" order by si.id, u.orderno");

HashMap instances=new HashMap();// key:instanceid, value  _valueid1_valueid2
Integer key; StringBuffer sb;
if(attributeInstances!=null)for(int i=0;i<attributeInstances.size();i++){
	key= new Integer(Tools.getInt( ((List)attributeInstances.get(i)).get(0),-1));
	sb=(StringBuffer)instances.get(key);
	if(sb==null){
		sb=new StringBuffer("_");
		sb.append(((List)attributeInstances.get(i)).get(1));
		instances.put(key, sb);
	}else{
		sb.append("_").append(((List)attributeInstances.get(i)).get(1));
	}
}
HashMap instances2=new HashMap();// value:instanceid, key  _valueid1_valueid2
for(Iterator it= instances.keySet().iterator();it.hasNext();){
	key=(Integer) it.next();
	instances2.put(instances.get(key).toString(),key);
}
instances2.put("inputCount", new Integer(0));// this will be updated when recursing instances

ArrayList inputList=new ArrayList();
prepareAttributeTable(instances2,0,attributes,attributeValues,"", inputList);
List li_store=QueryEngine.getInstance().doQueryList("select t.m_attributesetinstance_id,t.qty from fa_storage t  where t.C_STORE_ID=(select d.id from c_store d where d.name='"+storedata+"') and t.m_product_id="+productId);
List li_dest=QueryEngine.getInstance().doQueryList("select t.m_attributesetinstance_id,t.qty from fa_storage t  where t.C_STORE_ID=(select d.id from c_store d where d.name='"+destdata+"') and t.m_product_id="+productId);
%>
<div id="itemdetail_div">
<table cellpadding="5" cellspacing="0" border="0" width="100%"  style="margin-top: 5px;">	
<tr><td><%= PortletUtils.getMessage(pageContext, "bg-batch-value",null)%>:
<input type="text" id="itemdetail_defaultvalue" value="" size="10"> &nbsp;
<span style="display:none"><input type="checkbox" id="itemdetail_notnull" value="1"></span><!--<%= PortletUtils.getMessage(pageContext, "do-not-create-record-for-null",null)%>-->
<input class="command2_button" type="button" name="clearinstances" value="<%=PortletUtils.getMessage(pageContext, "clear-all",null)%>(K)" onclick="gc.clearItemDetailInputs()" accessKey="K" >&nbsp;&nbsp;<%= PortletUtils.getMessage(pageContext, "dispatcher_storage",null)%>&nbsp;&nbsp;&nbsp;&nbsp;
<%
	if(store_col!=null){
		store_table =store_col.getReferenceTable();
		flagstore=true;
%>
<span style="color: #996633"><%=store_col.getDescription(locale)%>:<%=storedata%></span>&nbsp; &nbsp;
<%}%>
<%
	if(dest_col!=null){
		dest_table=dest_col.getReferenceTable();
		flagdest=true;
%>
<span style="color:#339966"><%=dest_col.getDescription(locale)%>:<%=destdata%></span>
<%}%>
</td></tr>
<tr><td><%= PortletUtils.getMessage(pageContext, "input-value-for-each-attribute",null)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= PortletUtils.getMessage(pageContext, "all_total",null)%>:<span id="tot_product"></span></td></tr>
<tr><td>
<form id="itemdetail_form">
<div style="width:790px; height:360px;overflow-y: auto; overflow-x: auto; border-width:thin;border-style:groove;border-color:#CCCCCC;padding:0px"> 
<%=getAttributeTable(instances2,0,attributes,attributeValues,"",inputList,li_store,li_dest,flagstore,flagdest,store_table,dest_table,userWeb)%>
</div>
</form>
</td></tr>
<tr><td>
<input class="command2_button" type="button" name="createinstances" value="<%=PortletUtils.getMessage(pageContext, "object.save",null)%>(J)" onclick="gc.saveItemDetail()" accessKey="J" >
<input class="command2_button" type="button" name="cancel" value="<%=PortletUtils.getMessage(pageContext, "cancel",null)%>(Q)" onclick="Alerts.killAlert(this)" accessKey="Q" >
</td></tr>
</table>
</div>
<%}catch(Throwable t){
	logger.error("/html/nds/pdt/itemdetail.jsp", t);
	out.print(PortletUtils.getMessage(pageContext, "exception",null)+":"+ t.getMessage());
}%>

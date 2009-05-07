<%@page errorPage="/html/nds/error.jsp"%>
<%@ page import="org.json.*"%>
<%!
/**
 Allow switch view in list scroll page
*/
private static boolean listEditable=Tools.getYesNo(((Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS)).getProperty("list.editable","Y"),true);
%>

<%
 /**
	 List table, how query page and list box, param
	 	1. table -- table id or name
 */
String tn= request.getParameter("categroy");

String 
 
TableCategory tablecategory
int tablecategoryId=nds.util.Tools.getInt(tn,-1);
if(tablecategoryId==-1){
	tablecategory=TableManager.getInstance().getTableCategories(tn);
	tablecategoryId= table.getId();
}else{
	tablecategory= TableManager.getInstance().getTableCategories(tablecategoryId);
}
List params= QueryEngine.getInstance().doQueryList("select * from AD_TABLECATEGORY  where id="+userid+" and module='ad_option'");


%>
<tree>






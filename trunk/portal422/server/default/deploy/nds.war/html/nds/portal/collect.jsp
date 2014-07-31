<%@page errorPage="/html/nds/error.jsp"%>

<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%    /**
     * @param 
      		id - tablecategory.id	
     */
     
int tablecategoryId=  ParamUtils.getIntAttributeOrParameter(request, "id", -1);
String onlyfa=  ParamUtils.getAttributeOrParameter(request, "onlyfa");
String NDS_PATH=nds.util.WebKeys.NDS_URI;
UserWebImpl userWeb =null;
try{
	userWeb= ((UserWebImpl)WebUtils.getSessionContextManager(session).getActor(nds.util.WebKeys.USER));	
}catch(Exception userWebException){
	//System.out.println("########## found userWeb=null##########"+userWebException);
}
Configurations conf= (Configurations)WebUtils.getServletContextManager().getActor( nds.util.WebKeys.CONFIGURATIONS);
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
//get WEBaction 传入参数环境
HashMap actionEnv = new HashMap();
actionEnv.put("httpservletrequest", request);
actionEnv.put("userweb", userWeb);

List categoryChildren=ssv.getChildrenOfTableCategorybymenu(request,tablecategoryId,true/*include webaction*/ );
Locale locale =userWeb.getLocale();
int tableId,fa_tableId;
Table table;
List mu_favorites=ssv.getSubSystemsOfmufavorite(request);
String url,cdesc,tdesc,tabout,fa_tdesc;
String famus = new String();
List favs=null;

if(mu_favorites.size()>0){
	for(int j=0;j<mu_favorites.size();j++){
		favs=(List)mu_favorites.get(j);
		String	fa_menu=(String)favs.get(0);
		String	fa_muac=(String)favs.get(1);
		String	fa_rpt=(String)favs.get(2);
		Object	fa_tab=favs.get(3);
		String fa_tabimg = new String();
		if(fa_rpt.equals("Y"))fa_tabimg="<img src='/html/nds/images/cxtab.gif' style='height:16px;width:20px;'/>";

		if(fa_tab instanceof Table){
			fa_tableId =((Table)fa_tab).getId(); 
			fa_tdesc=((Table)fa_tab).getDescription(locale);
			famus=famus+"<div class=\"accordion_headings\">"+fa_tabimg+"<input type=\"checkbox\" value=\""+fa_tableId+"\" class=\"fa_mu\"/><a onclick=\""+fa_muac+"\">>"+StringUtils.escapeForXML(fa_tdesc)+"</a></div>";
		}	
	}	
}

String tabout1 ="<div><h3 class=\"ui-accordion-first\"><a style=\"font-size: larger;\">我的收藏夹</a><a class=\"select_all\" href=\"javascript:mu.del_select_mufavorite();\"></a></h3><div id=\"mu_favorite\">"+famus+"</div></div>";
out.print("<div id=\"tab_accordion\">"+tabout1+"</div>");
%>

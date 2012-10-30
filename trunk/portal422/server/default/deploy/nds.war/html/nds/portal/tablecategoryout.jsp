<?xml version="1.0"?>
<%@page errorPage="/html/nds/error.jsp"%>

<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*"%>

<%    /**
     * @param 
      		id - tablecategory.id	
     */
     
int tablecategoryId=  ParamUtils.getIntAttributeOrParameter(request, "id", -1);

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
Table table,fa_table;
List mu_favorites=ssv.getSubSystemsOfmufavorite(request);
String url,cdesc,tdesc,tabout,fa_tdesc;
String famus = new String();

if(mu_favorites.size()>0){
System.out.println("mu_favorites     "+mu_favorites.size());
for(int j=0;j<mu_favorites.size();j++){
List favs=(List)mu_favorites.get(j);
String	fa_menu=(String)favs.get(0);
List fa_tab=(List)favs.get(2);

for(int e=0;e<fa_tab.size();e++){
   //System.out.println(fa_tab.size());
	String fa_tabimg = new String();
	if(fa_tab.get(e)  instanceof Table){
		fa_table=(Table)fa_tab.get(e);
		fa_tableId =fa_table.getId(); 
		fa_tdesc=fa_table.getDescription(locale);
		famus=famus+"<div class=\"accordion_headings\" onclick=\"javascript:pc.navigate('"+fa_tableId+"')\">"+fa_tabimg+"<a class=\"fa_mu\" href=\"javascript:mu.del_mufavorite('"+fa_tableId+"');\">"+fa_tableId+"</a><a>"+StringUtils.escapeForXML(fa_tdesc)+"</a></div>";
					}
					
			}
				//System.out.println(famus);
	}
}


//String tabout = new String();
TableManager manager=TableManager.getInstance();
TableCategory tc= manager.getTableCategory(tablecategoryId);
//System.out.println(tc.getName());
//String tabout1 = new String();
String tabout1 ="<div><h3><a>我的收藏夹</a></h3><div id=\"mu_favorite\">"+famus+"</div></div>";
for(int j=0;j<categoryChildren.size();j++){
List als=(List)categoryChildren.get(j);
String	ACCORDION_name=(String)als.get(0);
//System.out.println(ACCORDION_name);
List tab=(List)als.get(1);
//System.out.println(tab.size());
//String higthp=String.valueOf((tab.size()+1)*23);
String Inable = new String();
String Inaction = new String();

for(int e=0;e<tab.size();e++){
	String tabimg = new String();
	if(tab.get(e)  instanceof Table){
		table=(Table)tab.get(e);
		tableId =table.getId(); 
		tdesc=table.getDescription(locale);
		if(table.getAccordico()!=null){
			//tabimg="<img src=\""+table.getAccordico()+"\" style=\"height:16px;width:20px;\">";
			tabimg="<img src=\""+StringUtils.escapeForXML(table.getAccordico())+"\" style=\"height:16px;width:20px;\"></img>";
			}
		Inable=Inable+"<div class=\"accordion_headings\" onclick=\"javascript:pc.navigate('"+tableId+"')\">"+tabimg+"<a>"+StringUtils.escapeForXML(tdesc)+"</a></div>";
		//System.out.println(Inable);
  }else if(tab.get(e)  instanceof WebAction){
  	/*
			WebAction action=(WebAction)tab.get(e);
			WebAction.ActionTypeEnum ate= action.getActionType();
			WebAction.DisplayTypeEnum dst=action.getDisplayType();
			if(ate.equals(WebAction.ActionTypeEnum.JavaScript)&&dst.equals(WebAction.DisplayTypeEnum.TreeNode)){
			System.out.println("sdfsdfsdfdsf");
			Inable=Inable+"<div class=\"accordion_headings\" onclick=\""+action.getScript()+"\"><a>"+StringUtils.escapeForXML(action.getDescription())+"</a></div>";
		}
		*/
		//扩展webaction treenode 支持 outlook 方式
		WebAction action=(WebAction)tab.get(e);
		Inaction=Inaction+action.toHTML(locale,actionEnv);
		
	}
}
//自适应调整OUTLOOK 菜单高度

System.out.println(Inable);

if(tab.size()>=12&&Inable!=null){
	tabout="<div><h3><a>"+ACCORDION_name+"</a></h3><div style=\"height:300px;max-height:269px\">"+Inable+"</div></div>";
	}else if(Inable != null && Inable.length() != 0){
  tabout="<div><h3><a>"+ACCORDION_name+"</a></h3><div>"+Inable+"</div></div>";
	}else{
	tabout=" ";
	}
System.out.println(tabout);
 /*
tabout="<div><h3><a>"+ACCORDION_name+"</a></h3><div>"+Inable+"</div></div>";
*/
tabout1=tabout1+tabout+Inaction;
}
//System.out.println(tabout1);
out.print("<div id=\"tab_accordion\">"+tabout1+"</div>");
%>

<?xml version="1.0"?>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ page contentType="text/xml;charset=UTF-8"%>
<%@ page import="java.sql.ResultSet,java.sql.Connection,java.sql.PreparedStatement,nds.query.web.*,nds.control.web.*,nds.util.*,nds.schema.*,nds.query.*, java.io.*,java.util.*,nds.control.util.*,nds.portlet.util.*,nds.report.*,nds.web.bean.*,nds.model.*, nds.model.dao.*,org.json.JSONObject"%>
<%
/**
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
List mu_favorites=new ArrayList();//ssv.getSubSystemsOfmufavorite(request);
String url,cdesc,tdesc,tabout,fa_tdesc;
String famus = new String();
//System.out.print(mu_favorites.size());
if(mu_favorites.size()>0){
//System.out.println("mu_favorites     "+mu_favorites.size());
for(int j=0;j<mu_favorites.size();j++){
List favs=(List)mu_favorites.get(j);
String	fa_menu=(String)favs.get(0);
String	fa_muac=(String)favs.get(1);
String	fa_rpt=(String)favs.get(2);
Object	fa_tab=favs.get(3);
String fa_tabimg = new String();
if(fa_rpt.equals("Y"))fa_tabimg="<img src='/html/nds/images/cxtab.gif' style='height:16px;width:20px;'/>";

if(fa_tab instanceof Table){
		fa_tableId =((Table)fa_tab).getId(); 
		fa_tdesc=((Table)fa_tab).getDescription(locale);
		famus=famus+"<div class=\"accordion_headings\" onclick=\""+fa_muac+"\">"+fa_tabimg+"<a class=\"fa_mu\" href=\"javascript:mu.del_mufavorite('"+fa_tableId+"');\">"+fa_tableId+"</a><a>"+StringUtils.escapeForXML(fa_tdesc)+"</a></div>";
	  			}	
			}	
}
//System.out.println(famus);
//String tabout = new String();
TableManager manager=TableManager.getInstance();
TableCategory tc= manager.getTableCategory(tablecategoryId);
//System.out.println(tc.getName());
String tabout1 = new String();
if(mu_favorites.size()>0){
tabout1 ="<div><h3 class=\"ui-accordion-first\"><a style=\"color:white;\">我的收藏夹</a></h3><div id=\"mu_favorite\">"+famus+"</div></div>";
}
for(int j=0;j<categoryChildren.size();j++){
List als=(List)categoryChildren.get(j);
String	ACCORDION_name=(String)als.get(0);
String	ACCORDION_CLS_STRING=(String)als.get(2);

//System.out.println(ACCORDION_name);
List tab=(List)als.get(1);
//System.out.println(tab.size());
//String higthp=String.valueOf((tab.size()+1)*23);
String Inable = new String();
String Inaction = new String();
WebAction action=null;

/**
ACCORDION_CLS_STRING格式有两种
1.字符串，默认为折叠菜单分类的样式
2.json格式字符串，{"accordion_cls":"折叠菜单样式","href":""} 只显示折叠菜单
accordion_cls:折叠菜单样式
single:只显示折叠菜单，子菜单全部删除
href：折叠菜单的动作
**/
String ACCORDION_CLS = "";
String HIDE_UL = "";
String ACTION_HREF = "";

ACCORDION_CLS = ACCORDION_CLS.equals("") ? "fa-system fa-color-red":ACCORDION_CLS;
try {
	JSONObject json = new JSONObject(ACCORDION_CLS_STRING);
	ACCORDION_CLS = (String) json.opt("accordion_cls");
	ACTION_HREF = "onclick=\""+(String) json.opt("href")+"\"";
	HIDE_UL  = "hide-ul";
} catch (Exception e) {
	ACCORDION_CLS = ACCORDION_CLS_STRING.equals("") ? "fa-system fa-color-red":ACCORDION_CLS_STRING;
}

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
		Inable=Inable+"<li>"+
				"<a href=\"javascript:void(0);\" onclick=\"javascript:pc.navigate('"+tableId+"','null',this)\">"+tabimg+
					"<i class=\"fa fa-angle-right\"><b></b></i>"+
					"<span>"+StringUtils.escapeForXML(tdesc)+"</span>"+
				"</a>"+
			"</li>";
  }else if(tab.get(e)  instanceof WebAction){
  	  
			action=(WebAction)tab.get(e);
			//System.out.println(action.getName());
			WebAction.ActionTypeEnum ate= action.getActionType();
			WebAction.DisplayTypeEnum dst=action.getDisplayType();
			if(ate.equals(WebAction.ActionTypeEnum.JavaScript)&&dst.equals(WebAction.DisplayTypeEnum.Accord)){
			Inable=Inable+"<li>"+
				"<a href=\"javascript:void(0);\" onclick=\""+action.getScript()+"\">"+
					"<i class=\"fa fa-angle-right\"><b></b></i>"+
					"<span>"+StringUtils.escapeForXML(action.getDescription())+"</span>"+
				"</a>"+
			"</li>";
		}else{
		//扩展webaction treenode 支持 outlook 方式
		  action=(WebAction)tab.get(e);
		//System.out.println(action.getName());
		//System.out.println(action.getActionType());
			Inaction=Inaction+action.toHTML(locale,actionEnv);
		}
	}
}
//自适应调整OUTLOOK 菜单高度

//System.out.println(Inable);
//height:300px;
//如果只显示折叠菜单 则不显示子菜单
if(HIDE_UL.equals("hide-ul")){
Inable = " ";
}
if(tab.size()>=12&&Inable!=null){
	tabout="<li>"+
		"<a href=\"javascript:void(0);\" "+ACTION_HREF+">"+
			"<i class=\"fa icon "+ACCORDION_CLS+"\">"+
				"<b></b><b></b>"+
			"</i>"+
			"<span class=\"pull-right fa-angle-down "+HIDE_UL+"\">"+
			"</span>"+
			"<span>"+ACCORDION_name+"</span>"+
		"</a>"+
		"<ul class=\"nav lt "+HIDE_UL+"\" style=\"max-height:500px\">"+							   
			Inable+
		"</ul>"+
	"</li>";
	}else if(Inable != null && Inable.length() != 0){
	tabout="<li>"+
		"<a href=\"javascript:void(0);\" "+ACTION_HREF+">"+
			"<i class=\"fa icon "+ACCORDION_CLS+"\">"+
				"<b></b><b></b>"+
			"</i>"+
			"<span class=\"pull-right fa-angle-down "+HIDE_UL+"\">"+
			"</span>"+
			"<span>"+ACCORDION_name+"</span>"+
		"</a>"+
		"<ul class=\"nav lt "+HIDE_UL+"\">"+							   
			Inable+
		"</ul>"+
	"</li>";
	}else{
	tabout=" ";
	}
//System.out.println(tabout);
 /*
tabout="<div><h3><a>"+ACCORDION_name+"</a></h3><div>"+Inable+"</div></div>";
*/
if(onlyfa==null){
tabout1=tabout1+tabout+Inaction;
}
}
//System.out.println(tabout1);
out.print("<aside class=\"bg-light aside-md\">"+
	"<section class=\"vbox\">"+
		"<section class=\"w-f scrollable\">"+
				"<nav class=\"nav-primary\">"+
					"<ul class=\"nav\" id=\"nav\">"+
						tabout1+
					"</ul>"+
				"</nav>"+
		"</section>"+
		"<footer class=\"footer lt hidden-xs b-t b-light\">"+
			"<a class=\"pull-right btn btn-sm btn-default btn-icon\" onclick=\"pc.menu_switch()\">"+
			"</a>"+
			"<div class=\"copyright hidden-nav-xs\">"+
				"Copyright © burgeon"+
			"</div>"+
		"</footer>"+
	"</section>"+
"</aside>");
%>

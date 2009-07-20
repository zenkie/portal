<%
/**
Navigation bar
 */

TableManager manager=TableManager.getInstance();
nds.query.web.CreatePortal portalMachine = new nds.query.web.CreatePortal();
portalMachine.setPreTableDescText("");
portalMachine.setCategoryTableIndent(false);
portalMachine.setCategoryAttributeTexts("class='beta'");
portalMachine.setHrefAttributesText("class='gamma'");
String targetPage="opw";
String name;
nds.query.web.SubSystemView ssv=new nds.query.web.SubSystemView();
List rtm=null;
// elements: Vector ( 3 elements: categoryId(Integer),  table vector ( of that category),
// and vector size ( of that category to be row count in category table, may eliminate some tables
//        such as item or ftp tables)
//Vector sortedTables = portalMachine.sortTables(portalMachine.getTableCategories(request));
//List subsystems =manager.getSubSystems();
List subsystems =ssv.getSubSystems(request);
SubSystem subSystem;
//portalMachine.preparePortalHTML(request,targetPage,4);
	
Integer categoryId,subSystemId;
String subSystemDesc;
org.json.JSONArray menuObjs=new org.json.JSONArray();
org.json.JSONArray tables=new org.json.JSONArray();
org.json.JSONObject tb;
org.json.JSONObject jc;

int tabId= Integer.MAX_VALUE-1;

String homeByJSP=conf.getProperty("home.jsp","true");
if("true".equalsIgnoreCase(homeByJSP)){
	jc=new org.json.JSONObject();
	jc.put("id", 0);
	jc.put("desc",PortletUtils.getMessage(pageContext, "navitab",null));
	jc.put("url", "home.jsp");
	menuObjs.put(jc);
}
for (int i=0; i< subsystems.size(); i++){   
     subSystem=(SubSystem)subsystems.get(i);        
     subSystemId=subSystem.getId();
     subSystemDesc=subSystem.getDescription(locale);
     jc=new org.json.JSONObject();
     jc=new org.json.JSONObject();
     jc.put("id", subSystemId);
	 jc.put("desc", subSystemDesc);
	 jc.put("url","subsystem.jsp?id="+subSystemId); 
	 menuObjs.put(jc);
} 

 
jc=new org.json.JSONObject();
jc.put("id",  tabId--);
jc.put("desc",PortletUtils.getMessage(pageContext, "report-center",null));
jc.put("url", "/html/nds/cxtab/rpthome.jsp");
menuObjs.put(jc);
%>
<div id="page-nav-container"></div>
<script>
	var gMenuObjects=<%=menuObjs.toString()%>;
</script>


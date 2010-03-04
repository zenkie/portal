<%
/**
Navigation bar, when subSystem specified, will list categories as menu 
 */
String name;
List rtm=null;
// elements: Vector ( 3 elements: categoryId(Integer),  table vector ( of that category),
// and vector size ( of that category to be row count in category table, may eliminate some tables
//        such as item or ftp tables)
//Vector sortedTables = portalMachine.sortTables(portalMachine.getTableCategories(request));
//List subsystems =manager.getSubSystems();
SubSystem subSystem;
	
Integer categoryId,subSystemId;
String subSystemDesc;
org.json.JSONArray menuObjs=new org.json.JSONArray();
org.json.JSONArray tables=new org.json.JSONArray();
org.json.JSONObject tb;
org.json.JSONObject jc;

int tabId= Integer.MAX_VALUE-1;
boolean hasOnlyActions=true;//not show reports if has only actions in subsystem
if(ssId==-1){
	List subsystems =ssv.getSubSystems(request);
	// list all subsystems, for backward compatibility
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
	hasOnlyActions=false;
}else{
	// list table categories as menu
	
	List cats =ssv.getTableCategories(request,ssId);
	for (int i=0; i< cats.size(); i++){   
	     List child=(List)cats.get(i);
	     Object o =child.get(0);
	     if(o instanceof TableCategory){
	     	 TableCategory tc=(TableCategory)o;
		     jc=new org.json.JSONObject();
		     jc.put("id", tc.getId());
			 jc.put("desc", tc.getName());
			 jc.put("url","tablecategory.jsp?id="+tc.getId()); 
			 menuObjs.put(jc);
			 hasOnlyActions=false;
	     }else if(o instanceof WebAction){
			WebAction wa=(WebAction)o;
			jc=new org.json.JSONObject();
		     jc.put("id", "_"+wa.getId());//nerver equals to Tablecategory
			 jc.put("desc", wa.getDescription());
			 jc.put("url","webaction.jsp?id="+wa.getId()); 
			 menuObjs.put(jc);     	
	     }else{
	     	throw new Error("Unsupported type in ssv:"+ o.getClass());	
	     }
	}
	if(!hasOnlyActions){
		jc=new org.json.JSONObject();
		jc.put("id",  tabId--);
		jc.put("desc",PortletUtils.getMessage(pageContext, "report-center",null));
		jc.put("url", "/html/nds/cxtab/rpthome.jsp");
		menuObjs.put(jc);
	}

}	
%>
<div id="page-nav-container"></div>
<script>
	var gMenuObjects=<%=menuObjs.toString()%>;
</script>


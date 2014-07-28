<%@ page pageEncoding="utf-8"%>
<%
/** -- add support for webaction of tab buttons --**/
  Connection actionEnvConnection=null;
  List<WebAction> waTabButtons=new ArrayList<WebAction>();
  HashMap actionEnv=new HashMap();
  try{
  	actionEnvConnection=QueryEngine.getInstance().getConnection();
	actionEnv.put("httpservletrequest", request);
	actionEnv.put("userweb", userWeb);
	actionEnv.put("connection", actionEnvConnection);
	//special env data for TabButton display check
	actionEnv.put("objectid", masterId);
	actionEnv.put("maintable", masterTable.getName());
		
  	List<WebAction> was=table.getWebActions(WebAction.DisplayTypeEnum.TabButton);
  	for(int wasi=0;wasi<was.size();wasi++){
  		WebAction wa=was.get(wasi);
  		if(wa.canDisplay(actionEnv)){
  			waTabButtons.add(wa);
  		}
  	}
  }finally{
  	if(actionEnvConnection!=null)try{actionEnvConnection.close();}catch(Throwable ace){}
  }
for(int wasi=0;wasi<waTabButtons.size();wasi++){
	out.println(waTabButtons.get(wasi).toHTML(locale,actionEnv));
}
if(table.isActionEnabled(Table.DELETE)){
	ButtonFactory commandFactory= ButtonFactory.getInstance(pageContext,locale);
	%>
	<td>&nbsp;<input class="cbutton" type="button" name="DeleteLine" accesskey="E" title="标记删除，需点击页面顶端的保存按钮完成服务器端的删除" onclick="javascript:doDeleteLine();" value="删除选中行"></td>
<%}%>
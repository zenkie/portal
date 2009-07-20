<%
validCommands.clear();
if((canModify||canDelete||canSubmit)&& isWriteEnabled && hasWritePermission){
	if(object_page_url.indexOf("input=false")>0){
		modifyPageUrl=StringUtils.replace(object_page_url,"input=false","input=true");
	}else
		modifyPageUrl=object_page_url + "&input=true";

	validCommands.add( commandFactory.newButtonInstance("GoModifyPage", 
		PortletUtils.getMessage(pageContext, "object.gomodifypage",null),
		"oc.doGoModifyPage("+ tableId+","+ objectId+",'"+modifyPageUrl+"')"
		));
}
if(canSubmit){
	boolean shouldWarn=Tools.getYesNo(userWeb.getUserOption("WARN_ON_SUBMIT","Y"),true);
	validCommands.add( commandFactory.newButtonInstance("Submit", 
		PortletUtils.getMessage(pageContext, "object.submit",null),
		"oc.doSubmit("+ canModify +","+shouldWarn+")","G"
	));
	validCommands.add( commandFactory.newButtonInstance("SubmitPrint", 
		PortletUtils.getMessage(pageContext, "object.submitprint",null),
		"oc.doSubmitPrint("+ canModify +","+shouldWarn+")","H"
	));
	
}
//unsubmit support
if( table.isActionEnabled(Table.UNSUBMIT) && table.isActionEnabled(Table.SUBMIT) && status==2){
	// user should be the last modifier to do unsubmit
	if(table.getColumn("modifierid")!=null){
		int lastModifierId=Tools.getInt(QueryEngine.getInstance().doQueryOne("select modifierid from "+ table.getRealTableName()+" where id="+ objectId),-1);
		if(lastModifierId!=-1&& lastModifierId== userWeb.getUserId()){
			boolean shouldWarn=Tools.getYesNo(userWeb.getUserOption("WARN_ON_SUBMIT","Y"),true);
			validCommands.add( commandFactory.newButtonInstance("Unsubmit", 
				PortletUtils.getMessage(pageContext, "object.unsubmit",null),
				"oc.doUnsubmit("+shouldWarn+")","U"
			));
		}
	}
}
if(objectId!=-1){
    // get extended buttones
    validCommands.addAll(table.getExtendButtons(objectId, userWeb));
}
validCommands.add( commandFactory.newButtonInstance("Print", 
		PortletUtils.getMessage(pageContext, "object.print",null),
		"oc.doPrint("+ tableId+","+ objectId+")"
		));		
validCommands.add( commandFactory.newButtonInstance("Refresh", 
			PortletUtils.getMessage(pageContext, "object.refresh",null),
			"oc.doRefresh()","J"
			));	

%>
<%@ include file="inc_command.jsp" %>
<%
// these are list buttons of webaction
for(int wasi=0;wasi<waObjButtons.size();wasi++){
	out.print(waObjButtons.get(wasi).toHTML(locale));
}
%>

<%
validCommands.clear();
if( objectId == -1){
    if(canAdd){
 		validCommands.add( commandFactory.newButtonInstance("Create", 
			PortletUtils.getMessage(pageContext, "object.create",null),
			"oc.doCreate()", "S"
		));
    }
}else{
	if(canModify){
		validCommands.add( commandFactory.newButtonInstance("Modify", 
			PortletUtils.getMessage(pageContext, "object.modify",null),
			"oc.doModify()", "S"
		));
	}
	if(canDelete){
		validCommands.add( commandFactory.newButtonInstance("Delete", 
			PortletUtils.getMessage(pageContext, "object.delete",null),
			"oc.doDelete()","X"
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
	validCommands.addAll(table.getExtendButtons(objectId, userWeb));
	
	validCommands.add( commandFactory.newButtonInstance("Print", 
			PortletUtils.getMessage(pageContext, "object.print",null),
			"oc.doPrint()","P"
			));	
	validCommands.add( commandFactory.newButtonInstance("Refresh", 
			PortletUtils.getMessage(pageContext, "object.refresh",null),
			"oc.doRefresh()","J"
			));	
}
%>
<%@ include file="inc_command.jsp" %>
<%
// these are list buttons of webaction
for(int wasi=0;wasi<waObjButtons.size();wasi++){
	out.print(waObjButtons.get(wasi).toHTML(locale,actionEnv)); 
}
%>



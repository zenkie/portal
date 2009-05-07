<%
if( objectId == -1){
    if(canAdd){
 		validCommands.add( commandFactory.newButtonInstance("Create", 
			PortletUtils.getMessage(pageContext, "object.create",null),
			"oc.doCreate()", "S"
		));
		validCommands.add( commandFactory.newButtonInstance("Template", 
			PortletUtils.getMessage(pageContext, "object.template",null),
			"oc.doTemplate()", "T"
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
	if(canAdd){
    	validCommands.add( commandFactory.newButtonInstance("NewObject", 
			PortletUtils.getMessage(pageContext, "object.newobject",null),
			"oc.doNewObject()","N"
		));
    }	
	validCommands.add( commandFactory.newButtonInstance("CopyTo", 
			PortletUtils.getMessage(pageContext, "object.copyto",null),
			"oc.doCopyTo()","Y"
			));
	validCommands.add( commandFactory.newButtonInstance("Print", 
			PortletUtils.getMessage(pageContext, "object.print",null),
			"oc.doPrint()","P"
			));	
	validCommands.add( commandFactory.newButtonInstance("PrintSetting", 
			PortletUtils.getMessage(pageContext, "object.printsetting",null),
			"oc.doPrintSetting()","T"
			));	
	validCommands.add( commandFactory.newButtonInstance("Refresh", 
			PortletUtils.getMessage(pageContext, "object.refresh",null),
			"oc.doRefresh()","J"
			));	

	otherviews= Collections.EMPTY_LIST;
	//item table should not show other views
	if(manager.getParentTable(table)==null) otherviews=userWeb.constructViews(table,objectId);
	if(!otherviews.isEmpty()){
		if(otherviews.size()==1){
	 		validCommands.add( commandFactory.newButtonInstance("OtherViews", 
				PortletUtils.getMessage(pageContext, "object.otherviews",null),
				"oc.doShowObject("+ ((Table) otherviews.get(0)).getId()+")","W"
			));	
	 	}else{
	 		viewIdString="";
	 		for(int oi=0;oi<otherviews.size();oi++){
	  			viewIdString += ((Table)otherviews.get(oi)).getId()+"_";
	  		}
	  		validCommands.add( commandFactory.newButtonInstance("OtherViews", 
				PortletUtils.getMessage(pageContext, "object.otherviews",null),
				"oc.doSelectView('"+ viewIdString +"')","W"
			));	
	 	}
	}
}
%>
<%@ include file="inc_command.jsp" %>



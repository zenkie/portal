<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%!  /**
     * Encode sql to html valid string, will be put into <input> tag
     */
    private String encode(String sql){
        String s=  nds.util.StringUtils.replace(sql,"\"", "\\\"");
        return s;
    }
%>
<%
	/**
		return to filter object input box 	
		@param condition* - "NOT IN" | "IN" this is used in sql where clause
		@param type  - "a" for not replaceing environment attribute ($xxx$), and vice vesa.
	*/

QueryRequest query =(QueryRequest) request.getAttribute("query");
String condition=(String)request.getParameter("condition");
String type=(String)request.getParameter("type");
String fromtype=(String)request.getParameter("fromtype");
//System.out.print(fromtype);
//System.out.print("aaaaaaaa");
Expression paremExpr= query.getParamExpression();
String paramExpStr=(paremExpr==null?"":paremExpr.toHTMLInputElement());
//paramExpStr=userWeb.replaceVariables(paramExpStr);
//System.out.print(paramExpStr);
String desc="";
nds.schema.Filter fo=new nds.schema.Filter();
fo.setDescription(desc);
//System.out.print(type);
if("a".equals(type)||"a".equals(fromtype)){
	desc=query.getParamDesc(false);
	fo.setSql(condition+" ("+ encode(query.toPKIDSQL(false))+")");
	}else{
	//System.out.print("aaaaa");
	desc=query.getParamDesc(true);
	//System.out.print(desc);
	fo.setSql(condition+" ("+ encode(query.toPKIDSQL(true))+")");
	paramExpStr=userWeb.replaceVariables(paramExpStr);
}
//desc=userWeb.replaceVariables(query.getParamDesc(false));
//desc=query.getParamDesc(false);
//fo.setSql(condition+" ("+ encode(query.toPKIDSQL(false))+")");
fo.setExpression(paramExpStr);
//System.out.print(fo.getExpression());
%> 
oq.returnFilterObj("<%=encode(desc)%>", "<%=fo.toXML()%>");

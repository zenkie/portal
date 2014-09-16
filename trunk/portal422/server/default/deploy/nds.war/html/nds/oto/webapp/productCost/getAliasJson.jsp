<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.query.QueryEngine,nds.query.QueryException,nds.query.SPResult" %>
<%
int productid=nds.util.Tools.getInt(request.getParameter("id"),-1);

if (productid==-1) return;
ArrayList params=new ArrayList();
params.add(userWeb.getUserId());
params.add(productid);

ArrayList para=new ArrayList();
para.add(java.sql.Clob.class);
String resultStr=null;

	Collection list=QueryEngine.getInstance().executeFunction("wx_alias_$r_phonejson",params,para);
	resultStr=(String)list.iterator().next();

%>
<%=resultStr%>
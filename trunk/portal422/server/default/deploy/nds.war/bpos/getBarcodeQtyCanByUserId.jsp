<%@ page language="java" import="java.util.List,nds.query.QueryEngine,nds.util.Tools" pageEncoding="utf-8"%>
<%
String storeId=(String)session.getAttribute("storeId");
if(null==storeId)storeId=request.getParameter("storeid");
String barcode=request.getParameter("barcode");
String styles=request.getParameter("styles");
String flag=request.getParameter("flag_num");
try{
	if(styles!=null){																														//select  m.id,t.qtycan from  V_FA_STORAGE t ,m_product_alias m , m_product p where t.c_store_id=4005 and t.m_productalias_id=m.id and m.M_PRODUCT_ID = p.ID and p.NAME='AS001'	
		List qtyCans=QueryEngine.getInstance().doQueryList("select m.id,t.qtycan from  V_FA_STORAGE t ,m_product_alias m ,m_product p where t.c_store_id="+storeId+" and t.m_productalias_id=m.id and m.M_PRODUCT_ID=p.ID AND p.NAME='"+styles+"'");
%><%=qtyCans%><%
	}
	if(barcode!=null&&!flag.equals("1")){
		int qtyCan=-99999;
		qtyCan=Tools.getInt(QueryEngine.getInstance().doQueryOne("select t.qtycan from  V_FA_STORAGE t ,m_product_alias m where t.c_store_id="+storeId+" and t.m_productalias_id=m.id AND m.no='"+barcode+"'"),-99999);
	  %><%=qtyCan%><%
	}else if(barcode!=null&&flag.equals("1")){
  int qtyCan=-99999;
		qtyCan=Tools.getInt(QueryEngine.getInstance().doQueryOne("select sum(t.qtycan) from  V_FA_STORAGE t ,m_product m where t.c_store_id="+storeId+" and t.m_product_id=m.id AND m.name='"+barcode+"'"),-99999);
    %><%=qtyCan%><%
 }
}catch(Throwable t){}
%>
<%
PairTable legends= table.getLegends(Column.MASK_QUERY_LIST);//key:Column, value:Legend
if(legends!=null && legends.size()>0){%>
	<span class="f"><%=PortletUtils.getMessage(pageContext, "legend",null)%></span>&nbsp;
<%
	for(int lgidx=0;lgidx<legends.size();lgidx++){
		Column lgColumn=(Column) legends.getKey(lgidx);
		out.print("&nbsp;<span class='f'>--"+lgColumn.getDescription(locale)+"</span>");
		Legend lg=(Legend) legends.getValue(lgidx);
		for(int lgItemIdx=0;lgItemIdx< lg.size();lgItemIdx++){
			out.print("<span class='b "+lg.getItem(lgItemIdx).getStyle()+"'>"+ lg.getItem(lgItemIdx).getDescription()+"</span>");
		}
	}
}
%>

<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/calendar/init.jsp" %>

<%
Calendar cal = (Calendar)selCal.clone();
%>
<script>
function redirect(form) {
	view('year', 0,1, form.options[form.options.selectedIndex].value);
}
function updateCalendar(month, day, year) {
	view('day',month,day,year);
}
</script>

<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="center">
<form>
	<table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td><a class="gamma" href="javascript:view('year',0,1,<%= Integer.toString(selYear - 1) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_left.gif" width="11"></a></td>
				<td width="10">
					&nbsp;
				</td>
				<td>
					<select onChange="redirect(this);">

						<%
						for (int i = -10; i <= 10; i++) {
						%>

							<option <%= ((curYear - selYear + i) == 0) ? "selected" : "" %> value="<%= Integer.toString(curYear + i) %>"> <%= curYear + i %></option>

						<%
						}
						%>

					</select>
					
				</td>
				<td width="10">
					&nbsp;
				</td>
				<td><a class="gamma" href="javascript:view('year',0,1,<%= Integer.toString(selYear + 1) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_right.gif" width="11"></a></td>
			</tr>
			</table>
		</td>
		<td align="right">
		</td>
	</tr>
	</table>

	<br>

	<table border="0" cellpadding="0" cellspacing="0" width="95%">

	<%
	for (int j = 0; j < 12; j++) {
		cal.set(Calendar.MONTH, j);
		cal.set(Calendar.DATE, 1);

		int month = cal.get(Calendar.MONTH);
		int year = cal.get(Calendar.YEAR);

		maxDayOfMonth = cal.getActualMaximum(Calendar.DATE);
	%>

		<c:if test="<%= (j == 0) || (j == 3) || (j == 6) || (j == 9) %>">
			<tr>
				<td valign="top">
		</c:if>

		<c:if test="<%= (j == 1) || (j == 2) || (j == 4) || (j == 5) || (j == 7) || (j == 8) || (j == 10) || (j == 11) %>">
			</td>
			<td width="20">
				&nbsp;
			</td>
			<td valign="top">
		</c:if>

		<script language="JavaScript">

			<%
			Set calendarData = new HashSet();

			for (int i = 1; i <= maxDayOfMonth; i++) {
				Calendar tempCal = (Calendar)selCal.clone();
				tempCal.set(Calendar.MONTH, month);
				tempCal.set(Calendar.DATE, i);
				tempCal.set(Calendar.YEAR, year);

				boolean hasEvents = nds.web.CalendarUtils.hasEvents(table,filter,userWeb, tempCal);

				if (hasEvents) {
					calendarData.add(new Integer(i));
				}
			}
			%>

		</script>

		<%
		request.setAttribute(WebKeys.CALENDAR_DATA, calendarData);
		%>

		<liferay-util:include page="/html/common/calendar.jsp">
			<liferay-util:param name="namespace" value="" />
			<liferay-util:param name="sel_month" value="<%= Integer.toString(month) %>" />
			<liferay-util:param name="sel_day" value="1" />
			<liferay-util:param name="sel_year" value="<%= Integer.toString(year) %>" />
			<liferay-util:param name="show_top_pattern" value="MMMM" />
			<liferay-util:param name="show_month_sel" value="false" />
		</liferay-util:include>

		<c:if test="<%= (j == 2) || (j == 5) || (j == 8) || (j == 11) %>">
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<br>
				</td>
			</tr>
		</c:if>

	<%
	}
	%>

	</table>
</form>
</td></tr></table>

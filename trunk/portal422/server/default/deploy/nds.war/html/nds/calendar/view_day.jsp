<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/calendar/init.jsp" %>

<%
Calendar cal = (Calendar)selCal.clone();
List events = nds.web.CalendarUtils.getEventsByDay(table,filter,userWeb, selCal);

DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.FULL, locale);
DateFormat timeFormat = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
%>

<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="center">

	<table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>

				<%
				cal.add(Calendar.DATE, -1);
				%>

				<td><a class="bg" href="javascript:view('day',<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_left.gif" width="11"></a></td>
				<td width="10">
					&nbsp;
				</td>

				<%
				cal.add(Calendar.DATE, 1);
				%>

				<td>
					<font class="bg" size="2">
					<b><%= dateFormat.format(Time.getDate(cal)) %></b>
					</font>
				</td>
				<td width="10">
					&nbsp;
				</td>

				<%
				cal.add(Calendar.DATE, 1);
				%>

				<td><a class="bg" href="javascript:view('day',<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_right.gif" width="11"></a></td>
			</tr>
			</table>
		</td>
		<td align="right">
		</td>
	</tr>
	</table>

	<br>

	<table border="0" cellpadding="4" cellspacing="0" width="95%">
	<tr class="beta">
		<td>
			<font class="beta" size="2"><b>
			<%= LanguageUtil.get(pageContext, "time") %>
			</b></font>
		</td>
		<td>
			<font class="beta" size="2"><b>
			<%= LanguageUtil.get(pageContext, "title") %>
			</b></font>
		</td>
		<td>
			<font class="beta" size="2"><b>
			
			</b></font>
		</td>
	</tr>

	<c:if test="<%= events.size() == 0 %>">
		<tr class="bg">
			<td align="center" colspan="3">
				<font class="bg" size="2"><%= LanguageUtil.get(pageContext, "there-are-no-events-on-this-day") %></font>
			</td>
		</tr>
	</c:if>

	<%
	for (int i = 0; i < events.size(); i++) {
		CalendarEvent event = (CalendarEvent)events.get(i);

		String className = "gamma";
		if (MathUtil.isEven(i)) {
			className += " bg";
		}

		Calendar startCal = null;
		startCal = new GregorianCalendar(timeZone, locale);
		startCal.setTime(event.getStartDate());

	%>

		<tr class="<%= className %>">
				<td nowrap>
					<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" nowrap>
							<font class="<%= className %>" size="2"><%= timeFormat.format(Time.getDate(event.getStartDate(), timeZone)) %></font>
						</td>
						<td align="right" nowrap>
							<font class="<%= className %>" size="2">&nbsp;&#150;&nbsp;</font>
						</td>
						<td align="right" nowrap>
							<font class="<%= className %>" size="2"><%= timeFormat.format(Time.getDate(event.getEndTime(), timeZone))%></font>
						</td>
					</tr>
					</table>
				</td>


			<td>
				<font class="<%= className %>" size="2"><a class="<%=event.getCssClass() %>" href="javascript:showObject(<%= event.id%>)"><%=  (event.shortDesc!=null?event.shortDesc:event.description)%></a></font>

			</td>
			<td>
			</td>
		</tr>

	<%
	}
	%>

	</table>
</td></tr></table>

<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/calendar/init.jsp" %>


<%
Calendar cal = (Calendar)selCal.clone();

DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.LONG, locale);
DateFormat dayOfWeekFormat = new SimpleDateFormat("EEE", locale);
DateFormat monthDateFormat = new SimpleDateFormat("M/d", locale);
DateFormat timeFormat = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
%>

<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="center">

	<table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>

				<%
				cal.add(Calendar.DATE, -7);
				%>

				<td><a class="bg" href="javascript:view('week',<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_left.gif" width="11"></a></td>
				<td width="10">
					&nbsp;
				</td>

				<%
				cal.add(Calendar.DATE, 7);
				%>

				<td>
					<font class="bg" size="2">
					<b><%= dateFormat.format(Time.getDate(cal)) %> -

					<%
					cal.add(Calendar.DATE, 6);
					%>

					<%= dateFormat.format(Time.getDate(cal)) %></b>
					</font>
				</td>
				<td width="10">
					&nbsp;
				</td>

				<%
				cal.add(Calendar.DATE, 1);
				%>

				<td><a class="bg" href="javascript:view('week',<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_right.gif" width="11"></a></td>
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
	cal = (Calendar)selCal.clone();

	for (int i = 0; i < 7; i++) {
	%>

		<tr>
			<td class="beta" colspan="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="10"></td>
		</tr>
		<tr>
			<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>

			<%
			String className = "gamma";
			if (cal.get(Calendar.MONTH) == curMonth && cal.get(Calendar.DATE) == curDay && cal.get(Calendar.YEAR) == curYear) {
				className = "beta";
			}
			%>

			<td class="<%= className %>" valign="top">
				<table border="0" cellpadding="8" cellspacing="0">
				<tr>
					<td>
						<font class="<%= className %>" size="2">
						<b><%= dayOfWeekFormat.format(Time.getDate(cal)) %></b><br>
						<a class="<%= className %>" href="javascript:view('day',<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><%= monthDateFormat.format(Time.getDate(cal)) %></a><br>
						</font>

						<c:if test="<%= editableEvents %>">
							<a class="<%= className %>" href="javascript:add(<%= Integer.toString(cal.get(Calendar.MONTH)) %>,<%= Integer.toString(cal.get(Calendar.DATE)) %>,<%= Integer.toString(cal.get(Calendar.YEAR)) %>)"><img border="0" height="9" hspace="0" src="<%= SKIN_COMMON_IMG %>/06_plus.gif" title="<%= LanguageUtil.get(pageContext, "add") %>" vspace="0" width="9"></a>
						</c:if>
					</td>
				</tr>
				</table>
			</td>
			<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			<td valign="top" width="99%">
				<table border="0" cellpadding="4" cellspacing="0" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="4" cellspacing="0" width="100%">

						<%
						List events = nds.web.CalendarUtils.getEventsByDay(table,filter,userWeb, cal);

						for (int j = 0; j < events.size(); j++) {
							CalendarEvent event = (CalendarEvent)events.get(j);

							className = "gamma";;

							if (MathUtil.isEven(j)) {
								className = "bg";
							}

						%>

							<tr class="<%= className %>">
								<td width="5">
									<img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5">
								</td>
								<td nowrap valign="top">
										<table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td align="right" nowrap>
												<font class="<%= className %>" size="1"><%= timeFormat.format(Time.getDate(event.getStartDate(), timeZone)) %></font>
											</td>
											<td align="right" nowrap>
												<font class="<%= className %>" size="1">&nbsp;&#150;&nbsp;</font>
											</td>
											<td align="right" nowrap>
												<font class="<%= className %>" size="1"><%= timeFormat.format(Time.getDate(event.getEndTime(), timeZone))%></font>
											</td>
										</tr>
										</table>
								</td>
								<td width="10">
									<img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="10">
								</td>
								<td valign="top" width="99%">
									<font class="<%= className %>" size="2"><a class="<%= event.getCssClass() %>" href="javascript:showObject(<%= event.id%>)"><%= (event.shortDesc!=null?event.shortDesc:event.description)%></a></font>
								</td>
							</tr>

						<%
						}
						%>

						</table>
					</td>
				</tr>
				</table>
			</td>
			<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		</tr>

		<c:if test="<%= i + 1 == 7 %>">
			<tr>
				<td class="beta" colspan="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="10"></td>
			</tr>
		</c:if>

	<%
		cal.add(Calendar.DATE, 1);
	}
	%>

	</table>
</td></tr></table>

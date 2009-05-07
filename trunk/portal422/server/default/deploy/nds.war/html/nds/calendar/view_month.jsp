<%@page errorPage="/html/nds/error.jsp"%>
<%@ include file="/html/nds/calendar/init.jsp" %>


<%
Calendar cal = (Calendar)selCal.clone();
cal.set(Calendar.DATE, 1);

int month = cal.get(Calendar.MONTH);
int year = cal.get(Calendar.YEAR);

//int maxDayOfMonth = cal.getActualMaximum(Calendar.DATE);
//int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

DateFormat dateFormat = new SimpleDateFormat("MMMM, yyyy", locale);
DateFormat timeFormat = new SimpleDateFormat("h:mma", locale);
%>

<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr><td align="center">
	<table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr>
		<td>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>

				<td><a class="bg" href="javascript:view('month', <%=Integer.toString(selCal.get(Calendar.MONTH) - 1) %>, <%= Integer.toString(selCal.get(Calendar.DATE)) %>,<%= Integer.toString(selCal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_left.gif" width="11"></a></td>
				<td width="10">
					&nbsp;
				</td>
				<td>
					<font class="bg" size="2">
					<b><%= dateFormat.format(Time.getDate(cal)) %></b>
					</font>
				</td>
				<td width="10">
					&nbsp;
				</td>
				<td><a class="bg" href="javascript:view('month', <%=Integer.toString(selCal.get(Calendar.MONTH) +1) %>, <%= Integer.toString(selCal.get(Calendar.DATE)) %>,<%= Integer.toString(selCal.get(Calendar.YEAR)) %>)"><img border="0" height="11" src="<%= SKIN_COMMON_IMG %>/02_right.gif" width="11"></a></td>
			</tr>
			</table>
		</td>
		<td align="right">
			
		</td>
	</tr>
	</table>

	<br>

	<table border="0" cellpadding="0" cellspacing="0" width="95%">
	<tr class="gamma">
		<td class="beta" colspan="15"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr class="beta">
		<td><img border="0" height="22" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="15%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "sunday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="14%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "monday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="14%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "tuesday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="14%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "wednesday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="14%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "thursday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="14%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "friday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td align="center" width="15%">
			<font class="gamma" size="2"><b><%= LanguageUtil.get(pageContext, "saturday-abbreviation") %></b></font>
		</td>
		<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr class="gamma">

	<%
	for (int i = 1; i < dayOfWeek; i++) {
	%>

		<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td height="100"><font class="gamma" size="1">&nbsp;</font></td>

	<%
	}

	for (int i = 1; i <= maxDayOfMonth; i++) {
		if (dayOfWeek > 7) {
	%>

		<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr class="gamma">
		<td class="beta" colspan="15"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr class="gamma">

	<%
			dayOfWeek = 1;
		}

		dayOfWeek++;

		Calendar tempCal = (Calendar)selCal.clone();
		tempCal.set(Calendar.MONTH, month);
		tempCal.set(Calendar.DATE, i);
		tempCal.set(Calendar.YEAR, year);

		String className = "gamma";
		if (tempCal.get(Calendar.MONTH) == curMonth && tempCal.get(Calendar.DATE) == curDay && tempCal.get(Calendar.YEAR) == curYear) {
			className = "beta";
		}
	%>

		<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="gamma" height="100" valign="top">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr class="<%= className %>">
				<td>
					<table border="0" cellpadding="4" cellspacing="0" width="100%">
					<tr>
						<td>
							<font class="<%= className %>" size="2"><b>
							<a class="<%= className %>" href="javascript:view('day',<%= Integer.toString(month) %>,<%= Integer.toString(i) %>,<%= Integer.toString(year) %>)"><%= i %></a>&nbsp;
							</b></font>

							<c:if test="<%= tempCal.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY %>">
								<font class="<%= className %>" size="1">
								&nbsp;[<a class="<%= className %>" href="javascript:view('week',<%= Integer.toString(month) %>,<%= Integer.toString(i) %>,<%= Integer.toString(year) %>)"><%= LanguageUtil.get(pageContext, "week") %> <%= tempCal.get(Calendar.WEEK_OF_YEAR) %></a>]
								</font>
							</c:if>
						</td>

						<c:if test="<%= editableEvents %>">
							<td align="right">
								<a class="<%= className %>" href="javascript:add(<%= Integer.toString(tempCal.get(Calendar.MONTH)) %>,<%= Integer.toString(tempCal.get(Calendar.DATE)) %>,<%= Integer.toString(tempCal.get(Calendar.YEAR)) %>)"><img border="0" height="9" hspace="0" src="<%= SKIN_COMMON_IMG %>/06_plus.gif" title="<%= LanguageUtil.get(pageContext, "add") %>" vspace="0" width="9"></a>
							</td>
						</c:if>

					</tr>
					</table>
				</td>
			</tr>

			<%
			List events = nds.web.CalendarUtils.getEventsByDay(table,filter,userWeb, tempCal);

			for (int j = 0; j < events.size(); j++) {
				CalendarEvent event = (CalendarEvent)events.get(j);

			%>

				<tr class="gamma">
					<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</tr>
				<tr class="bg">
					<td>
						<table border="0" cellpadding="2" cellspacing="0">
						<tr>
							<td>
								<font class="bg" size="1"><%= timeFormat.format(Time.getDate(event.beginDate, timeZone)) %></font>
								<font class="bg" size="1"><a class="<%=(event.getCssClass().equals("gamma")?"bg":event.getCssClass())%>" href="javascript:showObject(<%=event.id%>)"><%= StringUtil.shorten(event.shortDesc, 80) %></a></font>

							</td>
						</tr>
						</table>
					</td>
				</tr>

			<%
			}
			%>

			</table>
		</td>

	<%
	}

	for (int i = 7; i >= dayOfWeek; i--) {
	%>

		<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td height="100"><font class="gamma" size="1">&nbsp;</font></td>

	<%
	}
	%>

		<td class="beta"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr class="gamma">
		<td class="beta" colspan="15"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	</table>
</td></tr></table>

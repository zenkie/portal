<%@ include file="/html/nds/common/init.jsp" %>
<%@ page import="nds.web.*" %>
<%
TableManager manager=TableManager.getInstance();
int tableId= ParamUtils.getIntAttributeOrParameter(request, "table", -1);
CalendarTable table=(CalendarTable)manager.getTable(tableId);
String filter= request.getParameter("filter_column");
String monthParam = request.getParameter("month");
String dayParam = request.getParameter("day");
String yearParam = request.getParameter("year");

boolean showMonthSel = true;
boolean editableEvents=table.isEventEditable();

Calendar selCal = new GregorianCalendar(timeZone, locale);
selCal.set(Calendar.DATE, 1);

try {
	selCal.set(Calendar.YEAR, Integer.parseInt(yearParam));
}
catch (NumberFormatException nfe) {
}

try {
	selCal.set(Calendar.MONTH, Integer.parseInt(monthParam));
}
catch (NumberFormatException nfe) {
}

try {
	int maxDayOfMonth = selCal.getActualMaximum(Calendar.DATE);

	int dayParamInt = Integer.parseInt(dayParam);

	if (dayParamInt > maxDayOfMonth) {
		dayParamInt = maxDayOfMonth;
	}

	selCal.set(Calendar.DATE, dayParamInt);
}
catch (NumberFormatException nfe) {
}

int selMonth = selCal.get(Calendar.MONTH);
int selDay = selCal.get(Calendar.DATE);
int selYear = selCal.get(Calendar.YEAR);

int maxDayOfMonth = selCal.getActualMaximum(Calendar.DATE);

selCal.set(Calendar.DATE, 1);
int dayOfWeek = selCal.get(Calendar.DAY_OF_WEEK);
selCal.set(Calendar.DATE, selDay);

Calendar curCal = new GregorianCalendar(timeZone, locale);
int curMonth = curCal.get(Calendar.MONTH);
int curDay = curCal.get(Calendar.DATE);
int curYear = curCal.get(Calendar.YEAR);

%>


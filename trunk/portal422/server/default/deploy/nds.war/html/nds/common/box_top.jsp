<%
/**
 * Copyright (c) 2000-2004 Liferay, LLC. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/common/init.jsp" %>

<%

// General variables

String titleClassName = ParamUtil.get(request, "box_title_class", "beta");
String bodyClassName = ParamUtil.get(request, "box_body_class", "bg");

String title = ParamUtil.get(request, "box_title", "");

int intWidth = (int)ParamUtil.get(request, "box_width", (double)RES_TOTAL);
String width="100%";
String wildWidth = "*";
if(intWidth>0){ //yfzhu added 
	try {
		width=Integer.toString(intWidth );
		wildWidth = Integer.toString(intWidth - 2);
	}catch (Exception e) {
	}
}

boolean boldTitle = ParamUtil.get(request, "box_bold_title", true);
boolean brWrapContent = ParamUtil.get(request, "box_br_wrap_content", true);

// Portlet specific variables

String portletId = ParamUtil.get(request, "box_portlet_id", "");
String columnOrder = ParamUtil.get(request, "box_column_order", "");

boolean stateMax = ParamUtil.get(request, "box_state_max", false);
boolean stateMin = ParamUtil.get(request, "box_state_min", false);
boolean modeEdit = ParamUtil.get(request, "box_mode_edit", false);
boolean modeHelp = ParamUtil.get(request, "box_mode_help", false);

boolean showEditIcon = ParamUtil.get(request, "box_show_edit_icon", false);
boolean showHelpIcon = ParamUtil.get(request, "box_show_help_icon", false);
boolean showMoveIcon = ParamUtil.get(request, "box_show_move_icon", false);
boolean showMinIcon = ParamUtil.get(request, "box_show_min_icon", false);
boolean showMaxIcon = ParamUtil.get(request, "box_show_max_icon", false);
boolean showCloseIcon = ParamUtil.get(request, "box_show_close_icon", false);

boolean restoreCurrentView = ParamUtil.get(request, "restore_current_view", false);

if (!signedIn) {
	showEditIcon = false;
	//showHelpIcon = false;
	showMoveIcon = false;
	showMinIcon = GetterUtil.getBoolean(PropsUtil.get(PropsUtil.LAYOUT_GUEST_SHOW_MIN_ICON));
	showMaxIcon = GetterUtil.getBoolean(PropsUtil.get(PropsUtil.LAYOUT_GUEST_SHOW_MAX_ICON));
	showCloseIcon = false;
}

boolean decorateBox = false;
if (Validator.isNotNull(title) || (showEditIcon == true) || (showHelpIcon == true) || (showMoveIcon == true) || (showMinIcon == true) || (showMaxIcon == true) || (showCloseIcon == true)) {
	decorateBox = true;
}
%>

<c:if test="<%= decorateBox %>">
	<table border="0" cellpadding="0" cellspacing="0" width="<%= width %>">
	<tr>
		<td colspan="3"><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="<%= titleClassName %>" rowspan="4">
			<c:if test="<%= Validator.isNotNull(title) %>">
				<table border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td nowrap><font class="<%= titleClassName %>" size="2"><%= boldTitle ? "<b>" : "" %>&nbsp;<%= title %>&nbsp;<%= boldTitle ? "</b>" : "" %></font></td>
				</tr>
				</table>
			</c:if>
		</td>
		<td></td>
		<td rowspan="4">
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<c:if test="<%= showEditIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_edit", "<%= SKIN_COMMON_IMG %>/01_<%= modeEdit ? "leave_" : "" %>edit_on.gif", "<%= SKIN_COMMON_IMG %>/01_<%= modeEdit ? "leave_" : "" %>edit_off.gif");
					</script>

					<%
					PortletURL portletURL = new PortletURLImpl(request, portletId, layout.getLayoutId(), false);

					if (modeEdit) {
						portletURL.setWindowState(WindowState.NORMAL);
						portletURL.setPortletMode(PortletMode.VIEW);
					}
					else {
						portletURL.setWindowState(WindowState.MAXIMIZED);
						portletURL.setPortletMode(PortletMode.EDIT);
					}
					%>

					<td rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><a href="<%= portletURL %>"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_edit" src="<%= SKIN_COMMON_IMG %>/01_<%= modeEdit ? "leave_" : "" %>edit_off.gif" title="<%= LanguageUtil.get(pageContext, (modeEdit ? "leave-" : "") + "edit-preferences") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_edit');"></a></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td></td>
				</c:if>

				<c:if test="<%= showHelpIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_help", "<%= SKIN_COMMON_IMG %>/01_<%= modeHelp ? "leave_" : "" %>help_on.gif", "<%= SKIN_COMMON_IMG %>/01_<%= modeHelp ? "leave_" : "" %>help_off.gif");
					</script>

					<%
					PortletURL portletURL = new PortletURLImpl(request, portletId, layout.getLayoutId(), false);

					if (modeHelp) {
						portletURL.setWindowState(WindowState.NORMAL);
						portletURL.setPortletMode(PortletMode.VIEW);
					}
					else {
						portletURL.setWindowState(WindowState.MAXIMIZED);
						portletURL.setPortletMode(PortletMode.HELP);
					}

					portletURL.setSecure(request.isSecure());
					%>

					<td rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><a href="<%= portletURL %>"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_help" src="<%= SKIN_COMMON_IMG %>/01_<%= modeHelp ? "leave_" : "" %>help_off.gif" title="<%= LanguageUtil.get(pageContext, "help") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_help');"></a></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td></td>
				</c:if>

				<c:if test="<%= showMoveIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_up", "<%= SKIN_COMMON_IMG %>/01_up_on.gif", "<%= SKIN_COMMON_IMG %>/01_up_off.gif");
						loadImage("p_<%= portletId %>_down", "<%= SKIN_COMMON_IMG %>/01_down_on.gif", "<%= SKIN_COMMON_IMG %>/01_down_off.gif");
					</script>

					<td rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><a href="javascript: movePortletUp('<%= layoutId %>', '<%= portletId %>', '<%= columnOrder %>');"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_up" src="<%= SKIN_COMMON_IMG %>/01_up_off.gif" title="<%= LanguageUtil.get(pageContext, "up") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_up');"></a></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td></td>
					<td rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><a href="javascript: movePortletDown('<%= layoutId %>', '<%= portletId %>', '<%= columnOrder %>');"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_down" src="<%= SKIN_COMMON_IMG %>/01_down_off.gif" title="<%= LanguageUtil.get(pageContext, "down") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_down');"></a></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td></td>
				</c:if>

				<c:if test="<%= showMinIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_min", "<%= SKIN_COMMON_IMG %>/01_min_on.gif", "<%= SKIN_COMMON_IMG %>/01_min_off.gif");
						loadImage("p_<%= portletId %>_restore", "<%= SKIN_COMMON_IMG %>/01_restore_on.gif", "<%= SKIN_COMMON_IMG %>/01_restore_off.gif");
					</script>

					<td id="p_p_body_<%= portletId %>_min_buttons" rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<c:if test="<%= !stateMin %>">
								<td class="<%= bodyClassName %>"><a href="javascript: minimizePortlet('<%= layoutId %>', '<%= portletId %>', false);"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_min" src="<%= SKIN_COMMON_IMG %>/01_min_off.gif" title="<%= LanguageUtil.get(pageContext, "minimize") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_min');"></a></td>
							</c:if>

							<c:if test="<%= stateMin %>">
								<td class="<%= bodyClassName %>"><a href="javascript: minimizePortlet('<%= layoutId %>', '<%= portletId %>', true);"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_restore" src="<%= SKIN_COMMON_IMG %>/01_restore_off.gif" title="<%= LanguageUtil.get(pageContext, "restore") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_restore');"></a></td>
							</c:if>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showMaxIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_max", "<%= SKIN_COMMON_IMG %>/01_max_on.gif", "<%= SKIN_COMMON_IMG %>/01_max_off.gif");
						loadImage("p_<%= portletId %>_restore", "<%= SKIN_COMMON_IMG %>/01_restore_on.gif", "<%= SKIN_COMMON_IMG %>/01_restore_off.gif");
					</script>

					<%
					boolean action = !restoreCurrentView;

					PortletURL portletURL = new PortletURLImpl(request, portletId, layout.getLayoutId(), action);

					if (stateMax) {
						portletURL.setWindowState(WindowState.NORMAL);
					}
					else {
						portletURL.setWindowState(WindowState.MAXIMIZED);
					}

					if (!action) {
						String portletNamespace = PortalUtil.getPortletNamespace(portletId);

						Map renderParameters = RenderParametersPool.get(request, layout.getLayoutId(), portletId);

						Iterator itr = renderParameters.entrySet().iterator();

						while (itr.hasNext()) {
							Map.Entry entry = (Map.Entry)itr.next();

							String key = (String)entry.getKey();

							if (key.startsWith(portletNamespace)) {
								key = key.substring(portletNamespace.length(), key.length());

								String[] values = (String[])entry.getValue();

								portletURL.setParameter(key, values);
							}
						}
					}

					portletURL.setSecure(request.isSecure());
					%>

					<td id="p_p_body_<%= portletId %>_max_buttons" rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<c:if test="<%= !stateMax %>">
								<td class="<%= bodyClassName %>"><a href="<%= portletURL %>"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_max" src="<%= SKIN_COMMON_IMG %>/01_max_off.gif" title="<%= LanguageUtil.get(pageContext, "maximize") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_max');"></a></td>
							</c:if>

							<c:if test="<%= stateMax %>">
								<td class="<%= bodyClassName %>"><a href="<%= portletURL %>"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_restore" src="<%= SKIN_COMMON_IMG %>/01_restore_off.gif" title="<%= LanguageUtil.get(pageContext, "restore") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_restore');"></a></td>
							</c:if>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
					<td><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showCloseIcon %>">
					<script language="JavaScript">
						loadImage("p_<%= portletId %>_close", "<%= SKIN_COMMON_IMG %>/01_close_on.gif", "<%= SKIN_COMMON_IMG %>/01_close_off.gif");
					</script>

					<td rowspan="3">
						<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><a href="javascript: closePortlet('<%= layoutId %>', '<%= portletId %>', '<%= columnOrder %>');"><img border="0" height="14" hspace="0" name="p_<%= portletId %>_close" src="<%= SKIN_COMMON_IMG %>/01_close_off.gif" title="<%= LanguageUtil.get(pageContext, "remove") %>" vspace="0" width="14" onMouseOut="offRollOver();" onMouseOver="onRollOver('p_<%= portletId %>_close');"></a></td>
						</tr>
						<tr>
							<td class="<%= bodyClassName %>"><img border="0" height="6" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
						</tr>
						</table>
					</td>
				</c:if>

				<td><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			</tr>
			<tr>
				<c:if test="<%= showEditIcon %>">
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
				</c:if>

				<c:if test="<%= showHelpIcon %>">
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
				</c:if>

				<c:if test="<%= showMoveIcon %>">
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
				</c:if>

				<c:if test="<%= showMinIcon %>">
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
				</c:if>

				<c:if test="<%= showMaxIcon %>">
					<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="2"></td>
				</c:if>

				<td class="alpha" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			</tr>
			<tr>
				<c:if test="<%= showEditIcon %>">
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showHelpIcon %>">
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showMoveIcon %>">
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showMinIcon %>">
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<c:if test="<%= showMaxIcon %>">
					<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</c:if>

				<td class="<%= bodyClassName %>"><img border="0" height="14" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			</tr>
			</table>
		</td>
		<td colspan="3"><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr>
			<td colspan="2" rowspan="2">
				<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="alpha" colspan="2"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>
				</tr>
				<tr>
					<td class="alpha" width="1"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
					<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="4"></td>
				</tr>
				</table>
			</td>

		<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>
		<td class="alpha" width="<%= wildWidth %>"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="alpha" width="5"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>


			<td colspan="2" rowspan="2">
				<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="alpha"colspan="2"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>
				</tr>
				<tr>
					<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="4"></td>
					<td class="alpha" width="1"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
				</tr>
				</table>
			</td>
	</tr>
	<tr>
		<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="<%= bodyClassName %>" rowspan="2"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr>
		<td class="alpha" width="1"><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="4"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="5"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="4"></td>
		<td class="alpha" width="1"><img border="0" height="10" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	</table>
</c:if>

<c:if test="<%= !decorateBox %>">
	<table border="0" cellpadding="0" cellspacing="0" width="<%= width %>">


		<tr>
			<td class="alpha" rowspan="2" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			<td class="alpha"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="<%= wildWidth %>"></td>
			<td class="alpha"rowspan="2" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		</tr>
		<tr>
			<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="*"></td>
		</tr>

	</table>
</c:if>

<table border="0" cellpadding="0" cellspacing="0" width="<%= width %>">
<tr id="p_p_body_<%= portletId %>" <%= (stateMin) ? "style=\"display: none;\"" : "" %>>
	<td class="alpha" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	<td width="<%= wildWidth %>">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr class="<%= bodyClassName %>">
			<td align="center">
				<c:if test="<%= brWrapContent %>">
					<br>
				</c:if>

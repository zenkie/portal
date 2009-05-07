<%@ include file="/html/common/init.jsp" %>

<portlet:defineObjects />

<tiles:useAttribute id="tilesPortletSubNav" name="portlet_sub_nav" classname="java.lang.String" />
<tiles:useAttribute id="tilesPortletContent" name="portlet_content" classname="java.lang.String" />

<%
boolean child = ParamUtil.get(request, "child", false);

RenderResponseImpl renderResponseImpl = (RenderResponseImpl)renderResponse;

Map portletViewMap = (Map)request.getAttribute(WebKeys.PORTLET_VIEW_MAP);

boolean access = ((Boolean)portletViewMap.get("access")).booleanValue();
boolean active = ((Boolean)portletViewMap.get("active")).booleanValue();

String portletId = (String)portletViewMap.get("portletId");
String portletTitle = (access && active) ? renderResponseImpl.getTitle() : portletConfig.getResourceBundle(locale).getString(WebKeys.JAVAX_PORTLET_TITLE);

boolean stateMax = ((Boolean)portletViewMap.get("stateMax")).booleanValue();
boolean stateMin = ((Boolean)portletViewMap.get("stateMin")).booleanValue();
boolean modeEdit = ((Boolean)portletViewMap.get("modeEdit")).booleanValue();
boolean modeHelp = ((Boolean)portletViewMap.get("modeHelp")).booleanValue();

boolean showEditIcon = ((Boolean)portletViewMap.get("showEditIcon")).booleanValue();
boolean showHelpIcon = ((Boolean)portletViewMap.get("showHelpIcon")).booleanValue();
boolean showMoveIcon = ((Boolean)portletViewMap.get("showMoveIcon")).booleanValue();
boolean showMinIcon = ((Boolean)portletViewMap.get("showMinIcon")).booleanValue();
boolean showMaxIcon = ((Boolean)portletViewMap.get("showMaxIcon")).booleanValue();
boolean showCloseIcon = ((Boolean)portletViewMap.get("showCloseIcon")).booleanValue();

boolean restoreCurrentView = ((Boolean)portletViewMap.get("restoreCurrentView")).booleanValue();
%>

<c:if test="<%= !child %>">
	<a name="p_<%= portletId %>"></a>

	<div id="p_p_id_<%= portletId %>">
		<liferay-util:box top="/html/nds/common/box_top.jsp" bottom="/html/nds/common/box_bottom.jsp">
			<liferay-util:param name="box_title_class" value="alpha" />
			<liferay-util:param name="box_body_class" value="gamma" />
			<liferay-util:param name="box_title" value="<%= renderResponseImpl.getTitle() %>" />
			<liferay-util:param name="box_width" value="<%= (String)portletViewMap.get(\"portletWidth\") %>" />
			<liferay-util:param name="box_br_wrap_content" value="false" />

			<liferay-util:param name="box_portlet_id" value="<%= portletId %>" />
			<liferay-util:param name="box_column_order" value="<%= (String)portletViewMap.get(\"curColumnOrder\") %>" />

			<liferay-util:param name="box_state_max" value="<%= Boolean.toString(stateMax) %>" />
			<liferay-util:param name="box_state_min" value="<%= Boolean.toString(stateMin) %>" />
			<liferay-util:param name="box_mode_edit" value="<%= Boolean.toString(modeEdit) %>" />
			<liferay-util:param name="box_mode_help" value="<%= Boolean.toString(modeHelp) %>" />

			<liferay-util:param name="box_show_edit_icon" value="<%= Boolean.toString(showEditIcon) %>" />
			<liferay-util:param name="box_show_help_icon" value="<%= Boolean.toString(showHelpIcon) %>" />
			<liferay-util:param name="box_show_move_icon" value="<%= Boolean.toString(showMoveIcon) %>" />
			<liferay-util:param name="box_show_min_icon" value="<%= Boolean.toString(showMinIcon) %>" />
			<liferay-util:param name="box_show_max_icon" value="<%= Boolean.toString(showMaxIcon) %>" />
			<liferay-util:param name="box_show_close_icon" value="<%= Boolean.toString(showCloseIcon) %>" />

			<liferay-util:param name="restore_current_view" value="<%= Boolean.toString(restoreCurrentView) %>" />

			<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
			</tr>
			<tr>
				<td align="center">
					<c:if test="<%= active %>">
						<c:if test="<%= access %>">
							<c:if test="<%= Validator.isNotNull(tilesPortletSubNav) %>">
								<liferay-util:include page="<%= \"/html\" + tilesPortletSubNav %>"/>
							</c:if>
						</c:if>

						<c:if test="<%= !access %>">
							<liferay-util:include page="/html/portal/portlet_access_denied.jsp" />
						</c:if>
					</c:if>

					<c:if test="<%= !active %>">
						<liferay-util:include page="/html/portal/portlet_inactive.jsp" />
					</c:if>
				</td>
			</tr>
			</table>
		
		<c:if test="<%= access && active %>">
			<liferay-util:include page="<%= \"/html\" + tilesPortletContent %>"/>
		</c:if>			
		</liferay-util:box>
		
	</div>
</c:if>

<c:if test="<%= child %>">
	<table border="0" cellpadding="0" cellspacing="0" height="100%" width="100%">
	<tr class="bg">
		<td align="center" valign="middle">
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center">
					<c:if test="<%= access && active %>">
						<liferay-util:include page="<%= \"/html\" + tilesPortletContent %>"/>
					</c:if>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	</table>
</c:if>

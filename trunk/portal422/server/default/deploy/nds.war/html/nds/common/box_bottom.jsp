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
String bodyClassName = ParamUtil.get(request, "box_body_class", "bg");

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

boolean brWrapContent = ParamUtil.get(request, "box_br_wrap_content", true);
%>

				<c:if test="<%= brWrapContent %>">
					<br>
				</c:if>
			</td>
		</tr>
		<tr class="<%= bodyClassName %>">
			<td><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		</tr>
		</table>
	</td>
	<td class="alpha" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
</tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="<%= width %>">

	<tr>
		<td class="alpha" rowspan="2" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
		<td class="<%= bodyClassName %>"><img border="0" height="4" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="*"></td>
		<td class="alpha" rowspan="2" width="1"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="1"></td>
	</tr>
	<tr>
		<td class="alpha"><img border="0" height="1" hspace="0" src="<%= COMMON_IMG %>/spacer.gif" vspace="0" width="<%= wildWidth %>"></td>
	</tr>

</table>

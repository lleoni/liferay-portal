<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/taglib/ui/discussion/init.jsp" %>

<%
int index = GetterUtil.getInteger(request.getAttribute("liferay-ui:discussion:index"));
int initialIndex = GetterUtil.getInteger(request.getAttribute("liferay-ui:discussion:index"));
int rootIndexPage = GetterUtil.getInteger(request.getAttribute("liferay-ui:discussion:rootIndexPage"));

DiscussionRequestHelper discussionRequestHelper = new DiscussionRequestHelper(request);
DiscussionTaglibHelper discussionTaglibHelper = new DiscussionTaglibHelper(request);

Discussion discussion = CommentManagerUtil.getDiscussion(discussionTaglibHelper.getUserId(), discussionRequestHelper.getScopeGroupId(), discussionTaglibHelper.getClassName(), discussionTaglibHelper.getClassPK(), ServiceContextFactory.getInstance(request));

Comment rootComment = discussion.getRootComment();

CommentIterator commentIterator = rootComment.getThreadCommentsIterator(rootIndexPage);

while (commentIterator.hasNext()) {
	rootIndexPage = commentIterator.getIndexPage();

	if (index >= (initialIndex + PropsValues.DISCUSSION_COMMENTS_DELTA_VALUE)) {
		break;
	}

	Comment comment = commentIterator.next();

	request.setAttribute("liferay-ui:discussion:currentComment", comment);
	request.setAttribute("liferay-ui:discussion:discussion", discussion);
%>

	<liferay-util:include page="/html/taglib/ui/discussion/view_message_thread.jsp" />

<%
	index = GetterUtil.getInteger(request.getAttribute("liferay-ui:discussion:index"));
}
%>

<aui:script sandbox="<%= true %>">
	var rootIndexPage = $('#<%= namespace %>rootIndexPage');
	var index = $('#<%= namespace %>index');

	rootIndexPage.val('<%= String.valueOf(rootIndexPage) %>');
	index.val('<%= String.valueOf(index) %>');

	<c:if test="<%= rootComment.getThreadCommentsCount() <= (index + 1) %>">
		var moreCommentsLink = $('#<%= namespace %>moreComments');

		moreCommentsLink.hide();
	</c:if>
</aui:script>
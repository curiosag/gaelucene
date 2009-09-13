<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="include/common.inc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Run Lucene on Google AppEngine</title>
<style type="text/css">
ul.hotwords {clear:both;}
ul.hotwords li {float:left; padding:4px 10px 4px 6px;}
</style>
</head>


<body>
<%@ include file="include/dashboard_header.inc.jsp"%>

<h2>GAELucene</h2>
<p>Server Start:<%=(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(org.apache.gaelucene.dashboard.GAELuceneAdminServlet.getStartTime())))%></p>
<ul>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/list"/>Files Management</a> - list indices files</li>
<%if(permission.canAdminSystem()) {%>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/importpackagedindex?dir=indices/mobile/index&cat=mobile"/>Import Indices</a> - import packaged indices onto google datastore</li>
<%}%>
</ul>
<ul>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/showpoolstat"/>Pool Stat</a> - show readers pool information</li>
<%if(permission.canAdminSystem()) {%>
<!--<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/reinitpool"/>Pool Reinit</a> - reset all pooled readers!</li>-->
<%}%>
</ul>
<ul>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/showcachestat"/>Cache Stat</a> - show memcache stats</li>
<%if(permission.canAdminSystem()) {%>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/clearcache"/>Cache Reinit</a> - clear all cache</li>
<%}%>
</ul>

<ul>
<%if(permission.canAdminSystem()) {%>
<li><a href="<%=GAELuceneConfig.getUrlPattern()%>/listusers"/>Users Management</a>
<%}%>
</ul>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>

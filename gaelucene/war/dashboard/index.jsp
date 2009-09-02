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
<ul>
<li><a href="/dashboard/gaelucene?do=list"/>List Files</a> - list indices files</li>
<li><a href="/dashboard/gaelucene?do=sync&dir=indices/news/index&cat=news"/>Sync Indices</a> - load packaged indices onto google datastore</li>
<li><a href="/dashboard/gaelucene?do=truncate"/><strike>Truncate DB!!!</strike></a> - <strike>truncate all data within google datastore!</strike></li>
</ul>
<ul>
<li><a href="/dashboard/gaelucene?do=showpoolstat"/>Pool Stat</a> - show readers pool information</li>
<li><a href="/dashboard/gaelucene?do=reinitpool"/>Pool Reinit!!!</a> - reset all pooled readers!!!</li>
</ul>
<ul>
<li><a href="/dashboard/gaelucene?do=showcachestat"/><strike>Cache Stat</strike></a> - <strike>show memcache stats</strike></li>
</ul>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>

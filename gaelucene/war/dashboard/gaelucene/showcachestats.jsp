<%@ page
contentType="text/html;charset=UTF-8"
import="java.text.DecimalFormat"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"

%><%@ include file="include/common.inc.jsp"%><%!
static DecimalFormat memoryUsageFormat = new DecimalFormat("###,###");
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Cache Stats</title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>Cache Stats</h2>
<%
Integer cacheSize=(Integer)request.getAttribute("Cache.Size");
Integer hits=(Integer)request.getAttribute("CacheStatistics.Hits");
Integer misses=(Integer)request.getAttribute("CacheStatistics.Misses");
%>
<table border="1">
<tr><th>Cache Size</th><td><%=cacheSize%></td></tr>
<tr><th>Hits</th><td><%=hits%></td></tr>
<tr><th>Misses</th><td><%=misses%></td></tr>
</table>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
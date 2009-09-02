<%@ page
contentType="text/html;charset=UTF-8"
import="java.text.DecimalFormat"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"

import="org.apache.lucene.store.GAEIndexCategory"
import="org.apache.lucene.store.GAEFile"

%><%@ include file="include/common.inc.jsp"%><%!
static DecimalFormat memoryUsageFormat = new DecimalFormat("###,###");
%><%
String action=ParamUtil.getString(request, "do", "").trim();
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - <%=action%></title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2><%=action%></h2>

<%
if ("showpoolstat".equals(action)) {
  Long freeMemory=(Long)request.getAttribute("Runtime.totalMemory");
  Long totalMemory=(Long)request.getAttribute("Runtime.maxMemory");
  Long maxMemory=(Long)request.getAttribute("Runtime.freeMemory");
  String poolStatus=(String)request.getAttribute("Pool.stat");
%>
<table border="1">
<tr>
<th>Memory Usage</th>
<td><pre>
total memory:<%=memoryUsageFormat.format(freeMemory)%>
  max memory:<%=memoryUsageFormat.format(totalMemory)%>
 free memory:<%=memoryUsageFormat.format(maxMemory)%></pre></td>
</tr>
<tr>
<th>Readers Status</th>
<td><pre>
<%=poolStatus%></pre></td>
</tr>
</table>
<%
}
else if ("showcachestat".equals(action)) {
  Integer hits=(Integer)request.getAttribute("CacheStatistics.Hits");
  Integer misses=(Integer)request.getAttribute("CacheStatistics.Misses");
%>
<table border="1">
<tr>
<th>Hits</th><td><%=hits%></td></tr>
<tr>
<th>Misses</th><td><%=misses%></td></tr>
</table>
<%
}
%>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
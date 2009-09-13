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
<title>GAELucene - Pool Stats</title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>Pool Stats</h2>
<%
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

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="include/common.inc.jsp"%><%!
public static String getStackTrace(StackTraceElement[] stes) {
  StringBuffer sb = new StringBuffer(512);
  for (int i=0; i<stes.length; i++) {
    sb.append(stes[i].toString()).append("<br/>");
  }
  return sb.toString();
}
%><%
String requestURI=(String)request.getAttribute("requestURI");
Exception exception=(Exception)request.getAttribute("exception");
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Exception</title>
</head>

<body>
<%@ include file="include/dashboard_header.inc.jsp"%>

<h2>Exception</h2>
<p>Failed to process your last request "<%=requestURI%>"!</p>

<table border="1">
<tr><th>Exception</td><td><%=exception.getClass().getName()%></td></tr>
<tr><th>Message</td><td><%=exception.getMessage()%></td></tr>
<tr><th>Stack</td><td><%=getStackTrace(exception.getStackTrace())%></td></tr>
</table>

<h2><a href="javascript:history.go(-1);">Go Back</a></h2>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>

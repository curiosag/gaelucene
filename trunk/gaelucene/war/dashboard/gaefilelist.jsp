<%@ page
contentType="text/html;charset=UTF-8"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"
import="org.apache.lucene.store.GAEIndexCategory"
import="org.apache.lucene.store.GAEFile"
%><%@ include file="include/common.inc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - List Files</title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>List Files</h2>

<%
List categories=(List)request.getAttribute("categories");
List files=(List)request.getAttribute("files");
if(categories == null || files == null) {
  return;
}
if (categories.isEmpty()) {
%>
0 Category Found!
<%
} else {%>
<p><%=categories.size()%> GAEIndexCategory Found!</p>
<table border="1">
<tr>
<th>id</th><th>category</th><th>version</th><th>last modified</th><th>del</th>
</tr>
<%
  for(int i=0; i<categories.size(); i++) {
    GAEIndexCategory category=(GAEIndexCategory)categories.get(i);
%>
<tr>
<td>G:<%=category.getId()%></td><td><b><%=category.getCat()%></b></td><td><%=category.getVer()%></td><td><%=dateFormat.format(new Date(category.getLastModified()))%></td><td><a href="/dashboard/gaelucene?do=delete&id=<%=category.getId()%>&type=category">X</a></td>
</tr>
<%
  }
%>
</table>
<%
}
if (files.isEmpty()) {
%>
<p>0 GAEFiles Found!</p>
<p><a href="/dashboard/gaelucene?do=sync&dir=indices/news/index&cat=news"/>Sync</a></p>
<%
} else {
%>
<p><%=files.size()%> GAEFiles Found!</p>
<table border="1">
<tr>
<th>id</th><th>category</th><th>version</th><th>name</th><th>length</th><th>last modified</th><th>segment count</th><th>del</th>
</tr>
<%
  for(int i=0; i<files.size(); i++) {
    GAEFile file=(GAEFile)files.get(i);
%>
<tr>
<td>G:<%=file.getId()%></td><td><b><%=file.getCat()%></b></td><td><%=file.getVer()%></td><td><b><%=file.getName()%></b></td><td align="right"><%=file.getLength()%></td><td><%=dateFormat.format(new Date(file.getLastModified()))%></td><td><%=file.getSegmentCount()%></td><td><a href="/dashboard/gaelucene?do=delete&id=<%=file.getId()%>&type=file">X</a></td>
</tr>
<%
  }
%>
</table>
<%
}
%>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
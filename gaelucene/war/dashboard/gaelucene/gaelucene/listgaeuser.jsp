<%@ page
contentType="text/html;charset=UTF-8"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"
import="org.apache.gaelucene.auth.GAELuceneUser"
%><%@ include file="include/common.inc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Users</title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>All Users</h2>

<%
List users=(List)request.getAttribute("users");
List reservedUsers=(List)request.getAttribute("reservedUsers");
if(users == null && reservedUsers == null) {
  return;
}
%>
<p><%=(users.size() + reservedUsers.size())%> GAELuceneUser Found!</p>
<table border="1">
<tr>
<th>id</th><th>email</th><th>del</th>
</tr>
<%
  for(int i=0; i<reservedUsers.size(); i++) {
%>
<tr>
<td>*</td><td><b><%=reservedUsers.get(i)%></b></td><td>-</td>
</tr>
<%
  }

  for(int i=0; i<users.size(); i++) {
    GAELuceneUser user=(GAELuceneUser)users.get(i);
%>
<tr>
<td><a href="<%=GAELuceneConfig.getUrlPattern()%>/edituserpermission?uid=<%=user.getUId()%>"><%=user.getUId()%></a></td><td><b><%=user.getEmail()%></b></td><td><a href="<%=GAELuceneConfig.getUrlPattern()%>/deleteruserprocess?uid=<%=user.getUId()%>">X</a></td>
</tr>
<%
  }
%>
</table>

<h2>Add New User</h2>
<table border="1">
<form name="f_" action="<%=GAELuceneConfig.getUrlPattern()%>/adduserprocess" method="post">
<tr>
<td>Email</td><td><input type="text" name="email" value=""></b></td><td colspan="2"><input type="submit" name="btnAdd" value="Add"></td>
</tr>
</form>
</table>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
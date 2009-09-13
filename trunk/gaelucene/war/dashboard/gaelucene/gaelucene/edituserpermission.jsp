<%@ page
contentType="text/html;charset=UTF-8"
import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.ArrayList"
import="org.apache.gaelucene.auth.GAELuceneUser"
import="org.apache.gaelucene.auth.GAELuceneAbstractPermission"
%><%@ include file="include/common.inc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Users &gt; Permission</title>
<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>User</h2>
<%
GAELuceneUser user=(GAELuceneUser)request.getAttribute("user");
if (user != null) {
  ArrayList<Integer> currentPerms = user.getPermissions();
  System.out.println("editUserPermission(" + user.getUId() + "," + currentPerms + ")");
%>
<table border="1">
<tr>
<th>id</th><th>email</th>
</tr>
<tr>
<td>G:<%=user.getUId()%></td><td><b><%=user.getEmail()%></b></td>
</tr>
</table>

<h2>Permission</h2>
<form name="f" action="<%=GAELuceneConfig.getUrlPattern()%>/updateuserpermissionprocess" method="post">
<input type="hidden" name="uid" value="<%=user.getUId()%>">
<table border="1">
<%
int[] allCombinedPerms = GAELuceneAbstractPermission.globalCombinedPermissionArray;
for (int i = 0; i < allCombinedPerms.length; i++) {
  int perm = allCombinedPerms[i];
  boolean hasPerm = false;
  if (currentPerms != null && currentPerms.size() > 0) {
    for (int m=0; m<currentPerms.size(); m++) {
      if (currentPerms.get(m) == perm) {
        hasPerm = true;
        break;
      }
    }
  }
%>
  <tr>
    <td nowrap><%=GAELuceneAbstractPermission.getDescription(perm)%></td>
    <td align="center"><input type="checkbox" name="perm" value="<%=perm%>" <%=(hasPerm ? "checked" : "")%>></td>
  </tr>
<%
} //for
%>
<tr>
<td colspan="2"><input type="submit" name="btnAdd" value="Save"></td>
</tr>
</form>
</table>
<%}%>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>
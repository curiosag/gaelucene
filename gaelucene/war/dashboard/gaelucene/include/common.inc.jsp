<%@ page 

import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"

import="org.apache.gaelucene.auth.GAELuceneOnlineUser"
import="org.apache.gaelucene.auth.GAELuceneOnlineUserManager"
import="org.apache.gaelucene.auth.GAELucenePermission"
import="org.apache.gaelucene.config.GAELuceneConfig"

import="com.liferay.util.ParamUtil"
%><%!
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%><%
GAELuceneOnlineUserManager onlineUserManager=GAELuceneOnlineUserManager.getInstance();
GAELuceneOnlineUser onlineUser=null;
try {
  onlineUser=onlineUserManager.getOnlineUser(request);
} catch (Exception e) {
  response.sendRedirect(onlineUserManager.createLoginURL(request));
  return;
}
GAELucenePermission permission=onlineUser.getPermission();

if (onlineUser == null) {
  response.sendRedirect(onlineUserManager.createLoginURL(request));
  return;
}
String contextPath=request.getContextPath();
String authEmail=onlineUser.getEmail();
application.setAttribute("authEmail", authEmail);
%>
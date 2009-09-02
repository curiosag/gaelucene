<%@ page 

import="java.text.SimpleDateFormat"
import="java.util.Date"
import="java.util.List"

import="org.apache.gaelucene.auth.GAEOnlineUser"
import="org.apache.gaelucene.auth.GAEOnlineUserManager"

import="com.liferay.util.ParamUtil"
%><%!
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%><%
GAEOnlineUserManager onlineUserManager=GAEOnlineUserManager.getInstance();
GAEOnlineUser onlineUser=null;
try {
  onlineUser=onlineUserManager.getOnlineUser(request);
} catch (Exception e) {
  response.sendRedirect(onlineUserManager.createLoginURL(request));
  return;
}
//FileBrowserPermission permission=onlineUser.getPermission();

if (onlineUser == null) {
  response.sendRedirect(onlineUserManager.createLoginURL(request));
  return;
}
String contextPath=request.getContextPath();
String authEmail=onlineUser.getEmail();
application.setAttribute("authEmail", authEmail);
%>
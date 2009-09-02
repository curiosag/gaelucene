<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.lucene.analysis.cjk.ChineseSegmenter" %>
<%
ChineseSegmenter segmenter=ChineseSegmenter.getSegmenter();
String text=request.getParameter("text");
String tokens=null;
if(text == null) {
  text="";
  tokens="";
} else {
	tokens=segmenter.scan(text, " ");
}
%>
<html>
<body>

<form action="?" method="post">
<div><textarea name="text" rows="6" cols="80"><%=text%></textarea></div>
<div><input type="submit" value=" Try " /></div>
</form>
<hr>
<textarea name="result" rows="6" cols="80"><%=tokens%></textarea>
</body>
</html>
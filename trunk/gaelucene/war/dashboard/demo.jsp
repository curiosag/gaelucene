<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="include/common.inc.jsp"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>GAELucene - Demo</title>
<style type="text/css">
ul.hotwords {clear:both;}
ul.hotwords li {float:left; padding:4px 10px 4px 6px;}
</style>
</head>


<body>
<%@ include file="include/dashboard_header.inc.jsp"%>
<h2>文章检索</h2>
<form action="/news/search" method="get">
<input type="text" name="q"><input type="submit"><br>
<ul class="hotwords">行业标准
<li><a href="/news/search?q=WCDMA">WCDMA</a></li>
<li><a href="/news/search?q=TD-SCDMA">TD-SCDMA</a></li>
<li><a href="/news/search?q=CDMA2000">CDMA2000</a></li>
</ul>
<ul class="hotwords">3G手机
<li><a href="/news/search?q=iPhone">iPhone</a></li>
<li><a href="/news/search?q=Google+Android">Google Android</a></li>
<li><a href="/news/search?q=%E5%A4%9A%E6%99%AE%E8%BE%BEHTC">多普达HTC</a></li>
<li><a href="/news/search?q=%E9%BB%91%E8%8E%93">黑莓</a></li>
<li><a href="/news/search?q=Palm">Palm</a></li>
<li><a href="/news/search?q=%E9%AD%85%E6%97%8F+OR+M8">魅族M8</a></li>
<li><a href="/news/search?q=%E7%90%A6%E5%9F%BA+OR+QiGi">琦基(QiGi)</a></li>
</ul>
<ul class="hotwords">3G上网本
<li><a href="/news/search?q=%E4%B8%8A%E7%BD%91%E6%9C%AC">上网本</a></li>
</ul>
</form>

<div style="clear:both;"></div>
<hr>
<h2>图片检索</h2>
<form action="/pic/search" method="get">
<input type="text" name="q"><input type="submit"><br>
<ul class="hotwords">
<li><a href="/pic/search?q=iPhone">iPhone</a></li>
<li><a href="/pic/search?q=Google+Android">Google Android</a></li>
<li><a href="/pic/search?q=%E5%A4%9A%E6%99%AE%E8%BE%BEHTC">多普达HTC</a></li>
<li><a href="/pic/search?q=%E9%BB%91%E8%8E%93">黑莓</a></li>
<li><a href="/pic/search?q=Palm">Palm</a></li>
<li><a href="/pic/search?q=%E9%AD%85%E6%97%8F+OR+M8">魅族M8</a></li>
<li><a href="/pic/search?q=%E7%90%A6%E5%9F%BA+OR+QiGi">琦基(QiGi)</a></li>
<li><a href="/pic/search?q=%E4%B8%8A%E7%BD%91%E6%9C%AC">上网本</a></li>
</ul>
</form>

<div style="clear:both;"></div>
<hr>
<h2>手机检索</h2>
<form action="/mobile/search" method="get">
<input type="text" name="q"><input type="submit"><br>
<ul class="hotwords">
<li><a href="/mobile/search?q=iPhone">iPhone</a></li>
<li><a href="/mobile/search?q=Google+Android">Google Android</a></li>
<li><a href="/mobile/search?q=%E5%A4%9A%E6%99%AE%E8%BE%BEHTC">多普达HTC</a></li>
<li><a href="/mobile/search?q=%E9%BB%91%E8%8E%93">黑莓</a></li>
<li><a href="/mobile/search?q=Palm">Palm</a></li>
<li><a href="/mobile/search?q=%E9%AD%85%E6%97%8F+OR+M8">魅族M8</a></li>
<li><a href="/mobile/search?q=%E7%90%A6%E5%9F%BA+OR+QiGi">琦基(QiGi)</a></li>
<li><a href="/mobile/search?q=%E4%B8%8A%E7%BD%91%E6%9C%AC">上网本</a></li>
</ul>
</form>

<div style="clear:both;"></div>
<hr>
<h2>GuestBook</h2>
<table>
<tr>
<td><a href="/guestbook.jsp"/>Guestbook</a></td>
</tr>
</table>

<div style="clear:both;"></div>
<hr>
<h2>分词Demo</h2>
<form action="segmenter.jsp" method="post">
<div><textarea name="text" rows="6" cols="80"></textarea></div>
<div><input type="submit" value=" Try " /></div>
</form>

<%@ include file="include/dashboard_footer.inc.jsp"%>
</body>
</html>

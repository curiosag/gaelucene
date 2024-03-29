﻿<%@ page
contentType="text/html;charset=UTF-8"
import="java.net.URLEncoder"
import="java.text.SimpleDateFormat"
import="java.util.Collection"
import="java.util.Date"
import="java.util.Iterator"

import="org.apache.lucene.analysis.standard.StandardAnalyzer"
import="org.apache.lucene.document.Document"
import="org.apache.lucene.index.GAEIndexReader"
import="org.apache.lucene.index.GAEIndexReaderPool"
import="org.apache.lucene.queryParser.MultiFieldQueryParser"
import="org.apache.lucene.search.BooleanClause"
import="org.apache.lucene.search.highlight.SimpleHTMLFormatter"
import="org.apache.lucene.search.highlight.WebLuceneHighlighter"
import="org.apache.lucene.search.highlight.WebLuceneQueryScorer"
import="org.apache.lucene.search.Hits"
import="org.apache.lucene.search.IndexSearcher"
import="org.apache.lucene.search.Query"

import="com.liferay.util.*"
%><%!
private static StandardAnalyzer analyzer=new StandardAnalyzer();

public void jspInit() {
}

static String[] matchFields=new String[] {"category", "title", "author", "content"};
static BooleanClause.Occur[] matchFlags=new BooleanClause.Occur[] {BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD, BooleanClause.Occur.SHOULD};
%><%
String queryString=ParamUtil.getString(request, "q", "").trim();
if ("".equals(queryString)) {
  queryString="lucene OR hadoop OR solr";
}
Query queryObject=MultiFieldQueryParser.parse(queryString, matchFields, matchFlags, analyzer);
GAEIndexReaderPool readerPool = GAEIndexReaderPool.getInstance();
GAEIndexReader indexReader = readerPool.borrowReader("demo");
if (indexReader == null) {
  out.println("null");
  return;
}
int maxDoc = indexReader.maxDoc();
int numDocs = indexReader.numDocs();

IndexSearcher searcher = new IndexSearcher(indexReader);
Hits hits = searcher.search(queryObject);
int resultCount=hits.length();
readerPool.returnReader(indexReader);
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>GAELucene Search Demo</title>
<style>
</style>
</head>

<body marginheight="3" topmargin="3">

<table border="0" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td align="left" valign="top"><a href="http://code.google.com/p/gaelucene/"><h1>GAELucene</h1></a></td>
<form action="?" method="get" id="form">
<td align="right" valign="top">
<input type="text" class="input" title="GAELucene Search" value="<%=Html.escape(queryString, true)%>" maxlength="60" size="60" name="q" autocomplete="off"/>
<input type="submit" name="btnG" value="GAELucene Search"/>
</td>
</form>
</tr>
</table>

<hr>
maxDoc:<%=maxDoc%><br>
numDocs:<%=numDocs%><br>
queryObject:<%=queryObject%><br>

<table border="0" width="100%" cellpadding="0" cellspacing="0" style="background:#e3eaf4;">
<tr>
<td><b>Web</b></div></td>
<td align="right"><p>Match <b><%=queryString%></b> total <b><%=resultCount%></b> Result</p></td>
</tr>
</table>

<h2 class="hd">Search Result</h2>
<div>
<ol>
<%
if(resultCount > 0) {
  WebLuceneQueryScorer queryScorer=new WebLuceneQueryScorer(queryObject);
  SimpleHTMLFormatter htmlFormater=new SimpleHTMLFormatter("<font color=#ff0000>", "</font>");

  for (int i=0; i < resultCount; i++) {
    Document doc=hits.doc(i);
    float score=hits.score(i);
    String title=(doc.getField("title") != null) ? doc.getField("title").stringValue() : "";
    String content=(doc.getField("content") != null) ? doc.getField("content").stringValue() : "";
    String author=(doc.getField("author") != null) ? doc.getField("author").stringValue() : "";
    String pubtime=(doc.getField("date") != null) ? doc.getField("date").stringValue() : "";
%>
<li>
<h3>
<%=WebLuceneHighlighter.highlight(title, htmlFormater, queryScorer, analyzer, 200)%>
</h3>
<div>
<%=WebLuceneHighlighter.highlight(content, htmlFormater, queryScorer, analyzer, 300)%>...<br>
<span class=gl><%=pubtime%> - <%=author%></span>
</div>
</li><br>
<%
  }
}%>
</ol>
</div>

<hr>
<p><a href="http://code.google.com/" target="_blank"><img src="http://code.google.com/appengine/images/appengine-silver-120x30.gif" alt="Powered by Google App Engine" border="0"/></a> & <a href="http://lucene.apache.org/" target="_blank"><img src="/images/lucene-green-120x18.gif" alt="Powered by Lucene" border="0"/></a><br></p>

</body>
</html>
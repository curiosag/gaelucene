<%@page
contentType="text/plain; charset=utf-8"

import="java.io.IOException"
import="java.io.StringReader"
import="java.net.URL"
import="java.net.URLEncoder"
import="java.util.*"

import="java.text.*"

import="org.apache.lucene.analysis.*"
import="org.apache.lucene.analysis.cjk.*"
import="org.apache.lucene.analysis.standard.*"
import="org.apache.lucene.document.*"
import="org.apache.lucene.index.*"
import="org.apache.lucene.search.*"
import="org.apache.lucene.search.highlight.*"

import="com.liferay.util.*"
%>
<%!
// cjk analyzer
private static Analyzer analyzer=new CJKAnalyzer();

public static final HashMap indexField=new HashMap();
public static final HashMap sortField=new HashMap();

// default catalog
private String catalog="mobile";

// singleton index reader pool
public static GAEIndexReaderPool indexReaderPool = GAEIndexReaderPool.getInstance();
%>
<%
String termField=null;
String termText=null;
if(request.getParameter("f") == null || request.getParameter("f").trim().length() <= 0) {
  out.println("f:null");
  return;
}
if(request.getParameter("t") == null || request.getParameter("t").trim().length() <= 0) {
  out.println("t:null");
  return;
}
termField=request.getParameter("f").trim();
termText=request.getParameter("t").trim();
out.println("f:" + termField);
out.println("t:" + termText);

int[] docs = new int[32];         // buffered doc numbers
int[] freqs = new int[32];        // buffered term freqs
int pointer;
int pointerMax;

IndexReader indexReader=indexReaderPool.borrowReader(catalog);
TermDocs termDocs=indexReader.termDocs(new Term(termField, termText));
out.println("[");
do {
  pointerMax=termDocs.read(docs, freqs);
  
  if (pointerMax != 0) {
    pointer = -1;
    for (pointer++; pointer<pointerMax; pointer++) {
      out.println(docs[pointer] + ",");
    }
  } else {
    termDocs.close();
    break;
  }
} while(true);
out.println("]");
%>

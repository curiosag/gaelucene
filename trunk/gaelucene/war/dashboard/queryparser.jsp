<%@ page 
contentType="text/html;charset=UTF-8"
language="java"
import="java.util.HashMap"
import="java.util.List"
import="java.util.regex.Pattern"

import="org.apache.lucene.analysis.Analyzer"
import="org.apache.lucene.analysis.cjk.ChineseSegmenter"
import="org.apache.lucene.analysis.cjk.CJKAnalyzer"
import="org.apache.lucene.index.Term"
import="org.apache.lucene.search.BooleanClause"
import="org.apache.lucene.search.BooleanQuery"
import="org.apache.lucene.search.Query"
import="org.apache.lucene.search.TermQuery"
import="org.apache.lucene.queryParser.MultiFieldSimpleQueryParser"
import="org.apache.lucene.queryParser.SimpleQueryParser"
%><%!
ChineseSegmenter segmenter;
HashMap<String, Float> boosts = new HashMap<String, Float>();
public void jspInit() {
  try {
    segmenter=ChineseSegmenter.getSegmenter();
  } catch(Exception e) {
    e.printStackTrace();
  }

  boosts.put("title", 6.0f);
  boosts.put("content", 2.0f);
}
static boolean isChecked(String[] fields, String field) {
  if(fields == null || fields.length == 0) {
    return false;
  }
  for(int i=0; i<fields.length; i++) {
    if(fields[i].equals(field)) {
      return true;
    }
  }
  return false;
}

// ½âÎö²éÑ¯×Ö·û´®->Query
public static final Pattern blankChars = Pattern.compile("\\s+");
public Query getKeywordsQuery(String keyword, String[] fields) {
	  BooleanQuery keywordQuery = new BooleanQuery();
	  String[] tokens = blankChars.matcher(keyword).replaceAll(" ").split(" ");
	  for (int i=0; i<tokens.length; i++) {
	    if (ChineseSegmenter.selectCJK(tokens[i]).length() < 1) {
	      continue;
	    }
	    String[] terms = segmenter.scan(tokens[i], " ").split(" ");
	    for (int j=0; j<terms.length; j++) {
	      BooleanQuery bq = new BooleanQuery();
	      for(int k=0; k<fields.length; k++) {
	        TermQuery tq = new TermQuery(new Term(fields[k], terms[j].toLowerCase()));
	        if("title".equals(fields[k])) {
	        	tq.setBoost(6.0f);
	        }
	        else if("tags".equals(fields[k])) {
	        	tq.setBoost(5.0f);
	      	}
	        bq.add(new BooleanClause(tq, BooleanClause.Occur.SHOULD));
	      }
	      keywordQuery.add(new BooleanClause(bq, BooleanClause.Occur.MUST));
	    }
	  }
	  if(keywordQuery.clauses().size() == 0) {
	    return null;
	  }
	  return keywordQuery;
}
%><%
Analyzer analyzer=new CJKAnalyzer();
Query queryObject=null;
String queryString=request.getParameter("q");
String[] matchFields=request.getParameterValues("field");
if(matchFields == null) {
  matchFields=new String[0];
}

if(queryString == null) {
  queryString="";
} else {
	if(matchFields.length == 1) {
    SimpleQueryParser queryParser=new SimpleQueryParser(matchFields[0], analyzer);
    queryParser.setDefaultOperator(SimpleQueryParser.AND_OPERATOR);
    queryParser.setValidFields(new String[] {"title", "content", "author", "source", "site"});
    //queryParser.setProcessPureNOTQuery(SimpleQueryParser.APPEND_MATCHALLDOCSQUERY_ONTO_CLAUSES);
    queryParser.setProcessPureNOTQuery(SimpleQueryParser.FORCE_FIRST_CLAUSE_TO_UNPROHIBITED);
    queryObject=queryParser.parse(queryString);
  } else {
    MultiFieldSimpleQueryParser queryParser=new MultiFieldSimpleQueryParser(matchFields, analyzer, boosts);
    queryParser.setDefaultOperator(SimpleQueryParser.AND_OPERATOR);
    queryParser.setValidFields(new String[] {"title", "content", "author", "source", "site"});
    //queryParser.setProcessPureNOTQuery(SimpleQueryParser.APPEND_MATCHALLDOCSQUERY_ONTO_CLAUSES);
    queryParser.setProcessPureNOTQuery(SimpleQueryParser.FORCE_FIRST_CLAUSE_TO_UNPROHIBITED);
    queryObject=queryParser.parse(queryString);
  }

/*
  SimpleQueryParser queryParser=new SimpleQueryParser(matchFields, analyzer, boosts);
  queryParser.setDefaultOperator(SimpleQueryParser.AND_OPERATOR);
  queryParser.setValidFields(new String[] {"title", "content", "author", "source", "site"});
  //queryParser.setProcessPureNOTQuery(SimpleQueryParser.APPEND_MATCHALLDOCSQUERY_ONTO_CLAUSES);
  queryParser.setProcessPureNOTQuery(SimpleQueryParser.FORCE_FIRST_CLAUSE_TO_UNPROHIBITED);
  queryObject=queryParser.parse(queryString);
*/
}
%>
<html>
<body>

<form action="?" method="post">
<div><textarea name="q" rows="6" cols="80"><%=queryString%></textarea></div>
<div><input type="checkbox" name="field" value="title" <%=isChecked(matchFields, "title") ? "checked" : ""%>>title <input type="checkbox" name="field" value="content" <%=isChecked(matchFields, "content") ? "checked" : ""%>>content <input type="checkbox" name="field" value="author" <%=isChecked(matchFields, "author") ? "checked" : ""%>>author</div>
<div><input type="submit" value=" Parse " /></div>
</form>
<hr>
<textarea name="result" rows="6" cols="80"><%=(queryObject == null ? "" : queryObject)%></textarea>
<textarea name="result" rows="6" cols="80"><%=getKeywordsQuery(queryString, matchFields)%></textarea>
</body>
</html>
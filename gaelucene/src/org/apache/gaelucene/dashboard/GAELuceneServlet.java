package org.apache.gaelucene.dashboard;

/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.cache.CacheStatistics;
import javax.jdo.PersistenceManager;
import javax.jdo.Query;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.gaelucene.auth.AuthenticationException;
import org.apache.gaelucene.auth.GAEOnlineUser;
import org.apache.gaelucene.auth.GAEOnlineUserManager;
import org.apache.gaelucene.tools.LuceneIndextTransfer;
import org.apache.lucene.index.GAEIndexReaderPool;
import org.apache.lucene.store.CF;
import org.apache.lucene.store.GAEFile;
import org.apache.lucene.store.GAEFileContentJDO;
import org.apache.lucene.store.GAEFileJDO;
import org.apache.lucene.store.GAEIndexCategory;
import org.apache.lucene.store.GAEIndexCategoryJDO;
import org.apache.lucene.store.PMF;


import com.liferay.util.ParamUtil;

public class GAELuceneServlet extends HttpServlet {
    public static final long serialVersionUID = 1l;

    // global logger
    private static final Logger log = Logger.getLogger(GAELuceneServlet.class.getName());

    // index readers pool
    private static GAEIndexReaderPool readerPool = GAEIndexReaderPool.getInstance();

    public void doGet(HttpServletRequest request, HttpServletResponse response)
                throws IOException, ServletException  {
        GAEOnlineUserManager userManager = GAEOnlineUserManager.getInstance();
        GAEOnlineUser user = null;
        try {
            user = userManager.getOnlineUser(request);
        } catch (AuthenticationException ae) {
            response.sendRedirect(userManager.createLoginURL(request));
            return;
        }
        String authEmail = user.getEmail();
        String action = ParamUtil.getString(request, "do", "").trim();
        log.info("user(" + authEmail + ") - " + action);

        PersistenceManager pm = PMF.get().getPersistenceManager();
        // load packaged indices onto google datastore
        if ("sync".equals(action)) {
            String dirName = ParamUtil.getString(request, "dir", "").trim();
            String category = ParamUtil.getString(request, "cat", "").trim();
            log.info("trying to sync index under '" + dirName + "' to db.");
            File indxDir = new File(this.getClass().getClassLoader().getResource(dirName).getFile());
            LuceneIndextTransfer.toGoogleDataSource(indxDir, category);
            response.sendRedirect("/dashboard/gaelucene?do=list");
        }
        // delete the specified GAEFile/GAECategory entity
        else if ("delete".equals(action)) {
            long id = ParamUtil.getLong(request, "id", 0);
            String type = ParamUtil.getString(request, "type", "").trim();
            if (id > 0) {
                if ("file".equals(type)) {
                    log.info("trying to delete file '" + id + "'");
                    GAEFileJDO.delete(new Long(id));
                }
                else if ("category".equals(type)) {
                    log.info("trying to delete category '" + id + "'");
                    GAEIndexCategoryJDO.delete(new Long(id));
                }
            }
            response.sendRedirect("/dashboard/gaelucene?do=list");
        }
        // delete a set of indices batchly
        else if ("batchdelete".equals(action)) {
            String category = ParamUtil.getString(request, "cat", "").trim();
            long version = ParamUtil.getLong(request, "ver", 0);
               log.info("trying to delete index of '" + category + "' with version='" + version + "'");
               GAEFileJDO.batchDelete(category, new Long(version));
            response.sendRedirect("/dashboard/gaelucene?do=list");
        }
        // show pool information
        else if ("showpoolstat".equals(action)) {
            long freeMemory = Runtime.getRuntime().freeMemory();
            long totalMemory = Runtime.getRuntime().totalMemory();
            long maxMemory = Runtime.getRuntime().maxMemory();
            request.setAttribute("Runtime.totalMemory", totalMemory);
            request.setAttribute("Runtime.maxMemory", maxMemory);
            request.setAttribute("Runtime.freeMemory", freeMemory);
            if (readerPool == null) {
                request.setAttribute("Pool.stat", "The pool HAS NOT BEEN initialized! Please check your log for detail!");
            } else {
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                readerPool.showPoolStats(out);
                request.setAttribute("Pool.stat", new String(out.toByteArray(), "UTF-8"));
            }
            request.getRequestDispatcher("/dashboard/gaelucene.jsp").forward(request, response);
        }
        // reset the readers pool
        else if ("reinitpool".equals(action)){
            if (readerPool != null) {
                readerPool.reinit();
            }
            response.sendRedirect("/dashboard/gaelucene?do=showpoolstat");
        }
        // show cache statistics 
        else if ("showcachestat".equals(action)) {
            CacheStatistics stats = CF.getCache().getCacheStatistics();
            int hits = stats.getCacheHits();
            int misses = stats.getCacheMisses();
            request.setAttribute("CacheStatistics.Hits", hits);
            request.setAttribute("CacheStatistics.Misses", misses);
            request.getRequestDispatcher("/dashboard/gaelucene.jsp").forward(request, response);
        }
        // list indices files
        else if ("list".equals(action)) {
            log.info("trying to list index files");
            //String query1 = "select from " + GAEIndexCategory.class.getName() + " order by cat asc";
            //List<GAEIndexCategory> categories = (List<GAEIndexCategory>)pm.newQuery(query1).execute();
            Query query1 = pm.newQuery(GAEIndexCategory.class);
            query1.setOrdering("cat asc");
            List<GAEIndexCategory> categories = (List<GAEIndexCategory>)query1.execute();
            log.info("got index categories.");
            //String query2 = "select from " + GAEFile.class.getName();
            //List<GAEFile> files = (List<GAEFile>)pm.newQuery(query2).execute();
            
            Query query2 = pm.newQuery(GAEFile.class);
            query2.setOrdering("name asc");
            List<GAEFile> files = (List<GAEFile>)query2.execute();
            log.info("got file list.");
            
            request.setAttribute("categories", categories);
            request.setAttribute("files", files);
            request.getRequestDispatcher("/dashboard/gaefilelist.jsp").forward(request, response);
        }
        // show index page
        else {
            request.getRequestDispatcher("/dashboard/index.jsp").forward(request, response);
        }
        
        pm.close();
    }

    // 解析queryString中的参数
    private Properties getRequestParameters(String queryString, String encoding) {
        Properties parameters = new Properties();
        if (queryString == null || queryString.trim().length() <= 0) {
            return parameters;
        }
        int i = 0;
        // 忽略有效参数前的无效字符
        char c = queryString.charAt(i);
        while (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))) {
            c = queryString.charAt(++i);
        }
        
        if (i > 0) {
            queryString = queryString.substring(i);
        }

        // 把'&amp;'替换为'&'
        queryString = queryString.replaceAll("&amp;", "&");
        String[] tokens = queryString.split("[&]");
        for (int j=0; j<tokens.length; j++) {
            int p = tokens[j].indexOf('=');
            if (p < 0) {
                continue;
            }
            
            String pname = tokens[j].substring(0, p);
            String pvalue = tokens[j].substring(p + 1);
            try {
                pvalue = URLDecoder.decode(pvalue, encoding);
            } catch (Exception e) {
                pvalue = URLDecoder.decode(pvalue);
            }
            parameters.setProperty(pname, pvalue);
            log.fine("parameter[" + pname + "]={" + pvalue + "}");
        }

        return parameters;
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
                throws IOException {
        String queryString = request.getQueryString();
        // parse 'query string'
        Properties parameters = getRequestParameters(queryString, "UTF-8");
        String action = parameters.getProperty("do", "").trim();
        // 注册接收索引文件
        if ("register".equals(action)) {
            String category = parameters.getProperty("cat", "").trim();
            long version = Long.parseLong(parameters.getProperty("ver", "0").trim());
            String fileName = parameters.getProperty("name", "").trim();
            long fileLength = Long.parseLong(parameters.getProperty("length", "-1").trim());
            long lastModified = Long.parseLong(parameters.getProperty("lastModified", "-1").trim());
            int segmentCount = Integer.parseInt(parameters.getProperty("segmentCount", "0"));
            
            log.info("receive a new file {cat:" + category + "; name:" + fileName + "; length:" + fileLength + "; lastModified:" + lastModified + "; segmentCount:" + segmentCount + "}.");
            Long fileId = GAEFileJDO.saveOrUpdate(category, new Long(version), fileName, new Long(fileLength), new Long(lastModified), new Integer(segmentCount));
            log.info("registered fileId:" + fileId);
            
            PrintWriter out = response.getWriter();
            out.print(fileId);
        }
        // 接收索引文件
        else if ("commit".equals(action)) {
            long fileId = Long.parseLong(parameters.getProperty("fileId", "0").trim());
            int segmentNo = Integer.parseInt(parameters.getProperty("segmentNo", "0").trim());
            long segmentLength = Long.parseLong(parameters.getProperty("segmentLength", "0").trim());
            
            log.info("receive a new segment {fileId:" + fileId + "; segmentNo:" + segmentNo + "; segmentLength:" + segmentLength + "}.");
            
            ServletInputStream is = request.getInputStream();
            ByteArrayOutputStream dos = new ByteArrayOutputStream();
            byte[] buffer = new byte[10240];
            for (int bytes = is.read(buffer, 0, 10240); bytes >= 0;) {
                dos.write(buffer, 0, bytes);
                bytes = is.read(buffer, 0, 10240);
            }
            log.info("receive " + dos.size() + " bytes from remote host");
            byte[] data = dos.toByteArray();
            GAEFileContentJDO.saveOrUpdate(new Long(fileId), new Integer(segmentNo), new Long(segmentLength), data);
        }
        // 激活最新提交的索引
        else if ("activate".equals(action)) {
            String category = parameters.getProperty("cat", "").trim();
            long version = Long.parseLong(parameters.getProperty("ver", "0").trim());
            log.info("trying to activate index of '" + category + "', version=" + version);
            GAEIndexCategoryJDO.saveOrUpdate(category, new Long(version), new Long(System.currentTimeMillis()));
        }
        // unknown operation
        else {
            log.warning("Unknown action:" + action);
        }
    }
}
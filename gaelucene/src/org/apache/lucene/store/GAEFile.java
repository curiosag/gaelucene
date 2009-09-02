package org.apache.lucene.store;

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

import java.util.logging.Logger;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.NotPersistent;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class GAEFile {
	// global logger
    private static final Logger log = Logger.getLogger(GAEFile.class.getName());
    
    public static final int SEGMENT_LENGTH = 512000;

    @PrimaryKey
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
    private Long id;
    
    @Persistent
    private String cat;
    
    @Persistent
    private Long ver;

    @Persistent
    private String name;

    ///@Persistent
    ///private Long cId;

    ///@Persistent
	///public Blob content;
    ///private byte[] content = null;

    @Persistent
    private Long length;

    @Persistent
    private Long lastModified = System.currentTimeMillis();
    
    @Persistent
    private Integer segmentCount = 0;

    @Persistent
    private Boolean deleted;

    @NotPersistent
    private GAEFileContent[] segments;

    public Long getId() {
        return id;
    }

	public String getCat() {
		return cat;
	}

	public void setCat(String cat) {
		this.cat = cat;
	}

	public Long getVer() {
		return ver;
	}

	public void setVer(Long ver) {
		this.ver = ver;
	}

    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	///public Blob getContent() {
	///	return content;
	///}

	///public void setContent(Blob content) {
	///	this.content = content;
	///}

	///public Long getCId() {
	///	return cId;
	///}

	///public void setCId(Long id) {
	///	cId = id;
	///}

//	public byte[] getContent0() {
//		if (this.content == null) {
//			String cacheId = getCacheId();
//			log.info("trying to fetch byte data from memcache for '" + this.name + "' with id '" + cacheId + "'");
//			///try {
//			///	this.content = (byte[]) CF.get().createCache(Collections.emptyMap()).get(cacheId);
//				this.content = (byte[]) CF.getCache().get(cacheId);
//				if (this.content == null) {
//					log.warning("file '" + this.name + "' not found in memcache with id '" + cacheId + "'!");
//					GAEFileContent gaeContent = GAEFileContentJDO.get(this.cId);
//					if (gaeContent != null) {
//						log.info("update the cache entity for '" + this.name + "' with id '" + cacheId + "' use db entity '" + this.cId + "', content length is " + (gaeContent.getContent() == null ? "null" : gaeContent.getContent().getBytes().length));
//						this.content = gaeContent.getContent().getBytes();
//						CF.getCache().put(cacheId, this.content);
//					}
//				}
//				else {
//					log.info("got " + this.content.length + " bytes from memcache for '" + this.name + "' with id '" + cacheId + "', whoes length=" + this.length);
//				}
//			///} catch (CacheException e) {
//			///	log.warning("failed to fetch byte data from memcache for '" + this.name + "' with id '" + cacheId + "', because:" + e);
//			///	e.printStackTrace();
//			///	this.content = null;
//			///}
//		}
//		return this.content;
//	}
//
//	public byte[] getContent() {
//		if (this.content == null) {
//			GAEFileContent gaeContent = GAEFileContentJDO.get(this.cId);
//			if (gaeContent != null) {
//				this.content = gaeContent.getContent().getBytes();
//				log.warning("got file '" + this.name + "'s content from gdb(" + this.cId + "), file-length=" + this.content.length);
//			} else {
//				log.warning("!!!!!!!!!!!!!!!!!!!!!!!!CAN NOT FIND file '" + this.name + "' from gdb!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//			}
//		}
//		return this.content;
//	}
//
//	public void setContent(byte[] content) {
//		this.content = content;
//	}

	public Long getLength() {
		return length;
	}

	public void setLength(Long length) {
		this.length = length;
	}

	public Long getLastModified() {
		return lastModified;
	}

	public void setLastModified(Long lastModified) {
		this.lastModified = lastModified;
	}

	public Integer getSegmentCount() {
		return segmentCount;
	}

	public void setSegmentCount(Integer segmentCount) {
		this.segmentCount = segmentCount;
	}

	public Boolean isDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}
	
//    public static byte[] readData(String fileName) throws IOException {
//    	File file = new File(fileName);
//    	return readData(new FileInputStream(file));
//    }
//    
//    public static byte[] readData(File file) throws IOException {
//    	return readData(new FileInputStream(file));
//    }
//    
//    public static byte[] readData(InputStream is) throws IOException {
//    	byte[] buffer = new byte[1024];
//    	ByteArrayOutputStream bos = new ByteArrayOutputStream();
//    	while(true) {
//    		int c = is.read(buffer);
//    		if(c == -1) {
//    			break;
//    		}
//    		bos.write(buffer, 0, c);
//    	}
//    	is.close();
//    	return bos.toByteArray();
//    }
//    
//    public static Blob readBlob(String fileName) throws IOException {
//    	File file = new File(fileName);
//    	return readBlob(new FileInputStream(file));
//    }
//    
//    public static Blob readBlob(InputStream is) throws IOException {
//   		byte[] bytes = readData(is);
//   		return new Blob(bytes);
//    }
    
	public byte[] getSegment(int segmentNo) {
		if (this.segments == null) {
			this.segments = new GAEFileContent[this.segmentCount];
		}
		
		if (this.segments[segmentNo] == null) {
			this.segments[segmentNo] = GAEFileContentJDO.get(id, segmentNo);
			log.warning("got segment '" + this.name + "-" + segmentNo + "' from gdb(" + this.segments[segmentNo].getId() + "), segment-size=" + this.segments[segmentNo].getContent().getBytes().length);
		}
		
		return this.segments[segmentNo].getContent().getBytes();
	}
    
//    public String getCacheId() {
//    	return this.cat + "-" + this.name + "-" + this.ver;
//    }
//
//    public static GAEFile getInstance(File file) {
//    	GAEFile gaeFile = new GAEFile();
//    	gaeFile.setName(file.getName());
//        byte[] data;
//        try {
//        	data = GAEFile.readData(file);
//        } catch (IOException ioe) {
//        	ioe.printStackTrace();
//        	data = new byte[0];
//        }
//        ///gaeFile.setContent(new Blob(data));
//        gaeFile.setContent(data);
//        gaeFile.setLength(new Long(data.length));
//        gaeFile.setLastModified(new Long(System.currentTimeMillis()));
//        gaeFile.setDeleted(new Boolean(false));
//    	return gaeFile;
//    }
    
    public String toString() {
    	StringBuffer result = new StringBuffer();
    	result.append("id:").append(this.id);
    	result.append("\nname:").append(this.name);
    	result.append("\ncategory:").append(this.cat);
    	result.append("\nversion:").append(this.ver);
    	result.append("\nlength:").append(this.length);
    	result.append("\nlastModified:").append(this.lastModified);
    	result.append("\nsegmentCount:").append(this.segmentCount);
    	return result.toString();
    }
}

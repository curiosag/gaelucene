package org.apache.gaelucene.auth;

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

import javax.servlet.http.HttpServletRequest;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class GAEOnlineUserManager {
	private static GAEOnlineUserManager instance = new GAEOnlineUserManager();

	private GAEOnlineUserManager() {
	}
	
	public static GAEOnlineUserManager getInstance() {
		return instance;
	}

	public GAEOnlineUser getOnlineUser(HttpServletRequest request) throws AuthenticationException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user == null) {
        	throw new AuthenticationException(GAEAuthException.NOT_LOGIN);
        }
        return new GAEOnlineUser(request, user);
	}
	
	public String createLoginURL(HttpServletRequest request) {
		return UserServiceFactory.getUserService().createLoginURL(request.getRequestURI());
	}
}

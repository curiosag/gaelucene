package org.apache.gaelucene.auth;

public class AuthenticationException extends GAEAuthException {

	// jdk1.5 uid
	public static final long serialVersionUID = 2007103000002l;

	public AuthenticationException(int reason) {
		super(reason);
	}
	
	public AuthenticationException(int reason, String msg) {
		super(reason, msg);
	}
}

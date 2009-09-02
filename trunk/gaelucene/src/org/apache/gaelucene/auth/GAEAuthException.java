package org.apache.gaelucene.auth;

public class GAEAuthException extends Exception {

	// jdk1.5 uid
	public static final long serialVersionUID = 2007103000001l;

	public static final int NOT_LOGIN = 1;
	public static final int WRONG_MEMBER_NAME = 2;
	public static final int WRONG_MEMBER_PASSWORD = 3;
	public static final int ACCOUNT_DISABLED = 4;
	public static final int NOT_ENOUGH_RIGHTS = 5;

	private int exceptionReason = NOT_LOGIN;

	public GAEAuthException(String msg) {
		super(msg);
	}
	
	public GAEAuthException(int reason) {
		exceptionReason = reason;		
	}

	public GAEAuthException(int reason, String msg) {
		super(msg);
		exceptionReason = reason;
	}

	public int getReason() {
		return exceptionReason;
	}
	
	public String getReasonString() {
		switch(exceptionReason) {
		case NOT_LOGIN:
			return "NOT LOGIN";
		case WRONG_MEMBER_NAME:
			return "INVALID USER NAME";
		case WRONG_MEMBER_PASSWORD:
			return "INVALID PASSWORD";
		case ACCOUNT_DISABLED:
			return "ACCOUNT HAS BEEN DISABLED";
		case NOT_ENOUGH_RIGHTS:
			return "NOT ENOUGH RIGHTS";
		}
		
		return "UNKNOWN REASON";
	}
	
	public String getMessage() {
		if(super.getMessage() == null) {
			return getReasonString();
		}
		return super.getMessage();
	}
}

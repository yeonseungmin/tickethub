package com.ch.tickethub.exception;

public class DuplicateLoginIdException extends RuntimeException{
	public DuplicateLoginIdException(String message) {
		super(message);
	}
}

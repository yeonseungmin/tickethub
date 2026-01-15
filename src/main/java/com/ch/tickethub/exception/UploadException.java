package com.ch.tickethub.exception;

/* 아래의 클래스는 자바의 RuntimeException을 상속받아, 개발자만의 예외 객체로 커스텀하기 위함 */
public class UploadException extends RuntimeException{
	
	// 자바에서 부모의 생성자는 물러받지 못한다.. 이유? 생성자는 해당 객체만의 초기화 작업에 사용되믈,
	// 만일 부모의 생성자마저도 물려받게 되면, 내가 부모가 되어버리는 개념..
	public UploadException(String msg) {
		super(msg);	// 에러 메시지를 담을 수 있는 부모의 생성자 호출
	}
	
	// Throwable은 예외 객체의 최상위 인터페이스이므로, 어떤 종류의 에러가 나더라도, 이 객체로 받을 수 있기 때문.
	public UploadException(String msg, Throwable e) {
		super(msg, e);	// 에러 메시지를 담을 수 있는 부모의 생성자 호출
	}
	
	public UploadException(Throwable e) {
		super(e);	// 에러 원인을 담을 수 있는 부모의 생성자 호출
	}
}

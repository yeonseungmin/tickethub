package com.ch.tickethub.util;

import java.text.NumberFormat;
import java.util.Locale;

// 숫자 자료형으로 출력된 데이터를 통화 표시로 출력해주는 유틸  클래스 정의
public class MoneyConverter {
	private static final NumberFormat KRW_FORMAT = NumberFormat.getInstance(Locale.KOREA);
	
	// 인스턴스를 new 로 생성하지 않고도 사용하게 하기 위해 메서드를 static으로 정의하자
	public static String format(int price) {
		return KRW_FORMAT.format(price);
	}
}

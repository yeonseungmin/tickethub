package com.ch.tickethub.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {
	private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder();
	
	public static String hash(String rawPassword) {
		return ENCODER.encode(rawPassword);
	}
	
	public static boolean matches(String rawPassword, String hashedPassword) {
		if(rawPassword == null || hashedPassword == null) {
			return false;
		}
		return ENCODER.matches(rawPassword, hashedPassword);
	}
}

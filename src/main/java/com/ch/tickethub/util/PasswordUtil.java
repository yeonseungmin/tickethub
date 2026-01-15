package com.ch.tickethub.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {
    private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder();
    
    public static String hash(String rawPassword) {
        if (rawPassword == null) return null;
        return ENCODER.encode(rawPassword.trim());
    }
    
    public static boolean matches(String rawPassword, String hashedPassword) {
        if (rawPassword == null || hashedPassword == null) {
            return false;
        }
        return ENCODER.matches(rawPassword.trim(), hashedPassword);
    }
}

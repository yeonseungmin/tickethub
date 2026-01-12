package com.ch.tickethub.model.member;

public enum LoginResult {
    SUCCESS,
    NOT_FOUND,        // 가입된 아이디 없음
    WRONG_PASSWORD,   // 비밀번호 불일치
    BLOCKED,          // 차단 계정
    SOCIAL_ACCOUNT    // 소셜 가입 계정
}

package com.ch.tickethub.dto;

import com.ch.tickethub.model.member.LoginResult;

import lombok.Data;

@Data
public class OauthLoginResponse {
    private LoginResult result; // SUCCESS / PROFILE_REQUIRED
    private Member member;      // 성공 or 프로필필요 시(최소 memberId 포함)
    private String reason;      // 프로필 추가 필요 이유

    public static OauthLoginResponse success(Member member) {
        OauthLoginResponse r = new OauthLoginResponse();
        r.result = LoginResult.SUCCESS;
        r.member = member;
        return r;
    }

    public static OauthLoginResponse profileRequired(String reason, Member member) {
        OauthLoginResponse r = new OauthLoginResponse();
        r.result = LoginResult.PROFILE_REQUIRED;
        r.reason = reason;
        r.member = member;
        return r;
    }

    // Controller에서 if문 단순화용으로..
    public boolean isSuccess() {
        return LoginResult.SUCCESS.equals(this.result);
    }

    public boolean isProfileRequired() {
        return LoginResult.PROFILE_REQUIRED.equals(this.result);
    }
}
package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class KakaoUser {

    private String provider;        // "kakao"
    private String socialId;        // kakao id

    private String email;
    private String nickname;
    private String profileImage;

    private String gender;
    private String ageRange;
    private String birthday;
}

package com.ch.tickethub.dto;

import lombok.Data;

@Data
public class KakaoUserResponse {

    private Long id;
    private String connected_at;
    private KakaoAccount kakao_account;

    @Data
    public static class KakaoAccount {
        private String email;
        private String gender;
        private String age_range;
        private String birthday;
        private Profile profile;
    }

    @Data
    public static class Profile {
        private String nickname;
        private String profile_image_url;
    }
}

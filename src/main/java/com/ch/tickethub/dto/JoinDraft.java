package com.ch.tickethub.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class JoinDraft implements Serializable {
    private static final long serialVersionUID = 1L;

    private String loginId;
    private String rawPassword; // 해시 전 비번
    private String name;
    private String email;
}
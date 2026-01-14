package com.ch.tickethub.dto;

import java.util.List;

import lombok.Data;

@Data
public class Dashboard {
    // 통계 카드
    private long totalRevenue;
    private int totalMembers;
    private int totalTickets;
    private int activeWorks;
    private int pendingReports;

    // 차트 및 목록 (기존 DTO 사용)
    private List<Genre> genreList;
    private List<Round> upcomingRounds;
    private List<Report> reportList;
}

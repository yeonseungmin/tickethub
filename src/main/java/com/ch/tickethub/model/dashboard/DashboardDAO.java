package com.ch.tickethub.model.dashboard;

import java.util.List;

import com.ch.tickethub.dto.Genre;
import com.ch.tickethub.dto.Report;
import com.ch.tickethub.dto.Round;

public interface DashboardDAO {

    // 통계 카드
    long selectTotalRevenue();

    int selectTotalMembers();

    int selectTotalTickets();

    int selectActiveWorks();

    int selectPendingReports();

    // 장르별 공연 분포 (기존 Genre DTO)
    List<Genre> selectGenreWithWorkCount();

    // 근일 공연 일정 (기존 Round DTO)
    List<Round> selectUpcomingRounds();

    // 신고된 리뷰 목록 (기존 Report DTO)
    List<Report> selectPendingReportList();
}

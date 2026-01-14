package com.ch.tickethub.model.dashboard;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.Dashboard;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardDAO dashboardDAO;

    @Override
    public Dashboard getDashboard() {
        Dashboard dashboard = new Dashboard();

        // 통계 카드
        dashboard.setTotalRevenue(dashboardDAO.selectTotalRevenue());
        dashboard.setTotalMembers(dashboardDAO.selectTotalMembers());
        dashboard.setTotalTickets(dashboardDAO.selectTotalTickets());
        dashboard.setActiveWorks(dashboardDAO.selectActiveWorks());
        dashboard.setPendingReports(dashboardDAO.selectPendingReports());

        // 차트 및 목록
        dashboard.setGenreList(dashboardDAO.selectGenreWithWorkCount());
        dashboard.setUpcomingRounds(dashboardDAO.selectUpcomingRounds());
        dashboard.setReportList(dashboardDAO.selectPendingReportList());

        return dashboard;
    }
}

package com.ch.tickethub.model.dashboard;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Genre;
import com.ch.tickethub.dto.Report;
import com.ch.tickethub.dto.Round;

@Repository
public class MybatisDashboardDAO implements DashboardDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public long selectTotalRevenue() {
        return sqlSessionTemplate.selectOne("Dashboard.selectTotalRevenue");
    }

    @Override
    public int selectTotalMembers() {
        return sqlSessionTemplate.selectOne("Dashboard.selectTotalMembers");
    }

    @Override
    public int selectTotalTickets() {
        return sqlSessionTemplate.selectOne("Dashboard.selectTotalTickets");
    }

    @Override
    public int selectActiveWorks() {
        return sqlSessionTemplate.selectOne("Dashboard.selectActiveWorks");
    }

    @Override
    public int selectPendingReports() {
        return sqlSessionTemplate.selectOne("Dashboard.selectPendingReports");
    }

    @Override
    public List<Genre> selectGenreWithWorkCount() {
        return sqlSessionTemplate.selectList("Dashboard.selectGenreWithWorkCount");
    }

    @Override
    public List<Round> selectUpcomingRounds() {
        return sqlSessionTemplate.selectList("Dashboard.selectUpcomingRounds");
    }

    @Override
    public List<Report> selectPendingReportList() {
        return sqlSessionTemplate.selectList("Dashboard.selectPendingReportList");
    }
}

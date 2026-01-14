package com.ch.tickethub.model.report;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Report;
import com.ch.tickethub.exception.ReportException;

@Repository
public class MybatisReportDAO implements ReportDAO {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Report report) throws ReportException {
		
		try {
			sqlSessionTemplate.insert("Report.insert", report);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ReportException("신고 접수 실패", e);
		}
	}

	@Override
	public List<Report> selectAll() {
		return sqlSessionTemplate.selectList("Report.selectAll");
	}

	@Override
	public void updateState(Report report) throws ReportException{
		try {
			sqlSessionTemplate.update("Report.updateReportState", report);
		} catch (Exception e) {
			e.printStackTrace();
			throw new ReportException("report 업데이트 실패", e);
		}
		
	}

}

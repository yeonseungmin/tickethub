package com.ch.tickethub.model.reportCategory;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.ReportCategory;

@Repository
public class MybatisReportCategoryDAO implements ReportCategoryDAO{
	
	@Autowired
	SqlSessionTemplate sessionTemplate;
	
	@Override
	public List<ReportCategory> selectAll() {
		return sessionTemplate.selectList("ReportCategory.selectAll");
	}

}

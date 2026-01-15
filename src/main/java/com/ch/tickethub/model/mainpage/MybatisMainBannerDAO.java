package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.MainBanner;

@Repository
public class MybatisMainBannerDAO implements MainBannerDAO {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<MainBanner> selectAll() {
		return sqlSessionTemplate.selectList("MainBanner.selectAll");
	}

	@Override
	public void insert(MainBanner mainBanner) {
		sqlSessionTemplate.insert("MainBanner.insert", mainBanner);
	}

	@Override
	public void delete(int mainbanner_id) {
		sqlSessionTemplate.delete("MainBanner.delete", mainbanner_id);
	}

	@Override
	public MainBanner select(int mainbanner_id) {
		return sqlSessionTemplate.selectOne("MainBanner.select", mainbanner_id);
	}

	@Override
	public void updateOrder(MainBanner mainBanner) {
		sqlSessionTemplate.update("MainBanner.updateOrder", mainBanner);
	}
}
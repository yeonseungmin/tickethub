package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.MainBanner;

public interface MainBannerDAO {
	
	public List<MainBanner> selectAll();
	public void insert(MainBanner mainBanner);
	public void delete(int mainbanner_id);
	public MainBanner select(int mainbanner_id);
	
}

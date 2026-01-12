package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.MainBanner;

public interface MainBannerService {

	public List<MainBanner> getList();
	public void register(MainBanner mainBanner, MultipartFile file);
	public void remove(int mainbanner_id);
}

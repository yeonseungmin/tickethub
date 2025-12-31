package com.ch.tickethub.model.work;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.Work;

public interface WorkService {
	public void regist(Work work, MultipartFile work_poster_img, MultipartFile work_content_img);
	public List getList();
	
	public void cancelUpload(Work work);
}

package com.ch.tickethub.model.person;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface PersonService {
	public void regist(List<String> nameList, List<MultipartFile> imgList);
}

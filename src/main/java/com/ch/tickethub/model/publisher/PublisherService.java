package com.ch.tickethub.model.publisher;

import java.util.List;

import com.ch.tickethub.dto.Publisher;

public interface PublisherService {
	
	public void regist(List<Publisher> publisherList);
	
	public List getList();
}

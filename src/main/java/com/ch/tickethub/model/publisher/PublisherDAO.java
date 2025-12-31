package com.ch.tickethub.model.publisher;

import java.util.List;

import com.ch.tickethub.dto.Publisher;

public interface PublisherDAO {
	
	public void insert(Publisher publisher);
	
	public List selectAll();
}

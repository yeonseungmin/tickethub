package com.ch.tickethub.model.publisher;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Publisher;
import com.ch.tickethub.exception.PublisherException;

@Transactional
@Service
public class PublisherServiceImpl implements PublisherService{
	
	@Autowired
	PublisherDAO publisherDAO;
	
	@Override
	public void regist(List<Publisher>publisherList) throws PublisherException {
		
		for(Publisher publisher : publisherList) {
			publisherDAO.insert(publisher);			
		}
	}

	@Override
	public List getList() {
		return publisherDAO.selectAll();
	}
}

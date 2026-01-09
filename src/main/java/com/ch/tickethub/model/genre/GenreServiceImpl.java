package com.ch.tickethub.model.genre;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class GenreServiceImpl implements GenreService{
	
	@Autowired
	GenreDAO genreDAO;
	
	@Override
	public List getList() {
		return genreDAO.selectAll();
	}

}

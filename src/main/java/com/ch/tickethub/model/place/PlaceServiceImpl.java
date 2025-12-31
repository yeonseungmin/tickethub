package com.ch.tickethub.model.place;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.exception.PlaceException;

@Transactional
@Service
public class PlaceServiceImpl implements PlaceService{
	
	@Autowired
	PlaceDAO placeDAO;
	
	
	public void regist(List<Place> placeList) throws PlaceException{
		
		for(Place place: placeList) {
			placeDAO.insert(place);
		}
		
	}


	@Override
	public List getList() {
		return placeDAO.selectAll();
	}

}

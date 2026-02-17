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

	@Override
	public void remove(int place_id) throws PlaceException{
		try {
			placeDAO.delete(place_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PlaceException("장소 삭제 실패", e);
		}
		
	}

	@Override
	public void setPlace(Place place) throws PlaceException{
		try {
			placeDAO.update(place);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PlaceException("장소 수정 실패", e);
		}
	}

	
}

package com.ch.tickethub.model.place;

import java.util.List;

import com.ch.tickethub.dto.Place;

public interface PlaceService {
	public void regist(List<Place> placeList);
	public List getList();
	public void remove(int place_id);
	public void setPlace(Place place);
}

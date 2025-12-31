package com.ch.tickethub.model.place;

import java.util.List;

import com.ch.tickethub.dto.Place;

public interface PlaceService {
	public void regist(List<Place> placeList);
	public List getList();
}

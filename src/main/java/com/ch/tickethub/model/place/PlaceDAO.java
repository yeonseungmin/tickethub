package com.ch.tickethub.model.place;

import java.util.List;

import com.ch.tickethub.dto.Place;

public interface PlaceDAO {
	public void insert(Place place);
	public List selectAll();
}

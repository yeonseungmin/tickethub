package com.ch.tickethub.model.place;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.exception.PlaceException;

@Repository
public class MybatisPlaceDAO implements PlaceDAO{
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insert(Place place) throws PlaceException {
		try {
			sqlSessionTemplate.insert("Place.insert", place);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PlaceException("장소 등록 실패", e);
		}
		
	}

	@Override
	public List selectAll() {
		return sqlSessionTemplate.selectList("Place.selectAll");
	}

	@Override
	public void delete(int place_id) throws PlaceException{
		try {
			sqlSessionTemplate.delete("Place.delete", place_id);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PlaceException("장소 삭제 실패", e);
		}
		
	}

	@Override
	public void update(Place place) throws PlaceException{
		try {
			sqlSessionTemplate.update("Place.update", place);
		} catch (Exception e) {
			e.printStackTrace();
			throw new PlaceException("장소 수정 실패", e);
		}
		
	}

}

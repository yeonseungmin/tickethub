package com.ch.tickethub.model.round;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.Round;
import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.RoundException;
import com.ch.tickethub.request.Casting;
import com.ch.tickethub.request.RoundDetail;
import com.ch.tickethub.request.RoundRegistRequest;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class RoundServiceImpl implements RoundService{
	
	@Autowired
	RoundDAO roundDAO;
	
	@Autowired
	RoundCastingDAO roundCastingDAO;
	
	@Transactional
	@Override
	public void regist(RoundRegistRequest roundRegistRequest) throws RoundException{
		
		for(RoundDetail roundDetail : roundRegistRequest.getRoundList()) {
			Round round = new Round();
			
			Work work = new Work();
			work.setWork_id(roundRegistRequest.getWork_id());
			round.setWork(work);
			
			Place place = new Place();
			place.setPlace_id(roundRegistRequest.getPlace_id());
			round.setPlace(place);
			
			round.setRound_date(roundRegistRequest.getRound_date());
			round.setRound_start_time(roundDetail.getRound_start_time());
			
			roundDAO.insert(round);
			
			for(Casting casting : roundDetail.getCastingList()) {
				RoundCasting roundCasting = new RoundCasting();
				
				Person person = new Person();
				person.setPerson_id(casting.getPerson_id());
				
				roundCasting.setPerson(person);
				roundCasting.setRound(round);
				roundCasting.setRole(casting.getRole());
				
				roundCastingDAO.insert(roundCasting);
			}
		}
		
	}
	
	
	@Override
	public List<Round> findByWorkId(int workId) {
		return roundDAO.selectByWorkId(workId);
	}


	@Override
	public List<Round> selectByWorkAndPlace(int workId, int placeId) {
		if (placeId > 0) {
	        // 관리자 페이지에서 장소를 선택한 경우 (정밀 필터링)
	        return roundDAO.selectByWorkAndPlace(workId, placeId);
	    } else {
	        // 일반 사용자 페이지 등 장소 상관없이 공연 회차를 다 보여줄 경우
	        return roundDAO.selectByWorkId(workId);
	    }
	}


	@Override
	public List<Map<String, Object>> getSeatStats(int round_id) {
		
		return roundDAO.selectSeatStats(round_id);
	}
}
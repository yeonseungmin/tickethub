package com.ch.tickethub.model.round;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.Person;
import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.Round;
import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.RoundException;
import com.ch.tickethub.model.roundseat.RoundSeatService;
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
	
	@Autowired
    private RoundSeatService roundSeatService;
	
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
		public List<Round> getRoundListByWork(int work_id) {
		    return roundDAO.selectByWorkId(work_id);
		}
		
}

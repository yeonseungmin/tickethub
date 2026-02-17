package com.ch.tickethub.model.round;

import java.util.HashMap;
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
import com.ch.tickethub.exception.RoundCastingException;
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


	@Override
	public void updateCasting(Round round) throws RoundCastingException {
	    // 기존 캐스팅 삭제
	    roundCastingDAO.deleteByRoundId(round.getRound_id());

	    // 새로운 캐스팅 리스트 삽입
	    if (round.getRoundCastingList() != null) {
	        for (RoundCasting casting : round.getRoundCastingList()) {
	            roundCastingDAO.insert(casting);
	        }
	    }
	}


	@Override
	public void setCancelStatus(int round_id, boolean is_cancelled) throws RoundException{
		Map<String, Object> params = new HashMap<>();
	    params.put("round_id", round_id);
	    // DB에는 보통 0과 1로 저장되므로 변환 처리 (또는 boolean 그대로 지원하는 경우 생략 가능)
	    params.put("is_cancelled", is_cancelled ? 1 : 0);

	    int result = roundDAO.updateCancelStatus(params);
	    
	    if (result == 0) {
	        throw new RoundException("회차 정보를 찾을 수 없거나 상태 변경에 실패했습니다.");
	    }
	    log.debug("회차 ID {} 의 취소 상태가 {}로 변경되었습니다.", round_id, is_cancelled);
	}
	
	@Transactional
	@Override
	public void removeRound(int round_id) throws RoundException {
	    // 해당 회차에 등록된 캐스팅(RoundCasting) 정보 먼저 삭제
	    try {
			roundCastingDAO.deleteByRoundId(round_id);
		} catch (RoundCastingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new RoundException("회차별 캐스팅 삭제 요류", e);
		}

	    // 회차 정보 삭제
	    int result = roundDAO.delete(round_id);

	    if (result == 0) {
	        throw new RoundException("삭제할 회차 정보를 찾을 수 없습니다.");
	    }
	    
	    log.debug("회차 ID {} 삭제 완료", round_id);
	}


	@Override
    @Transactional
    public void copyDaySchedule(int work_id, String sourceDate, List<String> targetDates) throws RoundException {
        
        // 1. 기준 날짜(sourceDate)의 모든 회차 리스트 조회 (캐스팅 정보가 포함된 상태여야 함)
        List<Round> sourceRounds = roundDAO.selectByDate(work_id, sourceDate);
        
        if (sourceRounds == null || sourceRounds.isEmpty()) {
            throw new RoundException("복사할 원본 데이터가 존재하지 않습니다.");
        }

        // 2. 대상 날짜(targetDates) 루프
        for (String tDate : targetDates) {
            
            // 3. 해당 날짜에 복사할 원본 회차들 루프
            for (Round sRound : sourceRounds) {
                
                // 3-1. 새 Round 객체 생성 및 정보 복제
                Round newRound = new Round();
                Work newWork = new Work();
                newWork.setWork_id(work_id);
                newRound.setWork(newWork);
                
                newRound.setPlace(sRound.getPlace()); // 장소 정보 복제
                newRound.setRound_date(tDate);        // 날짜만 타겟 날짜로 변경
                newRound.setRound_start_time(sRound.getRound_start_time()); // 시간 복제
                
                // DB에 Insert (MyBatis의 useGeneratedKeys="true" 설정을 통해 newRound의 round_id가 채워짐)
                roundDAO.insert(newRound);

                // 3-2. 해당 회차의 캐스팅(RoundCasting) 리스트 복제
                List<RoundCasting> sCastingList = sRound.getRoundCastingList();
                if (sCastingList != null && !sCastingList.isEmpty()) {
                    for (RoundCasting sCasting : sCastingList) {
                        RoundCasting newCasting = new RoundCasting();
                        
                        // 새 Round 객체를 연결 (위에서 생성된 새 round_id 참조)
                        newCasting.setRound(newRound); 
                        newCasting.setPerson(sCasting.getPerson()); // 배우 정보 복제
                        newCasting.setRole(sCasting.getRole());     // 배역 정보 복제
                        
                        roundCastingDAO.insert(newCasting);
                    }
                }
            }
        }
    }
}
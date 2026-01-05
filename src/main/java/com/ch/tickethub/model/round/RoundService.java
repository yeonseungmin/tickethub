package com.ch.tickethub.model.round;

import java.util.List;

import com.ch.tickethub.dto.Round;
import com.ch.tickethub.request.RoundRegistRequest;

public interface RoundService {
	public void regist(RoundRegistRequest roundRegistRequest);
	
	
	public List<Round> getRoundListByWork(int work_id);

}

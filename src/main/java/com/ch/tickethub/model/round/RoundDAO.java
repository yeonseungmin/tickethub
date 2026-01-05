package com.ch.tickethub.model.round;

import java.util.List;

import com.ch.tickethub.dto.Round;

public interface RoundDAO {
	public void insert(Round round);
	
	public List<Round> selectByWorkId(int work_id);
}

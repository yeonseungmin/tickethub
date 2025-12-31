package com.ch.tickethub.model.work;

import java.util.List;

import com.ch.tickethub.dto.Work;

public interface WorkDAO {
	public void insert(Work work);
	public List selectAll();
}

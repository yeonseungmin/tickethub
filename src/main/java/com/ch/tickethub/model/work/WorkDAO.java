package com.ch.tickethub.model.work;

import java.util.List;

import com.ch.tickethub.dto.Work;

public interface WorkDAO {
	public void insert(Work work);

	public List selectAll();

	public Work select(int work_id);

	public List<Work> selectListByPlace(int placeId);

	public List<Work> selectByGenreId(int genre_id);
	
	public void increaseLikeCount(int work_id);
	public void decreaseLikeCount(int work_id);
}

package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.GenreRanking;

public interface GenreRankingDAO {

    public List<GenreRanking> selectAll();

    public void insert(GenreRanking genreRanking);

    public void delete(int genreranking_id);

}

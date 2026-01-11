package com.ch.tickethub.model.mainpage;

import java.util.List;

import com.ch.tickethub.dto.GenreRanking;

public interface GenreRankingService {

    public List<GenreRanking> getList();

    public void register(GenreRanking genreRanking);

    public void remove(int genreranking_id);
}

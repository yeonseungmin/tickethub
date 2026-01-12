package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ch.tickethub.dto.GenreRanking;

@Service
public class GenreRankingServiceImpl implements GenreRankingService {

    @Autowired
    private GenreRankingDAO genreRankingDAO;

    @Override
    public List<GenreRanking> getList() {
        return genreRankingDAO.selectAll();
    }

    @Transactional
    @Override
    public void register(GenreRanking genreRanking) {
        genreRankingDAO.insert(genreRanking);
    }

    @Transactional
    @Override
    public void remove(int genreranking_id) {
        genreRankingDAO.delete(genreranking_id);
    }

    @Transactional
    @Override
    public void updateOrders(List<GenreRanking> genreRankingList) {
        for (GenreRanking genreRanking : genreRankingList) {
            genreRankingDAO.updateOrder(genreRanking);
        }
    }
}

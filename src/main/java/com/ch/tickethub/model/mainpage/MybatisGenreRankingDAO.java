package com.ch.tickethub.model.mainpage;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.GenreRanking;

@Repository
public class MybatisGenreRankingDAO implements GenreRankingDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<GenreRanking> selectAll() {
        return sqlSessionTemplate.selectList("GenreRanking.selectAll");
    }

    @Override
    public void insert(GenreRanking genreRanking) {
        sqlSessionTemplate.insert("GenreRanking.insert", genreRanking);
    }

    @Override
    public void delete(int genreranking_id) {
        sqlSessionTemplate.delete("GenreRanking.delete", genreranking_id);
    }

    @Override
    public void updateOrder(GenreRanking genreRanking) {
        sqlSessionTemplate.update("GenreRanking.updateOrder", genreRanking);
    }
}

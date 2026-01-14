package com.ch.tickethub.model.searchresult;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ch.tickethub.dto.SearchResult;

@Repository
public class MybatisSearchResultDAO implements SearchResultDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<SearchResult> selectByKeyword(String keyword) {
        return sqlSessionTemplate.selectList("SearchResult.selectByKeyword", keyword);
    }

    @Override
    public List<SearchResult> selectAutocomplete(String keyword) {
        return sqlSessionTemplate.selectList("SearchResult.selectAutocomplete", keyword);
    }

}

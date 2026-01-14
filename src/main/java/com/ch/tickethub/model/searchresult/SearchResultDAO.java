package com.ch.tickethub.model.searchresult;

import java.util.List;

import com.ch.tickethub.dto.SearchResult;

public interface SearchResultDAO {

    public List<SearchResult> selectByKeyword(String keyword);

    public List<SearchResult> selectAutocomplete(String keyword);

}

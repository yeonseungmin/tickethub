package com.ch.tickethub.model.searchresult;

import java.util.List;

import com.ch.tickethub.dto.SearchResult;

public interface SearchResultService {

    public List<SearchResult> getList(String keyword);

    public List<SearchResult> getAutocompleteList(String keyword);

}

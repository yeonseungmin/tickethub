package com.ch.tickethub.model.searchresult;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ch.tickethub.dto.SearchResult;

@Service
public class SearchResultServiceImpl implements SearchResultService {

    @Autowired
    private SearchResultDAO searchResultDAO;

    @Override
    public List<SearchResult> getList(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return searchResultDAO.selectByKeyword(keyword.trim());
    }

    @Override
    public List<SearchResult> getAutocompleteList(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return searchResultDAO.selectAutocomplete(keyword.trim());
    }

}

package com.ch.tickethub.controller.tickethub;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.SearchResult;
import com.ch.tickethub.model.searchresult.SearchResultService;

@Controller
public class SearchController {

    @Autowired
    private SearchResultService searchResultService;

    /**
     * 검색 결과 페이지
     */
    @GetMapping("/search")
    public String getSearch(@RequestParam(value = "q", defaultValue = "") String keyword, Model model) {

        List<SearchResult> searchResultList = searchResultService.getList(keyword);

        model.addAttribute("keyword", keyword);
        model.addAttribute("searchResultList", searchResultList);

        return "ticket/search/index";
    }

    /**
     * 자동완성 API (JSON 반환)
     */
    @GetMapping("/search/autocomplete")
    @ResponseBody
    public List<SearchResult> getAutocomplete(@RequestParam(value = "q", defaultValue = "") String keyword) {
        return searchResultService.getAutocompleteList(keyword);
    }

}

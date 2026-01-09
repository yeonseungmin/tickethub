package com.ch.tickethub.controller.tickethub;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class NavigationController {

	@GetMapping("/genre/{genreName}")
    public String genre(@PathVariable String genreName) {
        return "ticket/genre/" + genreName + "/index";
    }

    // 3. 검색 페이지 (/search)
    @GetMapping("/search")
    public String search() {
        return "ticket/search/list"; 
    }
}

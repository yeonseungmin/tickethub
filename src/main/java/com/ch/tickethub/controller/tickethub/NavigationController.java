package com.ch.tickethub.controller.tickethub;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Work;
import com.ch.tickethub.model.work.WorkService;

@Controller
public class NavigationController {

    @Autowired
    WorkService workService;

    // 기존 장르별 URL 리다이렉트 (하위 호환성 유지: /genre/concert → /genre?type=concert)
    @GetMapping("/genre/{genreName}")
    public String genre(@PathVariable String genreName) {
        return "redirect:/genre?type=" + genreName;
    }

    // 통합 장르 페이지 (신규)
    @GetMapping("/genre")
    public String genreUnified(@RequestParam(value = "type", defaultValue = "concert") String type) {
        // type 파라미터는 JSP에서 JavaScript로 읽어서 사용
        return "ticket/genre/index";
    }

    // 장르별 Work 목록 AJAX API (신규)
    @GetMapping("/api/genre/works")
    @ResponseBody
    public List<Work> getWorksByGenre(@RequestParam("genre_id") int genre_id) {
        return workService.getListByGenreId(genre_id);
    }

}

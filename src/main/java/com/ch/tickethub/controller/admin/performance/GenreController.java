package com.ch.tickethub.controller.admin.performance;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Genre;
import com.ch.tickethub.model.genre.GenreService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class GenreController {
	
	@Autowired
	GenreService genreService;
	
	@GetMapping("/performance/genre/list")
	@ResponseBody
	public List<Genre> getList() {
	
		return genreService.getList();
	}
}

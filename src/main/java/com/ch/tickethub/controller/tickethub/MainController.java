package com.ch.tickethub.controller.tickethub;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.MainBanner;
import com.ch.tickethub.dto.HotWork;
import com.ch.tickethub.dto.OpeningWork;
import com.ch.tickethub.dto.BestReview;
import com.ch.tickethub.dto.GenreRanking;
import com.ch.tickethub.model.mainpage.MainBannerService;
import com.ch.tickethub.model.mainpage.HotWorkService;
import com.ch.tickethub.model.mainpage.OpeningWorkService;
import com.ch.tickethub.model.bestreview.BestReviewService;
import com.ch.tickethub.model.mainpage.GenreRankingService;

@Controller
public class MainController {

	@Autowired
	private MainBannerService mainBannerService;

	@Autowired
	private HotWorkService hotWorkService;

	@Autowired
	private OpeningWorkService openingWorkService;

	@Autowired
	private GenreRankingService genreRankingService;
	
	@Autowired
	private BestReviewService bestReviewService;

	@GetMapping("/")
	public String getMain(Model model) {

		List<MainBanner> bannerList = mainBannerService.getList();
		model.addAttribute("bannerList", bannerList);

		List<HotWork> hotWorkList = hotWorkService.getList();
		model.addAttribute("hotWorkList", hotWorkList);

		List<OpeningWork> openingWorkList = openingWorkService.getList();
		model.addAttribute("openingWorkList", openingWorkList);

		List<GenreRanking> genreRankingList = genreRankingService.getList();
		model.addAttribute("genreRankingList", genreRankingList);
		
		List<BestReview> bestReviewList = bestReviewService.getList();
		model.addAttribute("bestReviewList", bestReviewList);

		return "ticket/index";
	}
	
	@GetMapping("/genreranking/list")
	@ResponseBody
	public List<GenreRanking> getGenreRankingListForAjax() {
		return genreRankingService.getList();
	}
}
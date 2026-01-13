package com.ch.tickethub.controller.admin.mainpage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.ch.tickethub.dto.MainBanner;
import com.ch.tickethub.dto.HotWork;
import com.ch.tickethub.dto.OpeningWork;
import com.ch.tickethub.dto.Review;
import com.ch.tickethub.dto.BestReview;
import com.ch.tickethub.dto.GenreRanking;
import com.ch.tickethub.exception.MainBannerException;
import com.ch.tickethub.exception.UploadException;
import com.ch.tickethub.model.mainpage.MainBannerService;
import com.ch.tickethub.model.mainpage.HotWorkService;
import com.ch.tickethub.model.mainpage.OpeningWorkService;
import com.ch.tickethub.model.review.ReviewService;
import com.ch.tickethub.model.bestreview.BestReviewService;
import com.ch.tickethub.model.mainpage.GenreRankingService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mainpage")
@Slf4j
public class MainPageController {

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

	@Autowired
	private ReviewService reviewService;

	@GetMapping("/mainbanner/banner")
	public String getMainbanner() {
		return "admin/mainpage/mainbanner/banner";
	}

	// 목록 조회
	@GetMapping("/mainbanner/list")
	@ResponseBody
	public List<MainBanner> getBannerList() {
		return mainBannerService.getList();
	}

	// 배너 등록
	@PostMapping("/mainbanner/regist")
	@ResponseBody
	public Map<String, String> registBanner(MainBanner mainBanner, @RequestParam("file") MultipartFile file) {

		mainBannerService.register(mainBanner, file);

		Map<String, String> body = new HashMap<>();
		body.put("message", "메인 배너가 등록되었습니다.");

		return body;
	}

	// 배너 삭제
	@PostMapping("/mainbanner/delete")
	@ResponseBody
	public Map<String, String> deleteBanner(int mainbanner_id) {

		mainBannerService.remove(mainbanner_id);

		Map<String, String> body = new HashMap<>();
		body.put("message", "베너가 삭제되었습니다");

		return body;
	}

	// 배너 순서 업데이트
	@PostMapping("/mainbanner/updateOrder")
	@ResponseBody
	public Map<String, String> updateMainBannerOrder(@RequestBody List<MainBanner> mainBannerList) {
		mainBannerService.updateOrders(mainBannerList);

		Map<String, String> body = new HashMap<>();
		body.put("message", "순서가 저장되었습니다.");
		return body;
	}

	// 예외 핸들러
	@ExceptionHandler({ MainBannerException.class, UploadException.class })
	@ResponseBody
	public ResponseEntity<Map<String, String>> handle(Exception e) {
		log.error("메인 배너 CRUD 중 오류 발생", e);

		Map<String, String> body = new HashMap<>();
		body.put("message", e.getMessage());

		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
	}

	// ============ 인기작 관리 ============

	@GetMapping("/hotwork/hotwork")
	public String getHotWork() {
		return "admin/mainpage/hotwork/hotwork";
	}

	// 목록 조회
	@GetMapping("/hotwork/list")
	@ResponseBody
	public List<HotWork> getHotWorkList() {
		return hotWorkService.getList();
	}

	// 인기작 등록
	@PostMapping("/hotwork/regist")
	@ResponseBody
	public Map<String, String> registHotWork(HotWork hotWork) {

		hotWorkService.register(hotWork);

		Map<String, String> body = new HashMap<>();
		body.put("message", "인기작으로 등록되었습니다.");

		return body;
	}

	// 인기작 삭제
	@PostMapping("/hotwork/delete")
	@ResponseBody
	public Map<String, String> deleteHotWork(int hotwork_id) {

		hotWorkService.remove(hotwork_id);

		Map<String, String> body = new HashMap<>();
		body.put("message", "인기작이 삭제되었습니다.");

		return body;
	}

	// 인기작 순서 업데이트
	@PostMapping("/hotwork/updateOrder")
	@ResponseBody
	public Map<String, String> updateHotWorkOrder(@RequestBody List<HotWork> hotWorkList) {
		hotWorkService.updateOrders(hotWorkList);

		Map<String, String> body = new HashMap<>();
		body.put("message", "순서가 저장되었습니다.");
		return body;
	}

	// ============ 오픈예정 관리 ============

	@GetMapping("/openingwork/openingwork")
	public String getOpeningWork() {
		return "admin/mainpage/openingwork/openingwork";
	}

	// 목록 조회
	@GetMapping("/openingwork/list")
	@ResponseBody
	public List<OpeningWork> getOpeningWorkList() {
		return openingWorkService.getList();
	}

	// 오픈예정 등록
	@PostMapping("/openingwork/regist")
	@ResponseBody
	public Map<String, String> registOpeningWork(OpeningWork openingWork) {

		openingWorkService.register(openingWork);

		Map<String, String> body = new HashMap<>();
		body.put("message", "오픈예정으로 등록되었습니다.");

		return body;
	}

	// 오픈예정 삭제
	@PostMapping("/openingwork/delete")
	@ResponseBody
	public Map<String, String> deleteOpeningWork(int openingwork_id) {

		openingWorkService.remove(openingwork_id);

		Map<String, String> body = new HashMap<>();
		body.put("message", "오픈예정이 삭제되었습니다.");

		return body;
	}

	// 오픈예정 순서 업데이트
	@PostMapping("/openingwork/updateOrder")
	@ResponseBody
	public Map<String, String> updateOpeningWorkOrder(@RequestBody List<OpeningWork> openingWorkList) {
		openingWorkService.updateOrders(openingWorkList);

		Map<String, String> body = new HashMap<>();
		body.put("message", "순서가 저장되었습니다.");
		return body;
	}

	// ============ 장르별 화제작 관리 ============

	@GetMapping("/genreranking/genreranking")
	public String getGenreRanking() {
		return "admin/mainpage/genreranking/genreranking";
	}

	// 목록 조회
	@GetMapping("/genreranking/list")
	@ResponseBody
	public List<GenreRanking> getGenreRankingList() {
		return genreRankingService.getList();
	}

	// 장르별 화제작 등록
	@PostMapping("/genreranking/regist")
	@ResponseBody
	public Map<String, String> registGenreRanking(GenreRanking genreRanking) {

		genreRankingService.register(genreRanking);

		Map<String, String> body = new HashMap<>();
		body.put("message", "장르별 화제작으로 등록되었습니다.");

		return body;
	}

	// 장르별 화제작 삭제
	@PostMapping("/genreranking/delete")
	@ResponseBody
	public Map<String, String> deleteGenreRanking(int genreranking_id) {

		genreRankingService.remove(genreranking_id);

		Map<String, String> body = new HashMap<>();
		body.put("message", "장르별 화제작이 삭제되었습니다.");

		return body;
	}

	// 장르별 화제작 순서 업데이트
	@PostMapping("/genreranking/updateOrder")
	@ResponseBody
	public Map<String, String> updateGenreRankingOrder(@RequestBody List<GenreRanking> genreRankingList) {
		genreRankingService.updateOrders(genreRankingList);

		Map<String, String> body = new HashMap<>();
		body.put("message", "순서가 저장되었습니다.");
		return body;
	}

	// ============ 베스트 리뷰 관리 ============

	@GetMapping("/bestreview/bestreview")
	public String getBestReview() {
		return "admin/mainpage/bestreview/bestreview";
	}

	// 목록 조회
	@GetMapping("/bestreview/list")
	@ResponseBody
	public List<BestReview> getBestReviewList() {
		return bestReviewService.getList();
	}

	// 공연별 리뷰 목록 조회
	@GetMapping("/bestreview/reviews")
	@ResponseBody
	public List<Review> getReviewsByWork(@RequestParam("work_id") int work_id) {
		return reviewService.getListByWorkId(work_id, "latest");
	}

	// 베스트 리뷰 등록
	@PostMapping("/bestreview/regist")
	@ResponseBody
	public Map<String, String> registBestReview(@RequestParam("review_id") int review_id) {
		BestReview bestReview = new BestReview();
		bestReview.setReview_id(review_id);
		bestReviewService.register(bestReview);

		Map<String, String> body = new HashMap<>();
		body.put("message", "베스트 리뷰로 등록되었습니다.");
		return body;
	}

	// 베스트 리뷰 삭제
	@PostMapping("/bestreview/delete")
	@ResponseBody
	public Map<String, String> deleteBestReview(int bestreview_id) {
		bestReviewService.remove(bestreview_id);

		Map<String, String> body = new HashMap<>();
		body.put("message", "베스트 리뷰가 삭제되었습니다.");
		return body;
	}
}
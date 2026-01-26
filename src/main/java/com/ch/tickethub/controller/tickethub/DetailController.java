package com.ch.tickethub.controller.tickethub;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.ReReview;
import com.ch.tickethub.dto.ReportCategory;
import com.ch.tickethub.dto.Review;
import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.SeatGrade;
import com.ch.tickethub.dto.Work;
import com.ch.tickethub.exception.ReReviewException;
import com.ch.tickethub.exception.ReviewException;
import com.ch.tickethub.model.memberLikeWork.MemberLikeWorkService;
import com.ch.tickethub.model.reportCategory.ReportCategoryService;
import com.ch.tickethub.model.rereview.ReReviewService;
import com.ch.tickethub.model.review.ReviewService;
import com.ch.tickethub.model.round.RoundService;
import com.ch.tickethub.model.seatgrade.SeatGradeService;
import com.ch.tickethub.model.work.WorkService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class DetailController {
	
	@Autowired
	WorkService workService;
	
	@Autowired
	SeatGradeService seatGradeService;
	
	@Autowired
	ReportCategoryService reportCategoryService;
	
	@Autowired
	ReviewService reviewService;
	
	@Autowired
	RoundService roundService;
	
	@Autowired
	MemberLikeWorkService memberLikeWorkService;
	
    @Autowired
    @Qualifier("naverMapClientId")
    private String naverMapClientId;

	@GetMapping("/detail")
	public String getDetail(int work_id, Model model, HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		if(loginMember == null) {
			model.addAttribute("memberLikeWork", 0);
		} else {
			int memberLikework = memberLikeWorkService.getMemberLikeWork(loginMember.getMemberId());
			model.addAttribute("memberLikeWork", memberLikework);
		}
		
		Work work = workService.getWork(work_id);
		List<RoundCasting> uniqueCastingList = workService.getUniqueCasting(work);
		List<ReportCategory> reportCategoryList = reportCategoryService.getReportCategoryList();
		Map<String, Object> stats = reviewService.getReviewStats(work_id);
		
		model.addAttribute("work", work);
		model.addAttribute("uniqueCastingList", uniqueCastingList);
		model.addAttribute("reportCategoryList", reportCategoryList);
		model.addAttribute("naverMapClientId", naverMapClientId);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			String jsonWork = mapper.writeValueAsString(work);
			
			model.addAttribute("jsonWork", jsonWork);
			model.addAttribute("avgRating", mapper.writeValueAsString(stats.get("avgRating")));
			model.addAttribute("reviewCount", mapper.writeValueAsString(stats.get("reviewCount")));
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "/ticket/detail/index";
	}
	
	@GetMapping("/detail/seat/stats")
	@ResponseBody
	public List<Map<String, Object>> getSeatStats(int round_id) {
		List<Map<String, Object>> seatStats = roundService.getSeatStats(round_id);
		
		//log.debug("seatStats는 {}", seatStats);
		
		return seatStats;
	}
	
	// 2. [추가] 예매 팝업창 호출 메서드
    @GetMapping("/ticket/reservation/popup")
    public String openReservation(@RequestParam("work_id") int workId, @RequestParam("round_id") int roundId, Model model) {
        log.info("예매 팝업 호출 - 공연ID: {}, 회차ID: {}", workId, roundId);
        
     // 1. 공연 상세 정보 조회 (기본 가격을 가져오기 위함)
        // 서비스 메서드명은 실제 프로젝트에 맞게 확인해주세요 (예: selectOne, getWork)
        Work work = workService.getWork(workId); 
        model.addAttribute("work", work);
        
        // 2. 좌석 등급 리스트 조회 (등급별 할증료를 가져오기 위함)
        List<SeatGrade> seatGradeList = seatGradeService.getList();
        model.addAttribute("seatGradeList", seatGradeList);
        
        // 3. 회차 ID 전달
        model.addAttribute("roundId", roundId);
        return "/ticket/reservation/popup";
    }
    
}

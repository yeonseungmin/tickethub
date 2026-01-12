package com.ch.tickethub.controller.tickethub;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ch.tickethub.dto.RoundCasting;
import com.ch.tickethub.dto.Work;
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
    @Qualifier("naverMapClientId")
    private String naverMapClientId;
	
	@GetMapping("/detail")
	public String getDetail(int work_id, Model model) {
		
		Work work = workService.getWork(work_id);
		List<RoundCasting> uniqueCastingList = workService.getUniqueCasting(work);
		

		
		model.addAttribute("work", work);
		model.addAttribute("uniqueCastingList", uniqueCastingList);
		model.addAttribute("naverMapClientId", naverMapClientId);
		
		ObjectMapper mapper = new ObjectMapper();
		
		try {
			String jsonWork = mapper.writeValueAsString(work);
			model.addAttribute("jsonWork", jsonWork);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "/ticket/detail/index";
	}
	
	// 2. [추가] 예매 팝업창 호출 메서드
    @GetMapping("/ticket/reservation/popup")
    public String openReservation(@RequestParam("work_id") int workId, @RequestParam("round_id") int roundId, Model model) {
        log.info("예매 팝업 호출 - 공연ID: {}, 회차ID: {}", workId, roundId);
        
        // JSP에서 사용할 수 있도록 모델에 담아줍니다.
        model.addAttribute("workId", workId);
        model.addAttribute("roundId", roundId);
        
        // 사용자가 말한 경로: /ticket/reservation/reservation.jsp
        return "/ticket/reservation/popup";
    }
}

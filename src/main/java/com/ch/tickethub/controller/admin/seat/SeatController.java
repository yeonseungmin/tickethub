package com.ch.tickethub.controller.admin.seat;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/seatmanager/seat")
public class SeatController {

	    // 좌석 관리 메인 페이지 호출
	    @GetMapping("")
	    public String getSeatMain() {
	        return "admin/seatmanager/seat/seat";
	    }

	    // 좌석 상태 업데이트 (Ajax용)
	    @PostMapping("/updateStatus")
	    @ResponseBody
	    public String updateStatus(@RequestParam String seatId, @RequestParam String status) {
	        // 실제 운영 시 이곳에서 Service를 호출하여 DB 상태를 변경합니다.
	        System.out.println("관리자 요청 - 좌석: " + seatId + ", 상태: " + status);
	        return "success";
	    }
}

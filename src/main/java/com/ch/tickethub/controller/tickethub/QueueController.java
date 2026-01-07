package com.ch.tickethub.controller.tickethub;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.QueueStatus;
import com.ch.tickethub.model.queue.QueueService;

@Controller 
@RequestMapping("/queue")
public class QueueController {

	@Autowired
	private QueueService queueService;

	// 1. 대기열 진입 메서드
	@PostMapping("/enter") // 대기열에 추가하는 건 서버의 상태를 변경시키므로 POST 방식으로
	@ResponseBody
	public QueueStatus enterQueue(@RequestParam("type") String type,
            @RequestParam(value = "work_id", required = false) String work_id,
            HttpSession session) {
		String user_id = session.getId();
		
		// 1.단 대기
		queueService.enterQueue(type, work_id, user_id);
		
		// 2. 현재 상태를 가져와서 반환.
		return queueService.getQueueStatus(type, work_id, user_id);
	}

	// 2. 현재 상태 조회 메서드
	@GetMapping("/status") // 단순히 상태 조회만 하므로 GET 방식
	@ResponseBody
	public QueueStatus getQueueStatus(@RequestParam("type") String type,
            @RequestParam(value = "work_id", required = false) String work_id,
            HttpSession session) {
		String user_id = session.getId();
		
		// 서비스에 세 가지 정보를 전부 넘겨잇
		return queueService.getQueueStatus(type, work_id, user_id);
	}
	
	@GetMapping("/waiting")
    public String waitingPage(@RequestParam("type") String type,
                             @RequestParam(value = "work_id", required = false) String work_id,
                             Model model) {
    
        model.addAttribute("type", type);
        model.addAttribute("work_id", work_id);
        
        return "queue/waiting";
    }
	
}
package com.ch.tickethub.controller.admin.performance;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.exception.SeatException;
import com.ch.tickethub.model.seat.SeatService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SeatController {

    @Autowired
    private SeatService seatService;

    @GetMapping("/performance/seat")
    public String seatMain() {
        return "admin/performance/seat/seat";
    }

    @GetMapping("/performance/seat/registform")
    public String getRegistForm() {
        return "admin/performance/seat/regist";
    }

    @PostMapping("/performance/seat/regist")
    @ResponseBody
    public Map<String, String> regist(Seat seat) {
        try {
            seatService.regist(seat);
        } catch (Exception e) {
            seatService.cancelRegist(seat);
            e.printStackTrace();
            throw e;
        }

        Map<String, String> body = new HashMap<>();
        body.put("message", "좌석 등록 성공");
        return body;
    }

    @GetMapping("/performance/seat/listpage")
    public String getListPage() {
        return "admin/performance/seat/list";
    }

    @GetMapping("/performance/seat/list")
    @ResponseBody
    public List<Seat> getList() {
        return seatService.getList();
        
    }

    // 좌석 관련 예외 처리
    @ExceptionHandler({SeatException.class, MissingServletRequestParameterException.class})
    @ResponseBody
    public ResponseEntity<Map<String, String>> handle(Exception e) {
        log.debug("좌석 처리 시 예외 발생, handler 메서드 호출됨");

        Map<String, String> body = new HashMap<>();
        body.put("message", "좌석 처리 실패");

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(body);
    }
}

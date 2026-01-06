package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.model.roundseat.RoundSeatService;

@Controller
@RequestMapping("/roundseat")
public class RoundSeatController {

    @Autowired
    private RoundSeatService roundSeatService;

    /**
     * 회차별 좌석 조회
     */
    @GetMapping("/list")
    @ResponseBody
    public List<SeatDetail> seatList(@RequestParam int round_id) {
        return roundSeatService.getSeatDetailByRound(round_id);
    }

    /**
     * 좌석 선점
     */
    @PostMapping("/preempt")
    @ResponseBody
    public String preempt(@RequestParam int round_id, @RequestParam int seat_id) {
        try {
            roundSeatService.preempt(round_id, seat_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 좌석 예약
     */
    @PostMapping("/reserve")
    @ResponseBody
    public String reserve(@RequestParam int round_id, @RequestParam int seat_id, @RequestParam int reservation_id) {
        try {
            roundSeatService.reserve(round_id, seat_id, reservation_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 예약/선점 취소
     */
    @PostMapping("/cancel")
    @ResponseBody
    public String cancel(@RequestParam int round_id, @RequestParam int seat_id) {
        try {
            roundSeatService.cancel(round_id, seat_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
}

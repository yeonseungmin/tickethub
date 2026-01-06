package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.dto.Work;
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
    
    @PostMapping("/updateStatus")
    @ResponseBody
    public String updateSeatStatus(@RequestParam("round_id") int roundId,@RequestParam("seat_id") int seatId, @RequestParam("status") String status) {
        try {
            int result = roundSeatService.updateStatus(roundId, seatId, status);
            return (result > 0) ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }
 // RoundSeatController.java 내부에 추가
    @GetMapping("/workList")
    @ResponseBody
    public List<Work> workList(@RequestParam("place_id") int placeId) {
        // RoundSeatService에 해당 메서드가 구현되어 있어야 합니다.
        return roundSeatService.getWorkListByPlace(placeId); 
    }

    @GetMapping("/roundList")
    @ResponseBody
    public List<com.ch.tickethub.dto.Round> roundList(@RequestParam("work_id") int workId) {
        return roundSeatService.getRoundListByWork(workId);
    }
}

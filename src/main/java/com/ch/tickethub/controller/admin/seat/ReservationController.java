package com.ch.tickethub.controller.admin.seat;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.Reservation;
import com.ch.tickethub.model.reservation.ReservationService;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    /**
     * 예매 실행 (결제 완료 후 호출되는 시나리오)
     * @param seatIds 선택한 좌석 번호 리스트 (예: [101, 102])
     */
    @PostMapping("/complete")
    @ResponseBody
    public String complete(@ModelAttribute Reservation reservation, 
                           @RequestParam("seatIds") List<Integer> seatIds) {
        try {
            // Service에서 트랜잭션으로 예매 저장 + 좌석 상태 변경 처리
            int reservationId = reservationService.makeReservation(reservation, seatIds);
            return "success:" + reservationId;
        } catch (Exception e) {
            e.printStackTrace();
            return "error: 예매 처리 중 오류가 발생했습니다.";
        }
    }

    /**
     * 내 예매 내역 조회
     */
    @GetMapping("/myList")
    public String myReservationList(@RequestParam int member_id, Model model) {
        List<Reservation> list = reservationService.getMemberReservations(member_id);
        model.addAttribute("resList", list);
        return "reservation/myList";
    }

    /**
     * 예매 상세 조회
     */
    @GetMapping("/detail")
    public String detail(@RequestParam int reservation_id, Model model) {
        Reservation reservation = reservationService.getReservation(reservation_id);
        model.addAttribute("res", reservation);
        return "reservation/detail";
    }

    /**
     * 예매 취소
     */
    @PostMapping("/cancel")
    @ResponseBody
    public String cancel(@RequestParam int reservation_id, 
                         @RequestParam int round_id, 
                         @RequestParam("seatIds") List<Integer> seatIds) {
        try {
            reservationService.cancelReservation(reservation_id, round_id, seatIds);
            return "success";
        } catch (Exception e) {
            return "error: 취소 중 오류 발생 - " + e.getMessage();
        }
    }
    
}
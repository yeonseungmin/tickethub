package com.ch.tickethub.controller.tickethub;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ch.tickethub.dto.Member;
import com.ch.tickethub.dto.SeatDetail;
import com.ch.tickethub.model.reservation.ReservationService;

@Controller
@RequestMapping("/ticket/reservation")
public class PaymentController {
    
    @Autowired
    private ReservationService reservationService;

    // [1] 좌석 선점 (AJAX 요청 처리)
    @PostMapping("/reserveSeats")
    @ResponseBody
    public Map<String, Object> reserveSeats(
            @RequestParam("round_id") int roundId,
            @RequestParam("seats") String seatsStr) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            List<Integer> seatIds = Arrays.stream(seatsStr.split(","))
                                          .map(Integer::parseInt)
                                          .collect(Collectors.toList());

            boolean isSuccess = reservationService.preemptSeats(roundId, seatIds);
            
            if (isSuccess) {
                response.put("success", true);
            } else {
                response.put("success", false);
                response.put("message", "이미 선택된 좌석이 포함되어 있습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "서버 오류: " + e.getMessage());
        }
        return response;
    }

    // [2] 결제 페이지 이동 (데이터 모델링 및 할인 로직 통합)
    @GetMapping("/payment")
    public String getPayment(
            @RequestParam("round_id") int roundId,
            @RequestParam("seats") String seats,
            HttpSession session, 
            Model model) {
        
        // 1. 좌석 ID 리스트 변환 (String -> List<Integer>)
        List<Integer> seatIds = Arrays.stream(seats.split(","))
                                      .map(String::trim)
                                      .map(Integer::parseInt)
                                      .collect(Collectors.toList());
        
        // 2. DB에서 선택한 좌석의 상세 정보 조회 (가격, 등급 등 포함)
        List<SeatDetail> seatDetailList = reservationService.getSelectedSeatsInfo(seatIds);

        // 3. 좌석 명칭 가공 (예: "A열 1번, A열 2번")
        String formattedSeats = seatDetailList.stream()
            .map(s -> s.getSeat_x() + "열 " + s.getSeat_y() + "번")
            .collect(Collectors.joining(", "));

        // 4. 등급 명칭 가공 (예: "VIP 석")
        String formattedGrade = "";
        if (seatDetailList != null && !seatDetailList.isEmpty()) {
            String rawGrade = seatDetailList.get(0).getGrade_name();
            if (rawGrade != null) {
                formattedGrade = rawGrade.toUpperCase() + " 석";
            }
        }

        // 5. 총 주문 금액 계산 (할인 적용 전 원가 합계)
        int totalAmount = 0;
        if (seatDetailList != null) {
            totalAmount = seatDetailList.stream().mapToInt(SeatDetail::getPrice).sum();
        }

        // 6. 회원 등급별 할인 혜택 계산 (Member > Grade > Grade_Benefit 연동)
        Member loginMember = (Member) session.getAttribute("loginMember");
        double discountRate = 0.0;
        int benefitId = 0;
        String benefitSummary = "혜택 없음";

        if (loginMember != null) {
            // member_id를 사용하여 DB에서 적용 가능한 benefit_id와 summary 조회
            Map<String, Object> benefit = reservationService.getAppliedBenefit(loginMember.getMemberId());
            
            if (benefit != null) {
                // Number 타입 대응 (Integer/Long 안전하게 변환)
                benefitId = ((Number) benefit.get("benefit_id")).intValue();
                benefitSummary = (String) benefit.get("summary"); // "10% 할인" 등
                
                // summary 텍스트에서 할인율 추출
                if (benefitSummary.contains("10%")) discountRate = 0.1;
                else if (benefitSummary.contains("5%")) discountRate = 0.05;
                else if (benefitSummary.contains("2%")) discountRate = 0.02;
            }
        }

        // 7. 최종 할인 및 결제 금액 계산
        int discountAmount = (int) (totalAmount * discountRate);
        int finalAmount = totalAmount - discountAmount;

        // 8. 뷰(JSP)로 모든 데이터 전달
        model.addAttribute("selectedSeatList", seatDetailList);
        model.addAttribute("formattedSeats", formattedSeats);
        model.addAttribute("formattedGrade", formattedGrade);
        model.addAttribute("totalAmount", totalAmount);
        
        model.addAttribute("discountAmount", discountAmount);
        model.addAttribute("finalAmount", finalAmount);
        model.addAttribute("benefitSummary", benefitSummary);
        model.addAttribute("benefitId", benefitId);

        model.addAttribute("roundId", roundId);
        model.addAttribute("seatIdsStr", seats); 

        return "ticket/reservation/payment";
    }
    
    @GetMapping("/completePayment")
    public String completePayment(
            @RequestParam("round_id") int roundId,
            @RequestParam("seats") String seats,
            @RequestParam("amount") int amount,
            @RequestParam("seat_grade_id") int seatGradeId,
            @RequestParam("benefitId") int benefitId,
            @RequestParam("orderId") String orderId,
            HttpSession session) {

        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/login";

        // 1. 좌석 ID 리스트 변환
        List<Integer> seatIds = Arrays.stream(seats.split(","))
                                      .map(String::trim)
                                      .map(Integer::parseInt)
                                      .collect(Collectors.toList());

        // 2. 예약 메인 저장 (실제 지불 금액과 총액 저장)
        // totalAmount는 좌석 상세 조회를 통해 다시 계산하거나 파라미터로 더 받아올 수 있습니다.
        int reservationId = reservationService.insertReservation(loginMember.getMemberId(), roundId, amount, amount, seatGradeId);

        // 3. 좌석 상태 변경 (AVAILABLE -> RESERVED)
        reservationService.confirmSeats(seatIds, reservationId);

        // 4. 할인 내역 저장
        if (benefitId > 0) {
            reservationService.insertDiscountDetail(reservationId, benefitId);
        }

        System.out.println("결제 완료 - 주문번호: " + orderId + ", 예약ID: " + reservationId);

        return "redirect:/?msg=success";
    }
}
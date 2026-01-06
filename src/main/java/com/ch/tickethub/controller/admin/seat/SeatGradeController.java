package com.ch.tickethub.controller.admin.seat;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.SeatGrade;
import com.ch.tickethub.model.seatgrade.SeatGradeService;

@Controller
@RequestMapping("/seatgrade")
public class SeatGradeController {

    @Autowired
    private SeatGradeService seatGradeService;

    /**
     * [사용자/관리자] 좌석 등급 전체 목록 조회
     * 예매 페이지의 좌석 범례(Legend)나 관리자 목록 페이지에서 사용
     */
    @GetMapping("/list")
    public String list(Model model) {
        List<SeatGrade> list = seatGradeService.getList();
        model.addAttribute("gradeList", list);
        return "seatgrade/list"; // JSP 경로 예시
    }

    /**
     * [관리자] 좌석 등급 등록 폼 이동
     */
    @GetMapping("/register")
    public String registerForm() {
        return "seatgrade/registerForm";
    }

    /**
     * [관리자] 좌석 등급 등록 처리
     */
    @PostMapping("/register")
    public String register(SeatGrade seatGrade) {
        seatGradeService.register(seatGrade);
        return "redirect:/seatgrade/list";
    }

    /**
     * [관리자] 좌석 등급 수정 폼 이동
     */
    @GetMapping("/modify")
    public String modifyForm(@RequestParam int seat_grade_id, Model model) {
        SeatGrade sg = seatGradeService.getGrade(seat_grade_id);
        model.addAttribute("seatGrade", sg);
        return "seatgrade/modifyForm";
    }

    /**
     * [관리자] 좌석 등급 수정 처리
     */
    @PostMapping("/modify")
    public String modify(SeatGrade seatGrade) {
        seatGradeService.modify(seatGrade);
        return "redirect:/seatgrade/list";
    }

    /**
     * [관리자] 좌석 등급 삭제 처리
     */
    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int seat_grade_id) {
        int result = seatGradeService.remove(seat_grade_id);
        return result > 0 ? "success" : "fail";
    }
    
    /**
     * [AJAX 전용] 예매 화면에서 좌석 등급 아이콘 정보 가져오기
     */
    @GetMapping("/api/legend")
    @ResponseBody
    public List<SeatGrade> getLegendApi() {
        return seatGradeService.getList();
    }
}
package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.Place;
import com.ch.tickethub.dto.Seat;
import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.place.PlaceService;
import com.ch.tickethub.model.seat.SeatService;
import com.ch.tickethub.model.seatgroup.SeatGroupService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/seatmanager/seat")
public class SeatController {

    @Autowired
    private SeatService seatService;

    @Autowired
    private SeatGroupService seatGroupService;

    @Autowired
    private PlaceService placeService;
    /**
     * 좌석 관리자 페이지
     * SeatService 기준으로 좌석 조회
     * Seat DTO에는 place_id 없음 → 그룹 기준 조회
     */
    @GetMapping("/manager")
    public String seatManager(@RequestParam(required = false, defaultValue = "0") int seat_group_id, Model model) {
        
        // 2. 모든 장소 목록을 가져와서 모델에 추가 (이 코드가 반드시 있어야 함)
        List<Place> placeList = placeService.getList();
        model.addAttribute("placeList", placeList);

        if(seat_group_id != 0) {
            List<Seat> seatList = seatService.selectByGroup(seat_group_id);
            SeatGroup seatGroup = seatGroupService.get(seat_group_id);

            model.addAttribute("seatList", seatList);
            model.addAttribute("seatGroup", seatGroup);
        }
        return "admin/seatmanager/seat/seat";
    }

    /**
     * 좌석 상태 업데이트
     */
    @PostMapping("/status/update")
    @ResponseBody
    public String updateStatus(@RequestParam int seat_id, @RequestParam String seat_state) {
        try {
            seatService.updateSeatState(seat_id, seat_state);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 좌석 삭제
     */
    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int seat_id) {
        try {
            seatService.delete(seat_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
    
    @PostMapping("/grade/update")
    @ResponseBody
    public String updateGrade(int seat_id, int seat_grade_id) {
        seatService.updateSeatGrade(seat_id, seat_grade_id);
        return "success";
    }

}

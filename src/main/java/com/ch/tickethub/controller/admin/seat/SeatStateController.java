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

@Controller
@RequestMapping("/seatmanager/seat/state")
public class SeatStateController {

    @Autowired
    private SeatService seatService;
    @Autowired
    private SeatGroupService seatGroupService;
    @Autowired
    private PlaceService placeService;

    // 상태 관리 메인 페이지
    @GetMapping("/main")
    public String seatStateMain(@RequestParam(required = false, defaultValue = "0") int seat_group_id, Model model) {
        List<Place> placeList = placeService.getList();
        model.addAttribute("placeList", placeList);

        if(seat_group_id != 0) {
            List<Seat> seatList = seatService.selectByGroup(seat_group_id);
            SeatGroup seatGroup = seatGroupService.get(seat_group_id);
            model.addAttribute("seatList", seatList);
            model.addAttribute("seatGroup", seatGroup);
        }
        return "admin/seatmanager/seat/seatstate";
    }

    // 좌석 상태 업데이트
    @PostMapping("/update")
    @ResponseBody
    public String updateStatus(@RequestParam int seat_id, @RequestParam String seat_state) {
        try {
            seatService.updateSeatState(seat_id, seat_state);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    // 좌석 삭제 (상태 관리 페이지에서 수행)
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
}
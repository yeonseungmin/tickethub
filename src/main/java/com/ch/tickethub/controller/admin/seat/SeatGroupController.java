package com.ch.tickethub.controller.admin.seat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.ch.tickethub.dto.SeatGroup;
import com.ch.tickethub.model.seatgroup.SeatGroupService;

@Controller
@RequestMapping("/seatgroup")
public class SeatGroupController {

    @Autowired
    private SeatGroupService seatGroupService;

    /**
     * 공연장별 구역 관리 페이지
     * @param place_id 공연장 ID
     */
    @GetMapping("/manager")
    public String manager(@RequestParam int place_id, Model model) {
        List<SeatGroup> groupList = seatGroupService.getByPlace(place_id);
        model.addAttribute("groupList", groupList);
        model.addAttribute("place_id", place_id);
        
        // 공연장 전체 도면 위에서 구역들을 배치하는 관리자 페이지로 이동
        return "admin/seatmanager/group/manager";
    }

    /**
     * 구역 생성 (Ajax)
     */
    @PostMapping("/insert")
    @ResponseBody
    public String insert(SeatGroup seatGroup) {
        try {
            seatGroupService.insert(seatGroup);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 위치 업데이트 (드래그 앤 드롭 결과 저장용)
     */
    @PostMapping("/updatePosition")
    @ResponseBody
    public String updatePosition(@RequestParam int seat_group_id, 
                                 @RequestParam int pos_x, 
                                 @RequestParam int pos_y) {
        try {
            seatGroupService.updatePosition(seat_group_id, pos_x, pos_y);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 레이아웃(간격, 방향) 업데이트
     */
    @PostMapping("/updateLayout")
    @ResponseBody
    public String updateLayout(@RequestParam int seat_group_id,
                               @RequestParam int row_gap,
                               @RequestParam int col_gap,
                               @RequestParam String direction) {
        try {
            seatGroupService.updateLayout(seat_group_id, row_gap, col_gap, direction);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }

    /**
     * 구역 삭제
     */
    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestParam int seat_group_id) {
        try {
            seatGroupService.delete(seat_group_id);
            return "success";
        } catch (Exception e) {
            return "error: " + e.getMessage();
        }
    }
}